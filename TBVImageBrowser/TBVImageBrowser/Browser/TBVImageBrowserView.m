//
//  TBVImageBrowserView.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "TBVImageBrowserViewFlowLayout.h"
#import "TBVImageBrowserConfiguration.h"
#import "TBVImageBrowserView.h"
#import "TBVImageBrowserViewCell.h"
#import "TBVImageBrowserViewModel.h"
#import "TBVImageBrowserItemViewModel.h"

static NSString *const kTBVImageBrowserViewCellReuseIdentifier = @"kTBVImageBrowserViewCell";
@interface TBVImageBrowserView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) TBVImageBrowserConfiguration *configuration;
@property (strong, nonatomic) TBVImageBrowserViewFlowLayout *flowLayout;
@property (strong, nonatomic) TBVImageBrowserViewModel *viewModel;
@property (strong, nonatomic) NSArray *dataSource;
@end

@implementation TBVImageBrowserView
#pragma mark life cycle
- (instancetype)initWithImageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider {
    return [self initWithImageProvider:imageProvider
                    configuration:[TBVImageBrowserConfiguration defaultConfiguration]];
}

- (instancetype)initWithImageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider
                   configuration:(TBVImageBrowserConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.clipsToBounds = YES;
        self.configuration = configuration;
        self.flowLayout = [[TBVImageBrowserViewFlowLayout alloc]
                           initWithItemSize:configuration.itemSize];
        [self addSubview:self.collectionView];
        [self layoutPageSubviews];
        @weakify(self)
        [[[RACObserve(self, elements) ignore:nil] map:^id(NSArray *elements) {
            return [elements.rac_sequence map:^id(id <TBVImageElementProtocol> element) {
                TBVImageBrowserItemViewModel *viewModel = [[TBVImageBrowserItemViewModel alloc] init];
                viewModel.clickImageCommand = configuration.clickedImageCommand;
                viewModel.progressSignal = [imageProvider progressSignal];
                viewModel.contentImageSignal = [imageProvider imageSignalForElement:element];
                return viewModel;
            }].array;
        }] subscribeNext:^(id value) {
            @strongify(self)
            self.viewModel.dataSource = value;
            [self.collectionView reloadData];
            
        }];
    }
    return self;
}

- (void)layoutPageSubviews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        /* for image's spacing in browser */
        make.right.equalTo(self).offset(2 * kTBVImageBrowserViewFlowLayoutMargin);
    }];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TBVImageBrowserViewCell *cell = [collectionView
                                     dequeueReusableCellWithReuseIdentifier:kTBVImageBrowserViewCellReuseIdentifier
                                     forIndexPath:indexPath];
    [cell bindViewModel:self.viewModel.dataSource[indexPath.item]];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(nonnull UICollectionViewCell *)cell
    forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    indexPath = [collectionView indexPathsForVisibleItems].firstObject;
    //TODO: set index
}
#pragma mark getter setter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:_flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[TBVImageBrowserViewCell class]
            forCellWithReuseIdentifier:kTBVImageBrowserViewCellReuseIdentifier];
    }
    
    return _collectionView;
}

- (TBVImageBrowserViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TBVImageBrowserViewModel alloc] init];
    }
    
    return _viewModel;
}
@end

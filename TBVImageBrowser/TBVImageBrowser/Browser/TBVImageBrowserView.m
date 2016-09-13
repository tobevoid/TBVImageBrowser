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

static NSString *const kTBVImageBrowserViewCellReuseIdentifier = @"kTBVImageBrowserViewCell";
@interface TBVImageBrowserView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) TBVImageBrowserConfiguration *configuration;
@property (strong, nonatomic) TBVImageBrowserViewFlowLayout *flowLayout;
@property (strong, nonatomic) TBVImageBrowserViewModel *viewModel;
@property (strong, nonatomic) id <TBVImageProviderManagerProtocol> imageProvider;
@end

@implementation TBVImageBrowserView
#pragma mark life cycle
- (instancetype)initWithElements:(NSArray<id<TBVImageElementProtocol>> *)elements
                   imageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider {
    return [self initWithElements:elements imageProvider:imageProvider
                    configuration:[TBVImageBrowserConfiguration defaultConfiguration]];
}

- (instancetype)initWithElements:(NSArray<id<TBVImageElementProtocol>> *)elements
                   imageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider
                   configuration:(TBVImageBrowserConfiguration *)configuration {
    self = [self init];
    if (self) {
        self.clipsToBounds = YES;
        self.configuration = configuration;
        self.flowLayout = [[TBVImageBrowserViewFlowLayout alloc]
                           initWithItemSize:configuration.itemSize];
        self.viewModel = [[TBVImageBrowserViewModel alloc]
                          initWithElements:elements
                          imageProvider:imageProvider
                          configuration:configuration];
        self.imageProvider = imageProvider;
        [self addSubview:self.collectionView];
        [self layoutPageSubviews];
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
                                     dequeueReusableCellWithReuseIdentifier:UIApplicationKeyboardExtensionPointIdentifier
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
                                             collectionViewLayout:self.flowLayout];
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
@end

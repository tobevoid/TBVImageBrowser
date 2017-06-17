//
//  TBVImageBrowserView.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <ReactiveObjC/ReactiveObjC.h>
#import <TBVLogger/TBVLogger.h>
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
        [self addSubview:self.collectionView];
        
        @weakify(self)
        RACCommand *clickedImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(imageBrowserView:didClickImageAtIndex:)]) {
                [self.delegate imageBrowserView:self didClickImageAtIndex:[self.elements indexOfObject:input]];
            }
            return [RACSignal empty];
        }];
        
        RACSignal *elementsChangeSignal = [[[RACObserve(self, elements)
            ignore:nil]
            map:^id(NSArray *elements) {
                return [elements.rac_sequence map:^id(id <TBVImageElementProtocol> element) {
                    TBVImageBrowserItemViewModel *viewModel = [[TBVImageBrowserItemViewModel alloc]
                                                               initWithElement:element];
                    viewModel.clickImageCommand = clickedImageCommand;
                    viewModel.progressPresenterClass = configuration.progressPresenterClass;
                    viewModel.contentImageSignal = [imageProvider imageSignalForElement:element];
                    return viewModel;
                }].array;
            }]
            doNext:^(id value) {
                @strongify(self)
                self.viewModel.dataSource = value;
                [self.collectionView reloadData];
            }];
        
        [[[[RACObserve(configuration, currentElementIndex)
            combineLatestWith:elementsChangeSignal]
            filter:^BOOL(RACTuple *value) {
                return [value.first integerValue] < [value.second count] &&
                    [value.first integerValue] >= 0;
            }]
            reduceEach:^id (NSNumber *currentIndex, NSArray *elements){
                return currentIndex;
            }]
            subscribeNext:^(id value) {
                @strongify(self)
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[value integerValue] inSection:0];
                [self.collectionView scrollToItemAtIndexPath:indexPath
                                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                    animated:NO];
                if ([self.delegate respondsToSelector:@selector(imageBrowserView:didDisplayImageAtIndex:)]) {
                    [self.delegate imageBrowserView:self didDisplayImageAtIndex:indexPath.item];
                }
            }];
    }
    return self;
}

- (void)dealloc {
    TBVLogInfo(@"<%@: %p> is being released", [self class], self);
}

#pragma mark layout
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutPageSubviews];
    [self setupBrowserFlowLayout];
}

- (void)layoutPageSubviews {
    self.collectionView.frame = (CGRect) {
        .origin = CGPointZero,
        /* for image's spacing in browser */
        .size = CGSizeMake(self.frame.size.width + 2 * kTBVImageBrowserViewFlowLayoutMargin,
                           self.frame.size.height)
    };
}

- (void)setupBrowserFlowLayout {
    if (self.flowLayout != self.collectionView.collectionViewLayout) {
        if (self.frame.size.height != 0 && self.frame.size.width != 0) {
            CGSize itemSize = CGSizeZero;
            if (CGSizeEqualToSize(CGSizeZero, self.configuration.itemSize)) {
                itemSize = self.frame.size;
                TBVLogInfo(@"layout browser with default item size.");
            } else {
                itemSize = self.configuration.itemSize;
            }
            self.flowLayout = [[TBVImageBrowserViewFlowLayout alloc] initWithItemSize:itemSize];
            [self.collectionView setCollectionViewLayout:self.flowLayout animated:NO];
        }
    }
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
    if ([self.delegate respondsToSelector:@selector(imageBrowserView:didDisplayImageAtIndex:)]) {
        [self.delegate imageBrowserView:self didDisplayImageAtIndex:indexPath.item];
    }
}
#pragma mark getter setter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
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

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.collectionView.backgroundColor = backgroundColor;
}

@end

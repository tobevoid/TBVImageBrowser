//
//  TBVImageBrowserViewCell.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <ReactiveObjC/ReactiveObjC.h>
#import <TBVLogger/TBVLogger.h>
#import "TBVImageProgressPresenterProtocol.h"
#import "TBVImageBrowserConfiguration.h"
#import "TBVImageBrowserViewFlowLayout.h"
#import "TBVImageBrowserViewCell.h"
#import "TBVImageBrowserItemViewModel.h"

@interface TBVImageBrowserViewCell() <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *contentScrollView;
@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) TBVImageBrowserItemViewModel *viewModel;
@property (strong, nonatomic) UIView <TBVImageProgressPresenterProtocol> *progressView;
@end

@implementation TBVImageBrowserViewCell
#pragma mark life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentScrollView addSubview:self.contentImageView];
        [self.contentView addSubview:self.contentScrollView];
        [self addTapGestures];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    /* 复用时，取消放大效果 */
    [self.contentScrollView setZoomScale:1.0 animated:NO];
    self.contentImageView.image = nil;
    [self.progressView setPresenterProgress:0 animated:NO];
}

#pragma mark layout
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutPageSubviews];
}

- (void)layoutPageSubviews {
    self.contentScrollView.frame = (CGRect) {
        .origin = CGPointZero,
        .size = CGSizeMake(self.bounds.size.width - 2 * kTBVImageBrowserViewFlowLayoutMargin,
                           self.bounds.size.height)
    };
    
    if (CGRectEqualToRect(self.contentImageView.frame, CGRectZero)) {
        self.contentImageView.frame = self.contentScrollView.bounds;
    }
    self.progressView.center = CGPointMake(self.frame.size.width * 0.5,
                                           self.frame.size.height * 0.5);
}
#pragma mark event response
- (void)singalTapTriggered:(UITapGestureRecognizer *)tap {
    [self.viewModel.clickImageCommand execute:nil];
}

- (void)doubleTapTriggered:(UITapGestureRecognizer *)tap {
    if (self.contentScrollView.zoomScale > 1.0) {
        [self.contentScrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.contentImageView];
        CGFloat zoomScale = self.contentScrollView.maximumZoomScale;
        CGFloat width = self.frame.size.width / zoomScale;
        CGFloat height = self.frame.size.height / zoomScale;
        [self.contentScrollView zoomToRect:CGRectMake(touchPoint.x - width * 0.5,
                                                      touchPoint.y - height * 0.5,
                                                      width,
                                                      height)
                                  animated:YES];
    }
}
#pragma mark public method
- (void)bindViewModel:(TBVImageBrowserItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    [self setupProgressPresenter:viewModel.progressPresenterClass];
    [self bindContentImageSignal:viewModel.contentImageSignal];
    [self bingProgressSignal:viewModel.progressSignal];
}

#pragma mark private method
- (void)setupProgressPresenter:(Class)progressPresenter{
    if (self.progressView || !progressPresenter) return;
    
    if ([progressPresenter conformsToProtocol:@protocol(TBVImageProgressPresenterProtocol)]) {
        id presenter = [progressPresenter presenter];
        if ([presenter isKindOfClass:[UIView class]]) {
            self.progressView = presenter;
            [self.contentView addSubview:self.progressView];
            CGSize size = CGSizeEqualToSize(CGSizeZero, self.progressView.frame.size) ?
                CGSizeMake(40.0f, 40.0f) : self.progressView.frame.size ;
            self.progressView.frame = (CGRect) {
                .origin = CGPointZero,
                .size = size
            };
            self.progressView.center = CGPointMake(self.frame.size.width * 0.5,
                                                   self.frame.size.height * 0.5);
        } else {
            TBVLogError(@"progressPresenter should be subclass of UIView.");
        }
    } else {
        TBVLogError(@"progressPresenter should comfirm TBVImageProgressPresenterProtocol.");
    }
}

- (void)bingProgressSignal:(RACSignal *)progressSignal {
    if (!self.progressView) return;
    
    @weakify(self)
    [[[progressSignal
        takeUntil:self.rac_prepareForReuseSignal]
        deliverOnMainThread]
        subscribeNext:^(id value) {
            @strongify(self)
            CGFloat progress = [value floatValue];
            [self.progressView setPresenterProgress:progress animated:YES];
            self.progressView.hidden = progress > 0.999;
        }];
}

- (void)bindContentImageSignal:(RACSignal *)contentImageSignal {
    @weakify(self)
    [[[[contentImageSignal
        takeUntil:self.rac_prepareForReuseSignal]
        ignore:nil]
        deliverOnMainThread]
        subscribeNext:^(UIImage *image) {
            @strongify(self)
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
            self.contentImageView.image = image;
            
            CGSize imageSize = image.size;
            CGSize contentScrollViewSize = self.contentScrollView.frame.size;
            CGRect contentImageViewFrame = self.contentImageView.frame;
            
            /* 宽度始终是屏幕宽度 */
            if (imageSize.width != 0 && imageSize.height != 0) {
                contentImageViewFrame.size.height = contentScrollViewSize.width /
                imageSize.width * imageSize.height;
                self.contentImageView.frame = contentImageViewFrame;
            }
            self.contentScrollView.contentSize = CGSizeMake(contentScrollViewSize.width,
                                                            MAX(contentScrollViewSize.height,
                                                                contentImageViewFrame.size.height));
            [self adjustImageViewToCenter];
            
        }];
}

#pragma mark private method

- (void)addTapGestures {
    UITapGestureRecognizer *singalTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(singalTapTriggered:)];
    singalTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singalTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(doubleTapTriggered:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    [singalTap requireGestureRecognizerToFail:doubleTap];
}

/** 调整到中心(主要针对 zoomScale < 1 的情况) */
- (void)adjustImageViewToCenter {
    CGSize boundsSize = self.contentScrollView.bounds.size;
    CGRect frameToCenter = self.contentImageView.frame;
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) * 0.5;
    } else {
        frameToCenter.origin.x = 0;
    }
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) * 0.5;
    } else {
        frameToCenter.origin.y = 0;
    }
    if (!CGRectEqualToRect(self.contentImageView.frame, frameToCenter)) {
        self.contentImageView.frame = frameToCenter;
    }
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.contentImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self adjustImageViewToCenter];
}

#pragma mark getter setter
- (UIScrollView *)contentScrollView
{
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.bouncesZoom = YES;
        _contentScrollView.maximumZoomScale = 3.0;
        _contentScrollView.minimumZoomScale = 1.0;
        _contentScrollView.multipleTouchEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView.scrollsToTop = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.delaysContentTouches = NO;
        _contentScrollView.alwaysBounceVertical = NO;
        _contentScrollView.autoresizingMask =
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _contentScrollView;
}

- (UIImageView *)contentImageView
{
    if (_contentImageView == nil) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.clipsToBounds = YES;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _contentImageView;
}
@end

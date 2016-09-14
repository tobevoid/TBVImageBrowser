//
//  TBVImageBrowserViewCell.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+HandleFrameLayout.h"
#import "TBVLogger.h"
#import "TBVImageBrowserViewCell.h"
#import "TBVImageBrowserItemViewModel.h"
#import "TBVImageBrowserViewFlowLayout.h"

@interface TBVImageBrowserViewCell() <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *contentScrollView;
@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) TBVImageBrowserItemViewModel *viewModel;
@end

@implementation TBVImageBrowserViewCell
#pragma mark life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentScrollView addSubview:self.contentImageView];
        [self.contentView addSubview:self.contentScrollView];
        [self layoutPageSubviews];
        [self addTapGestures];
    }
    
    return self;
}

- (void)layoutPageSubviews {
    [self.contentScrollView handleFrame:^(CGRect *frame) {
        frame->size.width = self.bounds.size.width - 2 * kTBVImageBrowserViewFlowLayoutMargin;
        frame->size.height = self.bounds.size.height;
    }];
    
    self.contentImageView.frame = self.contentScrollView.bounds;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    /* 复用时，取消放大效果 */
    [self.contentScrollView setZoomScale:1.0 animated:NO];
    self.contentImageView.image = nil;
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
    
    [self bindContentImageSignal:viewModel.contentImageSignal];
    [self bingProgressSignal:viewModel.progressSignal];
}

- (void)bingProgressSignal:(RACSignal *)progressSignal {
    //TODO: bind progress
}

- (void)bindContentImageSignal:(RACSignal *)contentImageSignal {
    @weakify(self)
    [[[contentImageSignal
       takeUntil:self.rac_prepareForReuseSignal]
      ignore:nil]
     subscribeNext:^(UIImage *image) {
         @strongify(self)
         self.contentImageView.image = image;
         
         CGSize imageSize = image.size;
         CGSize contentScrollViewSize = self.contentScrollView.frame.size;
         CGRect bounds = self.contentScrollView.bounds;
         
         /* 宽度始终是屏幕宽度 */
         if (imageSize.width != 0 && imageSize.height != 0) {
             [self.contentImageView handleFrame:^(CGRect *frame) {
                 frame->size.height = contentScrollViewSize.width /
                 imageSize.width * imageSize.height;
             }];
             bounds.size.height = self.contentImageView.frame.size.height;
         }
         self.contentScrollView.contentSize = CGSizeMake(contentScrollViewSize.width,
                                                         MAX(contentScrollViewSize.height,
                                                             bounds.size.height));
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

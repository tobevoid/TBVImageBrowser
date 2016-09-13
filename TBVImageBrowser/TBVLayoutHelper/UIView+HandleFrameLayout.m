//
//  UIView+HandleFrameLayout.m
//  TBVCommon
//
//  Created by tripleCC on 9/8/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "UIView+HandleFrameLayout.h"

@implementation UIView (HandleFrameLayout)
- (UIView *)handleVisibleFrame:(void (^)(CGRect *))action {
    if (!self.alpha || !self.hidden) return self;
    return [self handleFrame:action];
}

- (UIView *)handleVisibleCenter:(void (^)(CGPoint *))center {
    if (!self.alpha || !self.hidden) return self;
    return [self handleCenter:center];
}

- (UIView *)handleFrame:(void(^)(CGRect *))action {
    CGRect frame = self.frame;
    action(&frame);
    self.frame = frame;
    return self;
}

- (UIView *)handleCenter:(void(^)(CGPoint *))action {
    CGPoint center = self.center;
    action(&center);
    self.center = center;
    return self;
}
@end

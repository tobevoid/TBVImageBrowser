//
//  UIView+HandleFrameLayout.h
//  TBVCommon
//
//  Created by tripleCC on 9/8/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HandleFrameLayout)
- (UIView *)handleVisibleCenter:(void (^)(CGPoint *))center;
- (UIView *)handleVisibleFrame:(void (^)(CGRect *))action;
- (UIView *)handleFrame:(void(^)(CGRect *))action;
- (UIView *)handleCenter:(void(^)(CGPoint *))action;
@end

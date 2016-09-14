//
//  TBVImageProgressPresenterProtocol.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/14/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#ifndef TBVImageProgressPresenterProtocol_h
#define TBVImageProgressPresenterProtocol_h

#import <UIKit/UIKit.h>
@protocol TBVImageProgressPresenterProtocol <NSObject>
+ (instancetype)presenter;
- (void)setPresenterProgress:(CGFloat)progress animated:(BOOL)animated;
@end

#endif /* TBVImageProgressPresenterProtocol_h */

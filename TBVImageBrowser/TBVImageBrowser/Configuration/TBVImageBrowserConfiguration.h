//
//  TBVImageBrowserConfiguration.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

CF_EXPORT NSString *const kTBVImageBrowserProgressPresenterSizeKey;
@interface TBVImageBrowserConfiguration : NSObject
@property (assign, nonatomic) CGSize itemSize;
@property (strong, nonatomic) RACCommand *clickedImageCommand;

/** subclass of UIView, comfirm TBVImageProgressPresenterProtocol */
@property (assign, nonatomic) Class progressPresenterClass;

+ (instancetype)defaultConfiguration;
@end

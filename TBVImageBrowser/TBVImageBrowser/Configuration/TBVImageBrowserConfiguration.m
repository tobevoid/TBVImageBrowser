//
//  TBVImageBrowserConfiguration.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVImageBrowserConfiguration.h"

NSString *const kTBVImageBrowserProgressPresenterSizeKey = @"kTBVImageBrowserProgressPresenterSize";

@implementation TBVImageBrowserConfiguration
+ (instancetype)defaultConfiguration {
    TBVImageBrowserConfiguration *configuration = [[TBVImageBrowserConfiguration alloc] init];
    configuration.itemSize = CGSizeZero;
    configuration.currentElementIndex = 0;
    configuration.progressPresenterClass = nil;
    return configuration;
}
@end

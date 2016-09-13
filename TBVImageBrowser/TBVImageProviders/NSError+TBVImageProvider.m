//
//  NSError+TBVImageProvider.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "NSError+TBVImageProvider.h"
NSString *const kTBVImageProviderErrorKey = @"kTBVImageProviderError";
@implementation NSError (TBVImageProvider)
+ (instancetype)errorWithDomain:(NSString *)domain message:(NSString *)message {
    return [self errorWithDomain:domain code:-1 userInfo:@{kTBVImageProviderErrorKey : message}];
}
@end

//
//  NSError+TBVImageProvider.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Foundation/Foundation.h>

CF_EXPORT NSString *const kTBVImageProviderErrorKey;
@interface NSError (TBVImageProvider)
+ (instancetype)errorWithDomain:(NSString *)domain message:(NSString *)message;
@end

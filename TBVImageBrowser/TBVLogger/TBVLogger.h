//
//  TBVLogger.h
//  TBVNetworking
//
//  Created by tripleCC on 8/21/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TBV_LOG_ENABLE_DEBUG   1
#define TBV_LOG_ENABLE_INFO    1
#define TBV_LOG_ENABLE_WARN    1
#define TBV_LOG_ENABLE_ERROR   1

CF_EXPORT void TBVLogDebug(NSString *frmt, ...) NS_FORMAT_FUNCTION(1,2);
CF_EXPORT void TBVLogInfo(NSString *frmt, ...) NS_FORMAT_FUNCTION(1,2);
CF_EXPORT void TBVLogWarn(NSString *frmt, ...) NS_FORMAT_FUNCTION(1,2);
CF_EXPORT void TBVLogError(NSString *frmt, ...) NS_FORMAT_FUNCTION(1,2);

@interface TBVLogger : NSObject
+ (void)configureLogger;
@end

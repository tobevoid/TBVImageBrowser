//
//  TBVLogger.m
//  TBVNetworking
//
//  Created by tripleCC on 8/21/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "TBVLogger.h"

const DDLogLevel ddLogLevel = DDLogLevelVerbose;

#define MESSAGE(args, frmt) @"%@", [[NSString alloc] initWithFormat:frmt arguments:args]

void TBVLogDebug(NSString *frmt, ...) {
#if DEBUG && TBV_LOG_ENABLE_DEBUG
    va_list args;
    va_start(args, frmt);
    DDLogDebug(MESSAGE(args, frmt));
    va_end(args);
#endif
}

void TBVLogInfo(NSString *frmt, ...) {
#if DEBUG && TBV_LOG_ENABLE_INFO
    va_list args;
    va_start(args, frmt);
    DDLogInfo(MESSAGE(args, frmt));
    va_end(args);
#endif
}

void TBVLogWarn(NSString *frmt, ...) {
#if DEBUG && TBV_LOG_ENABLE_WARN
    va_list args;
    va_start(args, frmt);
    DDLogWarn(MESSAGE(args, frmt));
    va_end(args);
#endif
}

void TBVLogError(NSString *frmt, ...) {
#if DEBUG && TBV_LOG_ENABLE_ERROR
    va_list args;
    va_start(args, frmt);
    DDLogError(MESSAGE(args, frmt));
    va_end(args);
#endif
}


@implementation TBVLogger

+ (void)configureLogger {
    /* XcodeColors
     * 1、In Xcode bring up the Scheme Editor (Product -> Edit Scheme...)
     * 2、Select "Run" (on the left), and then the "Arguments" tab
     * 3、Add a new Environment Variable named "XcodeColors", with a value of "YES"
     */
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDTTYLogger sharedInstance].colorsEnabled = YES;
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor]
                                     backgroundColor:nil
                                             forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor orangeColor]
                                     backgroundColor:nil
                                             forFlag:DDLogFlagWarning];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor]
                                     backgroundColor:nil
                                             forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor cyanColor]
                                     backgroundColor:nil
                                             forFlag:DDLogFlagDebug];
}
@end

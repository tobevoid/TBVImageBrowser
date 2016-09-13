//
//  ALAssetsLibrary+TBVAssetsPicker.m
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "ALAssetsLibrary+TBVAssetsManager.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
@implementation ALAssetsLibrary (TBVAssetsManager)
+ (TBVAssetsAuthorizationStatus)tbv_authorizationStatus {
    switch ([self authorizationStatus]) {
        case ALAuthorizationStatusNotDetermined:
            return TBVAssetsAuthorizationStatusNotDetermined;
        case ALAuthorizationStatusRestricted:
            return TBVAssetsAuthorizationStatusRestricted;
        case ALAuthorizationStatusDenied:
            return TBVAssetsAuthorizationStatusDenied;
        case ALAuthorizationStatusAuthorized:
            return TBVAssetsAuthorizationStatusAuthorized;
    }
}

+ (RACSignal *)tbv_forceTriggerPermissionAsking {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        void (^sendStatus)() = ^{
            [subscriber sendNext:@([self tbv_authorizationStatus])];
            [subscriber sendCompleted];
        };
        
        if ([self tbv_authorizationStatus] != TBVAssetsAuthorizationStatusNotDetermined) {
            sendStatus();
            return nil;
        }
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            sendStatus();
            *stop = YES;
        } failureBlock:^(NSError *error) {
            sendStatus();
        }];
        return nil;
    }] deliverOnMainThread];
}
@end
#pragma clang diagnostic pop
//
//  PHPhotoLibrary+TBVAssetsPicker.m
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "PHPhotoLibrary+TBVAssetsManager.h"

@implementation PHPhotoLibrary (TBVAssetsManager)
+ (BQAuthorizationStatus)tbv_authorizationStatus {
    switch ([self authorizationStatus]) {
        case PHAuthorizationStatusNotDetermined:
            return BQAuthorizationStatusNotDetermined;
        case PHAuthorizationStatusRestricted:
            return BQAuthorizationStatusRestricted;
        case PHAuthorizationStatusDenied:
            return BQAuthorizationStatusDenied;
        case PHAuthorizationStatusAuthorized:
            return BQAuthorizationStatusAuthorized;
    }
}

+ (RACSignal *)tbv_requestAuthorization {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self  requestAuthorization:^(PHAuthorizationStatus status) {
            [subscriber sendNext:@([self tbv_authorizationStatus])];
            [subscriber sendCompleted];
        }];
        return nil;
    }] deliverOnMainThread];
}
@end

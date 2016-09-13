//
//  TBVAssetsPickerManager+Authorization.m
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVAssetsPickerManager+Authorization.h"
#import "ALAssetsLibrary+TBVAssetsManager.h"
#import "PHPhotoLibrary+TBVAssetsManager.h"

@implementation TBVAssetsPickerManager (Authorization)
- (TBVAssetsAuthorizationStatus)authorizationStatus {
    if (self.photoKitAvailable) {
        return [PHPhotoLibrary tbv_authorizationStatus];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
        return [ALAssetsLibrary tbv_authorizationStatus];
#pragma clang diagnostic pop
    }
}

- (BOOL)isAuthorized {
    return [self authorizationStatus] == TBVAssetsAuthorizationStatusAuthorized;
}

- (RACSignal *)requestAuthorization {
    /* tureSignal 或者 falseSignal不能为nil，所以不用RACSignal< + if then else> */
    if (self.photoKitAvailable) {
        return [PHPhotoLibrary tbv_requestAuthorization];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
        return [ALAssetsLibrary tbv_forceTriggerPermissionAsking];
#pragma clang diagnostic pop
    }
}
@end

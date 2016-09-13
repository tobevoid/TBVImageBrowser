//
//  ALAssetsLibrary+TBVAssetsPicker.h
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TBVAssetsManagerTypes.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
@interface ALAssetsLibrary (TBVAssetsManager)
+ (TBVAssetsAuthorizationStatus)tbv_authorizationStatus;
+ (RACSignal *)tbv_forceTriggerPermissionAsking;
@end
#pragma clang diagnostic pop

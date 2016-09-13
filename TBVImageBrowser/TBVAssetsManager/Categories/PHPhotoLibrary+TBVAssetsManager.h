//
//  PHPhotoLibrary+TBVAssetsPicker.h
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Photos/Photos.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TBVAssetsPickerTypes.h"
@interface PHPhotoLibrary (TBVAssetsManager)
+ (BQAuthorizationStatus)tbv_authorizationStatus;
+ (RACSignal *)tbv_requestAuthorization;
@end

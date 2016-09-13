//
//  TBVAssetsPickerManager+Authorization.h
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TBVAssetsPickerManager.h"
#import "TBVAssetsPickerTypes.h"
@interface TBVAssetsPickerManager (Authorization)
- (BOOL)isAuthorized;
- (RACSignal *)requestAuthorization;
- (BQAuthorizationStatus)authorizationStatus;
@end

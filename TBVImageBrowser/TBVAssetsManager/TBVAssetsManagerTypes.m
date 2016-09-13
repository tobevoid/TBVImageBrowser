//
//  TBVAssetsPickerTypes.m
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVAssetsManagerTypes.h"

const CGFloat kBQPosterImageWidth = 70;
const CGFloat kBQPosterImageHeight = kBQPosterImageWidth;

NSString * const TBVAssetsAssetsDidChangeNotification = @"TBVAssetsAssetsDidChangeNotification";


const NSDictionary *TBVAssetsAuthorizationStatusStringsMap;

@interface TBVAssetsManagerTypes : NSObject

@end

@implementation TBVAssetsManagerTypes
+ (void)load {
    #define BQ_ASSETS_PICKER_TYPE_ELEMENT(key) @(key) : @#key
    
    TBVAssetsAuthorizationStatusStringsMap =
        @{BQ_ASSETS_PICKER_TYPE_ELEMENT(TBVAssetsAuthorizationStatusNotDetermined),
          BQ_ASSETS_PICKER_TYPE_ELEMENT(TBVAssetsAuthorizationStatusRestricted),
          BQ_ASSETS_PICKER_TYPE_ELEMENT(TBVAssetsAuthorizationStatusDenied),
          BQ_ASSETS_PICKER_TYPE_ELEMENT(TBVAssetsAuthorizationStatusAuthorized)};
}
@end
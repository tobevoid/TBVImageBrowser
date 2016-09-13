//
//  PHFetchOptions+FilterMediaTypes.h
//  PhotoBrowser
//
//  Created by tripleCC on 8/22/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Photos/Photos.h>
#import "TBVAssetsPickerTypes.h"

@interface PHFetchOptions (TBVAssetsManager)
+ (instancetype)tbv_fetchOptionsWithCustomMediaType:(TBVAssetsPickerMediaType)mediaType;
+ (NSArray <NSNumber *> *)tbv_mediaTypesWithCustonMediaType:(TBVAssetsPickerMediaType)mediaType;
@end

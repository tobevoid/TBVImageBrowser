//
//  PHFetchOptions+FilterMediaTypes.h
//  PhotoBrowser
//
//  Created by tripleCC on 8/22/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Photos/Photos.h>
#import "TBVAssetsManagerTypes.h"

@interface PHFetchOptions (TBVAssetsManager)
+ (instancetype)tbv_fetchOptionsWithCustomMediaType:(TBVAssetsMediaType)mediaType;
+ (NSArray <NSNumber *> *)tbv_mediaTypesWithCustonMediaType:(TBVAssetsMediaType)mediaType;
@end

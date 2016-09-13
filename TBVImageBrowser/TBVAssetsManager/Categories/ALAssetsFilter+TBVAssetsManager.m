//
//  ALAssetsFilter+DisplayType.m
//  PhotoBrowser
//
//  Created by tripleCC on 8/22/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "ALAssetsFilter+TBVAssetsManager.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
@implementation ALAssetsFilter (TBVAssetsManager)
+ (instancetype)tbv_assetsFilterWithCustomMediaType:(TBVAssetsPickerMediaType)mediaType {
    if (mediaType == TBVAssetsPickerMediaTypeImage) {
        return [self allPhotos];
    }
    if (mediaType == TBVAssetsPickerMediaTypeVideo) {
        return [self allVideos];
    }
    if (mediaType == TBVAssetsPickerMediaTypeAll) {
        return [self allAssets];
    }
    return nil;
}
@end
#pragma clang diagnostic pop
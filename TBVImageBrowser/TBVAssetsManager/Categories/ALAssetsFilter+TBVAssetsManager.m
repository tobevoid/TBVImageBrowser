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
+ (instancetype)tbv_assetsFilterWithCustomMediaType:(TBVAssetsMediaType)mediaType {
    if (mediaType == TBVAssetsMediaTypeImage) {
        return [self allPhotos];
    }
    if (mediaType == TBVAssetsMediaTypeVideo) {
        return [self allVideos];
    }
    if (mediaType == TBVAssetsMediaTypeAll) {
        return [self allAssets];
    }
    return nil;
}
@end
#pragma clang diagnostic pop
//
//  PHFetchOptions+FilterMediaTypes.m
//  PhotoBrowser
//
//  Created by tripleCC on 8/22/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "PHFetchOptions+TBVAssetsManager.h"

@implementation PHFetchOptions (TBVAssetsManager)
+ (instancetype)tbv_fetchOptionsWithCustomMediaType:(TBVAssetsPickerMediaType)mediaType {
    NSArray *mediaTypes = [self tbv_mediaTypesWithCustonMediaType:mediaType];
    if (!mediaTypes.count) return nil;
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    NSMutableString *predicateString = [NSMutableString string];
    for (NSNumber *mediaType in mediaTypes) {
        [predicateString appendFormat:@"mediaType = %@", mediaType];
        if (![mediaType isEqual:mediaTypes.lastObject]) [predicateString appendString:@" || "];
    }
    options.predicate = [NSPredicate predicateWithFormat:predicateString];
    return options;
}

+ (NSArray <NSNumber *> *)tbv_mediaTypesWithCustonMediaType:(TBVAssetsPickerMediaType)mediaType {
    NSMutableArray *mediaTypes = [NSMutableArray array];
    if (mediaType == TBVAssetsPickerMediaTypeImage) {
        [mediaTypes addObject:@(PHAssetMediaTypeImage)];
    }
    if (mediaType == TBVAssetsPickerMediaTypeVideo) {
        [mediaTypes addObject:@(PHAssetMediaTypeVideo)];
    }
    if (mediaType == TBVAssetsPickerMediaTypeAll) {
        [mediaTypes addObject:@(PHAssetMediaTypeImage)];
        [mediaTypes addObject:@(PHAssetMediaTypeVideo)];
    }
    return mediaTypes;
}
@end

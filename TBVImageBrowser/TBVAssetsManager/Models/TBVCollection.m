//
//  BQAlbum.m
//  PhotoLibTest
//
//  Created by tripleCC on 15/12/10.
//  Copyright © 2015年 tripleCC. All rights reserved.
//
#import <Photos/Photos.h>
#import "PHAssetCollection+TBVAssetsManager.h"
#import "PHFetchOptions+TBVAssetsManager.h"
#import "ALAssetsFilter+TBVAssetsManager.h"
#import "TBVCollection.h"

@implementation TBVCollection
+ (instancetype)collectionWithOriginCollection:(NSObject *)aCollection {
    TBVCollection *collection = [[self alloc] init];
    if (collection) {
        collection.collection = aCollection;
    }
    return collection;
}

- (NSString *)collectionTitle {
    if ([self.collection class] != [ALAssetsGroup class]) {
        return  ((PHAssetCollection *)self.collection).localizedTitle;
    } else {
        return [(ALAssetsGroup *)self.collection valueForProperty:ALAssetsGroupPropertyName];
    }
}

- (NSInteger)collectionEstimatedAssetCount {
    if ([self.collection class] != [ALAssetsGroup class]) {
        return ((PHAssetCollection *)self.collection).estimatedAssetCount;
    } else {
        return [(ALAssetsGroup *)self.collection numberOfAssets];
    }
}

- (NSInteger)collectionAccurateAssetCountWithFetchOptions:(id)filterOptions {
    if ([self.collection class] != [ALAssetsGroup class]) {
        PHAssetCollection *collection = (PHAssetCollection *)self.collection;
        if ([filterOptions isKindOfClass:[PHFetchOptions class]]) {
            return [collection tbv_countOfAssetsFetchedWithOptions:filterOptions];
        }
    } else {
        ALAssetsGroup *group = (ALAssetsGroup *)self.collection;
        if ([filterOptions isKindOfClass:[ALAssetsFilter class]]) {
            [group setAssetsFilter:filterOptions];
            return group.numberOfAssets;
        }
    }
    return 0;
}

- (NSInteger)collectionAccurateAssetCountWithMediaType:(TBVAssetsPickerMediaType)mediaType {
    NSObject *filterOptions = nil;
    if ([self.collection class] != [ALAssetsGroup class]) {
        filterOptions = [PHFetchOptions tbv_fetchOptionsWithCustomMediaType:mediaType];
    } else {
        filterOptions = [ALAssetsFilter tbv_assetsFilterWithCustomMediaType:mediaType];
    }
    return [self collectionAccurateAssetCountWithFetchOptions:filterOptions];
}
@end


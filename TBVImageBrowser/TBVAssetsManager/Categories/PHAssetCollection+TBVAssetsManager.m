//
//  PHAssetCollection+TBVAssetsPicker.m
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "PHAssetCollection+TBVAssetsManager.h"

@implementation PHAssetCollection (TBVAssetsManager)
- (NSUInteger)tbv_countOfAssetsFetchedWithOptions:(PHFetchOptions *)fetchOptions {
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self options:fetchOptions];
    return result.count;
}
@end

//
//  PHAssetCollection+TBVAssetsPicker.h
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAssetCollection (TBVAssetsManager)
- (NSUInteger)tbv_countOfAssetsFetchedWithOptions:(PHFetchOptions *)fetchOptions;
@end

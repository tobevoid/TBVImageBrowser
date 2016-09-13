//
//  BQAlbum.h
//  PhotoLibTest
//
//  Created by tripleCC on 15/12/10.
//  Copyright © 2015年 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBVAsset;
@interface TBVCollection : NSObject
/**
 *  ALAssetsGroup or PHAssetCollection
 */
@property (strong, nonatomic) NSObject  *collection;

+ (instancetype)collectionWithOriginCollection:(NSObject *)aCollection;
- (NSString *)collectionTitle;
- (NSInteger)collectionEstimatedAssetCount;
- (NSInteger)collectionAccurateAssetCountWithFetchOptions:(id)filterOptions;
- (NSInteger)collectionAccurateAssetCountWithMediaType:(TBVAssetsMediaType)mediaType;
@end


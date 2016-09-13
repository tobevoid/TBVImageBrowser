//
//  TBVAssetsManagerProtocol.h
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#ifndef TBVAssetsManagerProtocol_h
#define TBVAssetsManagerProtocol_h

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TBVAssetsManagerTypes.h"

@class TBVAsset;
@class TBVCollection;
@protocol TBVAssetsManagerProtocol <NSObject>
@required
//====================================
//              image
//====================================

/** requestImage返回都是一个RACTuple，first是Image，second是是否为degraded */

- (RACSignal *)requestImageForAsset:(TBVAsset *)asset
                         targetSize:(CGSize)targetSize
                        contentMode:(TBVAssetsContentMode)contentMode;

- (RACSignal *)requestPosterImageForCollection:(TBVCollection *)collection
                                     mediaType:(TBVAssetsMediaType)mediaType;

- (RACSignal *)requestPosterImageForAsset:(TBVAsset *)asset;

- (RACSignal *)requestFullResolutionImageForAsset:(TBVAsset *)asset;

//====================================
//              asset / collection
//====================================

- (RACSignal *)requestSizeForAssets:(NSArray <TBVAsset *> *)assets;

- (RACSignal *)requestAllCollections;

- (RACSignal *)requestAssetsForCollection:(TBVCollection *)collection
                                mediaType:(TBVAssetsMediaType)mediaType;

- (RACSignal *)requestCameraRollCollection;

//====================================
//              video
//====================================

- (RACSignal *)requestVideoForAsset:(TBVAsset *)asset;

- (RACSignal *)requestURLAssetForAsset:(TBVAsset *)asset;
@end

#endif /* TBVAssetsManagerProtocol_h */

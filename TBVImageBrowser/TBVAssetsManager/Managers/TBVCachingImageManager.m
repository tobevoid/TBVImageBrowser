//
//  TBVCachingImageManager.m
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Photos/Photos.h>
#import "PHFetchOptions+TBVAssetsManager.h"
#import "TBVCachingImageManager.h"
#import "TBVAssetsPickerTypes.h"
#import "TBVAsset.h"
#import "TBVCollection.h"

@interface TBVCachingImageManager() <PHPhotoLibraryChangeObserver>
@property (strong, nonatomic) PHCachingImageManager *imageManager;
@property (strong, nonatomic, readonly) PHImageRequestOptions *defaultImageRequestOptions;
@end

@implementation TBVCachingImageManager
#pragma mark life cycle
- (instancetype)init {
    if (self = [super init]) {
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
    return self;
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark event response
- (void)photoLibraryDidChange:(PHChange *)change {
    /*  这里可以对change进行一些处理，让iOS8 + - 两个版本输出一致 */
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:TBVAssetsPickerAssetsDidChangeNotification
     object:change];
}

#pragma mark TBVAssetsManagerProtocol
- (RACSignal *)requestImageForAsset:(TBVAsset *)asset
                         targetSize:(CGSize)targetSize
                        contentMode:(TBVAssetsPickerContentMode)contentMode {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        PHImageRequestID requestId = [self.imageManager
                                      requestImageForAsset:(PHAsset *)asset.asset
                                      targetSize:targetSize
                                      contentMode:[self contentModeForCustomContentMode:contentMode]
                                      options:self.defaultImageRequestOptions
                                      resultHandler:^(UIImage * _Nullable result,
                                                      NSDictionary * _Nullable info) {
                                          [subscriber sendNext:RACTuplePack(result, info[PHImageResultIsDegradedKey])];
                                          if (![info[PHImageResultIsDegradedKey] boolValue]) {
                                              [subscriber sendCompleted];
                                          }
                                      }];
        return [RACDisposable disposableWithBlock:^{
            [self.imageManager cancelImageRequest:requestId];
        }];
    }];
}

- (RACSignal *)requestPosterImageForAsset:(TBVAsset *)asset {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        CGSize posterSize = CGSizeMake(kBQPosterImageWidth * BQAP_SCREEN_SCALE,
                                       kBQPosterImageHeight * BQAP_SCREEN_SCALE);
        /* 在获取缩略图的情况下，Fill比Fit获取的图片要清晰 */
        PHImageRequestID requestId = [self.imageManager
                                      requestImageForAsset:(PHAsset *)asset.asset
                                      targetSize:posterSize
                                      contentMode:PHImageContentModeAspectFill
                                      options:self.defaultImageRequestOptions
                                      resultHandler:^(UIImage * _Nullable result,
                                                      NSDictionary * _Nullable info) {
                                          [subscriber sendNext:RACTuplePack(result, info[PHImageResultIsDegradedKey])];
                                          if (![info[PHImageResultIsDegradedKey] boolValue]) {
                                              [subscriber sendCompleted];
                                          }
                                      }];
        return [RACDisposable disposableWithBlock:^{
            [self.imageManager cancelImageRequest:requestId];
        }];
    }];
}

- (RACSignal *)requestFullResolutionImageForAsset:(TBVAsset *)asset {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.defaultImageRequestOptions.networkAccessAllowed = YES;
        PHImageRequestID requestId = [self.imageManager
                                      requestImageForAsset:(PHAsset *)asset.asset
                                      targetSize:PHImageManagerMaximumSize
                                      contentMode:PHImageContentModeDefault
                                      options:self.defaultImageRequestOptions
                                      resultHandler:^(UIImage * _Nullable result,
                                                      NSDictionary * _Nullable info) {
                                          [subscriber sendNext:RACTuplePack(result, info[PHImageResultIsDegradedKey])];
                                          if (![info[PHImageResultIsDegradedKey] boolValue]) {
                                              [subscriber sendCompleted];
                                          }
                                      }];
        return [RACDisposable disposableWithBlock:^{
            [self.imageManager cancelImageRequest:requestId];
        }];
    }];
}

- (RACSignal *)requestSizeForAssets:(NSArray<TBVAsset *> *)assets {
    RACSequence *requestSequence = [[assets.rac_sequence
        filter:^BOOL(TBVAsset *asset) {
            return ((PHAsset *)asset.asset).mediaType == PHAssetMediaTypeImage;
        }]
        map:^id(TBVAsset *asset) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                self.defaultImageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                PHImageRequestID requestId =[self.imageManager
                                             requestImageDataForAsset:(PHAsset *)asset.asset
                                             options:self.defaultImageRequestOptions
                                             resultHandler:^(NSData * _Nullable imageData,
                                                             NSString * _Nullable dataUTI,
                                                             UIImageOrientation orientation,
                                                             NSDictionary * _Nullable info) {
                                                 [subscriber sendNext:@(imageData.length)];
                                                 [subscriber sendCompleted];
                                             }];
                return [RACDisposable disposableWithBlock:^{
                    [self.imageManager cancelImageRequest:requestId];
                }];
            }];
        }];

    return [[RACSignal
        zip:requestSequence]
        map:^id(RACTuple *value) {
            return [value.rac_sequence foldLeftWithStart:@0 reduce:^id(id accumulator, id value) {
                return @([accumulator integerValue] + [value integerValue]);
            }];
        }];
}

- (RACSignal *)requestAllCollections {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        PHFetchResult *smartResult = [PHAssetCollection
                                      fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                      subtype:PHAssetCollectionSubtypeAlbumRegular
                                      options:nil];
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        
        NSMutableArray *collections = [NSMutableArray array];
        for (PHAssetCollection *aCollection in smartResult) {
            TBVCollection *collection = [TBVCollection collectionWithOriginCollection:aCollection];
            [collections addObject:collection];
        }
        for (PHAssetCollection *aCollection in topLevelUserCollections) {
            TBVCollection *collection = [TBVCollection collectionWithOriginCollection:aCollection];
            [collections addObject:collection];
        }
        [subscriber sendNext:collections];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)requestPosterImageForCollection:(TBVCollection *)collection
                              mediaType:(TBVAssetsPickerMediaType)mediaType {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        PHFetchOptions *fetchOptions = [PHFetchOptions tbv_fetchOptionsWithCustomMediaType:mediaType];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                       ascending:YES]];
        PHAssetCollection *realCollection = (PHAssetCollection *)collection.collection;
        /* fetchKeyAssetsInAssetCollection 获取至多三张 */
        PHFetchResult *result = [PHAsset fetchKeyAssetsInAssetCollection:realCollection
                                                                 options:fetchOptions];
        if (!result.count) {
            [subscriber sendNext:[RACSignal empty]];
            [subscriber sendCompleted];
            return nil;
        }
        
        TBVAsset *posterAsset = [TBVAsset assetWithOriginAsset:result.firstObject];
        [subscriber sendNext:[self requestPosterImageForAsset:posterAsset]];
        [subscriber sendCompleted];
        return nil;
    }] switchToLatest];
}

- (RACSignal *)requestAssetsForCollection:(TBVCollection *)collection
                                mediaType:(TBVAssetsPickerMediaType)mediaType {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        PHFetchOptions *options = [PHFetchOptions tbv_fetchOptionsWithCustomMediaType:mediaType];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)collection.collection
                                                                   options:options];
        NSMutableArray *assets = [NSMutableArray arrayWithCapacity:fetchResult.count];
        for (PHAsset *asset in fetchResult) {
            [assets addObject:[TBVAsset assetWithOriginAsset:asset]];
        }
        [subscriber sendNext:assets];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)requestCameraRollCollection {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        PHFetchResult *smartAlbums = [PHAssetCollection
                                      fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                      subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                      options:nil];
        [subscriber sendNext:[TBVCollection collectionWithOriginCollection:smartAlbums.firstObject]];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (PHImageContentMode)contentModeForCustomContentMode:(TBVAssetsPickerContentMode)contentMode {
    switch (contentMode) {
        case TBVAssetsPickerContentModeFit:
            return PHImageContentModeAspectFit;
        case TBVAssetsPickerContentModeFill:
            return PHImageContentModeAspectFill;
    }
}

#pragma mark getter setter
- (PHCachingImageManager *)imageManager
{
    if (_imageManager == nil) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    
    return _imageManager;
}

- (PHImageRequestOptions *)defaultImageRequestOptions {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    /* PHImageRequestOptionsDeliveryModeOpportunistic 可能会先发送小图，
       PHImageRequestOptionsDeliveryModeHighQualityFormat 只会发送一张图 */
//    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    return options;
}
@end

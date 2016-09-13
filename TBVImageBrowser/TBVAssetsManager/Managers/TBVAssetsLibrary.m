//
//  TBVAssetsLibrary.m
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ALAssetsFilter+TBVAssetsManager.h"
#import "TBVAssetsLibrary.h"
#import "TBVAssetsPickerTypes.h"
#import "TBVAsset.h"
#import "TBVCollection.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
@interface TBVAssetsLibrary()
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@end
@implementation TBVAssetsLibrary
- (instancetype)init {
    if (self = [super init]) {
        [[[[NSNotificationCenter defaultCenter]
            rac_addObserverForName:ALAssetsLibraryChangedNotification object:self.assetsLibrary]
            takeUntil:self.rac_willDeallocSignal]
            subscribeNext:^(NSNotification *notification) {
                /*  这里可以对notification进行一些处理，让iOS8 + - 两个版本输出一致 */
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:TBVAssetsPickerAssetsDidChangeNotification
                 object:nil];
            }];
    }
    return self;
}

- (RACSignal *)requestImageForAsset:(TBVAsset *)aAsset
                         targetSize:(CGSize)targetSize
                        contentMode:(TBVAssetsPickerContentMode)contentMode {
    return [[[RACSignal return:aAsset.asset]
                deliverOn:[RACScheduler scheduler]]
                map:^id(ALAsset * asset) {
        CGImageRef resultImageRef = nil;
        
        BOOL degraded = NO;
        CGImageRef thumbnail = asset.thumbnail;
        if (targetSize.width < CGImageGetWidth(thumbnail) &&
            targetSize.height < CGImageGetHeight(thumbnail)) {
            // TBVAssetsPickerContentModeFill
            resultImageRef = thumbnail;
        }
        if (!resultImageRef) {
            CGImageRef aspectRatioThumbnail = asset.aspectRatioThumbnail;
            if (targetSize.width < CGImageGetWidth(aspectRatioThumbnail) &&
                targetSize.height < CGImageGetHeight(aspectRatioThumbnail)) {
                // TBVAssetsPickerContentModeFit
                resultImageRef = aspectRatioThumbnail;
            }
            if (!resultImageRef) {
                ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
                resultImageRef = [assetRepresentation fullScreenImage];
            }
        }
        UIImage *resultImage = nil;
        if (resultImageRef) {
            resultImage = [UIImage imageWithCGImage:resultImageRef
                                              scale:BQAP_SCREEN_SCALE
                                        orientation:UIImageOrientationUp];
        }
        return RACTuplePack(resultImage, @(degraded));
    }];
}

- (RACSignal *)requestPosterImageForAsset:(TBVAsset *)asset {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        CGSize posterSize = CGSizeMake(kBQPosterImageWidth * BQAP_SCREEN_SCALE,
                                       kBQPosterImageHeight * BQAP_SCREEN_SCALE);
        [subscriber sendNext:[self requestImageForAsset:asset
                                             targetSize:posterSize
                                            contentMode:TBVAssetsPickerContentModeFill]];
        [subscriber sendCompleted];
        return nil;
    }] switchToLatest];
}

- (RACSignal *)requestFullResolutionImageForAsset:(TBVAsset *)asset {
    return [[[RACSignal return:asset.asset]
        deliverOn:[RACScheduler scheduler]]
        map:^id(ALAsset * asset) {
            ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
            CGImageRef fullResolutionImage = [assetRepresentation fullResolutionImage];
            UIImage *resultImage = [UIImage imageWithCGImage:fullResolutionImage
                                                       scale:BQAP_SCREEN_SCALE
                                                 orientation:UIImageOrientationUp];
            
            return RACTuplePack(resultImage, @(NO));
        }];
}

- (RACSignal *)requestSizeForAssets:(NSArray<TBVAsset *> *)assets {
    return [RACSignal
        return:[[[[assets.rac_sequence
            map:^id(TBVAsset *asset) {
               return asset.asset;
            }]
            filter:^BOOL(ALAsset *asset) {
                return [asset valueForProperty:ALAssetPropertyType] == ALAssetTypePhoto;
            }]
            map:^id(ALAsset *asset) {
                return @([asset defaultRepresentation].size);
            }]
            foldLeftWithStart:@(0) reduce:^id(id accumulator, id value) {
                return @([accumulator integerValue] + [value integerValue]);
            }]];
    
}

- (RACSignal *)requestAllCollections {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableArray *collections = [NSMutableArray array];
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                          usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                TBVCollection *collection = [TBVCollection collectionWithOriginCollection:group];
                [collections addObject:collection];
            } else {
                [subscriber sendNext:collections];
                [subscriber sendCompleted];
            }
        } failureBlock:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)requestPosterImageForCollection:(TBVCollection *)collection
                            mediaType:(TBVAssetsPickerMediaType)mediaType {
    return [[[[RACSignal
        return:collection.collection]
        deliverOn:[RACScheduler scheduler]]
        filter:^BOOL(ALAssetsGroup *group) {
            return group.posterImage != nil;
        }]
        map:^id(ALAssetsGroup *group) {
            [group setAssetsFilter:[ALAssetsFilter tbv_assetsFilterWithCustomMediaType:mediaType]];
            return RACTuplePack([UIImage imageWithCGImage:group.posterImage], @(NO));
        }];
}

- (RACSignal *)requestAssetsForCollection:(TBVCollection *)collection
                                mediaType:(TBVAssetsPickerMediaType)mediaType {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableArray *assets = [NSMutableArray array];
        ALAssetsGroup *group = (ALAssetsGroup *)collection.collection;
        [group setAssetsFilter:[ALAssetsFilter tbv_assetsFilterWithCustomMediaType:mediaType]];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [assets addObject:[TBVAsset assetWithOriginAsset:result]];
            } else {
                [subscriber sendNext:assets];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)requestCameraRollCollection {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            [subscriber sendNext:[TBVCollection collectionWithOriginCollection:group]];
            [subscriber sendCompleted];
        } failureBlock:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}
#pragma mark getter setter
- (ALAssetsLibrary *)assetsLibrary
{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return _assetsLibrary;
}
@end
#pragma clang diagnostic pop
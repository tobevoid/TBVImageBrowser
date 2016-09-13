//
//  TBVAssetsPickerManager.m
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TBVLogger.h"
#import "TBVAssetsPickerManager.h"
#import "TBVAssetsManagerProtocol.h"
#import "TBVCachingImageManager.h"
#import "TBVAssetsLibrary.h"
#import "TBVCollection.h"


@interface TBVAssetsPickerManager() 
@property (strong, nonatomic) NSObject<TBVAssetsManagerProtocol> *realManager;
@property (strong, nonatomic) NSMutableArray *requestIdList;
@property (assign, nonatomic) BOOL photoKitAvailable;
@end

@implementation TBVAssetsPickerManager
#pragma mark life cycle
+ (TBVAssetsPickerManager *)manager {
    TBVAssetsPickerManager *manager = [[self alloc] init];
    if (manager) {
        
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _photoKitAvailable = NSClassFromString(@"PHImageManager") != nil;
    }
    return self;
}

- (void)dealloc {
    TBVLogInfo(@"%@ is being released", self);
}

#pragma mark TBVAssetsManagerProtocol
- (RACSignal *)requestImageForAsset:(TBVAsset *)asset
                         targetSize:(CGSize)targetSize
                        contentMode:(TBVAssetsPickerContentMode)contentMode {
    /* 这里不能用replayLazily等一系列方法，否则内存会居高不下，这系列方法会存储图片 */
    return [[self.realManager requestImageForAsset:asset
                                       targetSize:targetSize
                                        contentMode:contentMode]
            deliverOnMainThread];
}

- (RACSignal *)requestPosterImageForAsset:(TBVAsset *)asset {
    return [[self.realManager requestPosterImageForAsset:asset]
            deliverOnMainThread];
}

- (RACSignal *)requestFullResolutionImageForAsset:(TBVAsset *)asset {
    return [[self.realManager requestFullResolutionImageForAsset:asset]
            deliverOnMainThread];
}

- (RACSignal *)requestSizeForAssets:(NSArray<TBVAsset *> *)assets {
    /* assets是nil，返回的是[RACSignal empty]，界面需要有默认大小，所以返回0 */
    return [RACSignal
        if:[RACSignal return:@(!assets.count)]
        then:[RACSignal return:@0]
        else:[[self.realManager requestSizeForAssets:assets]
                deliverOnMainThread]];
}

- (RACSignal *)requestAllCollections {
    return [[self.realManager requestAllCollections]
            deliverOnMainThread];
}

- (RACSignal *)requestPosterImageForCollection:(TBVCollection *)collection
                            mediaType:(TBVAssetsPickerMediaType)mediaType {
    return [[self.realManager requestPosterImageForCollection:collection
                                                   mediaType:mediaType]
            deliverOnMainThread];
}

- (RACSignal *)requestAssetsForCollection:(TBVCollection *)collection
                                mediaType:(TBVAssetsPickerMediaType)mediaType {
    return [self.realManager requestAssetsForCollection:collection
                                              mediaType:mediaType];
}

- (RACSignal *)requestCameraRollCollection {
    return [self.realManager requestCameraRollCollection];
}
#pragma mark getter setter
- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [NSMutableArray array];
    }
    
    return _requestIdList;
}

- (NSObject *)realManager
{
    if (_realManager == nil) {
        if (self.photoKitAvailable) {
            _realManager = [[TBVCachingImageManager alloc] init];
        } else {
            _realManager = [[TBVAssetsLibrary alloc] init];
        }
    }
    
    return _realManager;
}
@end

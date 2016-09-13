//
//  TBVAssetsReformer.m
//  TBVAssetsPicker
//
//  Created by tripleCC on 9/12/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVAssetsReformer.h"
#import "TBVAssetsPickerManager.h"
#import "TBVLogger.h"

@interface TBVAssetsReformer()
@property (strong, nonatomic) TBVAssetsPickerManager *pickManager;
@end

@implementation TBVAssetsReformer

+ (instancetype)reformer {
    TBVAssetsReformer *reformer = [[TBVAssetsReformer alloc] init];
    return reformer;
}

- (void)dealloc {
    TBVLogInfo(@"%@ is being released", self);
}

- (RACSignal *)imageWithAsset:(TBVAsset *)asset mode:(TBVAssetsReformerMode)mode {
    switch (mode) {
        case TBVAssetsReformerModePoster: {
            return [self.pickManager requestPosterImageForAsset:asset];
        }
        case TBVAssetsReformerModeSmall: {
            CGFloat scale = 0.5;
            CGSize size = [UIScreen mainScreen].bounds.size;
            CGSize targetSize = CGSizeMake(size.width * scale, size.height * scale);
            return [self.pickManager requestImageForAsset:asset targetSize:targetSize contentMode:TBVAssetsPickerContentModeFill];
        }
        case TBVAssetsReformerModeMedium: {
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize size = [UIScreen mainScreen].bounds.size;
            CGSize targetSize = CGSizeMake(size.width * scale, size.height * scale);
            return [self.pickManager requestImageForAsset:asset targetSize:targetSize contentMode:TBVAssetsPickerContentModeFill];
        }
        case TBVAssetsReformerModeLarge: {
            CGSize targetSize = CGSizeMake(1500, 1500);
            return [self.pickManager requestImageForAsset:asset targetSize:targetSize contentMode:TBVAssetsPickerContentModeFill];
        }
        case TBVAssetsReformerModeRaw: {
            return [self.pickManager requestFullResolutionImageForAsset:asset];
        }
        default:
            break;
    }
}

- (TBVAssetsPickerManager *)pickManager {
    if (_pickManager == nil) {
        _pickManager = [TBVAssetsPickerManager manager];
    }
    
    return _pickManager;
}
@end
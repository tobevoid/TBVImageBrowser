//
//  TBVAssetsReformer.h
//  TBVAssetsPicker
//
//  Created by tripleCC on 9/12/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(NSInteger, TBVAssetsReformerMode) {
    TBVAssetsReformerModePoster,
    TBVAssetsReformerModeSmall,
    TBVAssetsReformerModeMedium,
    TBVAssetsReformerModeLarge,
    TBVAssetsReformerModeRaw,
};

@class TBVAsset;
@class TBVAssetsPickerManager;

@interface TBVAssetsReformer : NSObject
@property (strong, nonatomic, readonly) TBVAssetsPickerManager *pickManager;

+ (instancetype)reformer;
- (RACSignal *)imageWithAsset:(TBVAsset *)asset mode:(TBVAssetsReformerMode)mode;
@end

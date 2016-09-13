//
//  TBVAsset.m
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TBVAsset.h"

@implementation TBVAsset
+ (instancetype)assetWithOriginAsset:(NSObject *)aAsset {
    TBVAsset *asset = [[self alloc] init];
    if (asset) {
        asset.asset         = aAsset;
    }
    return asset;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated"
- (NSString *)assetLocalIdentifer {
    if ([self.asset class] != [ALAsset class]) {
        return ((PHAsset *)self.asset).localIdentifier;
    } else {
        return ((ALAsset *)self.asset).defaultRepresentation.url.absoluteString;
    }
}

- (CGSize)assetPixelSize {
    if ([self.asset class] != [ALAsset class]) {
        PHAsset *asset = (PHAsset *)self.asset;
        return CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    } else {
        ALAsset *asset = (ALAsset *)self.asset;
        return [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage].size;
    }
}
#pragma clang diagnostic pop
@end

//
//  TBVAsset.h
//  PhotoBrowser
//
//  Created by tripleCC on 8/24/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBVAsset : NSObject
/**
 *  PHAsset or ALAsset
 */
@property (strong, nonatomic) NSObject  *asset;

+ (instancetype)assetWithOriginAsset:(NSObject *)asset;
- (NSString *)assetLocalIdentifer;
- (CGSize)assetPixelSize;
@end

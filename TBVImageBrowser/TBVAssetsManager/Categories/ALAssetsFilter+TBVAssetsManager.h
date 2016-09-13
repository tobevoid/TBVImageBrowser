//
//  ALAssetsFilter+DisplayType.h
//  PhotoBrowser
//
//  Created by tripleCC on 8/22/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "TBVAssetsManagerTypes.h"

@interface ALAssetsFilter (TBVAssetsManager)
+ (instancetype)tbv_assetsFilterWithCustomMediaType:(TBVAssetsMediaType)mediaType;
@end

//
//  TBVImageProviderManager+Register.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVImageProviderManager+Register.h"

@implementation TBVImageProviderManager (Register)
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addImageProvider:[[TBVWebImageProvider alloc] init]];
        [self addImageProvider:[[TBVLocalImageProvider alloc] init]];
        [self addImageProvider:[[TBVAssetImageProvider alloc] init]];
    }
    return self;
}
@end

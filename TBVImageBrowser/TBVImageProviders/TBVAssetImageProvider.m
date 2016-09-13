//
//  TBVAssetImageProvider.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSError+TBVImageProvider.h"
#import "TBVAssetImageProvider.h"
#import "TBVAssetsReformer.h"
#import "TBVAsset.h"

@interface TBVAssetImageProvider()
@property (strong, nonatomic) TBVAssetsReformer *assetsReformer;
@end

@implementation TBVAssetImageProvider
- (NSString *)identifier {
    return @"TBVAssetImageProvider";
}

- (RACSignal *)imageSignalForElement:(id<TBVImageElementProtocol>)element progress:(TBVImageProviderProgressBlock)progress {
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        if ([element isKindOfClass:[TBVAsset class]]) {
            [subscriber sendNext:[self.assetsReformer imageWithAsset:element mode:TBVAssetsReformerModeLarge]];
        } else {
            NSString *message = [NSString stringWithFormat:@"the resource of elememt(%@) is not a asset.", element];
            [subscriber sendError:[NSError errorWithDomain:@"TBVAssetImageProvider" message:message]];
        }
        return nil;
    }]
        switchToLatest]
        deliverOnMainThread];
}

- (TBVAssetsReformer *)assetsReformer {
    if (_assetsReformer == nil) {
        _assetsReformer = [TBVAssetsReformer reformer];
    }
    
    return _assetsReformer;
}
@end

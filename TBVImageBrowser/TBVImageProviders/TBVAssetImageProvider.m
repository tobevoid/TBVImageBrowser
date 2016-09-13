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

NSString *const kTBVAssetImageProviderIdentifier = @"kTBVAssetImageProviderIdentifier";
@interface TBVAssetImageProvider()
@property (strong, nonatomic) TBVAssetsReformer *assetsReformer;
@end
@implementation TBVAssetImageProvider
- (NSString *)identifier {
    return kTBVAssetImageProviderIdentifier;
}

- (RACSignal *)imageSignalForElement:(id<TBVImageElementProtocol>)element progress:(TBVImageProviderProgressBlock)progress {
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        if ([element.resource isKindOfClass:[TBVAsset class]]) {
            [subscriber sendNext:[[self.assetsReformer imageWithAsset:(TBVAsset *)element.resource mode:TBVAssetsReformerModeLarge] map:^id(RACTuple *tuple) {
                return tuple.first;
            }]];
        } else {
            NSString *message = [NSString stringWithFormat:@"the resource of elememt(%@) is not a asset.", element.resource];
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

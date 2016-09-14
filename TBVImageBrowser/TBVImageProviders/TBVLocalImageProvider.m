//
//  TBVLocalImageProvider.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVLocalImageProvider.h"
#import "NSError+TBVImageProvider.h"
NSString *const kTBVLocalImageProviderIdentifier = @"kTBVLocalImageProviderIdentifier";
@implementation TBVLocalImageProvider
- (NSString *)identifier {
    return kTBVLocalImageProviderIdentifier;
}

- (RACSignal *)imageSignalForElement:(id<TBVImageElementProtocol>)element progress:(TBVImageProviderProgressBlock)progress {
    return [[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if ([element.resource isKindOfClass:[NSURL class]] && [(NSURL *)element.resource isFileURL]) {
            [subscriber sendNext:[(NSURL *)element.resource path]];
            [subscriber sendCompleted];
        } else {
            NSString *message = [NSString stringWithFormat:@"the resource of elememt(%@) is not a file url.", element.resource];
            [subscriber sendError:[NSError errorWithDomain:@"TBVLocalImageProvider" message:message]];
        }
        return nil;
    }]
        deliverOn:[RACScheduler scheduler]]
        map:^id(id value) {
            return [UIImage imageWithContentsOfFile:value];
        }]
        doNext:^(id x) {
            progress(1);
        }]
        deliverOnMainThread];
}
@end

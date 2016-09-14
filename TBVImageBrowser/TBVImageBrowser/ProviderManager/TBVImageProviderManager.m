//
//  TBVImageProviderManager.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVImageProviderManager.h"
#import "TBVLogger.h"

NSString *const kTBVImageProviderManagerNotFoundKey = @"kTBVImageProviderManagerNotFound";

@interface TBVImageProviderManager() 
@property (strong, nonatomic) NSMutableDictionary *providerMap;
@property (assign, nonatomic) CGFloat progress;
@end

@implementation TBVImageProviderManager
- (RACSignal *)imageSignalForElement:(id<TBVImageElementProtocol>)element {
    NSAssert(element.identifier, @"identifier of %@ can not be nil.", element);
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        TBVLogInfo(@"\nimage resource:\n\t%@;\nidentifier:\n\t%@;\n", element.resource, element.identifier);
        self.progress = 0;
        if ([self.providerMap.allKeys containsObject:element.identifier]) {
            [subscriber sendNext:[self.providerMap[element.identifier]
                    imageSignalForElement:element
                    progress:^(CGFloat progress) {
                        element.progress = progress;
                    }]];
            [subscriber sendCompleted];
        } else {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[kTBVImageProviderManagerNotFoundKey] =
            [NSString stringWithFormat:@"image provider with identifier %@ was not found", element.identifier];
            [subscriber sendError:[NSError errorWithDomain:@"TBVImageProviderManager"
                                                        code:-1
                                                    userInfo:userInfo]];
        }
        return nil;
    }]
        switchToLatest]
        catch:^RACSignal *(NSError *error) {
            TBVLogError(@"\nerror domain: \n\t%@; \nerror code: \n\t%ld; \nerror info: \n\t%@;\n", error.domain, error.code, error.userInfo);
            return [RACSignal empty];
    }];
    
}

- (void)addImageProvider:(id<TBVImageProviderProtocol>)provider {
    NSCParameterAssert(provider);
    NSAssert(provider.identifier, @"identifier of %@ can not be nil.", provider);
    TBVLogInfo(@"add provider %@", provider);
    
    self.providerMap[provider.identifier] = provider;
}

- (BOOL)removeImageProvider:(id<TBVImageProviderProtocol>)provider {
    NSAssert(provider.identifier, @"identifier of %@ can not be nil.", provider);
    TBVLogInfo(@"remove provider %@", provider);
    
    [self.providerMap removeObjectForKey:provider.identifier];
    return [self.providerMap.allKeys containsObject:provider.identifier];
}

- (NSMutableDictionary *)providerMap {
    if (_providerMap == nil) {
        _providerMap = [NSMutableDictionary dictionary];
    }
    
    return _providerMap;
}
@end

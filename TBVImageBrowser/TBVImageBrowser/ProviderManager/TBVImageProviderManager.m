//
//  TBVImageProviderManager.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVImageProviderManager.h"

NSString *const kTBVImageProviderManagerNotFoundKey = @"kTBVImageProviderManagerNotFound";

@interface TBVImageProviderManager() 
@property (strong, nonatomic) NSMutableDictionary *providerMap;
@property (assign, nonatomic) CGFloat progress;
@end

@implementation TBVImageProviderManager
- (RACSignal *)progressSignal {
    return [[RACObserve(self, progress)
        distinctUntilChanged]
        deliverOnMainThread];
}

- (RACSignal *)imageSignalForElement:(id<TBVImageElementProtocol>)element {
    NSAssert(element.identifier, @"identifier of %@ can not be nil.", element);
    
    self.progress = 0;
    if ([self.providerMap.allKeys containsObject:element.identifier]) {
        @weakify(self)
        return [self.providerMap[element.identifier]
                imageSignalForElement:element
                progress:^(CGFloat progress) {
            @strongify(self)
            self.progress = progress;
        }];
    } else {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[kTBVImageProviderManagerNotFoundKey] =
            [NSString stringWithFormat:@"image provider with identifier %@ was not found", element.identifier];
        return [RACSignal error:[NSError errorWithDomain:@"TBVImageProviderManager"
                                                    code:-1
                                                userInfo:userInfo]];
    }
}

- (void)addImageProvider:(id<TBVImageProviderProtocol>)provider {
    NSCParameterAssert(provider);
    NSAssert(provider.identifier, @"identifier of %@ can not be nil.", provider);
    
    self.providerMap[provider.identifier] = provider;
}

- (BOOL)removeImageProvider:(id<TBVImageProviderProtocol>)provider {
    NSAssert(provider.identifier, @"identifier of %@ can not be nil.", provider);
    
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

//
//  TBVImageProviderManagerProtocol.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#ifndef TBVImageProviderManagerProtocol_h
#define TBVImageProviderManagerProtocol_h
#import "TBVImageProviderProtocol.h"

@protocol TBVImageProviderManagerProtocol <NSObject>
@required
- (void)addImageProvider:(id <TBVImageProviderProtocol>)provider;
- (BOOL)removeImageProvider:(id <TBVImageProviderProtocol>)provider;
- (RACSignal *)imageSignalForElement:(id <TBVImageElementProtocol>)element;
@end

#endif /* TBVImageProviderManagerProtocol_h */

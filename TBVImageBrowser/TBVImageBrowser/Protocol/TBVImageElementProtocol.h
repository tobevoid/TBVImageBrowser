//
//  TBVImageElementProtocol.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#ifndef TBVImageElementProtocol_h
#define TBVImageElementProtocol_h
#import "TBVImageProviderIdentifierProtocol.h"

@protocol TBVImageElementProtocol <TBVImageProviderIdentifierProtocol>
@required
@property (strong, nonatomic) NSObject *resource;
@optional
@property (strong, nonatomic) NSDictionary *options;
@end

#endif /* TBVImageElementProtocol_h */
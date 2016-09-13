//
//  TBVImageProviderIdentifierProtocol.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#ifndef TBVImageProviderIdentifierProtocol_h
#define TBVImageProviderIdentifierProtocol_h

@protocol TBVImageProviderIdentifierProtocol <NSObject>
@required
@property (strong, nonatomic, readonly) NSString *identifier;
@end

#endif /* TBVImageProviderIdentifierProtocol_h */

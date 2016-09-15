//
//  TBVImageIdentifierProtocol.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#ifndef TBVImageIdentifierProtocol_h
#define TBVImageIdentifierProtocol_h

@protocol TBVImageIdentifierProtocol <NSObject>
@required
@property (strong, nonatomic, readonly) NSString *identifier;
@end

#endif /* TBVImageIdentifierProtocol_h */

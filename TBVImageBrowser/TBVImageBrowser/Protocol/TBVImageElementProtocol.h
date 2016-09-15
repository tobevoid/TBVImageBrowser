//
//  TBVImageElementProtocol.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#ifndef TBVImageElementProtocol_h
#define TBVImageElementProtocol_h
#import "TBVImageIdentifierProtocol.h"

@protocol TBVImageElementProtocol <TBVImageIdentifierProtocol>
@required
@property (strong, nonatomic) NSObject *resource;
@property (assign, nonatomic) CGFloat progress;
@optional
@property (strong, nonatomic) NSDictionary *options;
@end

#endif /* TBVImageElementProtocol_h */

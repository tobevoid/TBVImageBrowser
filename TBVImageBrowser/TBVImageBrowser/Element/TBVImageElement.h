//
//  TBVImageElement.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBVImageElementProtocol.h"
@interface TBVImageElement : NSObject <TBVImageElementProtocol>
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSObject *resource;
@property (strong, nonatomic) NSDictionary *options;

+ (instancetype)elementWithIdentifier:(NSString *)identifier
                             resource:(NSObject *)resource;

- (instancetype)initWithIdentifier:(NSString *)identifier
                          resource:(NSObject *)resource;

- (instancetype)initWithIdentifier:(NSString *)identifier
                          resource:(NSObject *)resource
                           options:(NSDictionary *)options;
@end

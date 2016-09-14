//
//  TBVImageElement.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBVImageElementProtocol.h"
@interface TBVImageElement : NSObject <TBVImageElementProtocol>
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSObject *resource;
@property (strong, nonatomic) NSDictionary *options;
@property (assign, nonatomic) CGFloat progress;

+ (instancetype)elementWithIdentifier:(NSString *)identifier
                             resource:(NSObject *)resource;

- (instancetype)initWithIdentifier:(NSString *)identifier
                          resource:(NSObject *)resource;

- (instancetype)initWithIdentifier:(NSString *)identifier
                          resource:(NSObject *)resource
                           options:(NSDictionary *)options;
@end

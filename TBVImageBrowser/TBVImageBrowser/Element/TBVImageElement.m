//
//  TBVImageElement.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVImageElement.h"

@implementation TBVImageElement
+ (instancetype)elementWithIdentifier:(NSString *)identifier
                             resource:(NSObject *)resource {
    TBVImageElement *element = [[self alloc]
                                initWithIdentifier:identifier
                                resource:resource];
    return element;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                          resource:(NSObject *)resource {
    return [self initWithIdentifier:identifier
                           resource:resource
                            options:nil];
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                          resource:(NSObject *)resource
                           options:(NSDictionary *)options {
    if (self = [self init]) {
        self.identifier = identifier;
        self.resource = resource;
        self.options = options;
    }
    return self;
}
@end

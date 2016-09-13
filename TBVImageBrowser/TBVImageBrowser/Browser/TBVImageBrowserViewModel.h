//
//  TBVImageBrowserViewModel.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@class TBVImageBrowserConfiguration;
@class TBVImageBrowserItemViewModel;
@protocol TBVImageElementProtocol;
@protocol TBVImageProviderManagerProtocol;
@interface TBVImageBrowserViewModel : NSObject
@property (strong, nonatomic) NSArray <TBVImageBrowserItemViewModel *> *dataSource;
- (instancetype)initWithElements:(NSArray<id<TBVImageElementProtocol>> *)elements
                   imageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider
                   configuration:(TBVImageBrowserConfiguration *)configuration;
@end

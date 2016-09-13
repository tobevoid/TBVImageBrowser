//
//  TBVImageBrowserView.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBVImageProviderManagerProtocol.h"
@class TBVImageBrowserConfiguration;
@interface TBVImageBrowserView : UIView
- (instancetype)initWithElements:(NSArray<id<TBVImageElementProtocol>> *)elements
                   imageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider;

- (instancetype)initWithElements:(NSArray<id<TBVImageElementProtocol>> *)elements
                   imageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider
                   configuration:(TBVImageBrowserConfiguration *)configuration;
@end

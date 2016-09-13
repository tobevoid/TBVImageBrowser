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
@property (strong, nonatomic) NSArray<id<TBVImageElementProtocol>> *elements;
- (instancetype)initWithImageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider;
- (instancetype)initWithImageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider
                        configuration:(TBVImageBrowserConfiguration *)configuration;
@end

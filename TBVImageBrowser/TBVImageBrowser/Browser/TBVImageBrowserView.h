//
//  TBVImageBrowserView.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBVImageProviderManagerProtocol.h"

@class TBVImageBrowserView;
@class TBVImageBrowserConfiguration;

@protocol TBVImageBrowserViewDelegate <NSObject>
@optional
- (void)imageBrowserView:(TBVImageBrowserView *)browserView didDisplayImageAtIndex:(NSInteger)index;
- (void)imageBrowserView:(TBVImageBrowserView *)browserView didClickImageAtIndex:(NSInteger)index;
@end

@interface TBVImageBrowserView : UIView
@property (strong, nonatomic) NSArray<id<TBVImageElementProtocol>> *elements;
@property (weak, nonatomic) id<TBVImageBrowserViewDelegate> delegate;
- (instancetype)initWithImageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider;
- (instancetype)initWithImageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider
                        configuration:(TBVImageBrowserConfiguration *)configuration;
@end

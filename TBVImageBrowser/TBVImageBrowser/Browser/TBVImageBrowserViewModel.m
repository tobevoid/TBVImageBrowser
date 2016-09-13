//
//  TBVImageBrowserViewModel.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVImageBrowserViewModel.h"
#import "TBVImageBrowserItemViewModel.h"
#import "TBVImageBrowserConfiguration.h"
#import "TBVImageProviderManagerProtocol.h"

@implementation TBVImageBrowserViewModel
- (instancetype)initWithElements:(NSArray<id<TBVImageElementProtocol>> *)elements
                   imageProvider:(id <TBVImageProviderManagerProtocol>)imageProvider
                   configuration:(TBVImageBrowserConfiguration *)configuration {
    if (self = [self init]) {
        self.dataSource = [elements.rac_sequence map:^id(id value) {
            TBVImageBrowserItemViewModel *viewModel = [[TBVImageBrowserItemViewModel alloc] init];
            viewModel.clickImageCommand = configuration.clickedImageCommand;
            viewModel.contentImageSignal = [imageProvider imageSignalForElement:value];
            viewModel.progressSignal = [imageProvider progressSignal];
            return viewModel;
        }].array;
    }
    
    return self;
}
@end

//
//  TBVImageBrowserItemViewModel.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVImageBrowserItemViewModel.h"

@implementation TBVImageBrowserItemViewModel
- (instancetype)initWithElement:(id<TBVImageElementProtocol>)element {
    if (self = [super init]) {
        self.progressSignal = [RACObserve(element, progress) distinctUntilChanged];
    }
    
    return self;
}
@end

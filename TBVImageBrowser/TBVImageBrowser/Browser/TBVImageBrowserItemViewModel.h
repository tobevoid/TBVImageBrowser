//
//  TBVImageBrowserItemViewModel.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "TBVImageElementProtocol.h"
@interface TBVImageBrowserItemViewModel : NSObject
@property (strong, nonatomic) RACSignal *contentImageSignal;
@property (strong, nonatomic) RACCommand *clickImageCommand;
@property (strong, nonatomic) RACSignal *progressSignal;
@property (assign, nonatomic) Class progressPresenterClass;
- (instancetype)initWithElement:(id <TBVImageElementProtocol>)element;
@end

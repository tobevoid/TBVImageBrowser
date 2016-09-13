//
//  TBVImageBrowserItemViewModel.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface TBVImageBrowserItemViewModel : NSObject
@property (strong, nonatomic) RACSignal *contentImageSignal;
@property (strong, nonatomic) RACCommand *clickImageCommand;
@property (strong, nonatomic) RACSignal *progressSignal;
@end

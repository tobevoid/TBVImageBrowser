//
//  TBVImageBrowserViewCell.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBVImageBrowserItemViewModel;
@interface TBVImageBrowserViewCell : UICollectionViewCell
- (void)bindViewModel:(TBVImageBrowserItemViewModel *)viewModel;
@end

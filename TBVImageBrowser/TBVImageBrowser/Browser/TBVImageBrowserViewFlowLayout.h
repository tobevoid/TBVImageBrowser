//
//  TBVImageBrowserViewFlowLayout.h
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

CF_EXPORT const CGFloat kTBVImageBrowserViewFlowLayoutMargin;
@interface TBVImageBrowserViewFlowLayout : UICollectionViewFlowLayout
- (instancetype)initWithItemSize:(CGSize)itemSize;
@end

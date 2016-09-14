//
//  TBVImageBrowserViewFlowLayout.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "TBVImageBrowserViewFlowLayout.h"

const CGFloat kTBVImageBrowserViewFlowLayoutMargin = 10;

@implementation TBVImageBrowserViewFlowLayout
- (instancetype)initWithItemSize:(CGSize)itemSize {
    if (self = [super init]) {
        NSAssert(itemSize.height, @"height of item size can't be 0.");
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(itemSize.width + kTBVImageBrowserViewFlowLayoutMargin * 2,
                                   itemSize.height);
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
    }
    return self;
}
@end

//
//  DALabeledCircularProgressView+TBVImageProgressPresenter.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/14/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "DALabeledCircularProgressView+TBVImageProgressPresenter.h"
#import "TBVLogger.h"
@implementation DALabeledCircularProgressView (TBVImageProgressPresenter)
+ (instancetype)presenter {
    DALabeledCircularProgressView *progressView = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    progressView.thicknessRatio = 0.1;
    progressView.progressLabel.textColor = [UIColor whiteColor];
    progressView.progressLabel.font = [UIFont systemFontOfSize:12];
    progressView.userInteractionEnabled = NO;
    return progressView;
}

- (void)setPresenterProgress:(CGFloat)progress animated:(BOOL)animated {
    [self setProgress:progress animated:animated];
    TBVLogDebug(@"progress %f", progress);
    self.progressLabel.text = [NSString stringWithFormat:@"%.02f", progress];
}
@end

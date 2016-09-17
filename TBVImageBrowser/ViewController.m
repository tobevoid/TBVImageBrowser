//
//  ViewController.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <Masonry/Masonry.h>
#import <DACircularProgress/DALabeledCircularProgressView.h>
#import "TBVLogger.h"
#import "ViewController.h"
#import "TBVImageBrowser.h"
#import "TBVImageElement.h"
#import "TBVImageProviderManager+Register.h"
#import "TBVAssetsPickerManager.h"
#import "TBVImageBrowserConfiguration.h"


@interface ViewController ()
@property (strong, nonatomic) TBVImageBrowserView *imageBrowserView;
@property (strong, nonatomic) TBVImageProviderManager *providerManager;
@property (strong, nonatomic) TBVAssetsPickerManager *pickerManager;
@property (strong, nonatomic) TBVImageBrowserConfiguration *configuration;
@property (strong, nonatomic) NSMutableSet *elements;
@end

@implementation ViewController
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"加载"
                                              style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(loadImageBroswer)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"取消"
                                             style:UIBarButtonItemStyleDone
                                             target:self
                                             action:@selector(removeImageBroswer)];
}

#pragma mark layout
- (void)layoutPageSubviews {
    [self.imageBrowserView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@200);
//        make.width.equalTo(@200);
//        make.center.equalTo(self.view);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark event response 
- (void)removeImageBroswer {
    [self resetAll];
}

- (void)loadImageBroswer {
    self.imageBrowserView = [[TBVImageBrowserView alloc]
                             initWithImageProvider:self.providerManager
                             configuration:self.configuration];
    [self.view addSubview:self.imageBrowserView];
    [self layoutPageSubviews];
    [UIView animateWithDuration:0.5 animations:^{
        [self.imageBrowserView layoutIfNeeded];
    }];
    
    [self setupElements];
}

#pragma mark private method 
- (void)setupElements {
    @weakify(self)
    [[[[self.pickerManager requestCameraRollCollection] map:^id(id value) {
        @strongify(self)
        return [self.pickerManager requestAssetsForCollection:value mediaType:TBVAssetsMediaTypeImage];
    }] switchToLatest] subscribeNext:^(NSArray *assets) {
        @strongify(self)
        [assets enumerateObjectsUsingBlock:^(id  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            TBVImageElement *element = [TBVImageElement elementWithIdentifier:kTBVAssetImageProviderIdentifier resource:asset];
            [self.elements addObject:element];
            if (idx > 5) *stop = YES;
        }];
        
        for (NSInteger i = 0; i < 5; i++) {
            NSString *fileName = [NSString stringWithFormat:@"%@", @(i)];
            NSURL *URL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"jpg"];
            TBVImageElement *element = [TBVImageElement elementWithIdentifier:kTBVLocalImageProviderIdentifier resource:URL];
            [self.elements addObject:element];
        }
        NSArray *URLStrings = @[
                                @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
                                @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                                @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg",
                                @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1833469/porter.jpg",
                                @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1521183/farmers.jpg"
                                ];
        
        for (NSString *URLString in URLStrings) {
            NSURL *URL = [NSURL URLWithString:URLString];
            TBVImageElement *element = [TBVImageElement elementWithIdentifier:kTBVWebImageProviderIdentifier resource:URL];
            [self.elements addObject:element];
        }
        
        self.imageBrowserView.elements = self.elements.allObjects;
    }];
}

- (void)resetAll {
    [self.imageBrowserView removeFromSuperview];
    self.imageBrowserView = nil;
    self.pickerManager = nil;
    self.configuration = nil;
    self.elements = nil;
    self.providerManager = nil;
}

#pragma mark getter setter
- (TBVImageBrowserView *)imageBrowserView {
    if (_imageBrowserView == nil) {
        _imageBrowserView = [[TBVImageBrowserView alloc] init];
    }
    
    return _imageBrowserView;
}

- (TBVImageProviderManager *)providerManager {
    if (_providerManager == nil) {
        _providerManager = [[TBVImageProviderManager alloc] init];
    }
    
    return _providerManager;
}

- (TBVAssetsPickerManager *)pickerManager {
    if (_pickerManager == nil) {
        _pickerManager = [TBVAssetsPickerManager manager];
    }
    
    return _pickerManager;
}

- (TBVImageBrowserConfiguration *)configuration {
    if (_configuration == nil) {
        _configuration = [TBVImageBrowserConfiguration defaultConfiguration];
        @weakify(self)
        _configuration.progressPresenterClass = [DALabeledCircularProgressView class];
        _configuration.currentElementIndex = 3;
        _configuration.clickedImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
            TBVLogDebug(@"clicked image action");
            return [RACSignal empty];
        }];
    }
    
    return _configuration;
}

- (NSMutableSet *)elements {
    if (_elements == nil) {
        _elements = [NSMutableSet set];
    }
    
    return _elements;
}
@end

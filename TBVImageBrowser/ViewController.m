//
//  ViewController.m
//  TBVImageBrowser
//
//  Created by tripleCC on 9/13/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//
#import <Masonry/Masonry.h>
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageBrowserView = [[TBVImageBrowserView alloc]
                             initWithImageProvider:self.providerManager
                             configuration:self.configuration];
    [self.view addSubview:self.imageBrowserView];
    [self layoutPageSubviews];
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
    
    @weakify(self)
    [[[[self.pickerManager requestCameraRollCollection] map:^id(id value) {
        @strongify(self)
        return [self.pickerManager requestAssetsForCollection:value mediaType:TBVAssetsMediaTypeImage];
    }] switchToLatest] subscribeNext:^(NSArray *assets) {
        [assets enumerateObjectsUsingBlock:^(id  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            TBVImageElement *element = [TBVImageElement elementWithIdentifier:kTBVWebImageProviderIdentifier resource:[asset asset]];
            [self.elements addObject:element];
            if (idx > 5) *stop = YES;
        }];
        
        for (NSInteger i = 0; i < 5; i++) {
            NSString *fileName = [NSString stringWithFormat:@"%@", @(i)];
            NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
            NSURL *URL = [NSURL URLWithString:path];
            TBVImageElement *element = [TBVImageElement elementWithIdentifier:kTBVWebImageProviderIdentifier resource:URL];
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

- (void)layoutPageSubviews {
    [self.imageBrowserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

# TBVImageBrowser
兼容本地资源、相册资源、网络资源的图片浏览器

##使用
```
@weakify(self)
[[[[self.pickerManager requestCameraRollCollection] map:^id(id value) {
    @strongify(self)
    return [self.pickerManager requestAssetsForCollection:value mediaType:TBVAssetsMediaTypeImage];
}] switchToLatest] subscribeNext:^(NSArray *assets) {
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        TBVImageElement *element = [TBVImageElement elementWithIdentifier:kTBVAssetImageProviderIdentifier resource:asset];
        [self.elements addObject:element];
        if (idx > 5) *stop = YES;
    }];
    
    for (NSInteger i = 0; i < 5; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@", @(i)];
        NSURL *URL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"png"];
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

```

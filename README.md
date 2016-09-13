# TBVImageBrowser
兼容本地资源、相册资源、网络资源的图片浏览器

##使用
###使用默认Provider
#####本地资源
```
NSString *fileName = [NSString stringWithFormat:@"%@", @(i)];
NSURL *URL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"png"];
TBVImageElement *element = [TBVImageElement elementWithIdentifier:kTBVLocalImageProviderIdentifier resource:URL];
[self.elements addObject:element];
```

#####相册资源
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
    }];
```
######网络资源(SDWebImage)

```
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
```

###自定义Provider
比如不使用SDWebImage，改用YYWebImage或者Kingfisher；不使用TBVAssetsReformer，使用自定义相册refomer。
#####步骤

- 声明Provider类，并遵守TBVImageProviderProtocol
- 设置Provider的唯一标志符，如

```
- (NSString *)identifier {
    return kTBVWebImageProviderIdentifier;
}
```
- 设置获取照片回调，如：

```
- (RACSignal *)imageSignalForElement:(id<TBVImageElementProtocol>)element progress:(TBVImageProviderProgressBlock)progress {
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        id <SDWebImageOperation> operation = nil;
        if ([element.resource isKindOfClass:[NSURL class]] &&
            [[[(NSURL *)element.resource scheme] lowercaseString] containsString:@"http"]) {
            operation = [self.downloadManager downloadImageWithURL:(NSURL *)element.resource
                                                           options:SDWebImageRetryFailed
                                                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                              progress(receivedSize / (CGFloat)expectedSize);
                                                          }
                                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (error) {
                    [subscriber sendError:error];
                } else {
                    [subscriber sendNext:image];
                    [subscriber sendCompleted];
                }
            }];
        } else {
            NSString *message = [NSString stringWithFormat:@"the resource of elememt(%@) is not a web url.", element.resource];
            [subscriber sendError:[NSError errorWithDomain:@"TBVWebImageProvider" message:message]];
        }
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }] deliverOnMainThread];
}
```
- 向TBVImageProviderManager注册Provider对象，如

```
[self addImageProvider:[[TBVWebImageProvider alloc] init]];
```
- 创建Element时设置此元素对应的Provider唯一标志符，如

```
TBVImageElement *element = [TBVImageElement elementWithIdentifier:kTBVWebImageProviderIdentifier resource:URL];
```
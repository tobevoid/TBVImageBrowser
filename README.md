# TBVImageBrowser
兼容本地资源、相册资源、网络资源的图片浏览器。<br>
[详情博客](http://t.cn/RcXVFb6)
##如何使用
###使用默认Provider
#####本地资源
```objc
NSString *fileName = [NSString stringWithFormat:@"%@", @(i)];
NSURL *URL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"png"];
TBVImageElement *element = [TBVImageElement elementWithIdentifier:kTBVLocalImageProviderIdentifier resource:URL];
[self.elements addObject:element];
```

#####相册资源
```objc
@weakify(self)
    [[[[self.pickerManager requestCameraRollCollection] map:^id(id value) {
        @strongify(self)
        return [self.pickerManager requestAssetsForCollection:value mediaType:TBVAssetsMediaTypeImage];
    }] switchToLatest] subscribeNext:^(NSArray *assets) {
        [assets enumerateObjectsUsingBlock:^(id  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        	@strongify(self)
            TBVImageElement *element = [TBVImageElement elementWithIdentifier:kTBVAssetImageProviderIdentifier resource:asset];
            [self.elements addObject:element];
            if (idx > 5) *stop = YES;
        }];
    }];
```
######网络资源(SDWebImage)

```objc
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

###自定义图片获取策略(Provider)
比如不使用SDWebImage，改用YYWebImage或者Kingfisher；不使用TBVAssetsReformer，使用自定义相册refomer。
#####步骤

- 声明Provider类，并遵守TBVImageProviderProtocol
- 设置Provider的唯一标志符，如

```objc
- (NSString *)identifier {
    return kTBVWebImageProviderIdentifier;
}
```
- 设置获取照片回调，如：

```objc
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

```objc
TBVImageElement *element = [TBVImageElement elementWithIdentifier:kTBVWebImageProviderIdentifier resource:URL];
```
###自定义Progress
由于实际项目中可以已经有一款progress控件了，所以TBVImageBrowser并没有强制要求依赖已有的progress控件，比如DACircularProgress。<br>
开发者可以自定义progress控件。以DACircularProgress为例：

- 创建TBVImageBrowserConfiguration，并设置progressPresenterClass为progress控件对应的类

```objc
_configuration = [TBVImageBrowserConfiguration defaultConfiguration];
_configuration.progressPresenterClass = [DALabeledCircularProgressView class];
```
- 创建DACircularProgress分类，并遵守TBVImageProgressPresenterProtocol协议

```objc
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
```
以上两步就可以给图片浏览器引入自己的progress控件了。<br>
对progress控件的要求：

- 是UIView或其子类
- 遵守TBVImageProgressPresenterProtocol协议

//
//  ZL3DWebView.m
//  3DWebView
//
//  Created by luokan on 2022/1/17.
//

#import "ZL3DWebView.h"
#import <WebKit/WebKit.h>
#import "WeakWebViewScriptMessageDelegate.h"
#import "JJURLSchemeHandler.h"
#import "ZKR3DFileArchive.h"
#import "ZKR3DPathManager.h"

@interface ZL3DWebView ()
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView * progressView;
@end

@implementation ZL3DWebView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

-(void) initUI{
    [self addSubview:self.webView];
    [self addSubview:self.progressView];
    [self initProgressObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotificationRefresh3d_009_enter:) name:@"ZKRNotificationRefresh3D_009_enter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotificationRefresh3d_009_leave:) name:@"ZKRNotificationRefresh3D_009_leave" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppEnterForground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

-(void) handleAppEnterBackground:(NSNotification *)notif{
    [self onTabChange:@"false"];
}

-(void) handleAppEnterForground:(NSNotification *)notif{
    [self onTabChange:@"true"];
}

-(void)handleNotificationRefresh3d_009_enter:(NSNotification *)notif{
    NSLog(@"[3D通知] = 刷新009 进入\n");
    [self onTabChange:@"true"];
}

-(void)handleNotificationRefresh3d_009_leave:(NSNotification *)notif{
    NSLog(@"[3D通知] = 刷新009 退出\n");
    [self onTabChange:@"false"];
}

-(void) switchCar:(ZKR3DCarDisplay)cartype withParams:(NSDictionary *)params{
    if(self.dispayCar == cartype)return;
    self.dispayCar = cartype;
    if(self.dispayCar && [self.dispayCar isEqualToString:ZKR3DCarDisplay001]){
        [self startLoad001ResourceWithParams:params];
    }else if(self.dispayCar && [self.dispayCar isEqualToString:ZKR3DCarDisplay009]){
        [self startLoad009ResourceWithParams:params];
    }
}


#pragma mark -
#pragma mark 用户操作
/// 车身变色 - 001
/// @param color 车身颜色
/// @param isSame 撞色车顶  YES  isBlack=true  NO  isBlack=false
/// @param isTrim 是否撞色车顶  YES  运动组件 isBlackTrim=true    NO 不是运动组件
-(void) changeColor:(ZKR3DCarColor)color isSame:(BOOL) isSame isTrim:(BOOL) isTrim{
    if(self.dispayCar && [self.dispayCar isEqualToString:ZKR3DCarDisplay001]){
        NSString *jsString;
        if(isTrim == YES){
            jsString = [NSString stringWithFormat:@"changeColor({ color: '%@', isBlack: %@, isBlackTrim: %@ })", color,isSame?@"true"
                                                           :@"false",isTrim?@"true":@"false"];
        }else{
            jsString = [NSString stringWithFormat:@"changeColor({ color: '%@', isBlack: %@})", color,isSame?@"true"
                                                           :@"false"];
        }
        [self base_OC_call_js_byJSString:jsString];
        NSLog(@"[3D模型] = %@\n",jsString);
    }else if(self.dispayCar && [self.dispayCar isEqualToString:ZKR3DCarDisplay009]){
        if(color && color.length > 0){
            NSString *jsString = [NSString stringWithFormat:@"changeColor({ color: '%@'})", color?:@""];
            [self base_OC_call_js_byJSString:jsString];
            NSLog(@"[3D模型] = %@\n",jsString);
        }
    }
}

-(void) changeLoadingBgColor:(NSString *)bgColor{
    if(self.dispayCar && [self.dispayCar isEqualToString:ZKR3DCarDisplay009]){
        NSString *jsString = [NSString stringWithFormat:@"loadingBgColor({ color: '%@'})", bgColor?:@""];
        [self base_OC_call_js_byJSString:jsString];
        NSLog(@"[3D模型] = %@\n",jsString);
    }
}

/// 改变轮毂
/// @param wheelName 轮毂名称
/// wheel1
/// wheel2 21英寸空气涡流轮毂
/// wheel3 21英寸弧光幻影轮毂
/// wheel4 21英寸多辐射线轮毂
-(void) changeWheel:(ZKR3DCarWheelName)wheelName{
    if(wheelName == nil) return;
    NSString *jsString = [NSString stringWithFormat:@"changeWheel('%@')",wheelName];
    [self base_OC_call_js_byJSString:jsString];
    NSLog(@"[3D模型] = %@",jsString);
}

/// 改变内饰
/// @param color 内饰的名称
/// brown   钛棕
/// black   碳黑
/// grey    铂灰
/// blue    氮蓝
-(void) changeInner:(ZKR3DCarColor)color{
    if(color == nil) return;
    NSString *jsString = [NSString stringWithFormat:@"changeInner('%@')",color];
    [self base_OC_call_js_byJSString:jsString];
    NSLog(@"[3D模型] = %@",jsString);
}

/// 切换金属饰条
-(void)changeChrome:(NSString *)chrome{
    if(chrome == nil) return;
    NSString *jsString = [NSString stringWithFormat:@"changeChrome('%@')",chrome];
    [self base_OC_call_js_byJSString:jsString];
    NSLog(@"[3D模型] = %@",jsString);
}

/// 重置视觉
-(void) resetPerspective{
    NSString *jsString = @"resetPerspective()";
    [self base_OC_call_js_byJSString:jsString];
    NSLog(@"[3D模型] = %@",jsString);
}

/// 切换视觉动画
/// 1: 格栅视觉  2: 轮毂视觉
-(void) toEntityAnimation:(NSString *)animation{
    if(animation == nil) return;
    NSString *jsString = [NSString stringWithFormat:@"toEntityAnimation(%@)",animation];
    [self base_OC_call_js_byJSString:jsString];
    NSLog(@"[3D模型] = %@",jsString);
}


-(void) onTabChange:(NSString *)flag{
    NSString *jsString = [NSString stringWithFormat:@"onTabChange('%@')",flag];
    [self base_OC_call_js_byJSString:jsString];
    NSLog(@"[3D模型] = %@",jsString);
}

/// 强制刷新贴图
-(void) forceUpdateObjects{
    NSString *jsString = @"forceUpdateObjects()";
    [self base_OC_call_js_byJSString:jsString];
    NSLog(@"[3D模型] = %@",jsString);
}

/// 设置模型缩放比例
/// @param scale 模型缩放比例 （0~1）
/// "scale" : 0.5
-(void) setModelScale:(float)scale{
        if(self.dispayCar && [self.dispayCar isEqualToString:ZKR3DCarDisplay009] && scale > 1){
            scale = 1;
        }
        NSString *jsString = [NSString stringWithFormat:@"setModelScale(%.2f)", scale];
        [self base_OC_call_js_byJSString:jsString];
       NSLog(@"[3D模型] = %@",jsString);
}

/// 基础的OC 调用 JS方法
/// @param jsString 调用的函数和参数
-(void) base_OC_call_js_byJSString:(NSString *) jsString{
    if(_webView && jsString && jsString.length > 0){
        [_webView evaluateJavaScript:jsString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
           
        }];
    }
}

#pragma 加载3D资源
-(void) startLoad001ResourceWithParams:(NSDictionary *)params{
    self.dispayCar = ZKR3DCarDisplay001;
    NSURL *fileURL;
    NSURL *baseUrl;
    
    NSString *filePath = [ZKR3DPathManager index001HtmlFile];
    if (!filePath.length) {
        //解压缩
        NSLog(@"[3D资源包解压缩]   开始\n");
        filePath = [ZKR3DFileArchive unzip001Soure];
        NSLog(@"[3D资源包解压缩]   结束\n");
    }
    if (!filePath.length) {
        return;
    }
    
    if(params == nil){ // 没有默认参数
        fileURL = [NSURL fileURLWithPath:filePath];
        baseUrl = [fileURL URLByDeletingLastPathComponent];
    }else{// 有默认参数
        
        NSString *appearanceColor = [params objectForKey:@"color"];
        NSString *innerColor = [params objectForKey:@"inner"];
        NSString *wheelName = [params objectForKey:@"wheel"];
        NSString *bgImageName = [params objectForKey:@"backgroundImage"];
        BOOL isBlack = [[params objectForKey:@"isBlack"] boolValue];
        BOOL isBlackTrim = [[params objectForKey:@"isBlackTrim"] boolValue];

        fileURL = [NSURL fileURLWithPath:filePath];
        
        if(isBlackTrim){
            filePath = [NSString stringWithFormat:@"%@#inner=%@&color=%@&isBlackTrim=true&wheel=%@",fileURL.absoluteURL,innerColor,appearanceColor,wheelName];
        }else{
            filePath = [NSString stringWithFormat:@"%@#inner=%@&color=%@&isBlack=%@&wheel=%@",fileURL.absoluteURL,innerColor,appearanceColor,isBlack?@"true":@"false",wheelName];
        }
        NSLog(@"[3D模型][加载001 -有参] 参数=%@\n",filePath);
        fileURL = [NSURL URLWithString:filePath];
        baseUrl = [fileURL URLByDeletingLastPathComponent];
        NSLog(@"第一次加载路径 = %@\n",filePath);
    }
    [_webView loadFileURL:fileURL allowingReadAccessToURL:baseUrl];
}


-(void) startLoad009ResourceWithParams:(NSDictionary *)params{
    self.dispayCar = ZKR3DCarDisplay009;
    NSURL *fileURL;
    NSURL *baseUrl;
    
    NSString *filePath = [ZKR3DPathManager index009HtmlFile];
    if (!filePath.length) {
        //解压缩
        NSLog(@"[3D资源包解压缩]   开始\n");
        filePath = [ZKR3DFileArchive unzip009Soure];
        NSLog(@"[3D资源包解压缩]   结束\n");
    }
    if (!filePath.length) {
        return;
    }
    
    if(params == nil){ // 没有默认参数
        fileURL = [NSURL fileURLWithPath:filePath];
        NSString *appearanceColor = [params objectForKey:@"color"]?:@"";
        NSString *scale = [params objectForKey:@"scale"]?:@"";
        // 测试
//        filePath = [NSString stringWithFormat:@"%@?scale=%@&loading=%@&loadcolor=ff0000",fileURL.absoluteURL,scale,@"1"];
        // 正式
        filePath = [NSString stringWithFormat:@"%@?scale=%@&loading=%@",fileURL.absoluteURL,scale,@"0"];
        
        NSLog(@"[3D模型][加载009-无参数] 参数=%@\n",filePath);
        baseUrl = [fileURL URLByDeletingLastPathComponent];
    }else{// 有默认参数
        NSString *appearanceColor = [params objectForKey:@"color"]?:@"";
        NSString *innerColor = [params objectForKey:@"inner"]?:@"";
        NSString *wheelName = [params objectForKey:@"wheel"]?:@"";
        NSString *chromeName = [params objectForKey:@"chrome"]?:@"";
        // 测试
//        NSString *loadcolor  = @"ff0000";
        // 正式
        NSString *loadcolor  = [params objectForKey:@"loadcolor"]?:@"ffffff";
        NSString *loading = [params objectForKey:@"loading"]?:@"1";
        NSString *scale = [params objectForKey:@"scale"]?:@"";
        BOOL isBlack = [[params objectForKey:@"isBlack"] boolValue];
        BOOL isBlackTrim = [[params objectForKey:@"isBlackTrim"] boolValue];
        
        fileURL = [NSURL fileURLWithPath:filePath];
        filePath = [NSString stringWithFormat:@"%@?scale=%@&loading=%@&@&color=%@&inner=%@&wheel=%@&chrome=%@&loadcolor=%@",fileURL.absoluteURL,scale,loading,appearanceColor,innerColor,wheelName,chromeName,loadcolor];
        NSLog(@"[3D模型][加载009-有参数] 参数=%@\n",filePath);
        
        fileURL = [NSURL URLWithString:filePath];
        baseUrl = [fileURL URLByDeletingLastPathComponent];
        NSLog(@"第一次加载路径 = %@\n",filePath);
    }
    [_webView loadFileURL:fileURL allowingReadAccessToURL:baseUrl];
}
#pragma mark -
#pragma mark 1. 进度条相关
-(void) initProgressObserver{
    //添加监测网页加载进度的观察者
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:0
                      context:nil];
}

/// 进度条KVO - kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
        
        NSLog(@"网页加载进度 = %f",_webView.estimatedProgress);
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
        
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
//        self.navigationItem.title = _webView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark -
#pragma mark  2. JS 调用OC
//被自定义的WKScriptMessageHandler在回调方法里通过代理回调回来，绕了一圈就是为了解决内存不释放的问题
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"3D调用OC  方法名字:%@ \n 消息体:%@ \n 结构信息:%@\n",message.name,message.body,message.frameInfo);
    //用message.body获得JS传出的参数体
    NSDictionary * parameter = message.body;
    //JS调用OC
    if([message.name isEqualToString:@"jsToOcNoPrams"]){
        NSLog(@"[JS调用OC] ===== 不带参数:%@\n",message.body);

    }else if([message.name isEqualToString:@"jsToOcWithPrams"]){
        // 1. modelStartLoading  3D开始加载
        // 2. modelLoaded          加载完成
        // 3. modelRenderFirstFrame
        // 4. modelLoadProgress    加载进度
        NSString *methodName = parameter[@"message"];
        if(methodName && self.messageCallBack){
            NSLog(@"[3D加载回调] = %@\n",parameter);
            NSNumber* progress = parameter[@"progress"];
            self.messageCallBack(methodName, progress,self.dispayCar);
        }
    }
}

#pragma mark -
#pragma mark 3. 懒加载UI
-(WKWebView *)webView{
    if(!_webView){
        /// 1. 网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        /// 1.0 跨域
        [config setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
        
        /// 2. 设置对象
        WKPreferences *preference = [[WKPreferences alloc] init];
        /// 2.1 最小字体大小
        preference.minimumFontSize = 0;
        /// 2.2 是否支持javescript
        preference.javaScriptEnabled = YES;
        /// 2.3 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        /// 2.4 是否允许读取本地文件
        [preference setValue:@YES forKey:@"allowFileAccessFromFileURLs"];

        
        config.preferences = preference;
        /// 1.3 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        /// 1.4 设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.mediaTypesRequiringUserActionForPlayback = YES;
        /// 1.5 设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        /// 1.6 设置请求的User-Agent信息中应用程序名称 iOS9后可用
        config.applicationNameForUserAgent = @"Zeekrlife";
        
        /// 3 自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
        
        /// 4. native和JS交互管理
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        /// 4.1 js调OC 一个有参  一个无参
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
        config.userContentController = wkUController;
        
        /// 5.以下代码适配文本大小
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        /// 5.1 用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        
        config.suppressesIncrementalRendering = YES;
        
        /// 5.2 本地静态资源
        [config setURLSchemeHandler:[JJURLSchemeHandler new] forURLScheme:@"file"];
        
        /// 6. 创建网页
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) configuration:config];
        
        
        _webView.backgroundColor = [UIColor clearColor];
        /// 6.1 UI代理
        _webView.UIDelegate = self;
        /// 6.2 导航代理
        _webView.navigationDelegate = self;
        
        /// 6.3 背景颜色透明
        _webView.backgroundColor = [UIColor clearColor];
        
        _webView.opaque = NO;
        
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.hidden = YES;
    }
    return _progressView;
}

-(void)dealloc{
    //移除观察者
    if(_webView){
        [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOcNoPrams"];
        [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOcWithPrams"];
        [_webView removeObserver:self
                      forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"释放了:ZL3DWebView ----- \n");
}

#pragma mark - 路径相关的操作
-(void)layoutSubviews{
    if(_webView){
        _webView.frame = self.bounds;
    }
}

@end

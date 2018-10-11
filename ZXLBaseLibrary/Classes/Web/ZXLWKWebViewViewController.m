//
//  ZXLWKWebViewViewController.m
//  ZXZ
//
//  Created by 张小龙 on 2017/2/27.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "ZXLWKWebViewViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "ZXLJSBridgeManager.h"
#import <ZXLUtilsDefined.h>
#import <ZXLSettingDefined.h>
#import <ZXLRouter.h>
#import <SDWebImage/SDWebImageDownloader.h>


@interface ZXLWKWebViewViewController ()<WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMapTable * responseCallbacks;
@property (nonatomic, strong) WKWebViewJavascriptBridge * webViewBridge;

@end

@implementation ZXLWKWebViewViewController

#pragma mark - 懒加载

-(NSMapTable * )responseCallbacks{
    if (!_responseCallbacks) {
        _responseCallbacks = [NSMapTable weakToStrongObjectsMapTable];
    }
    return _responseCallbacks;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = self.frame;
    rect.size.height -= ZXLSafeAreaBottomHeight;
    if (_wkWebView == nil){
        _wkWebView = [[WKWebView alloc] initWithFrame:rect];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        _wkWebView.scrollView.bounces = NO;
        _wkWebView.allowsBackForwardNavigationGestures = NO;
        _wkWebView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_wkWebView];
//        长按识别二维码保存图片功能
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 1;
        longPress.delegate = self;
        [_wkWebView addGestureRecognizer:longPress];
        
        [WKWebViewJavascriptBridge enableLogging];
        _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:_wkWebView];
        [_webViewBridge setWebViewDelegate:self];
        [ZXLJSBridgeManager registerHandler:self bridge:_webViewBridge];
        
        [self onRequestURL:self.nsWebURL];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)onRequestURL:(NSString *)strURL{
    if (!ZXLUtilsISNSStringValid(strURL))
        return;
    
    if ([strURL hasPrefix:@"http://"] || [strURL hasPrefix:@"https://"]){
        NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]];
        [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"ZXLIOSVersion"];
        [_wkWebView loadRequest:request];
    }
    else
    {
        [_wkWebView loadHTMLString:strURL baseURL:nil];
    }
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    completionHandler();
}

-(void)addResponseCallback:(WVJBResponseCallback)responseCallback forHandler:(NSString *)handlerName{
    if (!responseCallback || !ZXLUtilsISNSStringValid(handlerName)) return;
    
    [self.responseCallbacks setObject:responseCallback forKey:handlerName];
}

-(void)removeResponseCallback:(NSString *)handlerName{
    if (!ZXLUtilsISNSStringValid(handlerName)) return;
    
    [self.responseCallbacks removeObjectForKey:handlerName];
}

-(void)responseCallback:(NSString *)handlerName object:(id)object{
    if (!ZXLUtilsISNSStringValid(handlerName)) return;
    
    WVJBResponseCallback responseCallback = [self.responseCallbacks objectForKey:handlerName];
    if (responseCallback) {
        responseCallback(object);
        [self.responseCallbacks removeObjectForKey:handlerName];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_wkWebView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender{
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [sender locationInView:_wkWebView];
    // 获取长按位置对应的图片url的JS代码
    NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    // 执行对应的JS代码 获取url
    [_wkWebView evaluateJavaScript:imgJS completionHandler:^(id _Nullable imgUrl, NSError * _Nullable error) {
        if (imgUrl) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (finished) {
                        //在此进行图片二维码分析
                }
            }];
        }
    }];
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme];
    UIApplication *app = [UIApplication sharedApplication];
    // 打电话
    if ([scheme isEqualToString:@"tel"]) {
        if ([app canOpenURL:url]) {
            [app openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    // 打开App Store
    if ([url.absoluteString containsString:@"itunes.apple.com"]) {
        if ([app canOpenURL:url]) {
            [app openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    BOOL bResult = [ZXLRouter transactionURL:navigationAction.request.URL.absoluteString];
    decisionHandler(bResult?WKNavigationActionPolicyCancel:WKNavigationActionPolicyAllow);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

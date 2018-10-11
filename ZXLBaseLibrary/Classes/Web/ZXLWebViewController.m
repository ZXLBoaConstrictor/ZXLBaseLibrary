//
//  ZXLWebViewController.m
//  ZXZ
//
//  Created by xyt on 17/4/10.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "ZXLWebViewController.h"
#import <WebKit/WebKit.h>

@interface ZXLWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ZXLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.frame];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.h5AppURLStr]]];
}

- (void)setH5AppURLStr:(NSString *)h5AppURLStr {
    _h5AppURLStr = h5AppURLStr;
}

#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { // 类似 UIWebView 的 －webViewDidFinishLoad:

    if (webView.title.length > 0) {
        self.title = webView.title;
    }
}

@end

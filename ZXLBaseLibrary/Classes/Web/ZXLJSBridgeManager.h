//
//  ZXLJSBridgeManager.h
//  Compass
//
//  Created by 张小龙 on 2018/2/5.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WKWebViewJavascriptBridge;
@class ZXLWKWebViewViewController;

@interface ZXLJSBridgeManager : NSObject
+(void)registerHandler:(ZXLWKWebViewViewController *)webView bridge:(WKWebViewJavascriptBridge *)jsBridge;
+(void)refreshListInfo:(NSString *)uploadTaskID;
@end

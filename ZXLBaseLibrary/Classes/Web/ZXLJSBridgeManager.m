//
//  ZXLJSBridgeManager.m
//  Compass
//
//  Created by 张小龙 on 2018/2/5.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLJSBridgeManager.h"
#import "ZXLWKWebViewViewController.h"
#import "WKWebViewJavascriptBridge.h"

@interface ZXLJSBridgeManager()
@property(nonatomic,strong)NSMutableDictionary * uploadtaskListInfoDict;//上传任务返回刷新信息
@end

@implementation ZXLJSBridgeManager

-(NSMutableDictionary *)uploadtaskListInfoDict{
    if (!_uploadtaskListInfoDict) {
        _uploadtaskListInfoDict = [NSMutableDictionary dictionary];
    }
    return _uploadtaskListInfoDict;
}

+(instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLJSBridgeManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[ZXLJSBridgeManager alloc] init];
    });
    return _sharedObject;
}

+(void)registerHandler:(ZXLWKWebViewViewController *)webVC bridge:(WKWebViewJavascriptBridge *)jsBridge{
    NSArray<NSString *> * handlers = @[@"propsTitle"];
    
    __weak ZXLWKWebViewViewController * weakWebVC = webVC;
    for (NSString * handlerName in handlers) {
        [jsBridge registerHandler:handlerName handler:^(id data, WVJBResponseCallback responseCallback) {
            [ZXLJSBridgeManager webVC:weakWebVC WVJBResponseCallback:handlerName data:data responseCallback:responseCallback];
        }];
    }
}

+(void)webVC:(ZXLWKWebViewViewController *)webVC WVJBResponseCallback:(NSString *)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback{
    //交互数据转换空处理
    if (data && ![data isKindOfClass:[NSString class]])
        return;
    
}


@end

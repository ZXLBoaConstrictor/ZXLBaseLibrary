//
//  ZXLPayUtilsManager.m
//  ZXLPayUtilsModule
//
//  Created by 张小龙 on 2018/7/12.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLPayUtilsManager.h"

#import <ZXLUtilsDefined.h>
#import <WechatOpenSDK/WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import <SVProgressHUD/SVProgressHUD.h>

#define ZXLZXZScheme @"zxlprotocol"

#define ZXLZXZAppId    @"wx16d282cd9c64b218"
#define ZXLZXZOrzAppId @"wx9d287f1192f9219d"

@interface ZXLPayUtilsManager()<WXApiDelegate>
@property (nonatomic, copy) SendPayInfo payResult;
@property (nonatomic, assign) BOOL bRegister;
@end

@implementation ZXLPayUtilsManager

+ (instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLPayUtilsManager * manager = nil;
    dispatch_once(&pred, ^{
        manager = [[ZXLPayUtilsManager alloc] init];
    });
    return manager;
}

+(NSString *)appId{
    return ZXLZXZAppId;
}

+(void)registerAppId{
    NSString *strAppId = [ZXLPayUtilsManager appId];
    if (ZXLUtilsISNSStringValid(strAppId)) {
        [ZXLPayUtilsManager manager].bRegister = [WXApi registerApp:strAppId];
    }
}

+(BOOL)registerResult{
    return [ZXLPayUtilsManager manager].bRegister;
}

-(void)alipay:(NSString *)signString result:(SendPayInfo)result{
    self.payResult =  result;
    NSString *scheme = ZXLZXZScheme;
    
    WEAKSELF
    [[AlipaySDK defaultService] payOrder:signString fromScheme:scheme callback:^(NSDictionary *resultDic) {
        if (ZXLUtilsISDictionaryValid(resultDic)) {
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                if (weakSelf.payResult) {
                    weakSelf.payResult(YES);
                    weakSelf.payResult = nil;
                }
            }else{
                if (weakSelf.payResult) {
                    weakSelf.payResult(NO);
                    weakSelf.payResult = nil;
                }
    
                NSString *strError = [resultDic objectForKey:@"memo"];
                if (!ZXLUtilsISNSStringValid(strError)) {
                    strError = @"支付失败";
                }
                [SVProgressHUD showErrorWithStatus:strError];
            }
        }
    }];
}

-(void)weiXinPay:(NSDictionary *)payInfo result:(SendPayInfo)result{
    if (!self.bRegister) {
        [ZXLPayUtilsManager registerAppId];
    }
    
    self.payResult =  result;
    PayReq * request = ZXLNewObject(PayReq);
    request.partnerId = [payInfo objectForKey:@"partnerid"];
    request.prepayId = [payInfo objectForKey:@"prepayid"];
    request.nonceStr = [payInfo objectForKey:@"noncestr"];
    request.timeStamp = (UInt32)[[payInfo objectForKey:@"timestamp"] integerValue];
    request.package = [payInfo objectForKey:@"package"];
    request.sign = [payInfo objectForKey:@"sign"];
    [WXApi sendReq:request];
}

-(BOOL)openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    BOOL bResult = YES;
    NSString *strAppId = [ZXLPayUtilsManager appId];
    if ([url.relativeString rangeOfString:strAppId].location != NSNotFound || (ZXLUtilsISDictionaryValid(options) && [options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"])){
        bResult = [WXApi handleOpenURL:url delegate:self];
    }

    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        WEAKSELF
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if (resultDic && [[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                weakSelf.payResult(YES);
                weakSelf.payResult = nil;
            }else{
                weakSelf.payResult(NO);
                weakSelf.payResult = nil;
                NSString *strError = [resultDic objectForKey:@"memo"];
                if (!ZXLUtilsISNSStringValid(strError)) {
                    strError = @"支付失败";
                }
                [SVProgressHUD showErrorWithStatus:strError];
            }
        }];
    }
    return bResult;
}

-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        NSString * strError = @"支付失败";
        if (resp.errCode == WXErrCodeUserCancel) {
            strError = @"取消支付";
        }
        if (resp.errCode != 0) {
            [SVProgressHUD showErrorWithStatus:strError];
        }
        self.payResult(resp.errCode == 0);
        self.payResult = nil;
    }
}
@end

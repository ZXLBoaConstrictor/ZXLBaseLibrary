//
//  ZXLPayUtilsManager.h
//  ZXLPayUtilsModule
//  
//  Created by 张小龙 on 2018/7/12.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 第三方支付结果block
 
 @param bResult 支付结果
 */
typedef void (^SendPayInfo) (BOOL bResult);

@interface ZXLPayUtilsManager : NSObject
+ (instancetype)manager;

/**
 支付注册
 */
+(void)registerAppId;

+(BOOL)registerResult;
/**
 支付宝支付
 
 @param signString 支付签名信息
 */
-(void)alipay:(NSString *)signString result:(SendPayInfo)result;


/**
 微信支付
 
 @param payInfo 微信支付信息
 */
-(void)weiXinPay:(NSDictionary *)payInfo result:(SendPayInfo)result;

//第三方回调 此函数在 AppDelegate
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options 中调用
-(BOOL)openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;
@end

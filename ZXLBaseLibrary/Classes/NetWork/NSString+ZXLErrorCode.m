//
//  NSString+ZXLErrorCode.m
//  ZXLNetworkModule
//
//  Created by 张小龙 on 2018/6/25.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "NSString+ZXLErrorCode.h"
#import "ZXLUtilsDefined.h"

@implementation NSString (ZXLErrorCode)
+ (instancetype)errorCodeToString:(NSInteger)errorCode {
    NSString *strError = @"";
    switch (errorCode) {
        case 2001002:
            strError = @"获取用户信息无变化";
            break;
        default:
            strError = @"";
            break;
    }
    return strError;
}

+ (instancetype)errorMessage:(NSDictionary *)parameter message:(NSString *)defaultMessage{
    NSString * strError = [NSString errorCodeToString:[[parameter objectForKey:ZXLResponseCode] integerValue]];
    if (!ZXLUtilsISNSStringValid(strError)) {
        strError =  [parameter objectForKey:ZXLResponseMessage];
    }

    if (!ZXLUtilsISNSStringValid(strError)) {
        strError = defaultMessage;
    }
    if (!ZXLUtilsISNSStringValid(strError)) {
        strError = @"请求错误！";
    }
    return strError;
}

+ (instancetype)failureMessage:(NSError *)error message:(NSString *)defaultMessage{
    NSString *strError = @"";
    if (error.code == NSURLErrorNotConnectedToInternet) {
        strError = @"当前网络不可用，请检查网络设置";
    }else if (error.code == NSURLErrorTimedOut){
        strError = @"网络请求超时";
    }else if (error.code == NSURLErrorBadServerResponse){
        strError = @"当前网络连接异常，请检查网络连接";
    }else{
        strError = [error.userInfo  objectForKey:@"NSLocalizedDescription"];
    }
    
    if (!ZXLUtilsISNSStringValid(strError)) {
        strError = @"请求错误";
    }
    return strError;
}

@end

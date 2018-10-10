//
//  ZXLCrashUtilManager.h
//  ZXLCrashUtilModule
//
//  Created by 张小龙 on 2018/7/11.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXLCrashUtilManager : NSObject

/**
 崩溃工具注册
 */
+(void)registerAppId;

/**
 上报异常

 @param name 名称
 @param reason 原因
 */
+(void)reportException:(NSString *)name reason:(NSString *)reason;

/**
 上报出错信息

 @param error 错误信息
 */
+(void)reportError:(NSError *)error;
@end

//
//  ZXLPushMessageManager.h
//  ZXLPushMessageModule
//
//  Created by 张小龙 on 2018/7/11.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXLPushMessageManager : NSObject
/**
 个推SDK 启动是否成功
 */
@property (nonatomic,assign)BOOL geTuiSDKSuccess;

/**
 绑定用户userid 是否成功
 */
@property (nonatomic,assign)BOOL bindGeTuiUserId;

/**
 用户userid(登录后帐号信息)
 */
@property (nonatomic,copy)NSString * userId;

+(instancetype)manager;

/**
 检测推送消息
 注：如果推送SDK注册成功去绑定推送别名，如果推送SDK注册未成功则注册SDK，绑定别名如果没有成功则去重复绑定别名
 */
-(void)checkPushMessageRegisterSuccess;

/**
 推送消息解绑
 */
-(void)pushMessagunbindAliasUserId;

/**
 从点击推送消息中获取App 路由路径
 
 @param userInfo 启动App 信息
 @return App内部路由路径
 */
+(NSString *)getDynamicRoutesUrlFromPointPushMessage:(NSDictionary *)userInfo;

@end

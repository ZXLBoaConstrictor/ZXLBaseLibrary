//
//  ZXLThirdtPartyManager.h
//  ZXLThirdPartyModule
//
//  Created by 张小龙 on 2018/6/26.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZXLThirdPartyShareModel;

typedef NS_ENUM(NSInteger, ZXLShareType) {
    ZXLShareTypeWeiXinSession,// 微信朋友
    ZXLShareTypeWeiXinTimeline,// 朋友圈
    ZXLShareTypeQQ,          // QQ好友
    ZXLShareTypeMessage,//短信
};

typedef NS_ENUM(NSInteger, ZXLThirdPartyLoginType) {
    ZXLThirdPartyLoginTypeTencent,      // QQ
    ZXLThirdPartyLoginTypeWeiXin       // 微信
};

/**
 登录返回结果block
 
 @param accessToken 登录accessToken
 @param uid 用户id
 */
typedef void (^SendThirdLoginInfo) (NSString *accessToken, NSString *uid);


@interface ZXLThirdtPartyManager : NSObject

+(instancetype)manager;

//第三方回调
-(BOOL)openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;


/**
 登录获取第三方认证后

 @param type 获取认证类型
 @param loginReturnInfo 认证返回结果
 */
-(void)getUserInfoWithLoginType:(ZXLThirdPartyLoginType)type loginReturnInfo:(SendThirdLoginInfo)loginReturnInfo;

//分享
-(void)shareTo:(ZXLShareType)type shareInfo:(ZXLThirdPartyShareModel *)model;

-(BOOL)isWXAppInstalled;

-(BOOL)isQQInstalled;

@end

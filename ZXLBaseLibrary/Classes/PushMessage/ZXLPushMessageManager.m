//
//  ZXLPushMessageManager.m
//  ZXLPushMessageModule
//
//  Created by 张小龙 on 2018/7/11.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLPushMessageManager.h"
#import "ZXLUtilsModule.h"
#import "ZXLRouter.h"
#import <GTSDK/GeTuiSdk.h>
#import <UIKit/UIKit.h>

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
#ifdef DEBUG
//推送key
#define ZXLZXZAppId              @"wUBJmbZ6d67pW7DsQ9eBx8"
#define ZXLZXZAppKey             @"DJc4hKQELm5VQ8RKGUwfAA"
#define ZXLZXZAppSecret          @"l65A2PQ3HPAfcAQcx6sl66"
//other推送key
#define ZXLZXZOrzAppId           @"OHLiBRLxXLAu7YRU6QpoM6"
#define ZXLZXZOrzAppKey          @"UbIsTjqtKx6U3fY2fLv69"
#define ZXLZXZOrzAppSecret       @"RZc74afrWQ7kBMbiOEZTN4"

#else

//推送key
#define ZXLZXZAppId              @"O5a5m9qypV7A5xbxXwqcE5"
#define ZXLZXZAppKey             @"mXuMLdP7RK9qm6iemC8ef5"
#define ZXLZXZAppSecret          @"GGdwkZJBXt6gIyosNralS1"
//other推送key
#define ZXLZXZOrzAppId           @"mMker6uSR4AB0SIi6jUPt"
#define ZXLZXZOrzAppKey          @"NsEUd518Hl7AgIVVQ5GR9"
#define ZXLZXZOrzAppSecret       @"lVRjq9Z3pJ9Ys59bHh9kxA"
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface ZXLPushMessageManager()<GeTuiSdkDelegate,UNUserNotificationCenterDelegate>
#else
@interface ZXLPushMessageManager()<GeTuiSdkDelegate>
#endif
@end

@implementation ZXLPushMessageManager
+(instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLPushMessageManager * manager = nil;
    dispatch_once(&pred, ^{
        manager = [[ZXLPushMessageManager alloc] init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        
        self.userId = @"";
        self.geTuiSDKSuccess = NO;
        self.bindGeTuiUserId = ([[ZXLUtilsFunction userDefaultsObjectForKey:@"ZXLBindGeTuiUserId"] integerValue] == 1);

        [self registerAppId];
        // 注册 APNs
        [self registerRemoteNotification];

    }
    return self;
}

-(void)registerAppId{
    if ([self isCompanyAppType]) {
        /////////////////////////////
        // 个推
        // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
        if ([ZXLServerAddress manager].appType == ZXLAppTypeZXZ) {
            [GeTuiSdk startSdkWithAppId:ZXLZXZAppId appKey:ZXLZXZAppKey appSecret:ZXLZXZAppSecret delegate:self];
        }
        
        if ([ZXLServerAddress manager].appType == ZXLAppTypeZXZOrz) {
            [GeTuiSdk startSdkWithAppId:ZXLZXZOrzAppId appKey:ZXLZXZOrzAppKey appSecret:ZXLZXZOrzAppSecret delegate:self];
        }
    }
}

#pragma mark - 个推
/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                ZXLLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        // Fallback on earlier versions
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

-(void)checkPushMessageRegisterSuccess{
    if (!self.geTuiSDKSuccess) {
        [self registerAppId];
    }else{
        if (self.geTuiSDKSuccess && !self.bindGeTuiUserId && ZXLUtilsISNSStringValid(self.userId)) {
            [GeTuiSdk bindAlias:self.userId andSequenceNum:@"SequenceNum"];
        }
    }
}

-(void)pushMessagunbindAliasUserId{
    if (self.bindGeTuiUserId) {
        [GeTuiSdk unbindAlias:self.userId andSequenceNum:@"SequenceNum" andIsSelf:NO];
        [ZXLUtilsFunction userDefaultsRemoveObjectForKey:@"ZXLBindGeTuiUserId"];
        self.bindGeTuiUserId = NO;
    }
}

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    
    ZXLLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    
    ZXLLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    NSString * dynamicRoutesURL = [ZXLPushMessageManager getDynamicRoutesUrlFromPointPushMessage:response.notification.request.content.userInfo];
    if (ZXLUtilsISNSStringValid(dynamicRoutesURL)) {
        [ZXLRouter transactionURL:dynamicRoutesURL];
    }
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
}


#pragma mark - <GeTuiSdkDelegate>
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    ZXLLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    
    self.geTuiSDKSuccess = YES;
    //登录成功 个推SDK 启动成功绑定userid
    [self checkPushMessageRegisterSuccess];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    ZXLLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
    self.geTuiSDKSuccess = NO;
    [self checkPushMessageRegisterSuccess];
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    ZXLLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""]);
}

- (void)GeTuiSdkDidAliasAction:(NSString *)action result:(BOOL)isSuccess sequenceNum:(NSString *)aSn error:(NSError *)aError {
    if ([kGtResponseBindType isEqualToString:action]) {
        ZXLLog(@"绑定结果 ：%@ !, sn : %@", isSuccess ? @"成功" : @"失败", aSn);
        if (!isSuccess) {
            static NSInteger bindCount = 0;
            if (bindCount <3) {
                [self checkPushMessageRegisterSuccess];//个推送绑定用户的userid
                bindCount++;
            }
            ZXLLog(@"失败原因: %@", aError);
        }else{
            self.bindGeTuiUserId = YES;
            [ZXLUtilsFunction userDefaultsSetObject:@"1" forKey:@"ZXLBindGeTuiUserId"];
        }
    } else if ([kGtResponseUnBindType isEqualToString:action]) {
        ZXLLog(@"解绑结果 ：%@ !, sn : %@", isSuccess ? @"成功" : @"失败", aSn);
        if (!isSuccess) {
            ZXLLog(@"失败原因: %@", aError);
        }
    }
}


-(BOOL)isCompanyAppType{
    if ([ZXLServerAddress manager].appType == ZXLAppTypeZXZ || [ZXLServerAddress manager].appType == ZXLAppTypeZXZOrz) {
        return YES;
    }
    return NO;
}


+(NSString *)getDynamicRoutesUrlFromPointPushMessage:(NSDictionary *)userInfo{
    if (!ZXLUtilsISDictionaryValid(userInfo)) return @"";
    //    NSString *payload = [userInfo stringValueForKey:@"payload"];
    //    if (ISNSStringValid(payload)) {
    //        NSDictionary *pDict = [NSJSONSerialization JSONObjectWithData:[payload dataUsingEncoding:NSUTF8StringEncoding]
    //                                                              options:NSJSONReadingMutableContainers
    //                                                                error:nil];
    //        if (NotEmpty(pDict)) {
    //            return  [pDict stringValueForKey:@"link"];
    //        }
    //    }
    return [userInfo valueForKey:@"link"];;
}
@end

//
//  ZXLSocketManager.h
//  Compass
//
//  Created by 张小龙 on 2018/7/16.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import <Foundation/Foundation.h>


// 连接中... NotificationName
#define ZXLSocketStartConnect       @"ZXLSocketStartConnect"
// 连接失败
#define ZXLSocketConnectFail       @"ZXLSocketConnectFail"
// 连接成功
#define ZXLSocketConnectSucc       @"ZXLSocketConnectSucc"


@protocol ZXLSocketManagerDelegate<NSObject>
@optional
- (void)onCommNotify:(id)wParam;
@end

@interface ZXLSocketManager : NSObject
+(instancetype)manager;
-(void)addDelegte:(id<ZXLSocketManagerDelegate>)delegate;
-(void)removeDelegate:(id<ZXLSocketManagerDelegate>)delegate;

- (BOOL)connect;

- (void)disConnect;
-(BOOL)isCanSendData;
/**
 消息发送

 @param dataDict 数据字典
 */
- (void)sendMessage:(NSDictionary *)dataDict;
@end

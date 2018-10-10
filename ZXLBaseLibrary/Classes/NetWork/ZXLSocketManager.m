//
//  ZXLSocketManager.m
//  Compass
//
//  Created by 张小龙 on 2018/7/16.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLSocketManager.h"
#import "ZXLHttpManager.h"
#import "ZXLAddressManager.h"

#import <GCDAsyncSocket.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <UIKit/UIKit.h>
#import "ZXLUtilsDefined.h"
#import "ZXLPhoneInfo.h"

// 服务器目前是45s超时，设置20秒可以发两次
#define ZXLOnlinepace   20

/**
 socket 网络通讯连接状态
 
 - ZXLSocketStartConnectStatus: 准备开始连接
 - ZXLSocketConnectFailStatus: 连接失败
 - ZXLSocketConnectSuccStatus: 连接成功
 */
typedef NS_ENUM(NSUInteger, ZXLSocketStatus){
    ZXLSocketStartConnectStatus,
    ZXLSocketConnectFailStatus,
    ZXLSocketConnectSuccStatus
};


@interface ZXLSocketManager()<GCDAsyncSocketDelegate>
@property(nonatomic,strong)GCDAsyncSocket * asyncSocket;
@property (nonatomic,assign)ZXLSocketStatus socketStatus;
@property (nonatomic,assign)BOOL            destroyConnect;
@property (nonatomic,assign)BOOL            bCanSend;

@property (nonatomic,strong)NSTimer *       onlineTimer;
@property (nonatomic,assign)NSTimeInterval  theOnlineDate;
@property (nonatomic,strong)NSHashTable *   hashTable;
@end

@implementation ZXLSocketManager

+(instancetype)manager{
    static ZXLSocketManager *socketManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketManager = [[ZXLSocketManager alloc] init];
    });
    return socketManager;
}

-(instancetype)init{
    if (self = [super init]) {
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.socketStatus = ZXLSocketStartConnectStatus;
        self.bCanSend = NO;
        self.destroyConnect = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)appDidEnterBackground {
    [self disConnect];
}

- (void)appWillEnterForeground {
    [self connect];
}

-(NSHashTable *)hashTable{
    if (!_hashTable) {
        _hashTable = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
    }
    return _hashTable;
}

-(NSTimer *)onlineTimer{
    if (!_onlineTimer) {
        _onlineTimer = [NSTimer scheduledTimerWithTimeInterval:ZXLOnlinepace target:self selector:@selector(sendOnline) userInfo:nil repeats:YES];
    }
    return _onlineTimer;
}

-(void)addDelegte:(id<ZXLSocketManagerDelegate>)delegate{
    if (![self.hashTable containsObject:delegate]) {
        [self.hashTable addObject:delegate];
    }
}

-(void)removeDelegate:(id<ZXLSocketManagerDelegate>)delegate{
    if ([self.hashTable containsObject:delegate]) {
        [self.hashTable removeObject:delegate];
    }
}

- (void)endOnlineTimer{
    [self.onlineTimer setFireDate:[NSDate distantFuture]];
}
#pragma mark - 对外的一些接口

//建立连接
- (BOOL)connect{
    if (self.socketStatus != ZXLSocketStartConnectStatus) {
        return NO;
    }
    
    if (self.destroyConnect) {
        self.destroyConnect = NO;
    }
    
    return  [self.asyncSocket connectToHost:[ZXLAddressManager systemAddress:ZXLHOST] onPort:[[ZXLAddressManager systemAddress:ZXLPORT] integerValue] error:nil];
}

//断开连接
- (void)disConnect{
    [self.asyncSocket disconnect];
    [self endOnlineTimer];
    self.socketStatus = ZXLSocketStartConnectStatus;
    self.bCanSend = NO;
    self.destroyConnect = YES;
}

-(BOOL)isCanSendData{
    return self.bCanSend;
}

//发送消息
- (void)sendMessage:(NSDictionary *)dataDict{
    if ([self.asyncSocket isDisconnected]) { //判断连接状态
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![UIApplication sharedApplication].networkActivityIndicatorVisible) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    });
    
    NSError* error = nil;
    // NSDictionary -> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:&error];
    // \n 每段数据以\n作为结束标志
    NSData *next = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
    // 一段完整的数据
    NSMutableData *senddata = [[NSMutableData alloc] initWithData:data];
    [senddata appendData:next];
    //第二个参数，请求超时时间
    [self.asyncSocket writeData:senddata withTimeout:-1 tag:110];
}

#pragma mark - GCDAsyncSocketDelegate
//连接成功调用
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    ZXLLog(@"连接成功,host:%@,port:%d",host,port);
    self.socketStatus = ZXLSocketConnectSuccStatus;
    //身份验证
    [self userAuthentication];
}

//断开连接的时候调用
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err{
    ZXLLog(@"断开连接,host:%@,port:%d",sock.localHost,sock.localPort);
    if (self.destroyConnect) return;//此判断为主动断开不可去掉
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZXLSocketStartConnect object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIApplication sharedApplication].networkActivityIndicatorVisible) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    });
    //停止心跳发送
    [self endOnlineTimer];
    self.socketStatus = ZXLSocketStartConnectStatus;
    self.bCanSend = NO;

    if ( [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN
        ||  [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        //延时一秒重连
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self connect];
        });
    }
}

//写的回调
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag{
    [sock readDataToData:[GCDAsyncSocket LFData] withTimeout:-1 tag:0];
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [sock readDataToData:[GCDAsyncSocket LFData] withTimeout:-1 tag:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIApplication sharedApplication].networkActivityIndicatorVisible) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    });
    
    id responseData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if ([responseData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *responseDict = (NSDictionary *)responseData;
        //业务命令ID
        long cmid = (long)[[responseDict objectForKey:@"cmid"] longLongValue];
        switch (cmid) {
            case 1001000://认证业务结果处理
            {
                long code = (long)[[responseDict objectForKey:@"code"] longLongValue];
                switch (code) {
                    case 4000008://帐号异常操作
                    {
                        [self disConnect];//账号异常先断开连接
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZXLAccountLoginOut" object:@"客户端在其他手机中登录，请重新登录..."];// 退出登录
                    }
                        break;
                    case 4000006://用户不存在
                    case 4000036://修改密码等操作账号信息导致jwt失效，需要重新登录
                    {
                        //账号异常先断开连接
                        [self disConnect];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZXLAccountLoginOut" object:@"帐号异常"];// 退出登录
                    }
                        break;
                    case 4000005://刷新JsonWebToken
                    {
                        [ZXLHttpManager refreshToken];
                    }
                        break;
                    case 200:
                    {
                        ZXLLog(@"认证成功");
                        self.bCanSend = TRUE;// 认证成功后才能发送数据
                        [self.onlineTimer setFireDate:[NSDate distantPast]];//开始心跳发送
                        [[NSNotificationCenter defaultCenter] postNotificationName:ZXLSocketConnectSucc object:nil];//发送认证成功消息
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 3001000:
            {
                ZXLLog(@"收到接入心跳包%@",@"Action=3001000");
            }
                break;
                
            default:
            {
                [[self.hashTable allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj && [obj respondsToSelector:@selector(onCommNotify:)]){
                        [obj onCommNotify:responseDict];
                    }
                }];
            }
                break;
        }
    }
}

/**
 连接成功后发送认证
 */
- (void)userAuthentication {
    ZXLLog(@"发送认证请求");
}

-(void)sendOnline{
    ZXLLog(@"发送心跳请求");
}



@end

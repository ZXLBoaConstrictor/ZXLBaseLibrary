//
//  ZXLHttpManager.m
//  BaseUtilsModule
//
//  Created by 张小龙 on 2018/6/15.
//

#import "ZXLHttpManager.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "ZXLUtilsDefined.h"
#import "ZXLAddressManager.h"
#import "NSString+ZXLErrorCode.h"

@implementation ZXLHttpManager

+(ZXLHttpManager*)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLHttpManager * manager = nil;
    dispatch_once(&pred, ^{
        manager = [[ZXLHttpManager alloc] init];
    });
    return manager;
}

static dispatch_once_t pred = 0;
__strong static AFHTTPSessionManager *  mainManager = nil;

+(AFHTTPSessionManager *)httpSessionManager:(ZXLHttpServiceType)serviceType
                           requestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer{
    AFHTTPSessionManager * sessionManager = nil;

    if (serviceType == ZXLHttpMainPost || serviceType == ZXLHttpMainGet) {
        dispatch_once(&pred, ^{
            mainManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[ZXLAddressManager systemAddress:ZXLURLStr]]];
            mainManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            mainManager.responseSerializer = [AFJSONResponseSerializer serializer];
            mainManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
        });
        sessionManager =  mainManager;
    }

    sessionManager.requestSerializer = requestSerializer;
    NSString *strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (sessionManager.requestSerializer && ZXLUtilsISNSStringValid(strVersion)) {
        [sessionManager.requestSerializer setValue:strVersion forHTTPHeaderField:@"IOSVersion"];
    }

    return sessionManager;
}

+(void)attemptDealloc{
    pred = 0;
    mainManager = nil;
}

/**
 获取token
 
 @param serviceType 请求类型
 @param complete 返回结果
 */
+(void)getToken:(ZXLHttpServiceType)serviceType complete:(void (^)(NSString * token))complete{
    complete(@"");
}

+(void)checkAndRefreshToken{
    [ZXLHttpManager getToken:ZXLHttpMainPost complete:^(NSString *token) {
        
    }];
}

+(void)refreshToken{
 
}

/**
 记录token 上一次刷新获取时间
 
 @param nsAction 接口名称
 @param responseObject 返回数据
 */
+(void)rememberTokenExpirationTimeInMilliSecond:(NSString *)nsAction responseObject:(id)responseObject{
    if ([nsAction isEqualToString:@"login"] || [nsAction isEqualToString:@"jwt/refresh"]) {
        if ([[responseObject objectForKey:ZXLResponseCode] integerValue] == 200) {
            NSInteger timeInMilliSecond =  [[[responseObject objectForKey:@"result"] objectForKey:@"expires_in"] integerValue];
            if (timeInMilliSecond > 0) {
                [ZXLHttpManager manager].tokenExpirationTimeInMilliSecond = [[NSDate date] timeIntervalSince1970] + timeInMilliSecond;
            }
        }
    }
}

+(void)sendHttpRequest:(NSString *)apiName
             parameter:(NSDictionary *)parameter
              delegate:(id)delegate
                  type:(ZXLHttpServiceType)serviceType{
    [ZXLHttpManager sendHttpRequest:apiName
                          parameter:parameter
                           delegate:delegate
                               type:serviceType
                  requestSerializer:[AFHTTPRequestSerializer serializer]
                            success:nil failure:nil];
}

+(void)sendHttpRequest:(NSString *)apiName
             parameter:(NSDictionary *)parameter
              delegate:(id)delegate
                  type:(ZXLHttpServiceType)serviceType
     requestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer{
    [ZXLHttpManager sendHttpRequest:apiName
                          parameter:parameter
                           delegate:delegate
                               type:serviceType
                  requestSerializer:requestSerializer
                            success:nil failure:nil];
}

+(void)sendHttpRequest:(NSString *)apiName
             parameter:(NSDictionary *)parameter
                  type:(ZXLHttpServiceType)serviceType
               success:(void (^)(NSURLSessionDataTask *task, id  responseObject))success
               failure:(void (^)(NSURLSessionDataTask *  task, NSError *error))failure{
    [ZXLHttpManager sendHttpRequest:apiName
                          parameter:parameter
                           delegate:nil
                               type:serviceType
                  requestSerializer:[AFHTTPRequestSerializer serializer]
                            success:success
                            failure:failure];
}

+(void)sendHttpRequest:(NSString *)apiName
             parameter:(NSDictionary *)parameter
                  type:(ZXLHttpServiceType)serviceType
     requestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer
               success:(void (^)(NSURLSessionDataTask *task, id  responseObject))success
               failure:(void (^)(NSURLSessionDataTask *  task, NSError *error))failure {
    [ZXLHttpManager sendHttpRequest:apiName
                          parameter:parameter
                           delegate:nil
                               type:serviceType
                  requestSerializer:requestSerializer
                            success:success
                            failure:failure];
}

//请求判断过滤
+(void)sendHttpRequest:(NSString *)apiName
            parameter:(NSDictionary *)parameter
           delegate:(id)delegate
             type:(ZXLHttpServiceType)serviceType
  requestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer
            success:(void (^)(NSURLSessionDataTask *task, id  responseObject))success
            failure:(void (^)(NSURLSessionDataTask *  task, NSError *error))failure{
    if (!ZXLUtilsISNSStringValid(apiName))
        return;
    
    if (success == nil && failure == nil && delegate == nil) {
        return;
    }
    
    if (parameter == nil){
        parameter = [NSMutableDictionary dictionary];
    }
    
    [ZXLHttpManager getToken:serviceType complete:^(NSString *token) {
        [ZXLHttpManager sendRequest:apiName
                          parameter:parameter
                           delegate:delegate
                               type:serviceType
                  requestSerializer:requestSerializer
                            success:success
                            failure:failure
                              token:token];
    }];
}

+ (void)sendRequest:(NSString *)apiName
          parameter:(NSDictionary *)parameter
           delegate:(id)delegate
               type:(ZXLHttpServiceType)serviceType
  requestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer
            success:(void (^)(NSURLSessionDataTask *task, id  responseObject))success
            failure:(void (^)(NSURLSessionDataTask *  task, NSError *error))failure
              token:(NSString *)token
{
    AFHTTPSessionManager * pHttpMain = [ZXLHttpManager httpSessionManager:serviceType requestSerializer:requestSerializer];
    [pHttpMain.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    if (serviceType == ZXLHttpMainPost){
        [pHttpMain POST:apiName parameters:parameter progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
            if ([[responseObject objectForKey:ZXLResponseCode] integerValue] == 4000005) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZXLAccountLoginOut" object:@""];
            }else{
                if (success) {
                    success(task,responseObject);
                }else{
                    NSMutableDictionary *pResponse = [NSMutableDictionary dictionary];
                    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                        [pResponse addEntriesFromDictionary:responseObject];
                    }
                    
                    if ([[pResponse objectForKey:ZXLResponseCode] integerValue] == 200) {
                        [ZXLHttpManager OnReceive:pResponse apiName:apiName result:YES delegate:delegate type:serviceType];
                    }else{
                        [ZXLHttpManager OnReceiveError:task error:responseObject apiName:apiName delegate:delegate type:serviceType];
                    }
                }
            }
        } failure:^(NSURLSessionDataTask * task, NSError * _Nonnull error) {
            if (task.response && ((NSHTTPURLResponse *)task.response).statusCode == 403) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZXLAccountLoginOut" object:@""];
            }else{
                if (failure) {
                    failure(task,error);
                }else{
                    [ZXLHttpManager OnReceiveError:task error:error apiName:apiName delegate:delegate type:serviceType];
                }
            }
        }];
    }
    
    if (serviceType == ZXLHttpMainGet){
        [pHttpMain GET:apiName parameters:parameter progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
            
            if ([[responseObject objectForKey:ZXLResponseCode] integerValue] == 4000005) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZXLAccountLoginOut" object:@""];
            }else{
                if (success) {
                    success(task,responseObject);
                }else{
                    NSMutableDictionary *pResponse = [NSMutableDictionary dictionary];
                    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                        [pResponse addEntriesFromDictionary:responseObject];
                    }
                    
                    if ([[pResponse objectForKey:ZXLResponseCode] integerValue] == 200) {
                        [ZXLHttpManager OnReceive:pResponse apiName:apiName result:YES delegate:delegate type:serviceType];
                    }else{
                        [ZXLHttpManager OnReceiveError:task error:responseObject apiName:apiName delegate:delegate type:serviceType];
                    }
                }
            }
        } failure:^(NSURLSessionDataTask *  task, NSError * error) {
            if (task.response && ((NSHTTPURLResponse *)task.response).statusCode == 403) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZXLAccountLoginOut" object:@""];
            }else{
                if (failure) {
                    failure(task,error);
                }else{
                    [ZXLHttpManager OnReceiveError:task error:error apiName:apiName delegate:delegate type:serviceType];
                }
            }
        }];
    }
}

+(void)OnReceiveError:(NSURLSessionDataTask *)task error:(id)error apiName:(NSString *)apiName delegate:(id)delegate type:(ZXLHttpServiceType)serviceType{
    NSMutableDictionary *pDict = [NSMutableDictionary dictionary];
    NSString * strError = @"请求错误!";
    if (error && [error isKindOfClass:[NSError class]]){
        if (((NSError *)error).code == NSURLErrorNotConnectedToInternet) {
            strError = @"当前网络不可用，请检查网络设置";
        }else if (((NSError *)error).code == NSURLErrorTimedOut){
            strError = @"网络请求超时";
        }else if (((NSError *)error).code == NSURLErrorBadServerResponse){
            strError = @"当前网络连接异常，请检查网络连接";
        }else{
            strError = @"当前网络连接异常，请检查网络连接";
        }
        [pDict setValue:@(((NSError *)error).code).stringValue forKey:@"errorCode"];
        [pDict setValue:strError forKey:@"msg"];
    }
    
    if (error && [error isKindOfClass:[NSDictionary class]]) {
        [pDict addEntriesFromDictionary:(NSDictionary *)error];
        NSString * strError = [NSString errorCodeToString:[[pDict objectForKey:ZXLResponseCode] integerValue]];
        if (!ZXLUtilsISNSStringValid(strError)) {
            strError =  [pDict objectForKey:ZXLResponseMessage];
        }
        [pDict setValue:strError forKey:ZXLResponseMessage];
    }
    
    [ZXLHttpManager OnReceive:pDict apiName:apiName result:YES delegate:delegate type:serviceType];
}


+(void)OnReceive:(NSMutableDictionary *)wParam apiName:(NSString *)apiName result:(BOOL)bResult delegate:(id<ZXLHttpManagerDelegate>)delegate type:(ZXLHttpServiceType)serviceType{
    
    if (delegate && [delegate respondsToSelector:@selector(OnReceive:complete:)]){
        [wParam setValue:apiName forKey:@"apiName"];
        [delegate OnReceive:wParam complete:bResult];
    }
}

+(void)showErrorMessage:(NSDictionary *)parameter message:(NSString *)defaultMessage{
    [SVProgressHUD showErrorWithStatus:[NSString errorMessage:parameter message:defaultMessage]];
}

+(void)showFailureMessage:(NSError *)error message:(NSString *)defaultMessage{
    [SVProgressHUD showErrorWithStatus:[NSString failureMessage:error message:defaultMessage]];
}
@end

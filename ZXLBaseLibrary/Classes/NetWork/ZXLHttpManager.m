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
#import "ZXLAccountManager.h"
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

+(AFHTTPSessionManager *)httpSessionManager:(ZXLHttpServiceType)serviceType{
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
    
    NSString *strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (sessionManager.requestSerializer && ZXLUtilsISNSStringValid(strVersion)) {
        [sessionManager.requestSerializer setValue:strVersion forHTTPHeaderField:@"IOSVersion"];
    }

    return sessionManager;
}


/**
   检测是否需要请求获取token
 
 @return 检测结果
 */
+(BOOL)checkRequestToken:(ZXLHttpServiceType)serviceType{
    if (![ZXLAccountManager manager].isLogin) {
        return NO;
    }
    
    NSDate * expirationDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[ZXLHttpManager manager].tokenExpirationTimeInMilliSecond];
    NSTimeInterval interval = [expirationDate timeIntervalSinceDate:[NSDate date]];
    NSString *token = [ZXLAccountManager manager].token;
    //距离超时时间5分钟重新获取token
    if (interval < 5 * 60 || !ZXLUtilsISNSStringValid(token)) {
        return YES;
    }
    return NO;
}

/**
 获取token
 
 @param check 是否需要检测请求token
 @param serviceType 请求类型
 */
+(void)requestToken:(ZXLHttpServiceType)serviceType check:(BOOL)check complete:(void (^)(NSString * token))complete{
    if (check && ![ZXLHttpManager checkRequestToken:serviceType]) {
        if (complete) {
            complete([ZXLAccountManager manager].token);
        }
        return;
    }
    
    NSString * refreshToken = [ZXLAccountManager manager].refreshToken;
    refreshToken = ZXLUtilsISNSStringValid(refreshToken)?refreshToken:@"";
    //接口获取token
    AFHTTPSessionManager * pHttpMain = [ZXLHttpManager httpSessionManager:ZXLHttpMainPost];
    [pHttpMain POST:@"jwt/refresh" parameters:@{@"refreshToken":refreshToken} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject objectForKey:ZXLResponseCode] == 200) {
            [[ZXLAccountManager manager] setAccountData:[responseObject objectForKey:@"result"]];
            if (complete) {
                complete([ZXLAccountManager manager].token);
            }
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZXLAccountLoginOut" object:@"帐户验证失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == NSURLErrorNotConnectedToInternet) {
            [SVProgressHUD showErrorWithStatus:@"当前网络不可用，请检查网络设置"];
        }else if (error.code == NSURLErrorTimedOut){
            [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZXLAccountLoginOut" object:@"帐户验证失败"];
        }
    }];
}

+ (void)sendRequest:(NSString *)apiName
          parameter:(NSDictionary *)parameter
        serviceType:(ZXLHttpServiceType)serviceType
       requestToken:(NSString *)token
            success:(void (^)(NSURLSessionDataTask *task, id  responseObject))success
            failure:(void (^)(NSURLSessionDataTask *  task, NSError *error))failure
{
    AFHTTPSessionManager * pHttpMain = [ZXLHttpManager httpSessionManager:serviceType];
    [pHttpMain.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    if (serviceType == ZXLHttpMainPost){
        [pHttpMain POST:apiName parameters:parameter progress:nil success:success failure:failure];
    }
    
    if (serviceType == ZXLHttpMainGet){
        [pHttpMain GET:apiName parameters:parameter progress:nil success:success failure:failure];
    }
}

+(void)sendHttpRequest:(NSString *)apiName
             parameter:(NSDictionary *)parameter
           serviceType:(ZXLHttpServiceType)serviceType
              complete:(void (^)(NSDictionary *response))complete{
    if (!ZXLUtilsISNSStringValid(apiName))
        return;
    
    if (parameter == nil){
        parameter = [NSMutableDictionary dictionary];
    }
    
    [ZXLHttpManager requestToken:serviceType check:YES complete:^(NSString *token) {
        [ZXLHttpManager sendRequest:apiName parameter:parameter serviceType:serviceType requestToken:token success:^(NSURLSessionDataTask *task, id responseObject) {
            if(complete){
                complete(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [ZXLHttpManager showFailureMessage:error message:@"接口请求错误"];
        }];
    }];
}



+(void)showErrorMessage:(NSDictionary *)parameter message:(NSString *)defaultMessage{
    [SVProgressHUD showErrorWithStatus:[NSString errorMessage:parameter message:defaultMessage]];
}

+(void)showFailureMessage:(NSError *)error message:(NSString *)defaultMessage{
    [SVProgressHUD showErrorWithStatus:[NSString failureMessage:error message:defaultMessage]];
}
@end

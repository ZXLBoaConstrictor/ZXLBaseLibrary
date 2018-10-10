//
//  ZXLHttpManager.h
//  BaseUtilsModule
//
//  Created by 张小龙 on 2018/6/15.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestSerializer;
@protocol AFURLRequestSerialization;

/**
 业务请求分类(主要针对业务地址分类)
 - ZXLHttpMainPost: 主业务 POST请求
 - ZXLHttpMainGet: 主业务 GET 请求
 */
typedef NS_ENUM(NSUInteger, ZXLHttpServiceType){
    ZXLHttpMainPost,
    ZXLHttpMainGet
};

@protocol ZXLHttpManagerDelegate <NSObject>
/**
 通讯返回结果
 
 @param wParam 返回数据结果
 @param bResult 请求回应结果 如果错误Wparam 中是错误结果
 */
-(void)OnReceive:(NSMutableDictionary *)wParam complete:(BOOL)bResult;
@end

@interface ZXLHttpManager : NSObject

/**
 token 下一次token请求超时时间戳
 */
@property (nonatomic,assign)NSTimeInterval tokenExpirationTimeInMilliSecond;

/**
 接口请求单例
 @return 接口请求管理器
 */
+(ZXLHttpManager*)manager;

+(void)attemptDealloc;
/**
 获取token
 
 @param serviceType 请求类型
 @param complete 返回结果
 */
+(void)getToken:(ZXLHttpServiceType)serviceType complete:(void (^)(NSString * token))complete;

/**
 检测并更新TOKEN
 */
+(void)checkAndRefreshToken;

+(void)refreshToken;

/**
 接口请求总函数-代理形式
 
 @param apiName 接口名称
 @param parameter 请求参数字典
 @param delegate 代理
 @param serviceType 接口地址类型
 */
+(void)sendHttpRequest:(NSString *)apiName
             parameter:(NSDictionary *)parameter
              delegate:(id)delegate
                  type:(ZXLHttpServiceType)serviceType;


/**
 接口请求总函数-代理形式 加入RequestSerializer
 
 @param apiName 接口名称
 @param parameter 请求参数字典
 @param delegate 代理
 @param serviceType 接口地址类型
 @param requestSerializer Http请求类型
 */
+(void)sendHttpRequest:(NSString *)apiName
             parameter:(NSDictionary *)parameter
              delegate:(id)delegate
                  type:(ZXLHttpServiceType)serviceType
     requestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer;


/**
 接口请求总函数- block返回形式
 
 @param apiName 接口名称
 @param parameter 请求参数字典
 @param serviceType 接口地址类型
 @param success 返回成功block
 @param failure 返回失败block
 */
+(void)sendHttpRequest:(NSString *)apiName
            parameter:(NSDictionary *)parameter
                  type:(ZXLHttpServiceType)serviceType
               success:(void (^)(NSURLSessionDataTask *task, id  responseObject))success
               failure:(void (^)(NSURLSessionDataTask *  task, NSError *error))failure;

/**
 接口请求总函数- block返回形式 加入RequestSerializer
 
 @param apiName 接口名称
 @param parameter 请求参数字典
 @param serviceType 接口地址类型
 @param requestSerializer Http请求类型
 @param success 返回成功block
 @param failure 返回失败block
 */
+(void)sendHttpRequest:(NSString *)apiName
             parameter:(NSDictionary *)parameter
                  type:(ZXLHttpServiceType)serviceType
     requestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer
               success:(void (^)(NSURLSessionDataTask *task, id  responseObject))success
               failure:(void (^)(NSURLSessionDataTask *  task, NSError *error))failure;


/**
 显示请求错误信息

 @param parameter 参数
 @param defaultMessage 默认错误信息
 */
+(void)showErrorMessage:(NSDictionary *)parameter message:(NSString *)defaultMessage;

/**
 显示http失败错误

 @param error 失败信息
 @param defaultMessage 默认错误信息
 */
+(void)showFailureMessage:(NSError *)error message:(NSString *)defaultMessage;
@end

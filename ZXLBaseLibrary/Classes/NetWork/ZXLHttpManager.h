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

@interface ZXLHttpManager : NSObject

/**
 token 下一次token请求超时时间戳
 */
@property (nonatomic,assign)NSTimeInterval tokenExpirationTimeInMilliSecond;

+(ZXLHttpManager*)manager;

/**
 接口请求总函数- block返回形式
 
 @param apiName 接口名称
 @param parameter 请求参数字典
 @param serviceType 接口地址类型
 @param complete 接口返回数据
 */
+(void)sendHttpRequest:(NSString *)apiName
             parameter:(NSDictionary *)parameter
           serviceType:(ZXLHttpServiceType)serviceType
              complete:(void (^)(NSDictionary *response))complete;

/**
 显示请求错误信息

 @param parameter 参数
 @param defaultMessage 默认错误信息
 */
+(void)showErrorMessage:(NSDictionary *)parameter message:(NSString *)defaultMessage;
@end

//
//  ZXLAddressManager.h
//
//  Created by 张小龙 on 2018/6/15.
//  Copyright © 2018年 244061043@qq.com. All rights reserved.
//


#import <Foundation/Foundation.h>
/**
 业务地址分类
 */
typedef NS_ENUM(NSUInteger, ZXLAddressType){
    ZXLHOST,           // socket 地址
    ZXLPORT,           // socket 端口
    ZXLURLStr,        // 业务URL
    ZXLFileURLStr,   // 文件
};

@interface ZXLAddressManager : NSObject

@property (nonatomic,copy)NSString * socketHost;    // app Socket 地址
@property (nonatomic,copy)NSString * socketPort;    // app Socket 端口
@property (nonatomic,copy)NSString * address;       // app业务 地址

@property (nonatomic,copy)NSString * bucketName;    // 阿里云bucketName
@property (nonatomic,copy)NSString * endPoint;    // 阿里云endPoint
@property (nonatomic,copy)NSString * downloadfileURL;    // 阿里云endPoint

+ (instancetype)manager;

+(void)attemptDealloc;
/**
 获取App 不同业务接口地址
 @param addressType 不同业务接口地址类型
 @return 不同业务地址
 */
+(NSString *)systemAddress:(ZXLAddressType)addressType;

@end

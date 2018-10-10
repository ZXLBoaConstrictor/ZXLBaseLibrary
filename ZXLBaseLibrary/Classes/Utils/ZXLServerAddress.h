//
//  ZXLServerAddress.h
//  ZXLUtils
//  此工具类为了满足开发中服务器地址的获取使用，并避开打包错误等一系列由于地址引起的问题。
//  不要把地址放到配置文件或者.h中（地址管理可把其当父类使用）
//  Created by 张小龙 on 2018/5/3.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  ZXLServerAddressReleaseType @"ZXLServerAddressReleaseType"

/**
 开发环境类型

 - ZXLReleaseProductionType: 生成环境
 - ZXLReleasePreProductionType: 测试环境
 - ZXLReleaseDevelopmentType: 开发环境
 */
typedef NS_ENUM(NSUInteger, ZXLReleaseType){
    ZXLReleaseProductionType = 1,
    ZXLReleasePreProductionType,
    ZXLReleaseDevelopmentType,
};

/**
 公司App分类

 - ZXLAppTypeZXZ:
 - ZXLAppTypeZXZOrz: 
 */
typedef NS_ENUM(NSUInteger, ZXLAppType){
    ZXLAppTypeZXZ = 1,
    ZXLAppTypeZXZOrz,
};

@interface ZXLServerAddress : NSObject
/**
 App 发布环境类型
 */
@property (nonatomic,assign) ZXLReleaseType releaseType;
@property (nonatomic,assign) ZXLAppType appType;

+ (instancetype)manager;

/**
 设置公司域名数组
 @param hosts 域名数据
 */
- (void)setCompanyHost:(NSArray *)hosts;

/**
 判断此链接是不是公司 (此函数判断URL 依赖于setCompanyHost:中的hosts，所以请先添加hosts)
 @param url 链接
 @return 判断结果
 */
- (BOOL)isCompanyHost:(NSString *)url;
@end

//
//  ZXLPhoneInfo.h
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCellularData.h>

/**
 手机屏幕型号定义
 - ZXLIphone4Version: iphone4
 - ZXLIphone5Version: iphone5
 - ZXLIphone6Version: iphone6
 - ZXLIphone6pVersion: iphone6p
 - ZXLIphoneXVersion: iphoneX
 */
typedef NS_ENUM(NSUInteger, ZXLIphoneVersionStyle){
    ZXLIphone4Version,
    ZXLIphone5Version,
    ZXLIphone6Version,
    ZXLIphone6pVersion,
    ZXLIphoneXVersion,
};

@interface ZXLPhoneInfo : NSObject
/**
 获取手机型号
 @return 手机型号
 */
+(NSString *)iphoneType;


/**
 获取手机剩余存储空间
 @return 存储空间
 */
+(unsigned long long)freeDiskSpaceInBytes;

/**
 手机版本号
 @return 手机屏幕型号
 */
+(ZXLIphoneVersionStyle)iphoneVersion;


/**
 可用内存大小
 @return 内存大小
 */
+(double)memoryAvailableBytes;


/**
 App缓存大小(temp和NSCachesDirectory中的缓存，单位 M)
 @param completed 获取缓存结果
 */
+ (void)applicationCachesSize:(void (^)(double size))completed;

/**
 清理缓存(主要清理temp和NSCachesDirectory中的缓存)
 @param completed 清理缓存结果
 */
+ (void)applicationClearCaches:(void (^)(BOOL bResult))completed;

/**
 当前网络权限设置状态
 */
+ (void)checkNetWorkPermission:(CellularDataRestrictionDidUpdateNotifier)updateNotifier;
@end

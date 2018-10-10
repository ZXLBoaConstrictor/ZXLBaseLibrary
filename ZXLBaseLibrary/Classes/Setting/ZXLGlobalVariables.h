//
//  ZXLGlobalVariables.h
//  ZXLSettingModule
//
//  Created by 张小龙 on 2018/6/27.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus);

FOUNDATION_EXPORT  CGFloat       system_tabbarHeight;//底部栏高度
FOUNDATION_EXPORT  CGFloat       system_titleViewHeight;//顶部栏高度
FOUNDATION_EXPORT  CGFloat       system_titleStatusBarHeight;//顶部状态栏高度

//事件标志
FOUNDATION_EXPORT  BOOL         system_showStart;//是否显示启动宣传页
FOUNDATION_EXPORT  BOOL         system_advertisement;//客户端是否获取广告标志

FOUNDATION_EXPORT  AFNetworkReachabilityStatus   system_networkstatus;

FOUNDATION_EXPORT UINavigationController * system_UINavigationController;

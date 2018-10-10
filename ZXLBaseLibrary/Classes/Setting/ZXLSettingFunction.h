//
//  ZXLSettingFunction.h
//  ZXLSettingModule
//
//  Created by 张小龙 on 2018/6/27.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZXLFileType);

@interface ZXLSettingFunction : NSObject

/**
 设置 文件浏览器文件展示标准信息输出

 @param dataType 文件类型
 @param dateInfo 文件信息
 @param dateURL 文件路径
 @param bFromAlbum 是否出自相册
 @return 文件信息
 */
+(NSDictionary *)filesBrowserFileInfo:(ZXLFileType)dataType dateinfo:(id)dateInfo dateURL:(NSString *)dateURL fromAlbum:(BOOL)bFromAlbum;


/**
 设置 文件浏览器 所有文件信息

 @param dataInfo 字典数组 字典中 dataType 数据类型  dateImage 数据缩略图  dateURL 数据地址
 @param index 索引
 @return 文件浏览器信息
 */
+(NSDictionary *)filesBrowserData:(NSArray *)dataInfo Index:(NSInteger)index;

@end

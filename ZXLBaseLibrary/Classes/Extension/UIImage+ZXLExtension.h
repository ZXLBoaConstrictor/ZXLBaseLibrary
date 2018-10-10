//
//  UIImage+ZXLExtension.h
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/29.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(ZXLExtension)

/**
 主要处理图片旋转90°问题
 通常用在使用 UIImagePickerController 拍照后得来的图片会旋转 90°，利用此函数优化
 @return 图片
 */
- (UIImage *)fixOrientation;

/**
 App 中使用资源文件中的图片
 (注意 依赖于ZXLResourceAddress中的bundlename ，图片资源注意存储在bundle/image中)
 @param name 图片名称
 @return UIImage
 */
+(UIImage *)ZXLImageNamed:(NSString *)name;

/**
 利用颜色绘制纯属图片
 @param color 颜色值
 @return 图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 利用文字和颜色 绘制一张图片
 （场景：默认头像等）
 @param text 文字
 @param bgColor 图片背景颜色
 @param size 图片大小
 @return 图片
 */
+ (UIImage *)createImageWithText:(NSString *)text bgColor:(UIColor*)bgColor size:(CGSize)size;

@end

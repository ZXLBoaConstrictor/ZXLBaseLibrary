//
//  UIImageView+ZXLExtension.h
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/29.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(ZXLExtension)

/**
 圆角值，其设置必须在 setImage 函数之前
 */
@property (nonatomic,assign) CGFloat cornerRadius;

/**
 圆角控制 （依赖 cornerRadius > 0）
 */
@property (nonatomic,assign) UIRectCorner roundingCorners;

/**
 边框宽度（依赖 cornerRadius > 0 和 borderColor 有值）
 */
@property (assign, nonatomic) CGFloat borderWidth;

/**
 边框颜色 （依赖 cornerRadius > 0 和 borderWidth > 0）
 */
@property (strong, nonatomic) UIColor* borderColor;

/**
 平铺图片（图片不做拉伸展示）
 */
-(void)tiledImage;

/**
 添加高斯模糊效果(此函数在界面创建的时候使用)
 */
-(void)addVisualEffect;

@end

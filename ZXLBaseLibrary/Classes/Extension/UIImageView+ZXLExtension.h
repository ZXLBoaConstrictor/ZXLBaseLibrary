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
 平铺图片（图片不做拉伸展示）
 */
-(void)tiledImage;

/**
 添加高斯模糊效果(此函数在界面创建的时候使用)
 */
-(void)addVisualEffect;

@end

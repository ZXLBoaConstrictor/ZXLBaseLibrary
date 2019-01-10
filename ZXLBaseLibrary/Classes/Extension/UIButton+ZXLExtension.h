//
//  UIButton+ZXLExtension.h
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import  <UIKit/UIKit.h>

/**
 UIButton 控制图片和文件的显示位子

 - ZXLButtonEdgeInsetsStyleTop:  image在上，label在下
 - ZXLButtonEdgeInsetsStyleLeft:  image在左，label在右
 - ZXLButtonEdgeInsetsStyleBottom: image在下，label在上
 - ZXLButtonEdgeInsetsStyleRight: image在右，label在左
 */
typedef NS_ENUM(NSUInteger, ZXLButtonEdgeInsetsStyle) {
    ZXLButtonEdgeInsetsStyleTop,
    ZXLButtonEdgeInsetsStyleLeft,
    ZXLButtonEdgeInsetsStyleBottom,
    ZXLButtonEdgeInsetsStyleRight
};

@interface UIButton (ZXLExtension)

/**
 按钮防重点击间隔时间 (默认时间间隔 1.0)
 */
@property (nonatomic, assign) NSTimeInterval eventInterval;

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *  (注：此函数一定要在button 的title 和image 设置完成后使用)
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(ZXLButtonEdgeInsetsStyle)style
                             buttonSize:(CGSize)bsize
                              imageSize:(CGSize)size
                        imageTitleSpace:(CGFloat)space;
@end

//
//  ZXLProgressView.h
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/7/3.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ZXLProgressViewStyle) {
    ZXLProgressViewStyleCircle,                                          // 圆形进度条
    ZXLProgressViewStyleBar,                                             // 条形进度条
    ZXLProgressViewStyleDefault = ZXLProgressViewStyleCircle,
};


@interface ZXLProgressView : UIView
@property(nonatomic, assign, setter=setProgress:) CGFloat progress;     // 0.0 ~ 1.0

@property(nonatomic, assign) ZXLProgressViewStyle progressViewStyle;     // 进度条style
@property(nonatomic, strong) UIColor *trackTintColor;                   // 进度条背景色
@property(nonatomic, strong) UIColor *progressTintColor;                // 进度条颜色
@property(nonatomic, strong) UIColor *progressFullTintColor;            // 进度完成时progressTint的颜色
@property(nonatomic, assign) CGFloat lineWidth;                         // 绘制progress宽度  default: 10

// CCProgressViewStyleCircle 有效
@property(nonatomic, strong) UIColor *fillColor;                // 中心颜色
@property(nonatomic, assign) BOOL clockwise;                    // 是否是顺时针 default: YES
@property(nonatomic, assign) CGFloat startAngle;                // 进度条开始angle, default: -M_PI/2.0

- (void)setProgress:(CGFloat)progress;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end

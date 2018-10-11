//
//  ZXLTipsPopoverBackgroundView.m
//  Compass
//
//  Created by xyt on 2018/2/9.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLTipsPopoverBackgroundView.h"
#import <ZXLSettingDefined.h>
@interface ZXLTipsPopoverBackgroundView()
@property (nonatomic, assign) CGFloat fArrowOffset;
@end

@implementation ZXLTipsPopoverBackgroundView


//这个方法返回箭头宽度
+ (CGFloat)arrowBase{
    return EtalonSpacing;
}
//这个方法中返回内容视图的偏移
+(UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(10*ViewScaleValue, 0, 0, 0);
}
//这个方法返回箭头高度
+(CGFloat)arrowHeight{
    return 5*ViewScaleValue;
}
//这个方法返回箭头的方向
-(UIPopoverArrowDirection)arrowDirection{
    
    return UIPopoverArrowDirectionUp;
}
//这个在设置箭头方向时被调用 可以监听做处理
-(void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection{
    
}
////这个方法在设置箭头偏移量时被调用 可以监听做处理
-(void)setArrowOffset:(CGFloat)arrowOffset{
    self.fArrowOffset = arrowOffset;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//重写layout方法来来定义箭头样式
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.shadowOpacity = 0.2f;
    
    CGSize arrowSize = CGSizeMake([[self class] arrowBase], [[self class] arrowHeight]);
    UIImage * image  = [self drawArrowImage:arrowSize];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake((self.frame.size.width - arrowSize.width)/2 + self.fArrowOffset, 11*ViewScaleValue, arrowSize.width, arrowSize.height);
    [self addSubview:imageView];
}

//画箭头方法
- (UIImage *)drawArrowImage:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] setFill];
    CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, size.width, size.height));
    CGMutablePathRef arrowPath = CGPathCreateMutable();
    CGPathMoveToPoint(arrowPath, NULL, (size.width/2.0f), 0.0f);
    CGPathAddLineToPoint(arrowPath, NULL, size.width, size.height);
    CGPathAddLineToPoint(arrowPath, NULL, 0.0f, size.height);
    CGPathCloseSubpath(arrowPath);
    CGContextAddPath(ctx, arrowPath);
    CGPathRelease(arrowPath);
    UIColor *fillColor = [UIColor colorWithWhite:0 alpha:0.8];
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(BOOL)wantsDefaultContentAppearance{
    return NO;
}

@end

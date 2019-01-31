//
//  UIImageView+ZXLExtension.m
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/29.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "UIImageView+ZXLExtension.h"
#import "NSObject+ZXLExtension.h"
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import "NSURL+ZXLExtension.h"
#import "UIImage+ZXLExtension.h"

static const NSString *kZXLCornerRadiusImagePreString = @"ZXLCornerRadiusImagePreString";

@implementation UIImageView(ZXLExtension)

-(CGFloat)cornerRadius{
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).floatValue;
}

-(void)setCornerRadius:(CGFloat)radius{
    objc_setAssociatedObject(self, @selector(cornerRadius),[NSNumber numberWithFloat:radius], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIRectCorner)roundingCorners {
    id object = objc_getAssociatedObject(self, _cmd);
    if (object) {
        return ((NSNumber *)object).unsignedIntegerValue;
    }
    
    return UIRectCornerAllCorners;
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    objc_setAssociatedObject(self, @selector(roundingCorners), [NSNumber numberWithUnsignedInteger:roundingCorners], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)borderWidth {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).floatValue;
}

- (void)setBorderWidth:(CGFloat)width {
    objc_setAssociatedObject(self, @selector(borderWidth), [NSNumber numberWithFloat:width], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)borderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBorderColor:(UIColor *)color {
    objc_setAssociatedObject(self, @selector(borderColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void)load{
    [[self class] zxlSwizzleMethod:@selector(setImage:) swizzledSelector:@selector(replace_setImage:)];
    [[self class] zxlSwizzleMethod:@selector(sd_setImageWithURL:placeholderImage:options:progress:completed:) swizzledSelector:@selector(replace_sd_setImageWithURL:placeholderImage:options:progress:completed:)];
}
- (void)replace_setImage:(UIImage *)image{
    if (nil == image || [image isKindOfClass:[NSNull class]]) {
        [self replace_setImage:nil];
        return;
    }
    
    if (self.cornerRadius <= 0) {
        [self replace_setImage:image];
        return;
    }
    
    if (@available(iOS 10.0, *)) {//IOS 10以上四个角统一设置直接用最简单的设置方式，经过测试fps 没有太大的影响
        if (UIRectCornerAllCorners == self.roundingCorners) {
            if (self.layer.cornerRadius != self.cornerRadius) {
                self.layer.cornerRadius = self.cornerRadius;
                self.layer.masksToBounds = YES;
            }
            
            if (self.layer.borderColor != self.borderColor.CGColor) {
                self.layer.borderColor = self.borderColor.CGColor;
            }
            
            if (self.layer.borderWidth != self.borderWidth) {
                self.layer.borderWidth = self.borderWidth;
            }
            
            [self replace_setImage:image];
            return;
        }
    }
    
    NSURL *url =  [self sd_imageURL];
    if (nil == url || [url isKindOfClass:[NSNull class]] || url.keyOfCornerRadius.length == 0) {
        //相对于从网络获取图片读取缓存的方式会损耗一点cpu,但是基本可以忽略 。这里延迟处理为了兼容约束布局对于界面展示本地图片没有影响
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self replace_setImage:[self createRoundedRectImage:image]];
        });
    }else{
        
        //检测url 是否请求到图片如果未请求到图片 image 则为默认图片，把默认图片和请求到的图片利用不同的key缓存
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
        UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
        NSString *cacheImageKey = url.keyOfCornerRadius;
        if (!lastPreviousCachedImage) {
            cacheImageKey = [NSString stringWithFormat:@"%@_placeholderImage",url.keyOfCornerRadius];
        }
        
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheImageKey];
        if (cacheImage) {
            [self replace_setImage:cacheImage];
        }else{
            //这里延迟处理为了兼容约束布局对于界面展示本地图片没有影响
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIImage * newImage = [self createRoundedRectImage:image];
                [[SDImageCache sharedImageCache] storeImage:newImage forKey:cacheImageKey toDisk:YES completion:^{
                    [self replace_setImage:newImage];
                }];
            });
        }
    }
    
}

- (void)replace_sd_setImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(SDWebImageOptions)options
                          progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable SDExternalCompletionBlock)completedBlock{
    
    if (nil == url || [url isKindOfClass:[NSNull class]]) {
        [self replace_sd_setImageWithURL:nil placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
    }else {
        if (self.cornerRadius > 0) {
            url.keyOfCornerRadius = [NSString stringWithFormat:@"%@%f%@",kZXLCornerRadiusImagePreString,self.cornerRadius,[url absoluteString]];
        }
        
        [self replace_sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
    }
}



-(UIImage *)createRoundedRectImage:(UIImage*)image {
    //由于绘制圆角的图片一般都是小图这个生成图片大小由屏幕宽度决定
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.roundingCorners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), bezierPath.CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [image drawInRect:self.bounds];
    
    if (0 != self.borderWidth && nil != self.borderColor) {
        [bezierPath setLineWidth:2 * self.borderWidth];
        [self.borderColor setStroke];
        [bezierPath stroke];
    }
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

-(void)tiledImage{
    if (!self) return;
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
}

-(void)addVisualEffect{
    if (!self) return;
    
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.alpha = 0.92f;
    effectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:effectView];

    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:effectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    [self addConstraints:@[leftConstraint,rightConstraint,topConstraint,bottomConstraint]];
}

@end

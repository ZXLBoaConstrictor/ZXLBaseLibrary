//
//  UIImageView+ZXLExtension.m
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/29.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "UIImageView+ZXLExtension.h"

@implementation UIImageView(ZXLExtension)
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

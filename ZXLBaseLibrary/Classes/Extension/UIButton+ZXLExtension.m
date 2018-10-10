//
//  UIButton+ZXLExtension.m
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "UIButton+ZXLExtension.h"
#import <Foundation/Foundation.h>

@implementation UIButton (ZXLExtension)
- (void)layoutButtonWithEdgeInsetsStyle:(ZXLButtonEdgeInsetsStyle)style
                             buttonSize:(CGSize)bsize
                              imageSize:(CGSize)size
                        imageTitleSpace:(CGFloat)space{
    //1.获取图片文字的宽、高
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;
    CGFloat labelwidth = self.titleLabel.intrinsicContentSize.width;
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    size.width = MIN(size.width, bsize.width - 1.0f);
    size.height = MIN(size.height, bsize.height - 1.0f);
    CGFloat fSpace = MAX((bsize.height - labelHeight - space - size.height)/2, 0.5f) ;
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case ZXLButtonEdgeInsetsStyleTop:{
            imageEdgeInsets = UIEdgeInsetsMake(fSpace, (bsize.width - size.width)/2, fSpace + labelHeight + space,  (bsize.width - size.width)/2);
            labelEdgeInsets = UIEdgeInsetsMake(bsize.height - (labelHeight + fSpace), -imageWith, fSpace, 0);
        }
            break;
        case ZXLButtonEdgeInsetsStyleLeft:{
            imageEdgeInsets = UIEdgeInsetsMake((bsize.height - size.height)/2, (bsize.width - size.width - space - labelwidth)/2, (bsize.height - size.height)/2, bsize.width - size.width - (bsize.width - size.width - space - labelwidth)/2);
            labelEdgeInsets = UIEdgeInsetsMake(0, -(imageWith - size.width), 0, 0.5);
        }
            break;
        case ZXLButtonEdgeInsetsStyleBottom:{
            imageEdgeInsets = UIEdgeInsetsMake(fSpace + labelHeight + space, (bsize.width - size.width)/2, fSpace, (bsize.width - size.width)/2);
            labelEdgeInsets = UIEdgeInsetsMake(fSpace, 0, size.height + fSpace + space, 0);
        }
            break;
        case ZXLButtonEdgeInsetsStyleRight:{
            CGFloat fleftSpace = (bsize.width - size.width - space - labelwidth)/2;
            imageEdgeInsets = UIEdgeInsetsMake((bsize.height - size.height)/2,bsize.width - size.width - fleftSpace, (bsize.height - size.height)/2, fleftSpace);
            labelEdgeInsets = UIEdgeInsetsMake(0, -(imageWith + size.width + fSpace), 0, 0);
        }
            break;
        default:
            break;
    }
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}
@end

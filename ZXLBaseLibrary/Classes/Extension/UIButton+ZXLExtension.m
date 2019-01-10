//
//  UIButton+ZXLExtension.m
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "UIButton+ZXLExtension.h"
#import <Foundation/Foundation.h>
#import "NSObject+ZXLExtension.h"

static char * const eventIntervalKey = "eventIntervalKey";
static char * const eventUnavailableKey = "eventUnavailableKey";
@interface UIButton ()
@property (nonatomic, assign) BOOL eventUnavailable;
@end

@implementation UIButton (ZXLExtension)

+ (void)load {
    [[self class] zxlSwizzleMethod:@selector(sendAction:to:forEvent:) swizzledSelector:@selector(extensionSendAction:to:forEvent:)];
    if (!DEBUG_FLAG) {
        [[self class] zxlSwizzleMethod:@selector(setTitle:forState:) swizzledSelector:@selector(replace_setTitle:forState:)];
    }
}


#pragma mark - Action functions
- (void)replace_setTitle:(NSString *)title forState:(UIControlState)state {
    if([title isKindOfClass:[NSNull class]]) {
        [self replace_setTitle:nil forState:state];
    }else {
        [self replace_setTitle:title forState:state];
    }
}

- (void)extensionSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.eventUnavailable == NO) {
        self.eventUnavailable = YES;
        [self extensionSendAction:action to:target forEvent:event];
        [self performSelector:@selector(setEventUnavailable:) withObject:@(NO) afterDelay:MAX(self.eventInterval, 1.0)];
    }
}


#pragma mark - Setter & Getter functions

- (NSTimeInterval)eventInterval {
    return [objc_getAssociatedObject(self, eventIntervalKey) doubleValue];
}

- (void)setEventInterval:(NSTimeInterval)eventInterval {
    objc_setAssociatedObject(self, eventIntervalKey, @(eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)eventUnavailable {
    return [objc_getAssociatedObject(self, eventUnavailableKey) boolValue];
}

- (void)setEventUnavailable:(BOOL)eventUnavailable {
    objc_setAssociatedObject(self, eventUnavailableKey, @(eventUnavailable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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

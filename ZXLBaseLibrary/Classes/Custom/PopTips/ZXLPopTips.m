//
//  ZXLPopTips.m
//  Compass
//
//  Created by 张小龙 on 2018/2/8.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLPopTips.h"
#import "ZXLUIPopTipsViewController.h"
#import "ZXLTipsPopoverBackgroundView.h"
#import <ZXLSettingDefined.h>
#import <ZXLGlobalVariables.h>
#import <ZXLRouter.h>
#import <Masonry/Masonry.h>

CGSize localGetSizeOfString(NSString * string,float width,UIFont* font){
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
    return [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:font} context:nil].size;
}

@implementation ZXLPopTips
+(void)showTipsContent:(NSString *)content with:(CGFloat)contentWidth sender:(id)sender{
    
   CGFloat fContentHeight = localGetSizeOfString(content, contentWidth, [UIFont systemFontOfSize:12.0f]).height + 24*ViewScaleValue;
    
    ZXLUIPopTipsViewController *tipsVC = [[ZXLUIPopTipsViewController alloc] init];
    tipsVC.tipsText = content;
    tipsVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    tipsVC.modalPresentationStyle = UIModalPresentationPopover;
    tipsVC.popoverPresentationController.sourceView = (UIView *)sender;
    
    CGRect sourceRect = ((UIView *)sender).bounds;
    sourceRect.origin.y -= 10*ViewScaleValue;
    tipsVC.popoverPresentationController.sourceRect = sourceRect;
    tipsVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    tipsVC.preferredContentSize = CGSizeMake(contentWidth, fContentHeight);
    tipsVC.popoverPresentationController.delegate = tipsVC;
    tipsVC.popoverPresentationController.popoverBackgroundViewClass = [ZXLTipsPopoverBackgroundView class];
    tipsVC.popoverPresentationController.containerView.layer.cornerRadius = 6*ViewScaleValue;
    tipsVC.view.superview.layer.cornerRadius = 6.0f;
    UINavigationController *navigation = [ZXLRouter getTopUINavigationController:system_UINavigationController];
    [navigation presentViewController:tipsVC animated:YES completion:nil];
}
@end

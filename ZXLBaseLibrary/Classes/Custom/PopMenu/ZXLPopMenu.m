//
//  ZXLPopMenu.m
//  Compass
//
//  Created by 张小龙 on 2017/7/19.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "ZXLPopMenu.h"
#import <ZXLUtilsDefined.h>
#import <ZXLRouter.h>
#import <ZXLSettingDefined.h>
#import <ZXLGlobalVariables.h>
#import "ZXLPopoverBackgroundView.h"
#import "ZXLUIPopMenuViewController.h"

@implementation ZXLPopMenu
+(void)popMenu:(NSArray<ZXLPopMenuSettingModel *>*)ayMenu barButtonItem:(UIBarButtonItem *)barButtonItem select:(void (^)(NSInteger index))select{
    [ZXLPopMenu popMenu:ayMenu barButtonItem:barButtonItem width:156*ViewScaleValue select:select];
}

+(void)popMenu:(NSArray<ZXLPopMenuSettingModel *>*)ayMenu barButtonItem:(UIBarButtonItem *)barButtonItem width:(CGFloat)width select:(void (^)(NSInteger index))select{
    ZXLUIPopMenuViewController * popMenu = ZXLNewObject(ZXLUIPopMenuViewController);
    popMenu.ayMenu = ayMenu;
    popMenu.select = select;
    popMenu.modalPresentationStyle = UIModalPresentationPopover;
    popMenu.view.backgroundColor = [UIColor whiteColor];
    popMenu.popoverPresentationController.barButtonItem = barButtonItem;
    popMenu.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popMenu.preferredContentSize = CGSizeMake(width, ayMenu.count*43*ViewScaleValue);
    popMenu.popoverPresentationController.popoverBackgroundViewClass = [ZXLPopoverBackgroundView class];
    popMenu.popoverPresentationController.delegate = popMenu;
    popMenu.popoverPresentationController.containerView.layer.cornerRadius = 6*ViewScaleValue;
    UINavigationController *navigation = [ZXLRouter getTopUINavigationController:system_UINavigationController];
    [navigation.topViewController presentViewController:popMenu animated:YES completion:nil];
    popMenu.view.superview.layer.cornerRadius = 6.0f;
}
@end

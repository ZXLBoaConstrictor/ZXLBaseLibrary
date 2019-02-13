//
//  ZXLUIPopViewManager.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/2/12.
//

#import "ZXLUIPopViewManager.h"
#import "ZXLUIPopMenuViewController.h"
#import "ZXLUIPopTipsViewController.h"
#import "ZXLUIPopBackgroundView.h"
#import <ZXLSettingDefined.h>
#import <ZXLGlobalVariables.h>
#import <ZXLRouter.h>
#import <Masonry/Masonry.h>

@implementation ZXLUIPopViewManager

+(void)showTipsContent:(NSString *)content
                 width:(CGFloat)contentWidth
             direction:(UIPopoverArrowDirection)arrowDirection
          cornerRadius:(CGFloat)cornerRadius
                sender:(id)sender{
    
    if (!content || content.length == 0 || contentWidth == 0 || !sender) {
        return;
    }
    
    CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(contentWidth - EtalonSpacing*2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size.height + EtalonSpacing*2;
    
    
    ZXLUIPopTipsViewController *tipsVC = [[ZXLUIPopTipsViewController alloc] init];
    tipsVC.tipsText = content;
    tipsVC.modalPresentationStyle = UIModalPresentationPopover;
    tipsVC.popoverPresentationController.sourceView = (UIView *)sender;

    CGRect sourceRect = ((UIView *)sender).bounds;
    sourceRect.origin.y -= 5*ViewScaleValue;//修改整个内容和触发控件位子
    tipsVC.popoverPresentationController.sourceRect = sourceRect;
    tipsVC.popoverPresentationController.permittedArrowDirections = arrowDirection;
    tipsVC.popoverPresentationController.delegate = tipsVC;
    tipsVC.popoverPresentationController.popoverBackgroundViewClass = [ZXLUIPopBackgroundView class];
    //控制提示框大小
    tipsVC.preferredContentSize = CGSizeMake(contentWidth, contentHeight);
    
    UINavigationController *navigation = [ZXLRouter getTopUINavigationController:system_UINavigationController];
    [navigation presentViewController:tipsVC animated:YES completion:nil];
    
    // 改变弹出框圆角.(一定要放在后面写，这里会调用viewDidLoad，如果不清楚可以去苹果官网看一些调用顺序)
    tipsVC.view.layer.cornerRadius = cornerRadius;
    tipsVC.view.layer.masksToBounds = YES;
    
}

+(void)showMenu:(NSArray <ZXLUIPopMenuModel *>*)menu
          width:(CGFloat)contentWidth
     cellHeight:(CGFloat)cellHeight
   cornerRadius:(CGFloat)cornerRadius
  barButtonItem:(UIBarButtonItem *)barButtonItem
       complete:(void (^)(NSInteger index))completeBlock{
    if (!menu || menu.count == 0 || contentWidth <= 0 || cellHeight <= 0 || !barButtonItem) {
        return;
    }
    
    ZXLUIPopMenuViewController * menuVC = [[ZXLUIPopMenuViewController alloc] init];
    menuVC.menu = menu;
    menuVC.select = completeBlock;
    menuVC.cellHeight = cellHeight;
    menuVC.modalPresentationStyle = UIModalPresentationPopover;
    menuVC.popoverPresentationController.barButtonItem = barButtonItem;
    menuVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    menuVC.popoverPresentationController.popoverBackgroundViewClass = [ZXLUIPopBackgroundView class];
    menuVC.popoverPresentationController.delegate = menuVC;
    //menu ContentSize
    menuVC.preferredContentSize = CGSizeMake(contentWidth, menu.count*cellHeight);
    
    UINavigationController *navigation = [ZXLRouter getTopUINavigationController:system_UINavigationController];
    [navigation presentViewController:menuVC animated:YES completion:nil];
    //圆角设置
    menuVC.view.layer.cornerRadius = cornerRadius;
    menuVC.view.layer.masksToBounds = YES;
}
@end

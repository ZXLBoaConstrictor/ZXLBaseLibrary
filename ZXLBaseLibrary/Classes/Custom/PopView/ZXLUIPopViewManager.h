//
//  ZXLUIPopViewManager.h
//  AFNetworking
//
//  Created by 张小龙 on 2019/2/12.
//

#import <Foundation/Foundation.h>
@class ZXLUIPopMenuModel;

@interface ZXLUIPopViewManager : NSObject
/**
 提示框展示
 
 @param content 内容
 @param contentWidth 宽度
 @param arrowDirection 方向 （上、下）
 @param cornerRadius 圆角
 @param sender 触发控件
 */
+(void)showTipsContent:(NSString *)content
                width:(CGFloat)contentWidth
             direction:(UIPopoverArrowDirection)arrowDirection
          cornerRadius:(CGFloat)cornerRadius
                sender:(id)sender;

/**
 menu pop 显示

 @param menu menu模型数组
 @param width 宽度
 @param cellHeight 行高
 @param cornerRadius 圆角
 @param barButtonItem 触发控件UIBarButtonItem
 @param completeBlock 选择结果
 */
+(void)showMenu:(NSArray <ZXLUIPopMenuModel *>*)menu
          width:(CGFloat)contentWidth
     cellHeight:(CGFloat)cellHeight
   cornerRadius:(CGFloat)cornerRadius
  barButtonItem:(UIBarButtonItem *)barButtonItem
       complete:(void (^)(NSInteger index))completeBlock;
@end

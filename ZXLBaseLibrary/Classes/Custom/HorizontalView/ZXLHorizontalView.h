//
//  ZXLHorizontalView.h
//  AFNetworking
//
//  Created by 张小龙 on 2019/1/23.
//

#import <UIKit/UIKit.h>
@class ZXLUITextField;
/**
 自定义横向控件类型
 - ZXLHorizontalViewButton: 按钮点击
 - ZXLHorizontalViewShow: 文本展示
 - ZXLHorizontalViewInPut: 文本输入
 */
typedef NS_ENUM(NSUInteger, ZXLHorizontalViewStyle){
    ZXLHorizontalViewButton,
    ZXLHorizontalViewShow,
    ZXLHorizontalViewInPut
};



@interface ZXLHorizontalView : UIView
@property (nonatomic, readonly)UILabel *leftLabel;//此控件固定存在
@property (nonatomic, readonly)UIButton *button;//当 horizontalViewStyle 为 ZXLHorizontalViewButton时不为nil
@property (nonatomic, readonly)UILabel *showLabel;//当 horizontalViewStyle 为 ZXLHorizontalViewShow时存在nil
@property (nonatomic, readonly) ZXLUITextField   * inputField;//当 horizontalViewStyle 为 ZXLHorizontalViewInPut时不为nil
@property (nonatomic ,readonly) UIView         * dashLine;//当显示底部line时不为nil
@property (nonatomic ,readonly) UIImageView    * leftimageView;//当显示左边icon时不为nil
@property (nonatomic ,readonly) UIImageView    * rightimageView;//当显示右边边icon时不为nil

/*
 构造函数
 */
-(instancetype)initWithStyle:(ZXLHorizontalViewStyle)horizontalViewStyle //horView 类型
                showLeftIcon:(BOOL)showLeftIcon //左边是否展示Icon
              showRinghtIcon:(BOOL)showRinghtIcon //右边是否展示Icon
              showBottomline:(BOOL)showBottomline; //是否展示底部line
@end

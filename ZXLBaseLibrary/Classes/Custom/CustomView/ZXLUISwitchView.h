//
//  ZXLUISwitchView.h
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/6/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXLUISwitchView;

@protocol ZXLUISwitchViewDelegate <NSObject>
@optional
-(void)selectSwitchIndex:(ZXLUISwitchView *)pSwitch;
@end

@interface ZXLUISwitchView : UIView
@property(nonatomic,assign)CGFloat  buttonWidth;//按钮宽度
@property(nonatomic,assign)CGFloat  spaceWidth;//按钮与按钮宽度
@property(nonatomic,assign)BOOL     bBottomLine;//按钮底部有横线
@property(nonatomic,assign)BOOL     adjustsSizeToFitWidth;//按钮宽带自适应
@property(nonatomic,copy)UIColor * textColor; //默认文字颜色
@property(nonatomic,copy)UIColor * selectColor; //选中文字颜色
@property(nonatomic,copy)UIColor * selectbackgroundColor; //选中按钮背景色
@property(nonatomic,copy)UIColor * borderColor; //按钮border 颜色
@property(nonatomic,copy)UIFont   *font; //按钮字体大小
@property(nonatomic,assign)BOOL bhaveRedPoint;//有没有红点显示
@property(nonatomic)       UIEdgeInsets imageEdgeInsets; //按钮上带图片EdgeInsets
@property(nonatomic)       UIEdgeInsets titleEdgeInsets; //titleEdgeInsets

@property(nonatomic,weak)id delegate;
@property(nonatomic,assign)NSInteger selectIndex;//选中索引
@property(nonatomic,assign) NSInteger buttonCount;

-(void)setArrayswitch:(NSMutableArray *)ayswitch;//字典数组 字典内容 title  image  selectimage enabledimage
-(void)setSwitchIndex:(NSInteger)nIndex;
-(void)setRedPointIndex:(NSInteger)nIndex hidden:(BOOL)bhidden;

@end

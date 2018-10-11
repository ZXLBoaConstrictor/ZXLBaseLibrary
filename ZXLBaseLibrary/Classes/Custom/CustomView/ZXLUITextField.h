//
//  ZXLUITextField.h
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/6/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXLUITextField : UITextField
@property(nonatomic,assign)NSInteger fontCount; //字数限制
@property(nonatomic,assign)BOOL bNumber; //全数字
@property(nonatomic,assign)BOOL bShowBottomLine; //是否显示底部线
@property(nonatomic,assign)CGFloat bottomLineHeight; //底部线高度
@property(nonatomic,strong) UIColor  *bottomLineColor;
@property(nonatomic,strong) UIColor  *blfirstResponderColor;//底部为FirstResponder color

- (void)textFieldDidChange:(UITextField *)textField;
@end

//
//  ZXLUITextView.h
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/7/2.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXLUITextView : UITextView

@property (nonatomic, weak)id ZXLDelegate;
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 是否显示清空按钮 */
@property (nonatomic, assign) BOOL showClearButton;
/** 是否限制表情 */
@property (nonatomic, assign) BOOL bEmoji;

/** 字数限制 */
@property (nonatomic, assign)NSInteger fontCount;

@property (nonatomic, assign) BOOL autoChangeHeight;//自动适配高度
@property (nonatomic, assign) CGFloat minChangeHeight ;//自动适配高度的最小高度

-(void)textSizeThatFits;

@end

//
//  ZXLUITextView.m
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/7/2.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLUITextView.h"
#import <ZXLProgramSetting.h>
#import <UIImage+ZXLExtension.h>
#import <NSString+ZXLExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>

#define kClearButtonMargin  16

@interface ZXLUITextView ()
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation ZXLUITextView

#pragma mark -
#pragma mark Initialisation
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.bEmoji = YES;
    self.fontCount = 0;
    self.scrollEnabled = NO;
    self.autoChangeHeight = NO;
    self.minChangeHeight = 0;
    
    // 设置默认字体
    self.font = [UIFont systemFontOfSize:14.0f];
    self.backgroundColor = [UIColor whiteColor];
    // 设置默认颜色
    self.placeholderColor = [ZXLProgramSetting contentColor];
    
    // 删除按钮
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setBackgroundImage:[UIImage ZXLImageNamed:@"icon_delete"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteText) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton.hidden = YES;
    [self addSubview:self.deleteButton];
    
    // 使用通知监听文字 改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    
}


- (void)textSizeThatFits {
    
    if (!_autoChangeHeight) {
        return;
    }
    
    CGRect frame = self.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    frame.size.height =  [self sizeThatFits:constraintSize].height;
    
    if (_minChangeHeight > 0) {
        self.scrollEnabled = (frame.size.height > _minChangeHeight);
        frame.size.height = MIN(_minChangeHeight, frame.size.height);
    }
    
    self.frame = frame;
    
    if (self.ZXLDelegate && [self.ZXLDelegate respondsToSelector:@selector(textSizeThatFits)]) {
        [self.ZXLDelegate textSizeThatFits];
    }
}

- (void)textDidChange:(NSNotification *)note {
    // 会重新调用drawRect:方法
    [self setNeedsDisplay];
    
    [self checkClearButtonState];
    
    
    NSString *toBeString = self.text;
    BOOL isEmoj = NO;
    if (!self.bEmoji) {
        isEmoj = [toBeString stringContainsEmoji];
        toBeString = [toBeString disableEmoji];
    }
    
    if (self.fontCount > 0) {
        
        NSString *lang = self.textInputMode.primaryLanguage; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [self markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position || !selectedRange) {
                if (toBeString.length > _fontCount) {
                    self.text = [toBeString substringToIndex:_fontCount];
                    
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多输入%zd个字！", _fontCount]];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            if (toBeString.length > _fontCount) {
                self.text = [toBeString substringToIndex:_fontCount];
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多输入%zd个字！", _fontCount]];
            }
        }
        
    }
    
    
    if (isEmoj) {
        self.text = toBeString;
    }
    
    if (self.ZXLDelegate && [self.ZXLDelegate respondsToSelector:@selector(textDidChange:)]) {
        [self.ZXLDelegate textDidChange:self];
    }
    
    [self textSizeThatFits];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 每次调用drawRect:方法，都会将以前画的东西清除掉
 */
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    // 如果有文字，就直接返回，不需要画占位文字
    if (self.hasText)
        return;
    
    // 属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    
    // 画文字
    rect.origin.x = 5;
    rect.origin.y = 8;
    rect.size.width -= 2 * rect.origin.x;
    //    rect.size.height = 35;
    [self.placeholder drawInRect:rect withAttributes:attrs];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    // 重新调整contentInset ，系统可能会改top的值
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if (self.showClearButton) {
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, kClearButtonMargin+5);
    }
    
    // 布局删除按钮
    CGRect textFrame = CGRectMake(self.frame.size.width - kClearButtonMargin, (self.frame.size.height - kClearButtonMargin)*0.5, kClearButtonMargin, kClearButtonMargin);
    self.deleteButton.frame = textFrame;
    
    [self checkClearButtonState];
    
    [self setNeedsDisplay];
}

// 关闭键盘
-(void) dismissKeyBoard{
    [self resignFirstResponder];
}

// 检查clearButton按钮的状态
- (void)checkClearButtonState {
    if (self.showClearButton) {
        if ([self.text length] > 0) {
            self.deleteButton.hidden = NO;
        } else {
            self.deleteButton.hidden = YES;
        }
    }
}

#pragma mark -
// 清空
- (void)deleteText {
    self.text = @"";
    [self textSizeThatFits];
    // 如果有实现这个方法会调用
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    
    [self checkClearButtonState];
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}


@end

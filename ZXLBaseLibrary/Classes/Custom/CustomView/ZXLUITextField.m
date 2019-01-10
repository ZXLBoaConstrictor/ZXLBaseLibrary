//
//  ZXLUITextField.m
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/6/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLUITextField.h"
#import <NSString+ZXLExtension.h>
#import <ZXLProgramSetting.h>

@implementation ZXLUITextField

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.bNumber = NO;
        self.fontCount = 0;
        self.font = [UIFont systemFontOfSize:15.0f];
        self.textColor = [UIColor blackColor];
        self.bottomLineColor = [ZXLProgramSetting lineColor];
        self.bShowBottomLine = YES;
        self.bottomLineHeight = 0.25;
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [self addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        
    }
    return self;
}

- (void) drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (!self.bShowBottomLine)
        return;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, self.bottomLineHeight);
    // set to same colour as text
    if (self.isFirstResponder && self.blfirstResponderColor) {
        CGContextSetStrokeColorWithColor(contextRef, self.blfirstResponderColor.CGColor);
    }else{
        CGContextSetStrokeColorWithColor(contextRef, self.bottomLineColor.CGColor);
    }

    CGContextMoveToPoint(contextRef,0  , rect.size.height - self.bottomLineHeight);
    
    CGContextAddLineToPoint(contextRef, rect.size.width , rect.size.height - self.bottomLineHeight);
    
    
    CGContextDrawPath(contextRef, kCGPathStroke);
}

- (void)textFieldDidBegin:(UITextField *)textField {
    [self setNeedsDisplay];
}

- (void)textFieldDidEnd:(UITextField *)textField {
    [self setNeedsDisplay];
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (self.bNumber && ![self validateNumber:textField.text]) {
        
        textField.text = @"";
        return;
    }
    
    if (self.fontCount <= 0) {
        return;
    }
    
    NSString *toBeString = textField.text;
    BOOL isEmoj = [toBeString stringContainsEmoji];
    toBeString = [toBeString disableEmoji];
    
    if (isEmoj) {
        textField.text = toBeString;
    }
    
    NSString *lang = self.textInputMode.primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position || !selectedRange) {
            if (toBeString.length > self.fontCount) {
                textField.text = [toBeString substringToIndex:self.fontCount];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > self.fontCount) {
            textField.text = [toBeString substringToIndex:self.fontCount];
        }
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidChange:)]) {
        [(id)self.delegate textFieldDidChange:textField];
    }
    
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}

@end

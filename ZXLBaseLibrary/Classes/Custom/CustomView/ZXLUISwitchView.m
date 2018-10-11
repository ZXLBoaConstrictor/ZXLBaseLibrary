//
//  ZXLUISwitchView.m
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/6/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLUISwitchView.h"
#import "ZXLUIUnderlinedButton.h"

#import <ZXLUtilsDefined.h>
#import <NSDictionary+ZXLExtension.h>
#import <NSArray+ZXLExtension.h>
#import <ZXLSettingDefined.h>
#import <UIImage+ZXLExtension.h>

#import <Masonry/Masonry.h>


@interface ZXLUISwitchView()
@property(nonatomic,strong)UIScrollView * scrollView;
@end

@implementation ZXLUISwitchView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.selectIndex = -1;
        self.spaceWidth = 0;
        self.buttonCount = 0;
    }
    return self;
}

-(UIScrollView *)scrollView{
    if (!_scrollView){
        _scrollView = ZXLNewObject(UIScrollView);
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _scrollView;
}

-(void)dealloc{
    self.font = nil;
    self.borderColor = nil;
    self.textColor = nil;
    self.selectColor = nil;
    self.delegate = nil;
    self.selectbackgroundColor = nil;
}

-(void)setArrayswitch:(NSMutableArray *)ayswitch{
    self.selectIndex = -1;
    self.buttonCount = ayswitch.count;
    UIView *superView = self;
    //    if (ayswitch.count > 2) {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    superView = self.scrollView;
    //    }
    [superView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat btnWidth = 0;
    CGFloat startX = 0;

    for (NSInteger i = 0;i < ayswitch.count;i++) {
        NSDictionary *pDict = [ayswitch dictionaryAtIndex:i];
        if (ZXLUtilsISDictionaryValid(pDict)) {
            
            startX += btnWidth;
            if (self.adjustsSizeToFitWidth) {
                NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
                btnWidth = self.spaceWidth + [[pDict stringValueForKey:@"title"] boundingRectWithSize:CGSizeMake(MAXFLOAT, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:self.font} context:nil].size.width;
            }else{
                btnWidth = self.spaceWidth + self.buttonWidth;
            }
            
            UIButton *button = [self creatButton:pDict index:i superView:superView];
            if (button) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.height.equalTo(superView);
                    make.width.equalTo(@(btnWidth));
                    make.left.equalTo(@(startX));
                    if ([superView isKindOfClass:[UIScrollView class]]) {
                        if (ayswitch.count - 1 == i) {
                            make.right.equalTo(superView);
                        }
                    }
                }];
            }
            
            if (_bhaveRedPoint) {
                UIView *redPointView = (UIView *)[superView viewWithTag:0x20000 + i];
                if (redPointView == nil) {
                    redPointView = ZXLNewObject(UIView);
                    redPointView.backgroundColor = [UIColor redColor];
                    redPointView.layer.cornerRadius = 4*ViewScaleValue;
                    redPointView.layer.masksToBounds = YES;
                    redPointView.tag = 0x20000 + i;
                    [superView addSubview:redPointView];
                    [redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.height.equalTo(@(8*ViewScaleValue));
                        make.top.equalTo(@(5*ViewScaleValue));
                        make.right.equalTo(button).offset(-5*ViewScaleValue);
                    }];
                    redPointView.hidden = YES;
                }
            }
        }
    }
}

-(void)onButton:(id)sender{
    if (!((UIButton *)sender).selected){
        
        UIView *superView = self;
        //        if (self.buttonCount > 2) {
        superView = self.scrollView;
        //        }
        
        UIButton * btn = (UIButton *)[superView viewWithTag:0x11000 + self.selectIndex];
        if (btn){
            btn.selected = NO;
        }
        ((UIButton *)sender).selected = YES;
        self.selectIndex = ((UIButton *)sender).tag - 0x11000;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectSwitchIndex:)]){
        [self.delegate selectSwitchIndex:self];
    }
}


-(void)setSwitchIndex:(NSInteger)nIndex{
    if (self.selectIndex == nIndex)
        return;
    
    UIView *superView = self;
    //    if (self.buttonCount > 2) {
    superView = self.scrollView;
    //    }
    
    if (self.selectIndex >= 0){
        UIButton * btn = (UIButton *)[superView viewWithTag:0x11000 + self.selectIndex];
        if (btn){
            btn.selected = NO;
        }
    }
    
    self.selectIndex = nIndex;
    UIButton * btn = (UIButton *)[superView viewWithTag:0x11000 + nIndex];
    if (btn){
        btn.selected = YES;
    }
    
    if ([superView isKindOfClass:[UIScrollView class]]) {
        CGFloat fOffsetX = [self buttonCoordinate:self.selectIndex];
        if (fOffsetX > _scrollView.contentOffset.x + self.frame.size.width){
            [_scrollView setContentOffset:CGPointMake(MAX(0, fOffsetX - UIScreenFrameWidth/2), 0) animated:YES];
        }
        
        if (fOffsetX < _scrollView.contentOffset.x){
            [_scrollView setContentOffset:CGPointMake(MAX(0, _scrollView.contentOffset.x - UIScreenFrameWidth/2), 0) animated:YES];
        }
    }
}



-(CGFloat)buttonCoordinate:(NSInteger)index{
    if (self.adjustsSizeToFitWidth) {
        
        UIView *superView = self;
        //        if (self.buttonCount > 2) {
        superView = self.scrollView;
        //        }
        
        CGFloat fCoordinate = 0;
        for (NSInteger i = 0; i< index; i++) {
            UIButton * button = (UIButton *)[superView viewWithTag:0x11000 + i];
            if (button) {
                NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
                fCoordinate += self.spaceWidth + [button.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:self.font} context:nil].size.width;
            }
        }
        return fCoordinate;
    }else{
        return (self.selectIndex + 1) * self.buttonWidth;
    }
    return 0;
}

-(void)setRedPointIndex:(NSInteger)nIndex hidden:(BOOL)bhidden{
    
    UIView *superView = self;
    //    if (self.buttonCount > 2) {
    superView = self.scrollView;
    //    }
    
    UIView * redPoint = (UIView *)[superView viewWithTag:0x20000 + nIndex];
    if (redPoint){
        redPoint.hidden = bhidden;
    }
}


-(UIButton *)creatButton:(NSDictionary *)infoDict
                   index:(NSInteger)index
               superView:(UIView *)superView{
    
    UIButton * button = (UIButton *)[superView viewWithTag:0x11000 + index];
    if (button == nil) {
        button = (self.bBottomLine ? [ZXLUIUnderlinedButton buttonWithType:UIButtonTypeCustom] : [UIButton buttonWithType:UIButtonTypeCustom]);
        [button setTitle:[infoDict stringValueForKey:@"title"] forState:UIControlStateNormal];
        [button setTitleColor:self.textColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        button.titleLabel.font = self.font;
        button.imageEdgeInsets = self.imageEdgeInsets;
        button.titleEdgeInsets = self.titleEdgeInsets;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 0x11000 + index;
        [superView addSubview:button];
        
        if (self.bBottomLine){
            ((ZXLUIUnderlinedButton *)button).lineColor = self.selectColor;
        }
        
        if (ZXLUtilsISNSStringValid([infoDict stringValueForKey:@"image"]) && ZXLUtilsISNSStringValid([infoDict stringValueForKey:@"selectimage"])){
            [button setImage:[UIImage ZXLImageNamed:[infoDict stringValueForKey:@"image"]] forState:UIControlStateNormal];
            [button setImage:[UIImage ZXLImageNamed:[infoDict stringValueForKey:@"selectimage"]] forState:UIControlStateSelected];
        }else{
            if (ZXLUtilsISNSStringValid([infoDict stringValueForKey:@"selectimage"])){
                [button setImage:[UIImage ZXLImageNamed:[infoDict stringValueForKey:@"selectimage"]] forState:UIControlStateNormal];
            }
        }
        
        if (self.selectbackgroundColor){
            [button setBackgroundImage:[UIImage createImageWithColor:self.selectbackgroundColor] forState:UIControlStateSelected];
        }
        
        if (self.borderColor){
            button.layer.borderColor = self.borderColor.CGColor;
            button.layer.borderWidth = 0.5f;
        }
    }
    
    return button;
}
@end

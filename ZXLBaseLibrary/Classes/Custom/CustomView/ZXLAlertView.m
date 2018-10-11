//
//  ZXLAlertView.m
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/7/3.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLAlertView.h"
#import <Masonry/Masonry.h>
#import <ZXLUtilsDefined.h>
#import <ZXLSettingDefined.h>
#import <ZXLProgramSetting.h>
#import <UIImage+ZXLExtension.h>

@interface ZXLAlertView()
@property(nonatomic,strong)UIView * effectView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic,strong)UIButton * closeBtn;
@property(nonatomic,strong)UIButton * confirmBtn;
@property(nonatomic,strong)UIView * lineView;
@end


ZXLAlertView * systemAlertView;

@implementation ZXLAlertView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
        
        if (_effectView == nil) {
            _effectView = ZXLNewObject(UIView);
            _effectView.backgroundColor = [UIColor whiteColor];
            _effectView.layer.cornerRadius = 12*ViewScaleValue;
            _effectView.layer.masksToBounds = YES;
            _effectView.clipsToBounds = YES;
            [self addSubview:_effectView];
            [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(34*ViewScaleValue));
                make.right.equalTo(self).offset(-34*ViewScaleValue);
                make.height.equalTo(@(150*ViewScaleValue));
                make.centerY.equalTo(self);
            }];
        }
        
        if (_titleLabel == nil) {
            _titleLabel = ZXLNewObject(UILabel);
            _titleLabel.textColor = [UIColor blackColor];
            _titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.adjustsFontSizeToFitWidth = YES;
            [_effectView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(EtalonSpacing));
                make.right.equalTo(self->_effectView.mas_right).offset(-EtalonSpacing);
                make.top.equalTo(@(20*ViewScaleValue));
                make.height.equalTo(@(22*ViewScaleValue));
            }];
        }
        
        if (_contentLabel == nil) {
            _contentLabel = ZXLNewObject(UILabel);
            _contentLabel.textColor = [ZXLProgramSetting tipsBlackColor];
            _contentLabel.font = [UIFont systemFontOfSize:13.0f];
            _contentLabel.textAlignment = NSTextAlignmentCenter;
            _contentLabel.numberOfLines = 0;
            [_effectView addSubview:_contentLabel];
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self->_titleLabel);
                make.top.equalTo(self->_titleLabel.mas_bottom).offset(20*ViewScaleValue);
                make.bottom.equalTo(self->_effectView).offset(- 66*ViewScaleValue);
            }];
        }
        
        if (_confirmBtn == nil) {
            _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _confirmBtn.backgroundColor = [UIColor whiteColor];
            [_confirmBtn setTitleColor:[ZXLProgramSetting mainColor] forState:UIControlStateNormal];
            _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            [_confirmBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            [_effectView addSubview:_confirmBtn];
            [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self->_effectView);
                make.height.equalTo(@(46*ViewScaleValue));
            }];
        }
        
        if (_closeBtn == nil) {
            _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_closeBtn setImage:[UIImage ZXLImageNamed:@"ZXLAlertClose.png"] forState:UIControlStateNormal];
            [_closeBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            [_effectView addSubview:_closeBtn];
            [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(EtalonSpacing));
                make.right.equalTo(self->_effectView).offset(-EtalonSpacing);
                make.width.height.equalTo(@(32*ViewScaleValue));
            }];
            
            _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(10*ViewScaleValue, 10*ViewScaleValue, 10*ViewScaleValue, 10*ViewScaleValue);
        }
        
        if (_lineView == nil) {
            _lineView = ZXLNewObject(UIView);
            _lineView.backgroundColor = [ZXLProgramSetting lineColor];
            [_effectView addSubview:_lineView];
            [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self->_effectView);
                make.height.equalTo(@(0.5*ViewScaleValue));
                make.top.equalTo(self->_confirmBtn.mas_top);
            }];
        }
    }
    return self;
}

-(void)dealloc{
    self.block = nil;
}

-(void)onButton:(id)sender{
    if (sender == _confirmBtn) {
        self.block();
        [self removeFromSuperview];
        systemAlertView = nil;
    }
    
    if (sender == _closeBtn) {
        [self removeFromSuperview];
        systemAlertView = nil;
    }
}

-(void)setAlertView:(NSString *)title content:(NSString *)content button:(NSString *)button{
    _titleLabel.text = title;
    _contentLabel.text = content;
    [_confirmBtn setTitle:button forState:UIControlStateNormal];
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
    __block CGFloat fhight = [content boundingRectWithSize:CGSizeMake(UIScreenFrameWidth - 34*2*ViewScaleValue - EtalonSpacing*2, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil].size.height - [UIFont systemFontOfSize:13.0f].lineHeight;
    
    [_effectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(150*ViewScaleValue + fhight));
    }];
}

+(void)showAlertView:(NSString *)title content:(NSString *)content button:(NSString *)button finish:(completed)finish{
    if (systemAlertView == nil) {
        systemAlertView = ZXLNewObject(ZXLAlertView);
        systemAlertView.frame =[[UIApplication sharedApplication] delegate].window.bounds;
        [[[UIApplication sharedApplication] delegate].window addSubview:systemAlertView];
    }
    
    systemAlertView.block = finish;
    [systemAlertView setAlertView:title content:content button:button];
}

@end

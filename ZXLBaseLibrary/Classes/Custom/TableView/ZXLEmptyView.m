//
//  ZXLEmptyView.m
//  Compass
//
//  Created by 张小龙 on 2017/5/15.
//  Copyright © 2017年 张小龙. All rights reserved.
//

#import "ZXLEmptyView.h"
#import <ZXLSettingDefined.h>
#import <ZXLProgramSetting.h>
#import <ZXLUtilsDefined.h>
#import <Masonry/Masonry.h>
@interface ZXLEmptyView()
@property(nonatomic,strong)UILabel     *contentLabel;
@end

@implementation ZXLEmptyView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        if (_contentLabel == nil) {
            _contentLabel = ZXLNewObject(UILabel);
            _contentLabel.font = [UIFont systemFontOfSize:14.0f];
            _contentLabel.textColor = [ZXLProgramSetting contentColor];
            _contentLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_contentLabel];
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(@(200*ViewScaleValue));
                make.height.equalTo(@(20*ViewScaleValue));
            }];
        }
        
    }
    
    return self;
}

-(void)setContent:(NSString *)content
{
    _contentLabel.text = content;
}

@end

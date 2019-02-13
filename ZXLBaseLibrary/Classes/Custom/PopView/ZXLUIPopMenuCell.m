//
//  ZXLUIPopMenuCell.m
//  Compass
//
//  Created by 张小龙 on 2017/7/19.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "ZXLUIPopMenuCell.h"
#import "ZXLUIPopMenuModel.h"
#import <ZXLSettingDefined.h>
#import <UIImage+ZXLExtension.h>
#import <Masonry/Masonry.h>

@interface ZXLUIPopMenuCell()
@property(nonatomic,strong) UIImageView                 * iconView;
@property(nonatomic,strong) UILabel                     * titleLabel;
@property(nonatomic,strong) UIView                     * lineView;
@end
@implementation ZXLUIPopMenuCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setUpUI];
    }
    return self;
}

//cell UI creat
-(void)setUpUI{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        [self addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(20*ViewScaleValue));
            make.centerY.equalTo(self);
            make.left.equalTo(@(26*ViewScaleValue));
        }];
    }
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(46*ViewScaleValue));
            make.height.equalTo(self->_iconView);
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-EtalonSpacing);
        }];
    }
    
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1*ViewScaleValue));
            make.left.equalTo(@(EtalonSpacing));
            make.right.equalTo(self.mas_right).offset(-EtalonSpacing);
            make.bottom.equalTo(self.mas_bottom).offset(-1*ViewScaleValue);
        }];
    }
}

//cell set data
-(void)setCellData:(id)data line:(BOOL)hidden{
    if (data && [data isKindOfClass:[ZXLUIPopMenuModel class]]) {
        ZXLUIPopMenuModel *model = (ZXLUIPopMenuModel *)data;
        if (model.icon && model.icon.length > 0) {
           [_iconView setImage:[UIImage ZXLImageNamed:model.icon]];
            
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self->_iconView.mas_right).offset(20*ViewScaleValue);
            }];
        }else{
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(EtalonSpacing));
            }];
        }
        
        if (model.textAlignment > 0) {
            _titleLabel.textAlignment = model.textAlignment;
        }
        
        _titleLabel.text = model.title;
        if (model.textColor) {
          _titleLabel.textColor = model.textColor;
        }
        
        if (model.font) {
            _titleLabel.font = model.font;
        }
        
        _lineView.hidden = hidden;
    }
}

@end

//
//  ZXLUITableViewCell.m
//  Compass
//
//  Created by 张小龙 on 2017/4/7.
//  Copyright © 2017年 张小龙. All rights reserved.
//

#import "ZXLUITableViewCell.h"

@implementation ZXLUITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setUpUI];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

-(void)setUpUI{
    
}

-(void)setCellData:(id)data line:(BOOL)bhidden{
    
}

-(void)onButton:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onButtonCellView:Type:)]) {
        [self.delegate onButtonCellView:self Type:((UIButton *)sender).tag - ZXLUITableViewCellBtnTag];
    }
}

-(void)touchCustViewTag:(NSInteger)nTag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onButtonCellView:Type:)]) {
        [self.delegate onButtonCellView:self Type:nTag - ZXLUITableViewCellBtnTag];
    }
}

@end


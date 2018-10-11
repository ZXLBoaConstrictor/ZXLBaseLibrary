//
//  ZXLVisualEffectImageView.m
//  Compass
//
//  Created by 张小龙 on 2017/7/8.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "ZXLVisualEffectImageView.h"
#import <Masonry.h>
@interface ZXLVisualEffectImageView()
@property(nonatomic,strong)UIVisualEffectView * effectView;
@end

@implementation ZXLVisualEffectImageView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        if (_effectView == nil){
            _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            _effectView.alpha = 0.92f;
            [self addSubview:_effectView];
            [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }
    return self;
}

@end

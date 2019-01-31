//
//  ZXLHorizontalView.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/1/23.
//

#import "ZXLHorizontalView.h"
@interface ZXLHorizontalView ()
@property (nonatomic,assign) ZXLHorizontalViewStyle  horStyle;
@property (nonatomic,assign) CGFloat  uiDistance;//默认控件间距为12 像素可调整
@end

@implementation ZXLHorizontalView

-(instancetype)initWithStyle:(ZXLHorizontalViewStyle)horizontalViewStyle //horView 类型
                showLeftIcon:(BOOL)showLeftIcon //左边是否展示Icon
              showRinghtIcon:(BOOL)showRinghtIcon //右边是否展示Icon
              showBottomline:(BOOL)showBottomline{ //是否展示底部line
    if (self = [super init]) {
        self.horStyle = horizontalViewStyle;
        self.uiDistance = 12;
        
    }
    return self;
}

@end

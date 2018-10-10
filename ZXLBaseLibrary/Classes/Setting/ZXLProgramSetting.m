//
//  ZXLProgramSetting.m
//  Compass
//
//  Created by 张小龙 on 2018/1/4.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLProgramSetting.h"
#import "UIColor+ZXLExtension.h"

@interface ZXLProgramSetting()
@property(nonatomic, strong) UIColor *mainColor;                 // #FFA42F
@end

@implementation ZXLProgramSetting
+(instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLProgramSetting* manager = nil;
    dispatch_once(&pred, ^{
        manager = [[ZXLProgramSetting alloc] init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        self.mainColor = [UIColor colorWithHexString:@"#FFA42F"];
    }
    return self;
}

+(UIColor *)mainColor{
    return [ZXLProgramSetting manager].mainColor;
}
@end

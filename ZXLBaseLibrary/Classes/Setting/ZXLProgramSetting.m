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
@property(nonatomic, strong) UIColor *backgroundColor;           // #F2F2F4
@property(nonatomic, strong) UIColor *blackColor;                // #181819
@property(nonatomic, strong) UIColor *somberBlackColor;          // #3E3E41
@property(nonatomic, strong) UIColor *tipsBlackColor;            // #515154
@property(nonatomic, strong) UIColor *contentColor;              // #8E8E93
@property(nonatomic, strong) UIColor *helpBlackColor;            // #A1A1AA
@property(nonatomic, strong) UIColor *placeholderColor;         // #B5B5BC
@property(nonatomic, strong) UIColor *enabledColor;             // #BFBFC5
@property(nonatomic, strong) UIColor *lineColor;                // #ECECEC
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
        self.blackColor = [UIColor colorWithHexString:@"#181819"];
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F4"];
        self.somberBlackColor = [UIColor colorWithHexString:@"#3E3E41"];
        self.tipsBlackColor = [UIColor colorWithHexString:@"#515154"];
        self.contentColor = [UIColor colorWithHexString:@"#8E8E93"];
        self.helpBlackColor = [UIColor colorWithHexString:@"#A1A1AA"];
        self.placeholderColor = [UIColor colorWithHexString:@"#B5B5BC"];
        self.enabledColor = [UIColor colorWithHexString:@"#BFBFC5"];
        self.lineColor = [UIColor colorWithHexString:@"#ECECEC"];
    }
    return self;
}

+(UIColor *)mainColor{
    return [ZXLProgramSetting manager].mainColor;
}

+(UIColor *)backgroundColor{
    return [ZXLProgramSetting manager].backgroundColor;
}

+(UIColor *)blackColor{
    return [ZXLProgramSetting manager].blackColor;
}

+(UIColor *)somberBlackColor{
    return [ZXLProgramSetting manager].somberBlackColor;
}

+(UIColor *)tipsBlackColor{
    return [ZXLProgramSetting manager].tipsBlackColor;
}

+(UIColor *)contentColor{
    return [ZXLProgramSetting manager].contentColor;
}

+(UIColor *)helpBlackColor{
    return [ZXLProgramSetting manager].helpBlackColor;
}

+(UIColor *)placeholderColor{
    return [ZXLProgramSetting manager].placeholderColor;
}

+(UIColor *)enabledColor{
    return [ZXLProgramSetting manager].enabledColor;
}

+(UIColor *)lineColor{
    return [ZXLProgramSetting manager].lineColor;
}
@end

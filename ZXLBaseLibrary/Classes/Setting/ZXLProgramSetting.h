//
//  ZXLProgramSetting.h
//  Compass
//
//  Created by 张小龙 on 2018/1/4.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZXLProgramSetting : NSObject

/**
 #FFA42F
 */
@property(class, nonatomic, readonly) UIColor *mainColor;           // #FFA42F

+(instancetype)manager;

@end

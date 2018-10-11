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

/**
 #F2F2F4
 */
@property(class, nonatomic, readonly) UIColor *backgroundColor;     // #F2F2F4

/**
 #181819
 */
@property(class, nonatomic, readonly) UIColor *blackColor;          // #181819

/**
 // #3E3E41
 */
@property(class, nonatomic, readonly) UIColor *somberBlackColor;    // #3E3E41

/**
 #515154
 */
@property(class, nonatomic, readonly) UIColor *tipsBlackColor;      // #515154

/**
 #8E8E93
 */
@property(class, nonatomic, readonly) UIColor *contentColor;        // #8E8E93

/**
 #A1A1AA
 */
@property(class, nonatomic, readonly) UIColor *helpBlackColor;      // #A1A1AA

/**
 #B5B5BC
 */
@property(class, nonatomic, readonly) UIColor *placeholderColor;    // #B5B5BC

/**
 #B5B5BC
 */
@property(class, nonatomic, readonly) UIColor *enabledColor;        // #B5B5BC

/**
 #ECECEC
 */
@property(class, nonatomic, readonly) UIColor *lineColor;           // #ECECEC
+(instancetype)manager;
@end

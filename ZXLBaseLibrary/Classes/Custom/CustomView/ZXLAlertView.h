//
//  ZXLAlertView.h
//  ZXLCustomUIModule
//
//  Created by 张小龙 on 2018/7/3.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^completed)(void);

@interface ZXLAlertView : UIView

@property (nonatomic,copy)completed block;

+(void)showAlertView:(NSString *)title content:(NSString *)content button:(NSString *)button finish:(completed)finish;

@end

//
//  ZXLUIPopMenuModel.h
//  Compass
//
//  Created by 张小龙 on 2017/7/22.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZXLUIPopMenuModel : NSObject
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIFont *font;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic) NSTextAlignment    textAlignment;
@end

//
//  ZXLPopMenu.h
//  Compass
//
//  Created by 张小龙 on 2017/7/19.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXLPopMenuSettingModel.h"
@interface ZXLPopMenu : NSObject
+(void)popMenu:(NSArray<ZXLPopMenuSettingModel *>*)ayMenu barButtonItem:(UIBarButtonItem *)barButtonItem select:(void (^)(NSInteger index))select;

+(void)popMenu:(NSArray<ZXLPopMenuSettingModel *>*)ayMenu barButtonItem:(UIBarButtonItem *)barButtonItem width:(CGFloat)width select:(void (^)(NSInteger index))select;
@end

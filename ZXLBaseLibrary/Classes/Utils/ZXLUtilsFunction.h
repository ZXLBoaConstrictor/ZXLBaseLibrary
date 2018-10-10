//
//  ZXLUtilsFunction.h
//  ZXLUtils
//  经常用到的代码处理 组成好用的函数
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXLUtilsFunction : NSObject

/**
 NSUserDefaults 的增 、删、查
 */
+(id)userDefaultsObjectForKey:(NSString *)key;
+(void)userDefaultsSetObject:(id)object forKey:(NSString *)key;
+(void)userDefaultsRemoveObjectForKey:(NSString *)key;
@end

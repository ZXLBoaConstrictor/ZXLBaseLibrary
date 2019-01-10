//
//  NSObject+ZXLExtension.h
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXLExtensionLog.h"
#import <objc/runtime.h>
@interface NSObject (ZXLExtension)
- (id)zxlPerformSelector:(NSString *)aSelectorName;
- (id)zxlPerformSelector:(NSString *)aSelectorName withObject:(id)object;
- (id)zxlPerformSelector:(NSString *)aSelectorName withObject:(id)object1 withObject:(id)object2;
- (BOOL)zxlObserverKeyPath:(NSString *)key;

/**
 IMP 函数交换通用处理
 @param originalSelector 原函数
 @param swizzledSelector 交换函数
 */
+ (void)zxlSwizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

+ (void)zxlSwizzleClassMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
@end

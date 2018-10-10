//
//  NSObject+ZXLExtension.m
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "NSObject+ZXLExtension.h"
#import <objc/runtime.h>
@implementation NSObject (ZXLExtension)
- (id)ZXLPerformSelector:(NSString *)aSelectorName{
    if (aSelectorName == nil || [aSelectorName length] < 1) return nil;
    
    SEL sel = NSSelectorFromString(aSelectorName);
    if(sel && ([self respondsToSelector:sel])){
        IMP imp = [self methodForSelector:sel];
        id (*func)(id, SEL) = (void *)imp;
        return func(self, sel);
    }
    return nil;
}

- (id)ZXLPerformSelector:(NSString *)aSelectorName withObject:(id)object{
    if (aSelectorName == nil || [aSelectorName length] < 1) return nil;
    
    SEL sel = NSSelectorFromString(aSelectorName);
    if(sel && ([self respondsToSelector:sel])){
        IMP imp = [self methodForSelector:sel];
        id (*func)(id, SEL,id aObject) = (void *)imp;
        return func(self, sel,object);
    }
    return nil;
}

- (id)ZXLPerformSelector:(NSString *)aSelectorName withObject:(id)object1 withObject:(id)object2{
    if (aSelectorName == nil || [aSelectorName length] < 1) return nil;
    
    SEL sel = NSSelectorFromString(aSelectorName);
    if(sel && ([self respondsToSelector:sel])){
        IMP imp = [self methodForSelector:sel];
        id (*func)(id, SEL,id aObject,id bObject) = (void *)imp;
        return func(self, sel,object1,object2);
    }
    return nil;
}

- (BOOL)ZXLObserverKeyPath:(NSString *)key{
    if (key == nil || [key length] < 1) return NO;
    
    id info = self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath]) {
            return YES;
        }
    }
    return NO;
}

//IMP 交换
+ (void)ZXLSwizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector{
    
    if (!originalSelector || !swizzledSelector) return;
    
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class,originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,swizzledSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end

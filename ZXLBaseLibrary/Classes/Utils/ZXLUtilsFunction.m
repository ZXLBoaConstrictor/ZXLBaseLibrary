//
//  ZXLUtilsFunction.m
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLUtilsFunction.h"
#import "ZXLUtilsDefined.h"
@implementation ZXLUtilsFunction

+(id)userDefaultsObjectForKey:(NSString *)key{
    if (ZXLUtilsISNSStringValid(key)){
        return  [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil;
}

+(void)userDefaultsSetObject:(id)object forKey:(NSString *)key{
    if (ZXLUtilsISNSStringValid(key) && object){
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(void)userDefaultsRemoveObjectForKey:(NSString *)key{
    if (ZXLUtilsISNSStringValid(key)){
        [[NSUserDefaults standardUserDefaults]  removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end

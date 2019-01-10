//
//  NSUserDefaults+ZXLExtension.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/1/10.
//

#import "NSUserDefaults+ZXLExtension.h"
#import "NSObject+ZXLExtension.h"

@implementation NSUserDefaults(ZXLExtension)
+ (void)load {
    if (!DEBUG_FLAG) {
        [[self class] zxlSwizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(replace_setObject:forKey:)];
    }
}

- (void)replace_setObject:(id)value forKey:(NSString *)defaultName {
    if ([defaultName isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([value isKindOfClass:[NSNull class]]) {
        [self replace_setObject:nil forKey:defaultName];
    }else {
        [self replace_setObject:value forKey:defaultName];
    }
}
@end

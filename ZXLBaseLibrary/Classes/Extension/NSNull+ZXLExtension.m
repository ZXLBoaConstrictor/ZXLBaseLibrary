//
//  NSNull+ZXLExtension.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/1/10.
//

#import "NSNull+ZXLExtension.h"
#import "NSObject+ZXLExtension.h"

@implementation NSNull (ZXLExtension)
+ (void)load {
    if (!DEBUG_FLAG) {
        [objc_getClass("NSNull") zxlSwizzleMethod:@selector(length) swizzledSelector:@selector(replace_length)];
    }
}

- (NSInteger)replace_length {
    return 0;
}
@end

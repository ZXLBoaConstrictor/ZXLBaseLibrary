//
//  NSMutableString+ZXLExtension.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/1/10.
//

#import "NSMutableString+ZXLExtension.h"
#import "NSObject+ZXLExtension.h"

@implementation NSMutableString (ZXLExtension)
+ (void)load {
    if (!DEBUG_FLAG) {
        [objc_getClass("__NSCFString") zxlSwizzleMethod:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(replace_replaceCharactersInRange:withString:)];
        [objc_getClass("__NSCFString") zxlSwizzleMethod:@selector(objectForKeyedSubscript:) swizzledSelector:@selector(replace_objectForKeyedSubscript:)];
    }
}

- (void)replace_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if ((range.location + range.length) > self.length) {
        ZXLLog(@"error: Range or index out of bounds");
    }else {
        [self replace_replaceCharactersInRange:range withString:aString];
    }
}

- (id)replace_objectForKeyedSubscript:(NSString *)key {
    return nil;
}
@end

//
//  NSMutableAttributedString+ZXLExtension.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/1/10.
//

#import "NSMutableAttributedString+ZXLExtension.h"
#import "NSObject+ZXLExtension.h"

@implementation NSMutableAttributedString (ZXLExtension)
+ (void)load {
    if (!DEBUG_FLAG) {
        [objc_getClass("NSConcreteMutableAttributedString") zxlSwizzleMethod:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(replace_replaceCharactersInRange:withString:)];
    }
}

- (void)replace_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if ((range.location + range.length) > self.length) {
        ZXLLog(@"error: Range or index out of bounds");
    }else {
        [self replace_replaceCharactersInRange:range withString:aString];
    }
}
@end

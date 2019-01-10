//
//  UILabel+ZXLExtension.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/1/10.
//

#import "UILabel+ZXLExtension.h"
#import "NSObject+ZXLExtension.h"

@implementation UILabel(ZXLExtension)
+ (void)load {
    if (!DEBUG_FLAG) {
        [[self class] zxlSwizzleMethod:@selector(setText:) swizzledSelector:@selector(replace_setText:)];
    }
}

- (void)replace_setText:(NSString *)text {
    if ([text isKindOfClass:[NSNull class]]) {
        [self replace_setText:nil];
    }else {
        [self replace_setText:text];
    }
}
@end

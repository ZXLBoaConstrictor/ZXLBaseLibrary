//
//  UITextField+ZXLExtension.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/1/10.
//

#import "UITextField+ZXLExtension.h"
#import "NSObject+ZXLExtension.h"

@implementation UITextField(ZXLExtension)
+ (void)load {
    if (!DEBUG_FLAG) {
        [self zxlSwizzleMethod:@selector(setText:) swizzledSelector:@selector(replace_setText:)];
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

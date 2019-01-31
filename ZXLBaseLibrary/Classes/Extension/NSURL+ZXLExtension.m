//
//  NSURL+ZXLExtension.m
//  AFNetworking
//
//  Created by 张小龙 on 2019/1/29.
//

#import "NSURL+ZXLExtension.h"
#import <objc/runtime.h>

const void * kCornerRadiusKey = &kCornerRadiusKey;

@implementation NSURL (ZXLExtension)

-(void)setKeyOfCornerRadius:(NSString*)key{
    objc_setAssociatedObject(self, &kCornerRadiusKey,key, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString*)keyOfCornerRadius{
    return objc_getAssociatedObject(self, &kCornerRadiusKey);
}

@end

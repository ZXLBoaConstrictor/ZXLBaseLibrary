//
//  ZXLResourceAddress.m
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLResourceAddress.h"

@implementation ZXLResourceAddress
+(instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLResourceAddress * resourceAddress = nil;
    dispatch_once(&pred, ^{
        resourceAddress = [[ZXLResourceAddress alloc] init];
    });
    return resourceAddress;
}

@end

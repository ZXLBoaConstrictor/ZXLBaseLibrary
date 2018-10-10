//
//  ZXLExtensionResource.m
//  AFNetworking
//
//  Created by 张小龙 on 2018/6/22.
//

#import "ZXLExtensionResource.h"

@implementation ZXLExtensionResource
+(instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLExtensionResource * resourceAddress = nil;
    dispatch_once(&pred, ^{
        resourceAddress = [[ZXLExtensionResource alloc] init];
    });
    return resourceAddress;
}

@end

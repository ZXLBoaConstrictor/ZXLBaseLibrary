//
//  ZXLServerAddress.m
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/3.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLServerAddress.h"
#import "ZXLUtilsDefined.h"
#import "ZXLUtilsFunction.h"
@interface ZXLServerAddress()
@property (nonatomic,strong) NSArray *companyHost;
@end

@implementation ZXLServerAddress
+(instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLServerAddress * serverAddress = nil;
    dispatch_once(&pred, ^{
        serverAddress = [[ZXLServerAddress alloc] init];
        NSString * strReleaseType = [ZXLUtilsFunction userDefaultsObjectForKey:ZXLServerAddressReleaseType];
        //DEBUG环境默认是开发地址 ，release环境默认是正式地址。如果用到改地址的工具写入特殊环境类型才会变动
#ifdef DEBUG
        serverAddress.releaseType = ZXLReleaseDevelopmentType;
        if ([strReleaseType integerValue] == 1) {
            serverAddress.releaseType = ZXLReleaseProductionType;
        }
        if ([strReleaseType integerValue] == 2) {
            serverAddress.releaseType = ZXLReleasePreProductionType;
        }
#else
        serverAddress.releaseType = ZXLReleaseProductionType;
        if ([strReleaseType integerValue] == 2) {
            serverAddress.releaseType = ZXLReleasePreProductionType;
        }
        if ([strReleaseType integerValue] == 3) {
            serverAddress.releaseType = ZXLReleaseDevelopmentType;
        }
#endif
    });
    return serverAddress;
}

- (void)setCompanyHost:(NSArray *)hosts{
    _companyHost = hosts;
}

- (BOOL)isCompanyHost:(NSString *)url{
    if (!url
        || !ZXLUtilsISNSStringValid(url)
        || !ZXLUtilsISArrayValid(self.companyHost)
        || !([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]))  return NO;
    
    NSString *urlhost = nil;
    if ([url hasPrefix:@"http://"]) {
        urlhost = [url substringFromIndex:@"http://".length];
    }
    
    if ([url hasPrefix:@"https://"]) {
        urlhost = [url substringFromIndex:@"https://".length];
    }
    
    urlhost = [urlhost componentsSeparatedByString:@"/"].firstObject;
    if (!ZXLUtilsISNSStringValid(urlhost)) {
        return NO;
    }
    
    BOOL isCompanyHost = NO;
    for (NSString * host in self.companyHost) {
        if ([urlhost rangeOfString:host].location != NSNotFound) {
            isCompanyHost = YES;
        }
    }
    return isCompanyHost;
}
@end

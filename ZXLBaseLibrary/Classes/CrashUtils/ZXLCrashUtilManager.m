//
//  ZXLCrashUtilManager.m
//  ZXLCrashUtilModule
//
//  Created by 张小龙 on 2018/7/11.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLCrashUtilManager.h"
#import "ZXLServerAddress.h"
#import "ZXLUtilsDefined.h"
#import <Bugly/Bugly.h>

#ifdef DEBUG
#define ZXLReportCrash NO
#else
#define ZXLReportCrash YES
#endif

//第一个App 的Appid
#define ZXLZXZAppId @"a5e4a4ede7"

//第二个App 的Appid
#define ZXLZXZOrzAppId @"f803bb3b38"
@interface ZXLCrashUtilManager()
@property (nonatomic,copy)NSString *appId;
@end

@implementation ZXLCrashUtilManager
+ (instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLCrashUtilManager * manager = nil;
    dispatch_once(&pred, ^{
        manager = [[ZXLCrashUtilManager alloc] init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        if (ZXLReportCrash && [ZXLServerAddress manager].releaseType == ZXLReleaseProductionType) {
            switch ([ZXLServerAddress manager].appType) {
                case ZXLAppTypeZXZ: self.appId = ZXLZXZAppId; break;
                case ZXLAppTypeZXZOrz:self.appId = ZXLZXZOrzAppId;break;
                default:
                    break;
            }
        }
    }
    return self;
}

+(void)registerAppId{
    if (ZXLUtilsISNSStringValid([ZXLCrashUtilManager manager].appId)) {
        [Bugly startWithAppId:[ZXLCrashUtilManager manager].appId];
    }
}

+(void)reportException:(NSString *)name reason:(NSString *)reason{
    if (!ZXLUtilsISNSStringValid(name) && !ZXLUtilsISNSStringValid(reason))
        return;
    
    
    if (ZXLUtilsISNSStringValid([ZXLCrashUtilManager manager].appId)) {
        [Bugly reportException:[NSException exceptionWithName:name reason:reason userInfo:nil]];
    }
}

+(void)reportError:(NSError *)error{
    if (error == nil) return;
    
    if (ZXLUtilsISNSStringValid([ZXLCrashUtilManager manager].appId)) {
        [Bugly reportError:error];
    }
}

@end

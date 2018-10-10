//
//  ZXLPhoneInfo.m
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "ZXLPhoneInfo.h"
#import  <CoreGraphics/CoreGraphics.h>
#import  <UIKit/UIKit.h>
#import  <sys/utsname.h>
#include <sys/param.h>
#include <sys/mount.h>
#include <mach/mach.h>

#define ZXLCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define ZXLTempPath NSTemporaryDirectory()

@implementation ZXLPhoneInfo

+(NSString *)iphoneType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"])         return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"iPhone Simulator";
    return platform;
}

+(unsigned long long)freeDiskSpaceInBytes{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    //    NSString *str = [NSString stringWithFormat:@"手机剩余存储空间为：%0.2lld MB",freeSpace/1024/1024];
    return freeSpace;
}

+(ZXLIphoneVersionStyle)iphoneVersion{
    if([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO){
        return ZXLIphone5Version;
    }
    if([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) ||CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size)) : NO){
        return ZXLIphone6Version;
    }
    if([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size)|| CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO){
        return ZXLIphone6pVersion;
    }
    if([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO){
        return ZXLIphoneXVersion;
    }
    return ZXLIphone4Version;
}

+(double)memoryAvailableBytes{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount =HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS){
        return NSNotFound;
    }
    return (vm_page_size * vmStats.free_count) + (vmStats.inactive_count * vm_page_size);
}

+ (void)applicationCachesSize:(void (^)(double size))completed{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGFloat totalSize = 0;
        NSDirectoryEnumerator *cachesFileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:ZXLCachesPath];
        for (NSString *fileName in cachesFileEnumerator) {
            NSString *filepath = [ZXLCachesPath stringByAppendingPathComponent:fileName];
            
            BOOL dir = NO;
            [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&dir];
            if (dir)
                continue;
            
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:nil];
            if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory])
                continue;

            totalSize += [attrs[NSFileSize] integerValue];
        }
        
        NSDirectoryEnumerator *tempFileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:ZXLTempPath];
        for (NSString *fileName in tempFileEnumerator) {
            NSString *filepath = [ZXLTempPath stringByAppendingPathComponent:fileName];
            
            BOOL dir = NO;
            [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&dir];
            if (dir)
                continue;
            
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:nil];
            if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory])
                continue;
            
            totalSize += [attrs[NSFileSize] integerValue];
        }
        
        totalSize = totalSize / 1000.0 / 1000;
        if (completed) {
           completed(totalSize);
        }
    });
}


+ (void)applicationClearCaches:(void (^)(BOOL bResult))completed{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *cachesContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:ZXLCachesPath error:nil];
        [cachesContents enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSFileManager defaultManager] removeItemAtPath:[ZXLCachesPath stringByAppendingPathComponent:obj] error:nil];
        }];
        
        NSArray *tempContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:ZXLTempPath error:nil];
        [tempContents enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSFileManager defaultManager] removeItemAtPath:[ZXLTempPath stringByAppendingPathComponent:obj] error:nil];
        }];
        
        if (completed) {
            completed(YES);
        }
    });
}

+ (void)checkNetWorkPermission:(CellularDataRestrictionDidUpdateNotifier)updateNotifier{
    if (@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc]init];
        cellularData.cellularDataRestrictionDidUpdateNotifier = updateNotifier;
    } else {
        // Fallback on earlier versions
    }
}
@end

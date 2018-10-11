//
//  ZXLUploadManager+Extension.m
//  Compass
//
//  Created by 张小龙 on 2018/5/11.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLUploadManager+Extension.h"
#import "ZXLAliOSSManager.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import <ZXLAddressManager.h>
#import <ZXLUpload.h>

@implementation ZXLUploadManager(ZXLPrivate)

-(NSString *)serverAddress{
    return [ZXLAddressManager manager].downloadfileURL;
}

-(id)extensionUploadFile:(NSString *)objectKey
           localFilePath:(NSString *)filePath
                progress:(void (^)(float percent))progress
                complete:(void (^)(BOOL result))complete{
    return [[ZXLAliOSSManager manager] uploadFile:objectKey localFilePath:filePath progress:progress result:^(OSSTask *task) {
        OSSInitMultipartUploadResult * uploadResult = task.result;
        if (complete) {
            complete(task && uploadResult && uploadResult.httpResponseCode == 200);
        }
    }];
}

@end

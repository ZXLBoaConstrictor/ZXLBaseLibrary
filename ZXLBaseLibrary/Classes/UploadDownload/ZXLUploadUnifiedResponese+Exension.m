//
//  ZXLUploadUnifiedResponese+Exension.m
//  Compass
//
//  Created by 张小龙 on 2018/4/8.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLUploadUnifiedResponese+Exension.h"
#import "ZXLUploadTaskModel.h"
#import "ZXLAsyncUploadTaskManager.h"
#import <ZXLUtilsDefined.h>
#import <NSArray+ZXLExtension.h>

#import <ZXLUpload/ZXLUploadDefine.h>
#import <ZXLUpload/ZXLFileInfoModel.h>
#import <ZXLUpload/ZXLTaskInfoModel.h>

@implementation ZXLUploadUnifiedResponese(ZXLPrivate)

-(void)extensionUnifiedResponese:(ZXLTaskInfoModel *)taskInfo{
    if (taskInfo && [taskInfo uploadTaskType] == ZXLUploadTaskSuccess) {
        //公司业务在文件任务上传成功后统一处理上传结果
        ZXLUploadTaskModel *ZXLTaskModel = [[ZXLAsyncUploadTaskManager manager] getTaskInfoForUploadIdentifier:taskInfo.identifier];
        if (ZXLTaskModel) {
            NSMutableArray *paramsArr = [NSMutableArray array];
            for (NSInteger i = 0;i < [taskInfo uploadFilesCount];i++) {
                ZXLFileInfoModel * fileInfo = [taskInfo uploadFileAtIndex:i];
                if (fileInfo) {
                    switch (fileInfo.fileType) {
                        case ZXLFileTypeImage:
                            [paramsArr addObject:@{@"imgUrl" : [fileInfo uploadKey], @"type" : @(fileInfo.fileType).stringValue}];
                            break;
                        case ZXLFileTypeVoice:
                            [paramsArr addObject:@{@"time" : @(fileInfo.fileTime).stringValue, @"imgUrl" : [fileInfo uploadKey], @"type" : @(fileInfo.fileType)}];
                            break;
                        case ZXLFileTypeVideo:
                            [paramsArr addObject:@{@"time" : @(fileInfo.fileTime).stringValue,@"imgUrl" : [fileInfo uploadKey], @"type" : @(fileInfo.fileType).stringValue}];
                            break;
                        default:
                            break;
                    }
                }
            }
            
            if (ZXLUtilsISDictionaryValid(paramsArr)) {
                //通知文件任务组上传成功
            }
        }
    }
}
@end

//
//  ZXLAsyncUploadTaskManager.m
//  Compass
//
//  Created by 张小龙 on 2018/4/8.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLAsyncUploadTaskManager.h"
#import "ZXLUploadTaskModel.h"
#import "ZXLTaskFmdb.h"
#import <ZXLSettingFunction.h>
#import <ZXLUtilsDefined.h>
#import <ZXLRouter.h>
#import <NSString+Route.h>

#import <ZXLUpload/ZXLUpload.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface ZXLAsyncUploadTaskManager()
@property(nonatomic,strong)ZXLSyncMutableDictionary *uploadTasks;
@end

@implementation ZXLAsyncUploadTaskManager
+(instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLAsyncUploadTaskManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[ZXLAsyncUploadTaskManager alloc] initLoadLocalUploadInfo];
    });
    return _sharedObject;
}

- (instancetype)initLoadLocalUploadInfo{
    if (self = [super init]) {
        //读取本地上传信息
        NSMutableArray<ZXLUploadTaskModel *> * tasks = [[ZXLTaskFmdb manager] selectAllUploadTaskInfo];
        for (ZXLUploadTaskModel * model in tasks) {
            [self.uploadTasks setObject:model forKey:model.taskTid];
        }
    }
    return self;
}

-(ZXLSyncMutableDictionary *)uploadTasks{
    if (!_uploadTasks) {
        _uploadTasks = [[ZXLSyncMutableDictionary alloc] init];
    }
    return _uploadTasks;
}

-(BOOL)clearCache{
    if (![[ZXLUploadFileResultCenter shareUploadResultCenter] clearAllUploadFileInfo]
        ||![[ZXLUploadTaskManager manager] clearUploadTask]) {
        return NO;
    }

    [self.uploadTasks removeAllObjects];
    [[ZXLTaskFmdb manager] clearUploadTaskInfo];
    return YES;
}

-(void)restUploadTaskReStartProcess{
    [[ZXLUploadTaskManager manager] restUploadTaskReStartProcess];
}

-(void)addUploadTask:(ZXLUploadTaskModel *)taskModel{
    if (!taskModel || [self.uploadTasks objectForKey:taskModel.taskTid]) return;
    
    [self.uploadTasks setObject:taskModel forKey:taskModel.taskTid];
    [[ZXLTaskFmdb manager] insertUploadTaskInfo:taskModel];
}

-(void)reomveUploadTask:(NSString *)taskId{
    if (!ZXLUtilsISNSStringValid(taskId)) return;
    
    ZXLUploadTaskModel *taskModel = [self.uploadTasks objectForKey:taskId];
    if (taskModel) {
        [[ZXLUploadTaskManager manager] removeTaskForIdentifier:taskModel.uploadIdentifier];
    }
    
    [self.uploadTasks removeObjectForKey:taskId];
    [[ZXLTaskFmdb manager] deleteUploadTaskInfo:taskModel];
}

-(NSMutableArray<ZXLUploadTaskModel *> *)allUploadTask{
    NSMutableArray<ZXLUploadTaskModel *> * ayTasks = [NSMutableArray array];
    NSArray *allKeys = [self.uploadTasks allKeys];
    for (NSString *taskKey in allKeys) {
        [ayTasks addObject:[self.uploadTasks objectForKey:taskKey]];
    }
    return ayTasks;
}

-(NSInteger)taskCount{
    return [self.uploadTasks count];
}

-(ZXLUploadTaskModel *)getTaskInfoForUploadIdentifier:(NSString *)uploadIdentifier{
    if (!ZXLUtilsISNSStringValid(uploadIdentifier)) return nil;
    
    ZXLUploadTaskModel *tempTaskModel = nil;
    NSMutableArray<ZXLUploadTaskModel *> * ayTasks = [self allUploadTask];
    for (ZXLUploadTaskModel *taskModel in ayTasks) {
        if ([taskModel.uploadIdentifier isEqualToString:uploadIdentifier]) {
            tempTaskModel = taskModel;
            break;
        }
    }
    return tempTaskModel;
}

-(ZXLTaskInfoModel *)getUploadTaskInfoForTaskId:(NSString *)taskId{
    if (!ZXLUtilsISNSStringValid(taskId)) return nil;
    
    ZXLUploadTaskModel *taskModel = [self.uploadTasks objectForKey:taskId];
    if (taskModel && ZXLUtilsISNSStringValid(taskModel.uploadIdentifier)) {
        return [[ZXLUploadTaskManager manager] uploadTaskInfoForIdentifier:taskModel.uploadIdentifier];
    }
    return nil;
}

-(NSMutableArray <ZXLUploadTaskModel *> *)classUploadlistTaskArray:(NSString *)classId{
    NSMutableArray<ZXLUploadTaskModel *> * ayTask = [NSMutableArray array];
    
    NSMutableArray<ZXLUploadTaskModel *> * tempTasks = [self allUploadTask];
    for (ZXLUploadTaskModel *taskModel in tempTasks) {
        if (taskModel && ZXLUtilsISNSStringValid(taskModel.taskTid)) {
            if (!ZXLUtilsISNSStringValid(taskModel.classes) || [taskModel.classes rangeOfString:classId].location != NSNotFound) {
                [ayTask addObject:taskModel];
            }
        }
    }
    return ayTask;
}

-(NSInteger)selectClassUploadTaskCount:(NSString *)classId{
    NSInteger uploadCount = 0;
    NSMutableArray<ZXLUploadTaskModel *> * tempTasks = [self allUploadTask];
    for (ZXLUploadTaskModel *taskModel in tempTasks) {
        if (taskModel && ZXLUtilsISNSStringValid(taskModel.taskTid)) {
            if (!ZXLUtilsISNSStringValid(taskModel.classes) || [taskModel.classes rangeOfString:classId].location != NSNotFound) {
                uploadCount ++;
            }
        }
    }
    return uploadCount;
}

-(BOOL)checkClassHaveUploadTask:(NSString *)classId{
    BOOL bExistence = NO;
    NSMutableArray<ZXLUploadTaskModel *> * tempTasks = [self allUploadTask];
    for (ZXLUploadTaskModel *taskModel in tempTasks) {
        if (taskModel && ZXLUtilsISNSStringValid(taskModel.taskTid)) {
            if (!ZXLUtilsISNSStringValid(taskModel.classes) || [taskModel.classes rangeOfString:classId].location != NSNotFound) {
                bExistence = YES;
                break;
            }
        }
    }
    return bExistence;
}

-(BOOL)checkClassHaveErrorUploadTask:(NSString *)classId{
    BOOL bExistence = NO;
    NSMutableArray<ZXLUploadTaskModel *> * tempTasks = [self allUploadTask];
    for (ZXLUploadTaskModel *taskModel in tempTasks) {
        if (taskModel && ZXLUtilsISNSStringValid(taskModel.taskTid)) {
            if (!ZXLUtilsISNSStringValid(taskModel.classes) || [taskModel.classes rangeOfString:classId].location != NSNotFound) {
                if ([taskModel uploadTaskType] == ZXLUploadTaskError) {
                    bExistence = YES;
                    break;
                }
            }
        }
    }
    return bExistence;
}

+(ZXLFileInfoModel *)getUploadFileInfoForUploadIdentifier:(NSString *)uploadIdentifier
                                           fileIdentifier:(NSString *)fileIdentifier{
    ZXLTaskInfoModel *taskInfo = [[ZXLUploadTaskManager manager] uploadTaskInfoForIdentifier:uploadIdentifier];
    if (taskInfo) {
        return [taskInfo uploadFileForIdentifier:fileIdentifier];
    }
    return nil;
}

+(void)removeFileInfoForUploadIdentifier:(NSString *)uploadIdentifier index:(NSInteger)index{
    ZXLTaskInfoModel *taskInfo = [[ZXLUploadTaskManager manager] uploadTaskInfoForIdentifier:uploadIdentifier];
    if (taskInfo) {
        [taskInfo removeUploadFileAtIndex:index];
    }
}

+(void)replaceJSTaskFileInfoForUploadIdentifier:(NSString *)uploadIdentifier index:(NSInteger)index{
    ZXLTaskInfoModel *taskInfo = [[ZXLUploadTaskManager manager] uploadTaskInfoForIdentifier:uploadIdentifier];
    if (taskInfo) {
        NSInteger fileCount = [taskInfo uploadFilesCount];
        if (fileCount >= 2 && index < fileCount) {
            ZXLFileInfoModel * fileInfo = [taskInfo uploadFileAtIndex:fileCount - 1];
            [taskInfo replaceUploadFileAtIndex:index withUploadFile:fileInfo];
            [taskInfo removeUploadFileAtIndex:fileCount - 1];
        }
    }
}

+(NSMutableArray *)creatUploadTaskFileShowInfoForUploadIdentifier:(NSString *)uploadIdentifier{
    NSMutableArray *array = [NSMutableArray array];
    ZXLTaskInfoModel *taskInfo = [[ZXLUploadTaskManager manager] uploadTaskInfoForIdentifier:uploadIdentifier];
    if (taskInfo) {
        NSInteger fileCount = [taskInfo uploadFilesCount];
        if (fileCount > 0) {
            for (NSInteger i = 0 ;i< fileCount ;i++) {
                ZXLFileInfoModel * fileInfo = [taskInfo uploadFileAtIndex:i];
                if (fileInfo) {
                    id dataInfo = @(fileInfo.fileTime).stringValue;
                    if (fileInfo.fileType == ZXLFileTypeImage) {
                        dataInfo = [UIImage imageWithContentsOfFile:fileInfo.localURL];
                    }

                    if (ZXLUtilsISNSStringValid(fileInfo.assetLocalIdentifier)) {
                        dataInfo = fileInfo.assetLocalIdentifier;
                    }

                    NSMutableDictionary*pDict = [ZXLSettingFunction filesBrowserFileInfo:fileInfo.fileType dateinfo:dataInfo dateURL:fileInfo.localURL fromAlbum:ZXLUtilsISNSStringValid(fileInfo.assetLocalIdentifier)];
                    if (ZXLUtilsISDictionaryValid(pDict)) {
                        [array addObject:pDict];
                    }
                }
            }
        }
    }
    return array;
}

+(void)startUploadForIdentifier:(NSString *)identifier complete:(ZXLUploadTaskResponseCallback)complete{
    [[ZXLUploadTaskManager manager] startUploadForIdentifier:identifier compress:^(float compressPercent) {
        if (compressPercent < 1) {
            [SVProgressHUD showProgress:compressPercent status:@"文件压缩中"];
        }
    } progress:^(float progressPercent) {
        if (progressPercent < 1) {
            [SVProgressHUD showProgress:progressPercent status:@"文件上传中"];
        }
    } complete:complete];
}

+(void)uploadFile:(ZXLFileInfoModel *)fileInfo complete:(ZXLUploadFileResponseCallback)complete{
    [[ZXLUploadFileManager manager] uploadFile:fileInfo progress:^(float progressPercent) {
        if (progressPercent < 1) {
            [SVProgressHUD showProgress:progressPercent status:@"文件上传中"];
        }else{
            [SVProgressHUD dismiss];
        }
    } complete:complete];
}

+(void)uploadFile:(ZXLFileInfoModel *)fileInfo progress:(ZXLUploadFileProgressCallback)progress complete:(ZXLUploadFileResponseCallback)complete{
    [[ZXLUploadFileManager manager] uploadFile:fileInfo progress:progress complete:complete];
}

+(void)showFilesForUploadIdentifier:(NSString *)uploadIdentifier index:(NSInteger)index{
    if (!ZXLUtilsISNSStringValid(uploadIdentifier)) return;
    
    [[ZXLRouter manager] call:[NSString route:@"filesBrowser" addParams:[ZXLSettingFunction filesBrowserData:[ZXLAsyncUploadTaskManager creatUploadTaskFileShowInfoForUploadIdentifier:uploadIdentifier] Index:index]]];
}
@end

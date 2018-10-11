//
//  ZXLAsyncUploadTaskManager.h
//  Compass
//
//  Created by 张小龙 on 2018/4/8.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZXLUploadTaskModel;
@class ZXLFileInfoModel;
@class ZXLTaskInfoModel;

typedef NS_ENUM(NSUInteger, ZXLFileUploadType);

typedef void (^ZXLUploadTaskResponseCallback)(ZXLTaskInfoModel *taskInfo);

typedef void (^ZXLUploadFileProgressCallback)(float progressPercent);

typedef void (^ZXLUploadFileResponseCallback)(ZXLFileUploadType nResult,NSString *resultURL);

#define ZXLDocumentUploadTaskInfo @"ZXLDocumentUploadTaskInfo"

@interface ZXLAsyncUploadTaskManager : NSObject
+ (instancetype)manager;


/**
 清除缓存(清除所有上传相关缓存，如果有上传任务清除会失败)
 */
-(BOOL)clearCache;

/**
 app 重启后重新开始上传存储的本地任务
 */
-(void)restUploadTaskReStartProcess;

/**
 添加上传任务

 @param taskModel 上传任务信息
 */
-(void)addUploadTask:(ZXLUploadTaskModel *)taskModel;

/**
 删除上传任务保存信息

 @param taskId 任务id
 */
-(void)reomveUploadTask:(NSString *)taskId;

/**
 所有未完成的上传任务

 @return 上传任务
 */
-(NSMutableArray<ZXLUploadTaskModel *> *)allUploadTask;

/**
 未完成上传任务数量

 @return 任务数
 */
-(NSInteger)taskCount;


/**
 用上传唯一标示 获取公司上传任务信息

 @param uploadIdentifier 上传标示
 @return 任务信息
 */
-(ZXLUploadTaskModel *)getTaskInfoForUploadIdentifier:(NSString *)uploadIdentifier;


/**
 用taskId 获取对应的上传任务信息

 @param taskId 公司上传任务ID
 @return 上传任务信息
 */
-(ZXLTaskInfoModel *)getUploadTaskInfoForTaskId:(NSString *)taskId;

/**
 获取教室所有上传任务

 @param classId 教室id
 @return 上传任务数组
 */
-(NSMutableArray <ZXLUploadTaskModel *> *)classUploadlistTaskArray:(NSString *)classId;


/**
 查询此班级中存在多少个

 @param classId 班级id
 @return  班级中上传任务数量
 */
-(NSInteger)selectClassUploadTaskCount:(NSString *)classId;

/**
 检测此班级是否存在上传任务

 @param classId 班级id
 @return 是否存在上传任务
 */
-(BOOL)checkClassHaveUploadTask:(NSString *)classId;

/**
 检测此班级是否存在失败的上传任务
 
 @param classId 班级id
 @return 是否存在失败的上传任务
 */
-(BOOL)checkClassHaveErrorUploadTask:(NSString *)classId;


/**
 文件任务上传接口
 
 @param identifier 上传任务Identifier
 @param complete 上传结果
 */
+(void)startUploadForIdentifier:(NSString *)identifier complete:(ZXLUploadTaskResponseCallback)complete;

+(void)uploadFile:(ZXLFileInfoModel *)fileInfo complete:(ZXLUploadFileResponseCallback)complete;

+(void)uploadFile:(ZXLFileInfoModel *)fileInfo progress:(ZXLUploadFileProgressCallback)progress complete:(ZXLUploadFileResponseCallback)complete;
/**
 获取上传任务中某个文件的信息
 
 @param uploadIdentifier 上传任务Identifier
 @param fileIdentifier 文件Identifier
 @return 文件信息
 */
+(ZXLFileInfoModel *)getUploadFileInfoForUploadIdentifier:(NSString *)uploadIdentifier
                                           fileIdentifier:(NSString *)fileIdentifier;

/**
 删除指定上传任务中的文件

 @param uploadIdentifier 上传任务Identifier
 @param index 文件索引
 */
+(void)removeFileInfoForUploadIdentifier:(NSString *)uploadIdentifier index:(NSInteger)index;

/**
 JS 替换当前任务的文件(即拿最后一文件替换掉指定索引文件)
 
 @param uploadIdentifier 上传任务Identifier
 @param index 文件索引
 */
+(void)replaceJSTaskFileInfoForUploadIdentifier:(NSString *)uploadIdentifier index:(NSInteger)index;


/**
 创建上传任务中得文件做文件浏览器数据
 
 @param uploadIdentifier 上传任务Identifier
 @return 文件浏览器数据集合
 */
+(NSMutableArray *)creatUploadTaskFileShowInfoForUploadIdentifier:(NSString *)uploadIdentifier;

/**
 全局浏览器浏览 上传文件

 @param uploadIdentifier 上传任务Identifier
 @param index 浏览文件索引
 */
+(void)showFilesForUploadIdentifier:(NSString *)uploadIdentifier index:(NSInteger)index;
@end

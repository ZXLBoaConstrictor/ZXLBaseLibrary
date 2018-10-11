//
//  ZXLTaskFmdb.m
//  Compass
//
//  Created by 张小龙 on 2018/5/14.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLTaskFmdb.h"
#import "ZXLUploadTaskModel.h"
#import <ZXLUtilsDefined.h>

#import <FMDB/FMDB.h>


#define ZXLTaskInfoTableName @"zxltaskinfo"

#define ZXLTaskInfoTableCreateSQL                                                \
@"CREATE TABLE IF NOT EXISTS " ZXLTaskInfoTableName @" ("                        \
@"id"                                   @" integer primary key autoincrement, "  \
@"taskTid"                              @" VARCHAR(1024)  NOT NULL, "            \
@"taskName"                             @" VARCHAR(1024)          , "            \
@"taskImageURL"                         @" VARCHAR(1024)          , "            \
@"content"                              @" TEXT                   , "            \
@"uploadIdentifier"                     @" VARCHAR(1024)  NOT NULL  "            \
@")"

#define ZXLTaskInfoTableInsertSQL                                               \
@"INSERT OR IGNORE INTO " ZXLTaskInfoTableName @" ("                            \
@"taskTid"                                                      @", "           \
@"taskName"                                                     @", "           \
@"taskImageURL"                                                 @", "           \
@"content"                                                      @", "           \
@"uploadIdentifier"                                                             \
@") VALUES(?, ?, ?, ?, ?)"

#define ZXLTaskInfoTableDeleteSQL                                               \
@"DELETE FROM " ZXLTaskInfoTableName                                            \
@" WHERE taskTid = ?"

#define ZXLTaskInfoTableSelectSQL                                               \
@"SELECT * FROM " ZXLTaskInfoTableName                                          \

#define ZXLTaskFmdbPath          [NSString stringWithFormat:@"%@/com.zxl.tool.ZXLTask.db",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]]

@interface ZXLTaskFmdb ()
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;
@property (nonatomic, strong) dispatch_queue_t sqliteQueue;
@end

@implementation ZXLTaskFmdb
+(ZXLTaskFmdb*)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLTaskFmdb * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[ZXLTaskFmdb alloc] init];
        [_sharedObject creatDatabase];
    });
    return _sharedObject;
}

- (dispatch_queue_t)sqliteQueue{
    if (!_sqliteQueue) {
        _sqliteQueue = dispatch_queue_create("com.zxltask.sqliteQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _sqliteQueue;
}

-(void)creatDatabase{
    self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:ZXLTaskFmdbPath];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        BOOL success =  [db executeUpdate:ZXLTaskInfoTableCreateSQL];
        if (success) {
            
        }
    }];
}

//增
-(void)insertUploadTaskInfo:(ZXLUploadTaskModel *)taskModel{
    if (!taskModel) return;
    
    NSArray *arguments = @[taskModel.taskTid,
                           ZXLUtilsISNSStringValid(taskModel.taskName)?taskModel.taskName:@"",
                           ZXLUtilsISNSStringValid(taskModel.taskImageURL)?taskModel.taskImageURL:@"",
                           ZXLUtilsISNSStringValid(taskModel.content)?taskModel.content:@"",
                           taskModel.uploadIdentifier];
    dispatch_async(self.sqliteQueue, ^{
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            BOOL success = [db executeUpdate:ZXLTaskInfoTableInsertSQL withArgumentsInArray:arguments];
            if (!success) {
                ZXLLog(@"插入上传任务失败");
            }
        }];
    });
}

//删
-(void)deleteUploadTaskInfo:(ZXLUploadTaskModel *)taskModel{
    if (!taskModel && ZXLUtilsISNSStringValid(taskModel.taskTid)) return;
    
    NSArray *arguments = @[taskModel.taskTid];
    dispatch_async(self.sqliteQueue, ^{
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            BOOL success = [db executeUpdate:ZXLTaskInfoTableDeleteSQL withArgumentsInArray:arguments];
            if (!success) {
                ZXLLog(@"删除上传任务失败");
            }
        }];
    });
}

-(void)clearUploadTaskInfo{
    dispatch_async(self.sqliteQueue, ^{
        [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
            BOOL success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",ZXLTaskInfoTableName]];
            if (!success) {
                ZXLLog(@"清空上传任务失败");
            }
        }];
    });
}

//查
-(NSMutableArray<ZXLUploadTaskModel *> *)selectAllUploadTaskInfo{
    __block NSMutableArray<ZXLUploadTaskModel *> * taskModels = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet* resultSet = [db executeQuery:ZXLTaskInfoTableSelectSQL];
        while ([resultSet next]) {
            NSMutableDictionary *taskDictionary = [NSMutableDictionary dictionary];
            [taskDictionary setObject:[resultSet stringForColumn:@"taskTid"] forKey:@"taskTid"];
            [taskDictionary setObject:[resultSet stringForColumn:@"taskName"] forKey:@"taskName"];
            [taskDictionary setObject:[resultSet stringForColumn:@"taskImageURL"] forKey:@"taskImageURL"];
            [taskDictionary setObject:[resultSet stringForColumn:@"content"] forKey:@"content"];
            [taskDictionary setObject:[resultSet stringForColumn:@"uploadIdentifier"] forKey:@"uploadIdentifier"];
            
            [taskModels addObject:[ZXLUploadTaskModel dictionary:taskDictionary]];
        }
    }];
    return taskModels;
}
@end
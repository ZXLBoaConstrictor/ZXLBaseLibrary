//
//  ZXLTaskFmdb.h
//  Compass
//
//  Created by 张小龙 on 2018/5/14.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZXLUploadTaskModel;

@interface ZXLTaskFmdb : NSObject

+(ZXLTaskFmdb*)manager;

//增
-(void)insertUploadTaskInfo:(ZXLUploadTaskModel *)taskModel;
//删
-(void)deleteUploadTaskInfo:(ZXLUploadTaskModel *)taskModel;
-(void)clearUploadTaskInfo;
//查
-(NSMutableArray<ZXLUploadTaskModel *> *)selectAllUploadTaskInfo;
@end

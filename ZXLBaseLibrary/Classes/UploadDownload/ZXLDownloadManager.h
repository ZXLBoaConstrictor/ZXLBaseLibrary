//
//  ZXLDownloadManager.h
//  Compass
//
//  Created by 张小龙 on 2018/4/17.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXLDownloadManager : NSObject
/**
 文件上传下载管理器单列创建
 
 @return 文件上传下载管理器单列
 */
+(ZXLDownloadManager*)manager;


/**
 下载文件请求
 
 @param URLString 文件网络路径
 @param downloadProgressBlock 下载Progress
 @param destination 下载回调（目标位置）
 @param completionHandler 下载完成之后的回调
 */
+ (NSURLSessionDownloadTask *)download:(NSString *)URLString
                              progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                           destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                     completionHandler:(void (^)(NSURL *filePath, NSError *error))completionHandler;

/**
 下载视频
 
 @param URLStr 视频网络路径
 */
-(void)downLoadVideoWithURLStr:(NSString *)URLStr;

/**
 视频播放路径，经过本地缓存等检测后返回的可播放路径
 
 @param url 视频路径
 @return 返回要播放的路径
 */
+(NSURL *)videoPlayURL:(NSString *)url;


/**
 判断本地是否存在缓存的视频
 
 @param url 视频地址
 @return 是否存在结果
 */
+(BOOL)videoPlayURLlocal:(NSString *)url;
@end

//
//  ZXLDownloadManager.m
//  Compass
//
//  Created by 张小龙 on 2018/4/17.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLDownloadManager.h"
#import <ZXLUtilsDefined.h>

#import "ZFDownloadManager.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <KTVHTTPCache/KTVHTTPCache.h>

@interface ZXLDownloadManager()<ZFDownloadDelegate>
@property (nonatomic,copy)NSString * downloadURL;//下载路径

@end

@implementation ZXLDownloadManager
+(ZXLDownloadManager*)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLDownloadManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[ZXLDownloadManager alloc] init];
    });
    return _sharedObject;
}

- (void)downLoadVideoWithURLStr:(NSString *)URLStr{
    NSString *videoName = [[URLStr componentsSeparatedByString:@"/"] lastObject];
    if (![videoName hasSuffix:@".mp4"]) {
        videoName = [NSString stringWithFormat:@"%@.mp4",videoName];
    }
    //定义文件的缓存路径
    NSString *videoCachePath = [ZXLDownloadManager cacheFilePathWithName:videoName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoCachePath]) {
        UISaveVideoAtPathToSavedPhotosAlbum(videoCachePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        return;
    }
    
    NSString * strFilePath = FILE_PATH(videoName);
    if ([[NSFileManager defaultManager] fileExistsAtPath:strFilePath]) {
        UISaveVideoAtPathToSavedPhotosAlbum(strFilePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        return;
    }
    
    NSURL * completeCacheFileURL= [KTVHTTPCache cacheCompleteFileURLIfExistedWithURL:[NSURL URLWithString:URLStr]];
    if (completeCacheFileURL&& ZXLUtilsISNSStringValid(completeCacheFileURL.path) && [[NSFileManager defaultManager] fileExistsAtPath:completeCacheFileURL.path]) {
        UISaveVideoAtPathToSavedPhotosAlbum(completeCacheFileURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }else{
        //已经播放完的缓存
        self.downloadURL = URLStr;
        [[ZFDownloadManager sharedDownloadManager] downFileUrl:URLStr filename:videoName fileimage:nil];
        [ZFDownloadManager sharedDownloadManager].downloadDelegate = self;
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
}

- (void)updateCellProgress:(ZFHttpRequest *)request{
    if ([request.url.absoluteString isEqualToString:self.downloadURL]) {
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        if (fileInfo) {
            // 下载进度
            float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
            [SVProgressHUD showProgress:progress];
        }
    }
}

- (void)finishedDownload:(ZFHttpRequest *)request{
    if ([request.url.absoluteString isEqualToString:self.downloadURL]) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        if (fileInfo) {
            NSString *videoName = [[self.downloadURL componentsSeparatedByString:@"/"] lastObject];
            if (![videoName hasSuffix:@".mp4"]) {
                videoName = [NSString stringWithFormat:@"%@.mp4",videoName];
            }
            
            NSString * strFilePath = FILE_PATH(videoName);
            if ([[NSFileManager defaultManager] fileExistsAtPath:strFilePath]) {
                UISaveVideoAtPathToSavedPhotosAlbum(strFilePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        }
    }
}


+ (NSURLSessionDownloadTask *)download:(NSString *)URLString
                              progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                           destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                     completionHandler:(void (^)(NSURL *filePath, NSError *error))completionHandler {
    
    // 1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadProgressBlock) {
            downloadProgressBlock(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return destination(targetPath, response);
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(filePath, error);
        }
    }];
    
    [download resume];
    return download;
}

//保存录像完成后调用的方法
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存视频失败"];
    }else{
        
        if (ZXLUtilsISNSStringValid(self.downloadURL)) {
            NSString *videoName = [[self.downloadURL componentsSeparatedByString:@"/"] lastObject];
            if (![videoName hasSuffix:@".mp4"]) {
                videoName = [NSString stringWithFormat:@"%@.mp4",videoName];
            }
            
            NSString * strFilePath = FILE_PATH(videoName);
            if ([[NSFileManager defaultManager] fileExistsAtPath:strFilePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:strFilePath error:nil];
            }
            self.downloadURL = @"";
        }
        [SVProgressHUD showSuccessWithStatus:@"保存视频成功"];
    }
}

+(NSURL *)videoPlayURL:(NSString *)url{
    //先初始化
    NSString *videoName = [[url componentsSeparatedByString:@"/"] lastObject];
    if (![videoName hasSuffix:@".mp4"]) {
        videoName = [NSString stringWithFormat:@"%@.mp4",videoName];
    }
    
    //定义文件的缓存路径
    NSString * videoCachePath = [ZXLDownloadManager cacheFilePathWithName:videoName];
    NSFileManager*fileManager = [NSFileManager defaultManager];
    if (!([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) || [fileManager fileExistsAtPath:videoCachePath] || [fileManager fileExistsAtPath:FILE_PATH(videoName)]) {//缓存目录下已存在下载完成的文件
        
        if (!([url hasPrefix:@"http"] || [url hasPrefix:@"https"])) {
            return [NSURL fileURLWithPath:url];
        }
        
        if ([fileManager fileExistsAtPath:videoCachePath]) {
            return [NSURL fileURLWithPath:videoCachePath];
        }
    }
    
    if (!([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)) {
        return [NSURL URLWithString:url];
    }
    
    if (![KTVHTTPCache proxyIsRunning]) {
        NSError *error;
        [KTVHTTPCache proxyStart:&error];
    }
    
    return  [KTVHTTPCache proxyURLWithOriginalURL:[NSURL URLWithString:url]];
}

+(BOOL)videoPlayURLlocal:(NSString *)url{
    NSString *videoName = [[url componentsSeparatedByString:@"/"] lastObject];
    if (![videoName hasSuffix:@".mp4"]) {
        videoName = [NSString stringWithFormat:@"%@.mp4",videoName];
    }
    
    //定义文件的缓存路径
    NSString * videoCachePath = [ZXLDownloadManager cacheFilePathWithName:videoName];
    NSFileManager*fileManager = [NSFileManager defaultManager];
    if (![url hasPrefix:@"http"] || [fileManager fileExistsAtPath:videoCachePath] || [fileManager fileExistsAtPath:FILE_PATH(videoName)]) {//缓存目录下已存在下载完成的文件
        if (![url hasPrefix:@"http"]) {
            return YES;
        }
        
        if ([fileManager fileExistsAtPath:videoCachePath]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)cacheFilePathWithName:(NSString *)name{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *cacheFolderPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/CachesVideo/%@",name]];
    return cacheFolderPath;
}
@end

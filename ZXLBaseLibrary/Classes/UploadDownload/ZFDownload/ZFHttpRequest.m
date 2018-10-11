//
//  ZFHttpRequest.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFHttpRequest.h"
#import <AFNetworking/AFNetworking.h>

@interface ZFHttpRequest()

@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) AFURLSessionManager *manager;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation ZFHttpRequest

- (instancetype)initWithURL:(NSURL*)url
{
    self = [super init];
    if (self) {
        _url = url;
        //Configuring the session manager
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];

    }
    return self;
}

- (NSError*)error
{
    return _task.error;
}

- (BOOL)isFinished
{
    return _task.state == NSURLSessionTaskStateCompleted;
}

- (BOOL)isExecuting
{
    return _task.state == NSURLSessionTaskStateRunning;
}

- (void)cancel
{
    [_task cancel];
}

- (void)startAsynchronous {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    request.timeoutInterval = 30;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *fileData = [fileManager contentsAtPath:self.temporaryFileDownloadPath];
    self.currentLength = [fileData length];

    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    __weak typeof(self) weakSelf = self;
    _task = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        /* NSLog(@"dataTaskWithRequest"); */
        // 清空长度
        weakSelf.currentLength = 0;
        [weakSelf.fileHandle closeFile];
        weakSelf.fileHandle = nil;
        
        NSError *moveFileError = nil;
        [fileManager moveItemAtPath:self.temporaryFileDownloadPath toPath:self.downloadDestinationPath error:&moveFileError];
        if (error || moveFileError) {
            if (weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(requestFailed:)]) {
                [weakSelf.delegate requestFailed:weakSelf];
            }
        } else {
            if (weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(requestFinished:)]) {
                [weakSelf.delegate requestFinished:weakSelf];
            }
        }
    }];
    
    [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        /* NSLog(@"NSURLSessionResponseDisposition"); */
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (id)response;
            NSDictionary *dictionary = [httpResponse allHeaderFields];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(request:didReceiveResponseHeaders:)]) {
                [weakSelf.delegate request:weakSelf didReceiveResponseHeaders:dictionary];
            }
        }
        // 沙盒文件路径
        NSString *path = self.temporaryFileDownloadPath;
        /* NSLog(@"File downloaded to: %@",path); */
        // 创建一个空的文件到沙盒中
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
            [manager createFileAtPath:path contents:nil attributes:nil]; }
        // 创建文件句柄
        weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        return NSURLSessionResponseAllow;
    }];
    
    [self.manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        /* NSLog(@"setDataTaskDidReceiveDataBlock"); */
        // 指定数据的写入位置 -- 文件内容的最后面
        [weakSelf.fileHandle seekToEndOfFile];
        // 向沙盒写入数据
        @try {
            [weakSelf.fileHandle writeData:data];
            // 拼接文件总长度
            weakSelf.currentLength += data.length;

            if (weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(request:didReceiveBytes:)]) {
                [weakSelf.delegate request:weakSelf didReceiveBytes:data.length];
            }
        } @catch (NSException *exception) {
            [weakSelf cancel];
            if (weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(requestFailed:)]) {
                [weakSelf.delegate requestFailed:weakSelf];
            }
        }
    }];
    [_task resume];
}

- (void)dealloc
{
    [_task cancel];
}

@end

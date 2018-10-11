//
//  ZXLAliOSSManager.m
//  Compass
//
//  Created by 张小龙 on 2018/5/11.
//  Copyright © 2018年 ZXL. All rights reserved.
//

#import "ZXLAliOSSManager.h"
#import <ZXLUtilsDefined.h>

#import <ZXLAddressManager.h>
#import <NSDictionary+ZXLExtension.h>
#import <AliyunOSSiOS/AliyunOSSiOS.h>

@interface ZXLAliOSSManager()
@property (nonatomic,strong)OSSClient *client;
@end

@implementation ZXLAliOSSManager

+(instancetype)manager{
    static dispatch_once_t pred = 0;
    __strong static ZXLAliOSSManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[ZXLAliOSSManager alloc] init];
        [_sharedObject ossInit];
    });
    return _sharedObject;
}

/**
 获取阿里上传endPoint
 
 @return endPoint
 */
-(NSString *)getEndPoint{
  
    return [ZXLAddressManager manager].endPoint;
}

/**
 获取阿里上传BucketName
 
 @return BucketName
 */
-(NSString *)getBucketName{
    return [ZXLAddressManager manager].bucketName;
}



/**
 *    @brief    初始化获取OSSClient
 */
- (void)ossInit {
   
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    OSSClientConfiguration * config = [OSSClientConfiguration new];
    config.timeoutIntervalForRequest = 60;
    config.maxRetryCount = 5;
    config.maxConcurrentRequestCount = 1;
    _client = [[OSSClient alloc] initWithEndpoint:[self getEndPoint] credentialProvider:credential clientConfiguration:config];
}

/**
 获取公司阿里云token

 @return 阿里云使用token
 */
- (OSSFederationToken *) getFederationToken{
//    NSString *strSTSServer = [NSString stringWithFormat:@"%@upload/token/get?tokenType=Ali",[ZXLAddressManager manager].address];
//    NSURL * url = [NSURL URLWithString:strSTSServer];
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"post";
//
//    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"ZXLIOSVersion"];
//
//    OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
//
//    NSURLSession * session = [NSURLSession sharedSession];
//    NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
//                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                    if (error) {
//                                                        [tcs setError:error];
//                                                        return;
//                                                    }
//
//                                                    [tcs setResult:data];
//                                                }];
//    [sessionTask resume];
//
//    // 实现这个回调需要同步返回Token，所以要waitUntilFinished
//    [tcs.task waitUntilFinished];
//    if (tcs.task.error) {
//        return nil;
//    } else {
//
//        NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
//                                                                options:kNilOptions
//                                                                  error:nil];
//        OSSFederationToken * token = [OSSFederationToken new];
//        token.tAccessKey = [[object dictionaryValueForKey:@"result"] stringValueForKey:@"accessKeyId"];
//        token.tSecretKey = [[object dictionaryValueForKey:@"result"] stringValueForKey:@"accessKeySecret"];
//        token.tToken = [[object dictionaryValueForKey:@"result"] stringValueForKey:@"accessToken"];
//        token.expirationTimeInMilliSecond = [[NSDate oss_clockSkewFixedDate] timeIntervalSince1970]*1000 + [[[object dictionaryValueForKey:@"result"] stringValueForKey:@"durationSeconds"] integerValue] * 1000;
//        return token;
//    }
}

-(OSSRequest *)uploadFile:(NSString *)objectKey
            localFilePath:(NSString *)filePath
                 progress:(void (^)(float percent))progress
                   result:(void (^)(OSSTask *task))result{
    OSSResumableUploadRequest* resumableRequest = [[OSSResumableUploadRequest alloc] init];
    resumableRequest.bucketName = [self getBucketName];
    resumableRequest.objectKey = objectKey;
    resumableRequest.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    resumableRequest.partSize = 256 * 1024;//256K 分片上传
    //totalBytesSent 上传量 totalBytesExpectedToSend 上传文件大小
    resumableRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (progress) {
            progress((CGFloat)totalBytesSent/(CGFloat)totalBytesExpectedToSend);
        }
    };
    
    OSSInitMultipartUploadRequest * init = [[OSSInitMultipartUploadRequest alloc] init];
    init.bucketName = [self getBucketName];
    init.objectKey = objectKey;
    
    OSSTask * task = [_client multipartUploadInit:init];
    
    [task continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSInitMultipartUploadResult * taskresult = task.result;
            resumableRequest.uploadId = taskresult.uploadId;
            OSSTask * resumeTask = [self->_client resumableUpload:resumableRequest];
            [resumeTask continueWithBlock:^id(OSSTask *partTask) {
                result(partTask);
                return nil;
            }];
            [task waitUntilFinished];
        } else {
            result(task);
        }
        return nil;
    }];
    
    return resumableRequest;
}

-(OSSRequest *)bigFileUploadFile:(NSString *)objectKey
                   localFilePath:(NSString *)filePath
                        progress:(void (^)(float percent))progress
                          result:(void (^)(OSSTask *task))result{
    OSSResumableUploadRequest* resumableRequest = [[OSSResumableUploadRequest alloc] init];
    resumableRequest.bucketName = [self getBucketName];
    resumableRequest.objectKey = objectKey;
    resumableRequest.uploadingFileURL = [NSURL fileURLWithPath:filePath];
    resumableRequest.partSize = 256 * 1024;//256K 分片上传
    //totalBytesSent 上传量 totalBytesExpectedToSend 上传文件大小
    resumableRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (progress) {
            progress((CGFloat)totalBytesSent/(CGFloat)totalBytesExpectedToSend);
        }
    };
    
    OSSInitMultipartUploadRequest * init = [[OSSInitMultipartUploadRequest alloc] init];
    init.bucketName = [self getBucketName];
    init.objectKey = objectKey;
    
    OSSTask * task = [_client multipartUploadInit:init];
    
    [task continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSInitMultipartUploadResult * taskresult = task.result;
            resumableRequest.uploadId = taskresult.uploadId;
            OSSTask * resumeTask = [self->_client resumableUpload:resumableRequest];
            [resumeTask continueWithBlock:^id(OSSTask *partTask) {
                result(partTask);
                return nil;
            }];
            
            [task waitUntilFinished];
        } else {
            result(task);
        }
        return nil;
    }];
    return resumableRequest;
}

-(OSSRequest *)imageUploadFile:(UIImage *)image
                     objectKey:(NSString *)objectKey
                      progress:(void (^)(float percent))progress
                        result:(void (^)(OSSTask *task))result{
    
    OSSPutObjectRequest * put = [[OSSPutObjectRequest alloc] init];
    
    // required fields
    put.bucketName = [self getBucketName];
    put.objectKey = objectKey;
    put.uploadingData = UIImageJPEGRepresentation(image, 1.0);
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        if (progress) {
            progress(totalByteSent/totalBytesExpectedToSend);
        }
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [_client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        result(task);
   
        return nil;
    }];
    
    return put;
}
@end

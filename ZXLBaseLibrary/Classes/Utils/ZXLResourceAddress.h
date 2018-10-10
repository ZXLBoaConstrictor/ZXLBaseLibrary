//
//  ZXLResourceAddress.h
//  ZXLUtils
//  工程中资源路径定义
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXLResourceAddress : NSObject

/**
 工程中 bundlename（主要的资源）
 */
@property (nonatomic,copy) NSString * bundlename;

/**
 ZXLNSURLProtocol 服务器下载的H5ResourcePath
 */
@property (nonatomic,copy) NSString * urlPH5ResourcePath;

/**
 ZXLNSURLProtocol 本地bundlename中H5Resource文件夹名称
 */
@property (nonatomic,copy) NSString * bundleH5Resource;

+ (instancetype)manager;

@end

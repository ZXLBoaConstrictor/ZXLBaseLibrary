//
//  ZXLExtensionResource.h
//  AFNetworking
//
//  Created by 张小龙 on 2018/6/22.
//

#import <Foundation/Foundation.h>

@interface ZXLExtensionResource : NSObject
/**
 工程中 bundlename（主要的资源）
 */
@property (nonatomic,copy) NSString * bundlename;

/**
 图片资源在 bundlename 中文件夹名称
 */
@property (nonatomic,copy) NSString * bundleImageResource;
+(instancetype)manager;

@end

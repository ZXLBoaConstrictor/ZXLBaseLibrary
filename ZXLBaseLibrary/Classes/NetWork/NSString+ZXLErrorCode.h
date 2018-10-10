//
//  NSString+ZXLErrorCode.h
//  ZXLNetworkModule
//
//  Created by 张小龙 on 2018/6/25.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZXLResponseCode @"code"
#define ZXLResponseMessage @"message"

@interface NSString(ZXLErrorCode)

+ (instancetype)errorCodeToString:(NSInteger)errorCode;

+ (instancetype)errorMessage:(NSDictionary *)parameter message:(NSString *)defaultMessage;

+ (instancetype)failureMessage:(NSError *)error message:(NSString *)defaultMessage;
@end

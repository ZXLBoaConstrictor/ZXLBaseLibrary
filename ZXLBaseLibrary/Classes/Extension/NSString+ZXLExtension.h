//
//  NSString+ZXLExtension.h
//  ZXLUtils
//
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSString (ZXLExtension)

/**
 链接正则检测结果
 @return 检测结果
 */
- (NSArray<NSTextCheckingResult *> *)detectorTypeLinkCheck;
/**
 字符串中是否包含Emoji表情
 @return 判断结果
 */
- (BOOL)stringContainsEmoji;

/**
 删除表情后的字符串

 @return 字符串
 */
- (NSString *)disable_emoji;


/**
 名字判断
 @return 判断结果
 */
- (BOOL)isVaildRealName;

/**
 判断字符串中全是数字
 @return 判断结果
 */
-(BOOL)isNumber;

/**
 字符串是否是一个手机号 (简单判断只判断字符串中 都是数字和11位 ，复杂的判断就是号段判断。)
 （注意复杂判断中号段有可能不准）
 @return 判断结果
 */
-(BOOL)isPhoneNumber:(BOOL)bSimple;

/**
 邮箱判断
 @return 判断结果
 */
-(BOOL)isEmail;

/**
 base64 编码
 @return 编码结果
 */
- (NSString *)base64encode;

/**
 base64 解码
 @return 解码结果
 */
- (NSString *)base64decode;

/**
 UTF8编码
 @return 编码结果
 */
- (NSString *)encodeStringUTF8;

/**
 UTF8解码
 @return 解码结果
 */
- (NSString *)decodeStringUTF8;

/**
 md5 编码
 @return 编码结果
 */
- (NSString *)decodeStringMD5;

/**
 字符串转数组
 @return 数组
 */
- (NSArray *)array;

/**
 字符串转字典
 @return 字典
 */
- (NSDictionary *)dictionary;


/**
 根据当前时间戳生成的随机数字符串
 @return 随机数字符串
 */
+ (NSString *)randomNumber;

/**
 获取文件的MD5 值
 @param filePath 文件路径
 @return MD值
 */
+ (NSString *)fileMd5HashCreateWithPath:(NSString *)filePath;

/**
 字符串区域计算

 @param string 字符串
 @param width 展示区间宽度
 @param font 字体大小
 @return 区间大小
 */
+(CGSize)stringSizeWith:(NSString *)string width:(CGFloat)width font:(UIFont *)font;

@end

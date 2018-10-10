//
//  ZXLUtilsDefined.h
//  ZXLUtils
//  经常用到且好用的宏定义
//  Created by 张小龙 on 2018/5/28.
//  Copyright © 2018年 张小龙. All rights reserved.
//


/**
 对象创建

 @param class 对象class 名称
 @return object
 */
#define ZXLNewObject(class) [[class alloc]init];

/**
 字符串空判断
 @param string 字符串
 @return bool 判断结果
 */
#define ZXLUtilsISNSStringValid(string) (string != nil && [string length] > 0)

/**
 字典类型空判断
 @param dictionary 字典
 @return bool 判断结果
 */
#define ZXLUtilsISDictionaryValid(dictionary) (dictionary != nil && [dictionary count] > 0)

/**
 数组类型空判断
 @param array 数组
 @return bool 判断结果
 */
#define ZXLUtilsISArrayValid(array) (array != nil && [array count] > 0)

//键盘关闭函数
#define ZXLCloseKeyBord(bClose)  [[[UIApplication sharedApplication] keyWindow] endEditing:bClose]

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

/**
 日志输出

 @param ... 参数
 */
#ifdef DEBUG
#define ZXLLog(...) NSLog(__VA_ARGS__)
#else
#define ZXLLog(...)
#endif

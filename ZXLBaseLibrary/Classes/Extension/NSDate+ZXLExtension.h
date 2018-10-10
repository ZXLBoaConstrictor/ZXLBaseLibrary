//
//  NSDate+ZXLExtension.h
//  ZXLBaseUtils
//
//  Created by 张小龙 on 2018/5/30.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(ZXLExtension)

/** 是否为今天 */
-(BOOL)isToday;

/** 是否为昨天 */
- (BOOL)isYesterday;

/** 是否为本周内 */
- (BOOL)isThisWeak;

/** 是否为本月 */
- (BOOL)isThisMonth;

/** 是否为今年 */
- (BOOL)isThisYear;

/**本周星期几(注：中国式星期日为 7)*/
- (NSInteger)weekDay;

/**
 今天 00：00 ：00  凌晨0时
 @return 日期
 */
+(NSDate *)today;

/**
 某年某月某日 转换为NSDate
 @param month 月
 @param day 日
 @param year 年
 @return NSDate
 */
+ (NSDate *)dateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year;

/**本周星期一*/
+ (NSDate *)weekFirstDayWithToday;
/**某一天所在周星期一*/
+ (NSDate *)weekFirstDayWithDate:(NSString *)date;
/**某一天上周星期一*/
+ (NSDate *)frontWeekFirstDayWithDate:(NSString *)date;
/**某一天下周星期一*/
+ (NSDate *)nextWeekFirstDayWithDate:(NSString *)date;

/**
 某年某月的第一天时间
 @param month 月
 @param year 年
 @return NSDate
 */
+ (NSDate *)mothFirstDayWithMonth:(NSUInteger)month year:(NSUInteger)year;

/**
 今天 所在月的第一天
 @return NSDate
 */
+ (NSDate *)todayMothFirstDay;

/**
 指定时间的上个月的第一天
 @param date 指定时间
 @return 上个月的第一天
 */
+ (NSDate *)mothFirstDayWithFrontMonth:(NSDate *)date;

/**
 指定时间的下一个月的第一天
 @param date 指定时间
 @return 下月的第一天
 */
+ (NSDate *)mothFirstDayWithNextMonth:(NSDate *)date;

/**
 NSDateComponents 类型转 NSDate
 @param components NSDateComponents
 @return NSDate
 */
+ (NSDate *)dateFromDateComponents:(NSDateComponents *)components;

/**
 NSDate转NSDateComponents
 @param date date descriptionNSDate
 @return NSDateComponents
 */
+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;

/**
 日期对比是否为同一天
 @param date 对比日
 @param otherDate 另一个对比日
 @return 是否一样
 */
+ (BOOL)compareDate:(NSDate *)date otherDate:(NSDate *)otherDate;

/**
 时间戳转 展示字符串
 规则 今天 12:12  昨天 12:12  12月12日 12:12 跨年 2018年12月12日 12:12
 @param dTime 时间戳
 @return 时间显示
 */
+(NSString *)doubleTimeChangeToShowString:(double)dTime;
@end

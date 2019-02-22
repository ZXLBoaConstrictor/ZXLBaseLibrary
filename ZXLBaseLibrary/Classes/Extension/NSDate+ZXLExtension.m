//
//  NSDate+ZXLExtension.m
//  ZXLBaseUtils
//
//  Created by 张小龙 on 2018/5/30.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "NSDate+ZXLExtension.h"

@implementation NSDate(ZXLExtension)

#pragma mark - 获取指定日期的年份
- (NSInteger)year {
    return [NSDate dateComponentsFromDate:self].year;
}

#pragma mark - 获取指定日期的月份
- (NSInteger)month {
    return [NSDate dateComponentsFromDate:self].month;
}

#pragma mark - 获取指定日期的天
- (NSInteger)day {
    return [NSDate dateComponentsFromDate:self].day;
}

#pragma mark - 获取指定日期的小时
- (NSInteger)hour {
    return [NSDate dateComponentsFromDate:self].hour;
}

#pragma mark - 获取指定日期的分钟
- (NSInteger)minute {
    return [NSDate dateComponentsFromDate:self].minute;
}

#pragma mark - 获取指定日期的秒
- (NSInteger)br_second {
    return [NSDate dateComponentsFromDate:self].second;
}

#pragma mark - 获取指定日期的星期
- (NSInteger)weekday{
    if (!self)  return -1;
    
    NSDateComponents *comps = [NSDate dateComponentsFromDate:self];
    if (comps.weekday - 1 == 0) {
        return 7;
    }
    return  comps.weekday - 1;
}

-(BOOL)isToday{
    if (!self)  return NO;
  
    return [NSDate compareDate:[NSDate today] otherDate:self];
}

- (BOOL)isYesterday{
    if (!self)  return NO;
    
    NSDateComponents * compsSelf = [NSDate dateComponentsFromDate:self];
    NSDate *dateTemp = [NSDate dateWithYear:compsSelf.year month:compsSelf.month day:compsSelf.day];
    
    NSDateComponents *comps = [[NSDate localCalendar] components:NSCalendarUnitDay fromDate:[NSDate today] toDate:dateTemp options:0];
    return (comps.day + 1 == 0);
}

- (BOOL)isThisWeak{
    if (!self)  return NO;
    
    NSInteger weekDay = [NSDate today].weekday;
    NSDateComponents * compsSelf = [NSDate dateComponentsFromDate:self];
    NSDate *date = [NSDate dateWithYear:compsSelf.year month:compsSelf.month day:compsSelf.day];
    NSDateComponents *comps = [[NSDate localCalendar] components:NSCalendarUnitDay fromDate:[NSDate today] toDate:date options:0];
    //当日期大于今天 :今天星期加大于天数小于等于7天则为本周范围
    if (comps.day > 0) {
        return (weekDay + comps.day <= 7);
    }
    //当日期小于等于今天 :今天星期加大于天数大于0天则为本周范围
    return (weekDay + comps.day > 0);
}

- (BOOL)isThisMonth{
    if (!self)  return NO;
    
    NSDateComponents * compsSelf = [NSDate dateComponentsFromDate:self];
    NSDateComponents * comps = [NSDate dateComponentsFromDate:[NSDate today]];
    return (compsSelf.year == comps.year && compsSelf.month == comps.month);
}

- (BOOL)isThisYear{
    if (!self)  return NO;
    
    NSDateComponents * compsSelf = [NSDate dateComponentsFromDate:self];
    NSDateComponents * comps = [NSDate dateComponentsFromDate:[NSDate today]];
    return compsSelf.year == comps.year;
}

+(NSDate *)today{
    NSDateComponents * comps = [NSDate dateComponentsFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    return [NSDate dateWithYear:comps.year month:comps.month day:comps.day];
}
/**
 NSCalendar 单列
 
 @return NSCalendar
 */
+ (NSCalendar *)localCalendar {
    static NSCalendar *calendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        //注意这里默认时区为手机中设置的时区
    });
    return calendar;
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    
    // 初始化日期组件
    NSDateComponents *components = [NSDate dateComponentsFromDate:[NSDate date]];
    if (year >= 0) {
        components.year = year;
    }
    if (month >= 0) {
        components.month = month;
    }
    if (day >= 0) {
        components.day = day;
    }
    if (hour >= 0) {
        components.hour = hour;
    }
    if (minute >= 0) {
        components.minute = minute;
    }
    if (second >= 0) {
        components.second = second;
    }
    return [NSDate dateFromDateComponents:components];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute{
    return [NSDate dateWithYear:year month:month day:day hour:hour minute:minute second:-1];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour{
    return [NSDate dateWithYear:year month:month day:day hour:hour minute:-1 second:-1];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    return [NSDate dateWithYear:year month:month day:day hour:-1 minute:-1 second:-1];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month{
    return [NSDate dateWithYear:year month:month day:-1 hour:-1 minute:-1 second:-1];
}

+ (NSDate *)dateWithYear:(NSInteger)year{
    return [NSDate dateWithYear:year month:-1 day:-1 hour:-1 minute:-1 second:-1];
}

+ (NSDate *)dateWithMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute{
    return [NSDate dateWithYear:-1 month:month day:day hour:hour minute:minute second:-1];
}

+ (NSDate *)dateWithMonth:(NSInteger)month day:(NSInteger)day{
    return [NSDate dateWithYear:-1 month:month day:day hour:-1 minute:-1 second:-1];
}

+ (NSDate *)dateWithHour:(NSInteger)hour minute:(NSInteger)minute{
    return [NSDate dateWithYear:-1 month:-1 day:-1 hour:hour minute:minute second:-1];
}


+ (NSDate *)weekFirstDayWithToday{
    NSDate * today = [NSDate today];
    NSTimeInterval timeInterval = today.weekday - 1;
    return [NSDate dateWithTimeInterval:-timeInterval*24*60*60 sinceDate:today];
}

+ (NSDate *)weekFirstDayWithDate:(NSString *)date{
    
    return nil;
}

+ (NSDate *)frontWeekFirstDayWithDate:(NSString *)date{
    return nil;
}

+ (NSDate *)nextWeekFirstDayWithDate:(NSString *)date{
    return nil;
}

+ (NSDate *)mothFirstDayWithYear:(NSUInteger)year month:(NSUInteger)month{
    return [NSDate dateWithYear:year month:month day:1];
}

+ (NSDate *)todayMothFirstDay{
    NSDateComponents *comps = [NSDate dateComponentsFromDate:[NSDate today]];
    return [NSDate mothFirstDayWithYear:comps.year month:comps.month];
}

+ (NSDate *)mothFirstDayWithFrontMonth:(NSDate *)date{
    NSDateComponents * components = [NSDate dateComponentsFromDate:date];
    NSInteger month = components.month;
    NSInteger year = components.year;
    if (components.month == 1) {
        month = 12;
        year -= 1;
    }else{
        month -= 1;
    }
    return [NSDate mothFirstDayWithYear:year month:month];
}

+ (NSDate *)mothFirstDayWithNextMonth:(NSDate *)date{
    NSDateComponents * components = [NSDate dateComponentsFromDate:date];
    NSInteger month = components.month;
    NSInteger year = components.year;
    if (components.month == 12) {
        month = 1;
        year += 1;
    }else{
        month += 1;
    }
    return [NSDate mothFirstDayWithYear:year month:month];
}

+ (NSDate *)dateFromDateComponents:(NSDateComponents *)components {
    if (!components) return nil;
    
    //这里转要用格林威治标准时间
    NSCalendar *calender = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calender dateFromComponents:components];
}

+ (NSUInteger)daysInMonth:(NSUInteger)month ofYear:(NSUInteger)year {
    NSDate *date = [NSDate mothFirstDayWithYear:year month:month];
    return [[NSDate localCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

+ (NSUInteger)firstWeekdayInMonth:(NSUInteger)month ofYear:(NSUInteger)year {
    NSDate *date = [NSDate mothFirstDayWithYear:year month:month];
    return [[NSDate localCalendar] component:NSCalendarUnitWeekday fromDate:date];
}

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date{
    if (!date) return nil;
    
    return [[NSDate localCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:date];
}

+ (BOOL)compareDate:(NSDate *)date otherDate:(NSDate *)otherDate {
    if (!date || !otherDate) return NO;
    
    NSDateComponents *dateComps = [NSDate dateComponentsFromDate:date];
    NSDateComponents *otherDateComps = [NSDate dateComponentsFromDate:otherDate];
    return dateComps.year == otherDateComps.year && dateComps.month == otherDateComps.month && dateComps.day == otherDateComps.day;
}

+(NSString *)doubleTimeChangeToShowString:(double)dTime{
    if (dTime <= 0)
        return @"";
    
    NSDateFormatter* dateFormat = [NSDateFormatter new];
    dateFormat.timeZone = [NSTimeZone systemTimeZone];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dTime];
    //日历
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone systemTimeZone];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    
    
    if (comp1.year == comp2.year){
        if (comp1.month == comp2.month){
            if (comp1.day == comp2.day){
                [dateFormat setDateFormat:@"今天 HH:mm"];
                return [dateFormat stringFromDate:date];
            }else if (comp1.day == comp2.day - 1){
                [dateFormat setDateFormat:@"昨天 HH:mm"];
                return [dateFormat stringFromDate:date];
            }
        }
        
        [dateFormat setDateFormat:@"MM月dd日 HH:mm"];
        return [dateFormat stringFromDate:date];
        
    }else{
        [dateFormat setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        return [dateFormat stringFromDate:date];
    }
    
    return @"";
}

+ (NSString *)stringOfWeekdayInChinese:(NSUInteger)weekday{
    
    if (weekday < 1 || weekday > 7) {
        return @"";
    }
    static NSArray *Strings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Strings = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    });
    return Strings[weekday - 1];
}

#pragma mark - 日期和字符串之间的转换：NSDate --> NSString
+ (NSString *)dateString:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = format;
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

#pragma mark - 日期和字符串之间的转换：NSString --> NSDate
+ (NSDate *)date:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = format;
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    return destDate;
}

- (NSComparisonResult)compare:(NSDate *)targetDate format:(NSString *)format{
    NSString *dateString1 = [NSDate dateString:self format:format];
    NSString *dateString2 = [NSDate dateString:targetDate format:format];
    NSDate *date1 = [NSDate date:dateString1 format:format];
    NSDate *date2 = [NSDate date:dateString2 format:format];
    if ([date1 compare:date2] == NSOrderedDescending) {
        return 1;
    } else if ([date1 compare:date2] == NSOrderedAscending) {
        return -1;
    } else {
        return 0;
    }
}
@end

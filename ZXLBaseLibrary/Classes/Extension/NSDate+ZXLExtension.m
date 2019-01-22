//
//  NSDate+ZXLExtension.m
//  ZXLBaseUtils
//
//  Created by 张小龙 on 2018/5/30.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import "NSDate+ZXLExtension.h"

@implementation NSDate(ZXLExtension)


+(NSDate *)today{
    NSDateComponents * comps = [NSDate dateComponentsFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    return [NSDate dateWithMonth:comps.month day:comps.day year:comps.year];
}

-(BOOL)isToday{
    if (!self)  return NO;
  
    return [NSDate compareDate:[NSDate today] otherDate:self];
}

- (BOOL)isYesterday{
    if (!self)  return NO;
    
    NSDateComponents * compsTemp = [NSDate dateComponentsFromDate:self];
    NSDate *dateTemp = [NSDate dateWithMonth:compsTemp.month day:compsTemp.day year:compsTemp.year];
    
    NSDateComponents *comps = [[NSDate localCalendar] components:NSCalendarUnitDay fromDate:[NSDate today] toDate:dateTemp options:0];
    return (comps.day + 1 == 0);
}

- (BOOL)isThisWeak{
    if (!self)  return NO;
    
    NSInteger weekDay = [[NSDate today] weekDay];
    NSDateComponents * compsSelf = [NSDate dateComponentsFromDate:self];
    NSDate *date = [NSDate dateWithMonth:compsSelf.month day:compsSelf.day year:compsSelf.year];
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

- (NSInteger)weekDay{
    if (!self)  return -1;
    
    NSDateComponents *comps = [NSDate dateComponentsFromDate:self];
    if (comps.weekday - 1 == 0) {
        return 7;
    }
    return  comps.weekday - 1;
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

+ (NSDate *)dateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = year;
    comps.month = month;
    comps.day = day;
    return [NSDate dateFromDateComponents:comps];
}

+ (NSDate *)weekFirstDayWithToday{
    NSDate * today = [NSDate today];
    NSTimeInterval timeInterval = [today weekDay] - 1;
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

+ (NSDate *)mothFirstDayWithMonth:(NSUInteger)month year:(NSUInteger)year{
    return [NSDate dateWithMonth:month day:1 year:year];
}

+ (NSDate *)todayMothFirstDay{
    NSDateComponents *comps = [NSDate dateComponentsFromDate:[NSDate today]];
    return [NSDate mothFirstDayWithMonth:comps.month year:comps.year];
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
    return [NSDate mothFirstDayWithMonth:month year:year];
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
    return [NSDate mothFirstDayWithMonth:month year:year];
}

+ (NSDate *)dateFromDateComponents:(NSDateComponents *)components {
    if (!components) return nil;
    
    //这里转要用格林威治标准时间
    NSCalendar *calender = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calender dateFromComponents:components];
}

+ (NSUInteger)daysInMonth:(NSUInteger)month ofYear:(NSUInteger)year {
    NSDate *date = [NSDate mothFirstDayWithMonth:month year:year];
    return [[NSDate localCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

+ (NSUInteger)firstWeekdayInMonth:(NSUInteger)month ofYear:(NSUInteger)year {
    NSDate *date = [NSDate mothFirstDayWithMonth:month year:year];
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
    
    
    
    if (comp1.year == comp2.year)
    {
        if (comp1.month == comp2.month)
        {
            if (comp1.day == comp2.day)
            {
                [dateFormat setDateFormat:@"今天 HH:mm"];
                return [dateFormat stringFromDate:date];
            }else if (comp1.day == comp2.day - 1)
            {
                [dateFormat setDateFormat:@"昨天 HH:mm"];
                return [dateFormat stringFromDate:date];
            }
        }
        
        [dateFormat setDateFormat:@"MM月dd日 HH:mm"];
        return [dateFormat stringFromDate:date];
        
    }else
    {
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

@end

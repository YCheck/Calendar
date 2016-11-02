//
//  TimeTransform.m
//  Artselleasy
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 faith. All rights reserved.
//

#import "TimeTransform.h"

@implementation TimeTransform

+ (NSTimeInterval)nowTimeInterval{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval time = [nowDate timeIntervalSince1970] * 1000;
    return time;
}

+(NSString *)nowYear{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy";
    return [dateFormatter stringFromDate:nowDate];
}

+(NSString *)nowYMDHM{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-M-d";
    return [dateFormatter stringFromDate:nowDate];
}

+(NSString *)nowHM{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    return [dateFormatter stringFromDate:nowDate];
}

+(NSString *)nowMonth{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"M";
    return [dateFormatter stringFromDate:nowDate];
}

+(NSString *)dateToTimeD:(id)longTime{
    UInt64 beginTime = [longTime longLongValue];
    NSDate *d1 = [[NSDate alloc] initWithTimeIntervalSince1970:beginTime/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd";
    return [dateFormatter stringFromDate:d1];
}

+ (NSString *)dateToTimeYear:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateToTimeMonth:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"M";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateToTimeDay:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"d";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateToTimeYearMonthDay:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-M-d";
    return [dateFormatter stringFromDate:date];
}

+(NSString *)dateToTimeHM:(id)longTime{
    UInt64 beginTime = [longTime longLongValue];
    NSDate *d1 = [[NSDate alloc] initWithTimeIntervalSince1970:beginTime/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    return [dateFormatter stringFromDate:d1];
}

+(NSString *)auctionTimeYMDHM:(id)longTime{
    UInt64 beginTime = [longTime longLongValue];
    NSDate *d1 = [[NSDate alloc] initWithTimeIntervalSince1970:beginTime/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [dateFormatter stringFromDate:d1];
}

+(NSString *)dateToTimeYMD:(id)longTime{
    UInt64 beginTime = [longTime longLongValue];
    NSDate *d1 = [[NSDate alloc] initWithTimeIntervalSince1970:beginTime/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-M-d";
    return [dateFormatter stringFromDate:d1];
}

+(NSString *)dateToTimeForChineseYMD:(id)longTime{
    UInt64 beginTime = [longTime longLongValue];
    NSDate *d1 = [[NSDate alloc] initWithTimeIntervalSince1970:beginTime/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    return [dateFormatter stringFromDate:d1];
}

+(NSString *)dateToTimeForChineseYM:(id)longTime{
    UInt64 beginTime = [longTime longLongValue];
    NSDate *d1 = [[NSDate alloc] initWithTimeIntervalSince1970:beginTime/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月";
    return [dateFormatter stringFromDate:d1];
}

+(NSString *)dateToTimeForChineseCurrentWeek:(id)longTime{
    UInt64 beginTime = [longTime longLongValue] + 86400000 * 6;
    [self dateToTimeYMDWeek:[NSString stringWithFormat:@"%lf",beginTime]];
    NSDate *d1 = [[NSDate alloc] initWithTimeIntervalSince1970:beginTime/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    
    NSInteger index = [self getWeekdayFromDate:d1] - 1;
    if (index == 0) {
        index = 7;
    }
    UInt64 monday = beginTime - (index - 1) * 86400000;
    UInt64 sunday = beginTime + (7 - index) * 86400000;
    NSDate *mondayDate = [[NSDate alloc] initWithTimeIntervalSince1970:monday/1000.0];
    NSDate *sundayDate = [[NSDate alloc] initWithTimeIntervalSince1970:sunday/1000.0];
    NSString *mondayStr = [dateFormatter stringFromDate:mondayDate];
    dateFormatter.dateFormat = @"MM月dd日";
    NSString *sundayStr = [dateFormatter stringFromDate:sundayDate];
    return [NSString stringWithFormat:@"%@-%@",mondayStr,sundayStr];
    
}

+(NSString *)dateToTimeYMDHM:(id)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [dateFormatter stringFromDate:date];
}

+(NSString *)overTime:(id)longTime{
    UInt64 beginTime = [longTime longLongValue]/1000.0;
    NSDateFormatter*dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate* currentTime = [NSDate dateWithTimeIntervalSinceNow:0];
    UInt64 BirthdayTime = [currentTime timeIntervalSince1970];
    int timeRemaining = (int)(beginTime - BirthdayTime);
    //    NSLog(@"%d",timeRemaining);
    if (timeRemaining > 0) {
        int day = 0;
        day = (int)timeRemaining/86400;
        int hour;
        hour = (int)(timeRemaining%86400)/3600;
        int minute;
        minute = (int)((timeRemaining%86400)%3600)/60;
        int second;
        second = (int)(((timeRemaining%86400)%3600)%60);
        return [NSString stringWithFormat:@"%d天%d小时%d分%d秒",day,hour,minute,second];
    }else{
        return @"拍卖结束";
    }
}

+ (NSTimeInterval)timeStringTransformTimeInterval:(NSString *)str{
    NSDateFormatter*dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-M-dd"];
    NSDate *Birthdaydate =[dateFormat dateFromString:str];
    NSTimeInterval time = [Birthdaydate timeIntervalSince1970] * 1000;
    return time;
}

+ (NSString *)dateToTimeYMDWeek:(id)longTime{
    UInt64 beginTime = [longTime longLongValue];
    NSDate *d1 = [[NSDate alloc] initWithTimeIntervalSince1970:beginTime/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:d1];
    NSString *weekStr = [self weekString:[self getWeekdayFromDate:d1] - 1];
    return [NSString stringWithFormat:@"%@  %@",dateStr,weekStr];
}

+ (NSString *)weekString:(NSInteger )number
{
    if (number == 1) {
        return @"周一";
    }else if (number == 2){
        return @"周二";
    }else if (number == 3){
        return @"周三";
    }else if (number == 4){
        return @"周四";
    }else if (number == 5){
        return @"周五";
    }else if (number == 6){
        return @"周六";
    }else{
        return @"周日";
    }
}

+ (NSUInteger)getWeekdayFromDate:(NSDate*)date
{
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    
    NSCalendarUnitDay |
    
    NSCalendarUnitWeekday |
    
    NSCalendarUnitHour |
    
    NSCalendarUnitMinute |
    
    NSCalendarUnitSecond;
    
    components = [calendar components:unitFlags fromDate:date];
    
    NSUInteger weekday = [components weekday];
    
    return weekday;
    
}


@end

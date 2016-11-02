//
//  CalendarModel.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/19.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "CalendarModel.h"

@implementation CalendarModel
+(__kindof CalendarModel *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    CalendarModel *calendarDay = [[CalendarModel alloc] init];//初始化自身
    calendarDay.year = year;//年
    calendarDay.month = month;//月
    calendarDay.day = day;//日
    return calendarDay;
}
//返回当前天的NSDate对象
- (NSDate *)date
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    c.day = self.day;
    return [[NSCalendar currentCalendar] dateFromComponents:c];
}
//返回当前天的NSString对象
- (NSString *)toString
{
    NSDate *date = [self date];
    NSString *string = [date stringFromDate:date];
    return string;
}
//返回星期
- (NSString *)getWeek
{
    NSDate *date = [self date];
    NSString *week_str = [date compareIfTodayWithDate];
    return week_str;
}
//判断是不是今天
- (BOOL)isEqualToDate:(CalendarModel *)day{
    NSDate *now = [NSDate date];
    NSDateComponents *nowComps = [now YMDComponents];
    if (day.year == nowComps.year && day.month == nowComps.month && day.day == nowComps.day) {
        return YES;
    }
    return NO;
}

//判断是不是同一天
- (BOOL)isEqualTo:(CalendarModel *)day
{
    BOOL isEqual = (self.year == day.year) && (self.month == day.month) && (self.day == day.day);
    return isEqual;
}
@end

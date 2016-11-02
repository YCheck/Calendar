//
//  CalendarLogic.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/19.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "CalendarLogic.h"
#import "CalendarModel.h"

@interface CalendarLogic()
{
    NSDate *beforeDate;//起始日期
    NSDate *todayDate;//今天的日期
    NSDate *afterDate;//之前的日期
}
@end
@implementation CalendarLogic
//计算当前日期之前几天或者是之后的几天（负数是之前几天，正数是之后的几天）
- (NSMutableArray *)getMonthModelFromYears:(NSInteger)years{
    NSDate *date = [NSDate date];
    NSDate *before = [date dayInTheFollowingDay:-((int)years/2 * 365)];
    beforeDate = [before firstDayOfCurrentYear];//计算它years/2 * 365天以前的时间
    todayDate = date;//今天的日期
    afterDate = [[[date dayInTheFollowingDay:(int)years/2 * 365] firstDayOfCurrentYear] firstDayOfCurrentYear];//计算它years/2 * 365天以后的时间
    NSDateComponents *beforeDC = [beforeDate YMDComponents];
    NSDateComponents *afterDC= [afterDate YMDComponents];
    NSInteger beforeYear = beforeDC.year;
//    NSInteger beforeMonth = beforeDC.month;
    NSInteger afterYear = afterDC.year;
//    NSInteger afterMonth = afterDC.month;
    NSInteger months = (afterYear-beforeYear) * 12 + 12;//相差的月份(按年算)
    NSMutableArray *calendarMonth = [[NSMutableArray alloc]init];//每个月的dayModel数组
    for (int i = 0; i <= months; i++) {
        NSDate *month = [beforeDate dayInTheFollowingMonth:i];//beforeDate之后i个月
        NSMutableArray *calendarDays = [[NSMutableArray alloc]init];
        [self calculateDaysInPreviousMonthWithDate:month andArray:calendarDays];//计算上月份的天数
        [self calculateDaysInCurrentMonthWithDate:month andArray:calendarDays];//计算当月的天数
        [self calculateDaysInFollowingMonthWithDate:month andArray:calendarDays];//计算下月份的天数
        [calendarMonth insertObject:calendarDays atIndex:i];
    }
    return calendarMonth;
}
/*获取该日期 所属月份的model*/
- (NSMutableArray *)getCurrentMonthModel:(NSDate *)date{
    NSMutableArray *calendarDays = [[NSMutableArray alloc]init];
    [self calculateDaysInPreviousMonthWithDate:date andArray:calendarDays];//计算上月份的天数
    [self calculateDaysInCurrentMonthWithDate:date andArray:calendarDays];//计算当月的天数
    [self calculateDaysInFollowingMonthWithDate:date andArray:calendarDays];//计算下月份的天数
    return calendarDays;
}

#pragma mark - 日历上+当前+下月份的天数
//计算上月份掺杂的天数
- (NSMutableArray *)calculateDaysInPreviousMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
//    NSLog(@"---%@",[date stringFromDate:[date firstDayOfCurrentMonth]]);
    NSUInteger weeklyOrdinality = [[date firstDayOfCurrentMonth] weeklyOrdinality];//计算这个月的第一天是礼拜几,并转为int型
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];//上一个月的NSDate对象
//    NSLog(@"---%@",[date stringFromDate:dayInThePreviousMonth]);
    NSUInteger daysCount = [dayInThePreviousMonth numberOfDaysInCurrentMonth];//计算上个月有多少天
    NSUInteger partialDaysCount = weeklyOrdinality - 1;//获取上月在这个月的日历上显示的天数
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];//获取上月的年月日对象
    
    /*给上个月要在本月显示的日期设置TYPE*/
    for (int i = (int)daysCount - (int)partialDaysCount + 1; i < daysCount + 1; ++i) {
        CalendarModel *calendarDay = [CalendarModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeNull;
        [array addObject:calendarDay];
    }
    return NULL;
}
//计算下月份掺杂的天数
- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];//计算这个月的最后一天是礼拜几,并转为int型
    if (weeklyOrdinality == 7) return ;
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        CalendarModel *calendarDay = [CalendarModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeNull;
        [array addObject:calendarDay];
    }
}
//计算当月的天数
- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];//计算这个月有多少天
    NSDateComponents *components = [date YMDComponents];//今天日期的年月日
    for (int i = 1; i < daysCount + 1; ++i) {
        CalendarModel *calendarDay = [CalendarModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeDefault;
        if ([self isEqualToDate:[calendarDay date]]) {
            calendarDay.style = CellDayTypeSelected;
        }
        [array addObject:calendarDay];
    }
}
//判断是不是今天
- (BOOL)isEqualToDate:(NSDate *)paramDate{
    NSDate *now = [NSDate date];
    NSDateComponents *nowComps = [now YMDComponents];
    NSDateComponents *paramComps = [paramDate YMDComponents];
    if (paramComps.year == nowComps.year && paramComps.month == nowComps.month && paramComps.day == nowComps.day) {
        return YES;
    }
    return NO;
}
- (void)changStyle:(CalendarModel *)calendarDay
{
    
}

@end

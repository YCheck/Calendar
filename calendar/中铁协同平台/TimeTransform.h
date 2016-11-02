//
//  TimeTransform.h
//  Artselleasy
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 faith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTransform : NSObject
+(NSString *)overTime:(id)longTime;
+ (NSTimeInterval)nowTimeInterval;

/*date转字符串*/
+(NSString *)dateToTimeYear:(NSDate *)date;
+(NSString *)dateToTimeMonth:(NSDate *)date;
+(NSString *)dateToTimeDay:(NSDate *)date;
+(NSString *)dateToTimeYearMonthDay:(NSDate *)date;

/*时间戳转字符串  2016-1-1*/
+(NSString *)dateToTimeHM:(id)longTime;
+(NSString *)auctionTimeYMDHM:(id)longTime;
+(NSString *)dateToTimeYMDHM:(id)date;
+(NSString *)dateToTimeYMD:(id)longTime;
+(NSString *)dateToTimeD:(id)longTime;
//返回中文年月日
+(NSString *)dateToTimeForChineseYMD:(id)longTime;
+(NSString *)dateToTimeForChineseYM:(id)longTime;
+(NSString *)dateToTimeForChineseCurrentWeek:(id)longTime;//返回本周1--本周末日期

+(NSString *)dateToTimeYMDWeek:(id)longTime;//返回年月日+星期*
//返回当前年份
+(NSString *)nowYear;
//返回当前月份
+(NSString *)nowMonth;
//返回年月日
+(NSString *)nowYMDHM;
//返回时间
+(NSString *)nowHM;
//字符串转时间
+ (NSTimeInterval)timeStringTransformTimeInterval:(NSString *)str;
@end

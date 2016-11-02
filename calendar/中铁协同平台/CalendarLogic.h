//
//  CalendarLogic.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/19.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarLogic : NSObject
//根据传入的年数(起点-今天->终点 起点终点各占传入的一半年份) 获取各月份Model
- (NSMutableArray *)getMonthModelFromYears:(NSInteger)years;
/*获取该日期 所属月份的model*/
- (NSMutableArray *)getCurrentMonthModel:(NSDate *)date;
@end

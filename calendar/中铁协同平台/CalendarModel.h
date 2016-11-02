//
//  CalendarModel.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/19.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, CalendarForCellDayType) {
    CellDayTypeNull = 0,   //不显示
    CellDayTypeDefault,   //默认白底黑字
    CellDayTypeMarker,//被标记的日期
    CellDayTypeMarkerAndEvent,//被标记的日期
    CellDayTypePast,    //过去的日期
    CellDayTypePastAndEvent,    //过去且备注了事件的日期
    CellDayTypeFutur,   //将来的日期
    CellDayTypeFuturAndEvent,   //将来且备注了事件的日期
    CellDayTypeWeek,    //周末
    CellDayTypeSelected,    //今天的日期，默认被选中
    CellDayTypeSelectedAndEvent,//今天既被选中 又有事件
    
};
@interface CalendarModel : NSObject
@property (nonatomic, assign) NSUInteger day;//天
@property (nonatomic, assign) NSUInteger month;//月
@property (nonatomic, assign) NSUInteger year;//年
@property (nonatomic, assign) NSUInteger week;//周
@property (nonatomic, strong) NSString *Chinese_calendar;//农历
@property (nonatomic, strong) NSString *holiday;//传统节日
@property (assign, nonatomic) CalendarForCellDayType style;//显示的样式

/*针对日期样式记录事件条数*/
@property (nonatomic,assign) NSInteger firstTypeCount;
@property (nonatomic,assign) NSInteger secondTypeCount;
@property (nonatomic,assign) NSInteger thirdTypeCount;

+(__kindof CalendarModel *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
-(NSDate *)date;//返回当前天的NSDate对象
-(NSString *)toString;//返回当前天的NSString对象
-(NSString *)getWeek; //返回星期
@end

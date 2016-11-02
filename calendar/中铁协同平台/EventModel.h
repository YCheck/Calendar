//
//  EventModel.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, EventType) {
    EventTypeLevelOne = 0,   //一级事件
    EventTypeLevelSecond,// 二级事件
    EventTypeLevelThird,// 三级事件
};
@interface EventModel : NSObject

@property (nonatomic,assign) NSInteger firstTypeCount;
@property (nonatomic,assign) NSInteger secondTypeCount;
@property (nonatomic,assign) NSInteger thirdTypeCount;

@property (nullable,nonatomic) NSString *createDate;
@property (nullable,nonatomic) NSString *title;
@property (nonatomic,assign) NSInteger type;

@end

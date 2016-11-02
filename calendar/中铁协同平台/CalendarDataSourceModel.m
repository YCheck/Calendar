//
//  CalendarDataSourceModel.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/19.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "CalendarDataSourceModel.h"

@implementation CalendarDataSourceModel
static CalendarDataSourceModel *contact = Nil;
+ (CalendarDataSourceModel *)shareContactModel
{
    @synchronized(self){
        if (contact == nil) {
            contact = [[CalendarDataSourceModel alloc] init];
        }
    }
    return contact;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self){
        if (contact == nil) {
            contact = [super allocWithZone:zone];
            return contact;
        }
    }
    return nil;
}

- (NSMutableArray *)monthModels{
    if(!_monthModels){
        _monthModels = [NSMutableArray array];
    }
    return _monthModels;
}

@end

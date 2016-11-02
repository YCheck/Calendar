//
//  EventDataSourceModel.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/8/10.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "EventDataSourceModel.h"

@implementation EventDataSourceModel
static EventDataSourceModel *contact = Nil;
+ (EventDataSourceModel *)shareInstance
{
    @synchronized(self){
        if (contact == nil) {
            contact = [[EventDataSourceModel alloc] init];
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

- (NSMutableArray *)eventModels{
    if(!_eventModels){
        _eventModels = [NSMutableArray array];
    }
    return _eventModels;
}

- (NSMutableDictionary *)eventDic{
    if (!_eventDic) {
        _eventDic = [NSMutableDictionary dictionary];
    }
    return _eventDic;
}

- (NSArray *)allKeys{
    return self.eventDic.allKeys;
}

@end

//
//  EventDataSourceModel.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/8/10.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDataSourceModel : NSObject

@property (nonatomic,strong) NSMutableArray *eventModels;//记录
@property (nonatomic,strong) NSMutableDictionary *eventDic;
@property (nonatomic,strong) NSArray *allKeys;

+ (EventDataSourceModel *)shareInstance;

@end

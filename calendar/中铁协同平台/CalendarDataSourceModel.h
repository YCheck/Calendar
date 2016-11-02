//
//  CalendarDataSourceModel.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/19.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarDataSourceModel : NSObject

@property (nonatomic,strong) NSMutableArray *monthModels;//记录每个月的model


+ (CalendarDataSourceModel *)shareContactModel;
@end

//
//  MonthForDayCollectionViewCell.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/19.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarModel.h"
@interface MonthForDayCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *dayBtn;

@property (nonatomic) CalendarModel *calendarModel;
@property (nonatomic) CalendarModel *monthModel;

@end

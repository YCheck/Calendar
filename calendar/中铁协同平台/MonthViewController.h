//
//  MonthViewController.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/19.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarBaseViewController.h"
@interface MonthViewController : CalendarBaseViewController

@property (nonatomic) NSMutableArray *daysSource;//放的daymodel数组
@property (nonatomic,assign) NSInteger currentIndex;


@end

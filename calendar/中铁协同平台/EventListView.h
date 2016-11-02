//
//  EventListView.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListView : UIView
// 当前的数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
// 当前的数据视图模型
@property (nonatomic,retain) TableViewDataSource *arrayDataSource;
@end

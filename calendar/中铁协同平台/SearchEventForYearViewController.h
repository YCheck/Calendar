//
//  SearchEventForYearViewController.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarModel.h"
@interface SearchEventForYearViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *eventList;

@property (nonatomic) NSIndexPath *indexPath;//月份下标

@end

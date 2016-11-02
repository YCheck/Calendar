//
//  EventListTableViewCell.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventModel.h"
@interface EventListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateText;
- (void)configureForCell:(EventModel *)model;

@end

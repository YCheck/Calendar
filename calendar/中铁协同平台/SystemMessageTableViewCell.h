//
//  SystemMessageTableViewCell.h
//  Finance
//
//  Created by 微他 on 15-2-7.
//  Copyright (c) 2015年 inwhoop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMessageTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView *avtar;
@property (nonatomic , strong) UILabel *titile;
@property (nonatomic , strong) UILabel *message;
@property (nonatomic , strong) UIButton *receive;
@property (nonatomic , strong) UIButton *refused;

@end

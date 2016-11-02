//
//  EventListTableViewCell.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "EventListTableViewCell.h"

@implementation EventListTableViewCell

- (void)configureForCell:(EventModel *)model{
    self.titleLabel.text = model.title;
    self.dateText.text = [NSString stringWithFormat:@"%@",model.createDate];
    if (model.type == 0) {
        self.headerImage.image = [UIImage imageNamed:@"叹号"];
    }else if (model.type == 1){
        self.headerImage.image = [UIImage imageNamed:@"红圆"];
    }else if (model.type == 2){
        self.headerImage.image = [UIImage imageNamed:@"蓝圆"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

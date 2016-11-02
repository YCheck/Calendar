//
//  SystemMessageTableViewCell.m
//  Finance
//
//  Created by 微他 on 15-2-7.
//  Copyright (c) 2015年 inwhoop. All rights reserved.
//

#import "SystemMessageTableViewCell.h"

@implementation SystemMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avtar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12.5, 45, 45)];
        _avtar.layer.cornerRadius = 22.5;
        _avtar.layer.masksToBounds = YES;
        [self.contentView addSubview:_avtar];
        
        _titile = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_avtar.frame) + 12, 7.5, CGRectGetWidth(self.bounds) - CGRectGetMaxY(_avtar.frame) - 12, 30)];
        [self.contentView addSubview:_titile];
        
        _message = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titile.frame), _avtar.center.y + 3, 200, 22.5)];
        _message.textColor = HEXCOLOR(0x666666);
        _message.font = [UIFont systemFontOfSize:12];
        _message.hidden = YES;
        [self.contentView addSubview:_message];
        
        _receive = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _receive.layer.cornerRadius = 2;
        _receive.backgroundColor = [UIColor colorWithRed:59 / 255.0 green:172 / 255.0 blue:250 / 255.0 alpha:1];
        [_receive setTitle:@"接受" forState:UIControlStateNormal];
        [_receive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _receive.frame = CGRectMake(CGRectGetMinX(_titile.frame), _avtar.center.y + 3, 60, 25);
        _receive.hidden = YES;
        [self.contentView addSubview:_receive];
        
        _refused = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _refused.layer.cornerRadius = 2;
        _refused.backgroundColor = [UIColor colorWithRed:226 / 255.0 green:79 / 255.0 blue:75 / 255.0 alpha:1];
        [_refused setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refused setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _refused.frame = CGRectMake(CGRectGetMaxX(_receive.frame) + 8, _avtar.center.y + 3, 60, 25);
        _receive.hidden = YES;
        [self.contentView addSubview:_refused];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 69, CGRectGetWidth(self.contentView.bounds), 1)];
        view.backgroundColor = HEXCOLOR(0xdcdcdc);
        [self.contentView addSubview:view];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

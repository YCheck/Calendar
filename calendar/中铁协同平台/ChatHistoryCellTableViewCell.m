//
//  ChatHistoryCellTableViewCell.m
//  Finance
//
//  Created by apple on 15-2-6.
//  Copyright (c) 2015年 inwhoop. All rights reserved.
//

#import "ChatHistoryCellTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ChatHistoryCellTableViewCell(){
    UIImageView *icon;
    UILabel *name;
    UILabel *content;
    UILabel *baseline;
}

@end


@implementation ChatHistoryCellTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
        icon.layer.cornerRadius=22.5;
        icon.layer.masksToBounds=YES;
        [self.contentView addSubview:icon];
        
        name=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+15, 15, 100, 12)];
        name.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:name];
        content=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+15, CGRectGetMaxY(name.frame)+10, 100, 12)];
        content.font=[UIFont systemFontOfSize:14];
        content.textColor=[UIColor redColor];
        [self.contentView addSubview:content];
        
        baseline=[[UILabel alloc] initWithFrame:CGRectMake(0, 70, ScreenWidth, 1)];
        baseline.backgroundColor = HEXCOLOR(0xdcdcdc);
        [self.contentView addSubview:baseline];
    }
    return self;
}

-(void)setHistorydic:(NSDictionary *)historydic{
    [icon sd_setImageWithURL:historydic[@"headpath"] placeholderImage:nil];
    [name setText:historydic[@"usernick"]];
    [content setText:historydic[@"message"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

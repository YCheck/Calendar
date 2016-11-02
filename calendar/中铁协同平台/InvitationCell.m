//
//  ChatHistoryCellTableViewCell.m
//  Finance
//
//  Created by apple on 15-2-6.
//  Copyright (c) 2015年 inwhoop. All rights reserved.
//

#import "InvitationCell.h"
#import "UIImageView+WebCache.h"

@interface InvitationCell(){
    UIImageView *icon;
    UILabel *name;
    UILabel *content;
    UIButton *state;
    UILabel *baseline;
}

@end


@implementation InvitationCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
        icon.layer.cornerRadius=22.5;
        icon.layer.masksToBounds=YES;
        [self.contentView addSubview:icon];
        
        name=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, 15, 100, 12)];
        name.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:name];
        content=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, CGRectGetMaxY(name.frame)+10, 100, 12)];
        content.font=[UIFont systemFontOfSize:14];
        content.textColor=[UIColor redColor];
        [self.contentView addSubview:content];
        
        state=[[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-40, CGRectGetHeight(self.contentView.frame)/2, 20, 20)];
        [state setImage:[UIImage imageNamed:@"checkbox-unchecked_r"] forState:UIControlStateNormal];
        [state setImage:[UIImage imageNamed:@"checkbox_r"] forState:UIControlStateSelected];
        [state addTarget:self action:@selector(addpeople:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:state];
        baseline=[[UILabel alloc] initWithFrame:CGRectMake(0, 70, ScreenWidth, 1)];
        baseline.backgroundColor = HEXCOLOR(0xdcdcdc);
        [self.contentView addSubview:baseline];
    }
    return self;
}

-(void)setInvitationdic:(NSDictionary *)invitationdic{
//    _invitationdic=invitationdic;
//    NSString *url=[NSString stringWithFormat:@"%@%@",BASEURL,invitationdic[@"img"]];
//    [icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
//    [name setText:invitationdic[@"name"]];
//    [content setText:invitationdic[@"otherinfo"]];
}

-(void)addpeople:(UIButton *)sender{
    if (sender.selected==YES) {
        [_delegate removepeople:_invitationdic[@"frienduserid"]];
        sender.selected=NO;
    }else{
        [_delegate addpeople:_invitationdic[@"frienduserid"]];
        sender.selected=YES;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

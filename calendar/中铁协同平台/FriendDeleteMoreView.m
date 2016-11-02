//
//  FriendDeleteMoreView.m
//  EasyToVote
//
//  Created by gu on 16/1/29.
//  Copyright © 2016年 yp. All rights reserved.
//

#import "FriendDeleteMoreView.h"

@implementation FriendDeleteMoreView


- (instancetype)initWithFrame:(CGRect)frame isJiaJi:(BOOL)isJiaJi
{
    if (self = [super initWithFrame:frame]) {
        [self initInterface:isJiaJi];
    }
    return self;
}

- (void)initInterface:(BOOL)isJiaJi
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    view.userInteractionEnabled = NO;
    [self addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 135, 53, 120, 6+44*2)];
    UIImage *image = [[UIImage imageNamed:@"circle_loop_Add"] stretchableImageWithLeftCapWidth:0 topCapHeight:20];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    NSArray *arr = @[@{@"image":@"",@"title":@"修绑定领导群"},@{@"image":@"",@"title":@"我要配件"},@{@"image":@"",@"title":@"加急处理"}];
    if (isJiaJi) {
        arr = @[@{@"image":@"",@"title":@"修绑定领导群"},@{@"image":@"",@"title":@"我要配件"},@{@"image":@"",@"title":@"取消加急"}];
    }
    for (int i=0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setImage:[UIImage imageNamed:arr[i][@"image"]] forState:UIControlStateNormal];
        [btn setTitle:arr[i][@"title"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.frame = CGRectMake(0, 5 + 6 + 44 * i, 120, 44);
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        btn.tag = i;
    
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        btn.backgroundColor = [UIColor redColor];
        [imageView addSubview:btn];
        imageView.height = btn.bottom + 6;
    }
}

- (void)btnClick:(UIButton *)sender
{
    if (_btnClick) {
        _btnClick(sender);
    }
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self) {
        [self removeFromSuperview];
    }
}


@end

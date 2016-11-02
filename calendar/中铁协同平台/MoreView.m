//
//  MoreView.m
//  中铁协同平台
//
//  Created by gu on 16/7/21.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "MoreView.h"
#import "PYButton.h"
@interface MoreView ()

@end

@implementation MoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xf2f2f2);
        [self initInterface];
    }
    return self;
}

- (void)initInterface
{
    CGFloat jianju = (ScreenWidth - 60 * 4) / 5;
    
    int j = 0;//控制x坐标
    int m = 0;//控制y坐标
    NSArray *arr = @[@"拍照",@"图片",@"视频",@"文件",@"位置",@"成员地图"];
    for (int i=0; i<arr.count; i++) {
        PYButton *btn = [PYButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(m * (60 + jianju) + jianju, 10 + 90 * j, 60, 80);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
//        btn.titleLabel.backgroundColor = [UIColor redColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
//        btn.backgroundColor = [UIColor blueColor];
        [btn setType:PYButtonTypeBothSides_center labelPoint:CGPointMake(btn.width/2, btn.height - 10) imagePoint:CGPointMake(btn.width/2, btn.height / 2 - 10)];
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        m++;
        if ((i + 1) % 4 == 0) {
            j++;
            m = 0;
        }
    }
}

- (void)btnClick:(UIButton *)sender
{
    [_delegate moreViewDelegate:sender.tag];
}



@end

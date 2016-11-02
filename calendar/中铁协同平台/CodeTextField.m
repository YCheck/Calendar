//
//  CodeTextField.m
//  中铁协同平台
//
//  Created by gu on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "CodeTextField.h"

@implementation CodeTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.rightViewMode = UITextFieldViewModeAlways;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, self.height)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, view.height)];
    lineView.backgroundColor = HEXCOLOR(0xeeeeee);
    [view addSubview:lineView];
    
    _timeBtn = [TimeBtn buttonWithType:UIButtonTypeCustom];
    _timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_timeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_timeBtn setTitleColor:RGB(46, 122, 201) forState:UIControlStateNormal];
    _timeBtn.frame = CGRectMake(lineView.right, 0, view.width - lineView.width, view.height);
    [view addSubview:_timeBtn];
    
    self.rightView = view;
}

@end

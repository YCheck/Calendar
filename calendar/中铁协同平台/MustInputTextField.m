//
//  MustInputTextField.m
//  中铁协同平台
//
//  Created by gu on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "MustInputTextField.h"

@implementation MustInputTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, self.height)];
    label.text = @"*";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    self.rightView = label;
}

@end

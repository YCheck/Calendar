//
//  YearsPickerView.m
//  艺术蜥蜴
//
//  Created by admin on 15/4/14.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "CustomDatePickerView.h"

@implementation CustomDatePickerView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<CustomDatePickerDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        self.datePickerDelegate = delegate;
    }
    return self;
}

- (void)showInView:(UIView *)view{
    
    [view addSubview:self];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 216, ScreenWidth, 216)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self addSubview:_datePicker];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - _datePicker.frame.size.height - 44)];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.4;
    [self addSubview:_maskView];
    
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, _maskView.frame.size.height, ScreenWidth, 44)];
    _whiteView.backgroundColor = HEXCOLOR(0xeeeeee);
    [self addSubview:_whiteView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(_whiteView.frame.size.width - 70, 0, 50, 44);
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:HEXCOLOR(0xdf3032) forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:sureBtn];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, 0, 50, 44);
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:HEXCOLOR(0xdf3032) forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cancelDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:closeBtn];
    
}

- (void)sureBtnPressed{
    [self cancelDatePicker];
    [self.datePickerDelegate datePickerViewDidValueChanged:_datePicker];
}

- (void)dateChanged:(UIDatePicker *)datePicker{
    
}

- (void)cancelDatePicker{
    [_maskView removeFromSuperview];
    [_whiteView removeFromSuperview];
    [_datePicker removeFromSuperview];
    [self removeFromSuperview];
}

@end

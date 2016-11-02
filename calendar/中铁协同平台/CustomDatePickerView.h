//
//  YearsPickerView.h
//  艺术蜥蜴
//
//  Created by admin on 15/4/14.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomDatePickerDelegate <NSObject>

- (void)datePickerViewDidValueChanged:(UIDatePicker *)datePicker;

@end

@interface CustomDatePickerView : UIView
{
    UIView *_maskView;
    UIView *_whiteView;
}


@property (nonatomic,assign) id<CustomDatePickerDelegate> datePickerDelegate;
@property (nonatomic,retain) UIDatePicker *datePicker;


- (instancetype)initWithFrame:(CGRect)frame delegate:(id<CustomDatePickerDelegate>)delegate;
- (void)showInView:(UIView *)view;
- (void)cancelDatePicker;
@end

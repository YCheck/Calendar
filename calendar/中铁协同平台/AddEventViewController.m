//
//  AddEventViewController.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/8/8.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "AddEventViewController.h"
#import "UIViewController+NavigationItem.h"
#import "EventModel.h"
#import "CalendarModel.h"
#import "CalendarDataSourceModel.h"
#import "CustomDatePickerView.h"
@interface AddEventViewController ()<UITextFieldDelegate,CustomDatePickerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleText;
@property (strong, nonatomic) IBOutlet UIButton *dateBtn;

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CalendarModel *calendarModel = [CalendarDataSourceModel shareContactModel].monthModels[_indexPath.section][_indexPath.row];
    NSString *dateStr = [NSString stringWithFormat:@"%lu-%lu-%lu",calendarModel.year,calendarModel.month,(unsigned long)calendarModel.day];
    [self.dateBtn setTitle:dateStr forState:UIControlStateNormal];
    [self YCY_customNavigationRightButton:@"完成"];
    self.dateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.dateBtn.layer.borderWidth = 0.5;
}

//选择日期
- (IBAction)chooseDateBtnAction:(id)sender {
    CustomDatePickerView *datePicker = [[CustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) delegate:self];
    [datePicker showInView:[self.view superview]];
}

- (void)datePickerViewDidValueChanged:(UIDatePicker *)datePicker{
    UIDatePicker * control = (UIDatePicker*)datePicker;
    NSDate *_date = control.date;
    NSString *dateStr = [TimeTransform dateToTimeYearMonthDay:_date];
    [self.dateBtn setTitle:dateStr forState:UIControlStateNormal];
}

- (void)addEventAction{
    EventModel * model = [EventModel new];
    model.title = self.titleText.text;
    model.type = 1;
    model.createDate = self.dateBtn.titleLabel.text;
    NSMutableArray *values = [NSMutableArray arrayWithArray:[EventDataSourceModel shareInstance].eventDic[model.createDate]];
    [values addObject:model];
    [[EventDataSourceModel shareInstance].eventDic setValue:values forKey:model.createDate];
    
}

- (void)YCY_customNavigationRightButtonClicked{
    [self addEventAction];
    NSArray *vcArr = self.navigationController.viewControllers;
    UIViewController *vc = (UIViewController *)vcArr[1];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

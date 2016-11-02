//
//  CompanyNextTableViewController.m
//  中铁协同平台
//
//  Created by gu on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "CompanyNextTableViewController.h"
#import "ETTapLabel.h"
#import "CodeTextField.h"
@interface CompanyNextTableViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet CodeTextField *code;

@end

@implementation CompanyNextTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"公司注册";
    [_code.timeBtn addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getCode:(TimeBtn *)sender
{
    if (_phone.text.length == 0) {
        [self showAlter:@"请输入手机号"];
        return;
    }
    [sender countdownNum:59 color:HEXCOLOR(0xbbbbbb)];
}

- (void)showAlter:(NSString *)message
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alter addAction:okAction];
    [self presentViewController:alter animated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 15;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        ETTapLabel *label = [[ETTapLabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"提示:使用此号码的人员将使用管理员身份登录";
        label.textColor = [UIColor redColor];
        [label setTextInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        return label;
    }
    return nil;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}


@end

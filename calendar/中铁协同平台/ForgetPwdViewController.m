//
//  ForgetPwdViewController.m
//  中铁协同平台
//
//  Created by gu on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "CodeTextField.h"

@interface ForgetPwdViewController ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *hasBeenSend;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet CodeTextField *code;

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _hasBeenSend.hidden = YES;
    [_bgView strokeViewRatio:2 header:NO footer:NO];
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

- (IBAction)okBtn:(UIButton *)sender {
    if (_phone.text.length == 0) {
        [self showAlter:@"请输入手机号"];
    }
    if (_code.text.length == 0) {
        [self showAlter:@"请输入验证码"];
    }
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

//
//  CalendarBaseViewController.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "CalendarBaseViewController.h"
#import "ChatViewController.h"
#import "SearchEventForYearViewController.h"
#import "UIImage+GLTool.h"
@interface CalendarBaseViewController ()

@end

@implementation CalendarBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xf7f7f7) size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRightBotton];
    [self initBottomView];
}


- (void)createRightBotton{
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(0, 0, 27, 20);
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [sureButton setTitle:@"搜索" forState:UIControlStateNormal];
    [sureButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(rightSearchButton) forControlEvents:UIControlEventTouchUpInside];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:13];
    UIBarButtonItem *sureButtonBar = [[UIBarButtonItem alloc] initWithCustomView:sureButton];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 27, 20);
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [addButton setTitle:@"搜索" forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(rightAddButton) forControlEvents:UIControlEventTouchUpInside];
    addButton.titleLabel.font = [UIFont systemFontOfSize:13];
    UIBarButtonItem *addButtonBar = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItems = @[addButtonBar,sureButtonBar];
}


- (void)initBottomView{
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50 - 64, ScreenWidth, 50)];
    bottomV.backgroundColor = HEXCOLOR(0xf7f7f7);
    [self.view addSubview:bottomV];
    
    UIButton *todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    todayButton.frame = CGRectMake(0, ScreenHeight - 50 - 64, 60, 50);
    [todayButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [todayButton setTitle:@"今天" forState:UIControlStateNormal];
    [todayButton addTarget:self action:@selector(bottomBtnAciton) forControlEvents:UIControlEventTouchUpInside];
    todayButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:todayButton];
}

- (void)bottomBtnAciton{
    
}

- (void)rightSearchButton{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Calendar" bundle:nil];
    SearchEventForYearViewController *searchVC = [storyBoard instantiateViewControllerWithIdentifier:@"SearchEventForYearViewControllerSBID"];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)rightAddButton{
    ChatViewController *vc = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

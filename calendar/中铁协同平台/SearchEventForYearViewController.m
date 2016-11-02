//
//  SearchEventForYearViewController.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "SearchEventForYearViewController.h"
#import "EventListTableViewCell.h"
#import "ChatViewController.h"
#import "EventModel.h"
#import "AddEventViewController.h"

@interface SearchEventForYearViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>


// 当前的数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
// 当前的数据视图模型
@property (nonatomic,retain) TableViewDataSource *arrayDataSource;
@end

@implementation SearchEventForYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //移除背景色
    [self.searchBar.subviews[0].subviews[0] removeFromSuperview];

    self.dataSource = [NSMutableArray arrayWithArray:_eventList];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddEventBtnClick)];
    self.navigationItem.rightBarButtonItem = addBtn;
    [self.tableView registerNib:GetNIB(@"EventListTableViewCell") forCellReuseIdentifier:@"eventListTableViewCell"];
    
    self.tableView.dataSource = self;
}

- (void)AddEventBtnClick{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Calendar" bundle:nil];
    AddEventViewController *addEventVC = [storyBoard instantiateViewControllerWithIdentifier:@"AddEventViewControllerSBID"];
    addEventVC.indexPath = self.indexPath;
    [self.navigationController pushViewController:addEventVC animated:YES];
}

- (void)initWithData{
    [self.dataSource removeAllObjects];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *tya = @[@0,@1,@2];
    NSArray *tta = @[@"老板来了",@"我先走了",@"你去接人把",@"急着拿东西",@"其他",@"没有了"];
    for (int i = 0; i < tya.count; i ++){
        EventModel * model = [EventModel new];
        model.title = tta[i];
        model.type = [tya[i] intValue];
        NSTimeInterval time = [TimeTransform nowTimeInterval] ;
        NSTimeInterval beforeT = time - 86400 * 1000 * i * 2;
        model.createDate = [TimeTransform dateToTimeYMD:[NSString stringWithFormat:@"%f",beforeT]];
        [array addObject:model];
    }
    [self.dataSource addObjectsFromArray:array];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventListTableViewCell"
                                                                   ];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EventListTableViewCell" owner:nil options:nil] lastObject];
    }
    
    EventModel *model = self.dataSource[indexPath.row];
    [cell configureForCell:model];
    return cell;
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EventModel *model = self.dataSource[indexPath.row];
    ChatViewController *vc = [[ChatViewController alloc] init];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete ;
}


/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        EventModel *model = _dataSource[indexPath.row];
        [_dataSource removeObjectAtIndex:indexPath.row];
        NSMutableArray *values = [EventDataSourceModel shareInstance].eventDic[model.createDate];
        [values removeObject:model];
        [[EventDataSourceModel shareInstance].eventDic setValue:values forKey:model.createDate];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
    };
}

#pragma mark --UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length > 0) {
        [self performSelector:@selector(initWithData) withObject:nil afterDelay:1.5];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self closeKeyboard];
    searchBar.showsCancelButton = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeKeyboard];
}

//键盘上的搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self closeKeyboard];
    searchBar.showsCancelButton = NO;
    if (searchBar.text.length > 0) {
        [self performSelector:@selector(initWithData) withObject:nil afterDelay:1.5];
    }
}

- (void)closeKeyboard{
    
    [self.searchBar endEditing:YES];
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

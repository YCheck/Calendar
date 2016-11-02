//
//  MonthViewController.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/19.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "MonthViewController.h"
#import "MonthForDayCollectionViewCell.h"
#import "MonthHeaderView.h"
#import "CalendarViewController.h"
#import "CalendarDataSourceModel.h"
#import "SearchEventForYearViewController.h"
#import "EventListView.h"
#import "EventModel.h"
#import "UIButton+AddGesture.h"

NSString * const monthDetailIdentifier = @"monthForDayCollectionViewCell";
NSInteger const monthDetailHeaderHeight = 50;
NSInteger const monthDetailLineSpacing = 0;
NSInteger const monthDetailInsetSpacing = 10;
#define itemHeight (ScreenWidth - 6*monthDetailLineSpacing - monthDetailInsetSpacing * 2)/7
@interface MonthViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_days;
    NSMutableArray *_eventList;
    UICollectionView *_calendarCollectionView;
}

@property (nonatomic) EventListView *eventListView;

@end

@implementation MonthViewController

//- (EventListView *)eventListView{
//    if (!_eventListView) {
//        _eventListView = [[EventListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_calendarCollectionView.frame) , ScreenWidth, ScreenHeight - CGRectGetHeight(_calendarCollectionView.frame) - 64 - 20)];
//        _eventListView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_eventListView];
//    }
//    return _eventListView;
//}

/*重载*/
- (void)bottomBtnAciton{
    NSArray *values = [EventDataSourceModel shareInstance].eventDic[[TimeTransform nowYMDHM]];
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Calendar" bundle:nil];
    SearchEventForYearViewController *searchVC = [storyBoard instantiateViewControllerWithIdentifier:@"SearchEventForYearViewControllerSBID"];
    searchVC.eventList = values;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _eventList = [[NSMutableArray alloc] initWithArray:[EventDataSourceModel shareInstance].allKeys];
    //有顺序关系
    [self customWeekView];
    [self createCalendarView];
    [self initWithData];
    [self writeEvent];
    
}

- (void)writeEvent{
    _eventList = (NSMutableArray *)[EventDataSourceModel shareInstance].allKeys;
    for (int k = 0;k  < [CalendarDataSourceModel shareContactModel].monthModels.count; k ++) {
        NSArray *arr = [CalendarDataSourceModel shareContactModel].monthModels[k];
        for (CalendarModel *calendarModel in arr) {
            NSString *dateStr = [NSString stringWithFormat:@"%lu-%lu-%lu",calendarModel.year,calendarModel.month,(unsigned long)calendarModel.day];
            for (NSString *date in _eventList) {
                //            NSLog(@"%@        %@",[TimeTransform nowYMDHM],dateStr);
                /*记着除去不显示和被选中或者其他状态*/
                
                //            NSLog(@"----------nowTime=%@",[TimeTransform nowYMDHM]);
                if ([date isEqualToString:dateStr]) {
                    if (calendarModel.style == CellDayTypeNull){
                    }else if ([[TimeTransform nowYMDHM] isEqualToString:dateStr]) {
                        calendarModel.style = CellDayTypeSelectedAndEvent;
                    }else if ([TimeTransform timeStringTransformTimeInterval:dateStr] - [TimeTransform nowTimeInterval] < 0) {
                        calendarModel.style = CellDayTypePastAndEvent;
                    }else{
                        calendarModel.style = CellDayTypeFuturAndEvent;
                    }
                    
                    NSArray *values = [EventDataSourceModel shareInstance].eventDic[date];
                    if (values.count == 0) {
                        calendarModel.style = CellDayTypeDefault;
                    }
                    int level1=0,level2 = 0,level3 = 0;
                    for (int i = 0; i < values.count; i ++) {
                        EventModel *model = values[i];
                        if (model.type == 0){
                            level1 ++;
                        }else if (model.type == 1){
                            level2 ++;
                        }else if (model.type == 2){
                            level3 ++;
                        }
                    }
                    calendarModel.firstTypeCount = level1;
                    calendarModel.secondTypeCount = level2;
                    calendarModel.thirdTypeCount = level3;
                    break;
                }
            }
        }
    }
    
    [_calendarCollectionView reloadData];
}

- (void)initWithData{
    if (_eventList.count > 0 ) {
        return;
    }
    NSArray *tya = @[@0,@0,@1,@1,@2,@2];
    NSArray *tta = @[@"老板来了",@"我先走了",@"你去接人把",@"急着拿东西",@"其他",@"没有了"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0 ; i < 6 ; i ++) {
        NSTimeInterval time = [TimeTransform nowTimeInterval];
        NSTimeInterval beforeT = time - 86400 * 1000 * i * 2;
        NSString *createD = [TimeTransform dateToTimeYMD:[NSString stringWithFormat:@"%f",beforeT]];
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < 6; j ++){
            EventModel * model = [EventModel new];
            model.title = tta[j];
            model.type = [tya[j] intValue];
            model.createDate = createD;
            [array addObject:model];
        }
        [dic setValue:array forKey:createD];
    }
    [EventDataSourceModel shareInstance].eventDic = dic;
    
}

- (void)rightSearchButton{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Calendar" bundle:nil];
    SearchEventForYearViewController *searchVC = [storyBoard instantiateViewControllerWithIdentifier:@"SearchEventForYearViewControllerSBID"];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)customWeekView{
    NSArray *weekArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    bgView.backgroundColor = HEXCOLOR(0xf7f7f7);
    [self.view addSubview:bgView];
    for (int i = 0; i < 7; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * bgView.frame.size.width/7, 0,bgView.frame.size.width/7, 20)];
        label.text = weekArr[i];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0 || i == 6) {
            label.textColor = HEXCOLOR(0x999999);
        }else{
            label.textColor = HEXCOLOR(0x333333);
        }
        [bgView addSubview:label];
    }
}

-(void)createCalendarView
{
    //布局
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    //设置item的宽高
    layout.itemSize=CGSizeMake(itemHeight, itemHeight);
    //设置滑动方向
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    //设置行间距
    layout.minimumLineSpacing= monthDetailLineSpacing;
    //每列的最小间距
    layout.minimumInteritemSpacing = monthDetailLineSpacing;
    //四周边距
    layout.sectionInset=UIEdgeInsetsMake(0, monthDetailInsetSpacing, 0,monthDetailInsetSpacing);
    _calendarCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 50 - 20 - 64) collectionViewLayout:layout];
    [_calendarCollectionView registerNib:GetNIB(@"MonthHeaderView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"monthHeaderView"];
    [_calendarCollectionView registerNib:GetNIB(@"MonthForDayCollectionViewCell") forCellWithReuseIdentifier:monthDetailIdentifier];
    _calendarCollectionView.backgroundColor = [UIColor whiteColor];
    _calendarCollectionView.delegate=self;
    _calendarCollectionView.dataSource=self;
    _calendarCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_calendarCollectionView];
    [_calendarCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_currentIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    _calendarCollectionView.contentOffset = CGPointMake(0, _calendarCollectionView.contentOffset.y - monthDetailHeaderHeight);
}


#pragma mark -UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [CalendarDataSourceModel shareContactModel].monthModels.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[CalendarDataSourceModel shareContactModel].monthModels[section] count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MonthForDayCollectionViewCell *cell = nil;
    if (!cell) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:monthDetailIdentifier forIndexPath:indexPath];
    }
    CalendarModel *model = [CalendarDataSourceModel shareContactModel].monthModels[indexPath.section][indexPath.row];
    cell.monthModel = model;
    [cell.dayBtn addTarget:self action:@selector(dayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.dayBtn addTarget:self longAction:@selector(longGestureAction:)];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    MonthHeaderView *monthHeaderView = nil;
    if (kind == UICollectionElementKindSectionHeader){
        monthHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"monthHeaderView" forIndexPath:indexPath];
        /*取一个月中中间那天的月来作为header的title（因为其头尾掺杂有上下月的日期）*/
        CalendarModel *model = [CalendarDataSourceModel shareContactModel].monthModels[indexPath.section][15];
        monthHeaderView.monthLabel.text = [NSString stringWithFormat:@"%ld年%ld月",model.year,model.month];
        monthHeaderView.monthLabel.font = [UIFont systemFontOfSize:18];
        monthHeaderView.monthLabel.textColor = [UIColor blackColor];
        monthHeaderView.monthLabel.textAlignment = NSTextAlignmentCenter;
    }
    return monthHeaderView;
}
//点击某天 触发事件
- (void)dayBtnAction:(UIButton *)sender{
    UIButton *button = (UIButton *)sender;
    MonthForDayCollectionViewCell *cell = (MonthForDayCollectionViewCell *)button.superview.superview;
    NSIndexPath *indexPath = [_calendarCollectionView indexPathForCell:cell];
    CalendarModel *calendarModel = [CalendarDataSourceModel shareContactModel].monthModels[indexPath.section][indexPath.row];
    NSString *dateStr = [NSString stringWithFormat:@"%lu-%lu-%lu",calendarModel.year,calendarModel.month,calendarModel.day];
    NSArray *values = [EventDataSourceModel shareInstance].eventDic[dateStr];
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Calendar" bundle:nil];
    SearchEventForYearViewController *searchVC = [storyBoard instantiateViewControllerWithIdentifier:@"SearchEventForYearViewControllerSBID"];
    searchVC.indexPath = indexPath;
    searchVC.eventList = values;
    [self.navigationController pushViewController:searchVC animated:YES];
    
    
}
//长按某天触发事件
- (void)longGestureAction:(UILongPressGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        MonthForDayCollectionViewCell *cell = (MonthForDayCollectionViewCell *)recognizer.view.superview.superview;
        NSIndexPath *indexPath = [_calendarCollectionView indexPathForCell:cell];
        CalendarModel *calendarModel = self.daysSource[indexPath.row];
        if (calendarModel.style == CellDayTypePastAndEvent || calendarModel.style == CellDayTypeFuturAndEvent) {
            NSLog(@"112");
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, monthDetailHeaderHeight);
}

- (void)viewWillAppear:(BOOL)animated{
    [self writeEvent];
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

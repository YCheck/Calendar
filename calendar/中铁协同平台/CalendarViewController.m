//
//  CalendarViewController.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/18.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarHeaderView.h"
#import "CalendarForYearCollectionViewCell.h"
#import "MonthViewController.h"
#import "CalendarLogic.h"
#import "CalendarDataSourceModel.h"
#import "SearchEventForYearViewController.h"
#import "CustomDatePickerView.h"





NSString * const identifier = @"CalendarForYearCollectionViewCell";

NSInteger const headerHeight = 60;
NSInteger const lineSpacing = 10;
@interface CalendarViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CustomDatePickerDelegate>
{
    UICollectionView *_calendarCollectionView;
    NSMutableArray *_monthArray;//存放每月的model
    NSMutableArray *_currentMonthArray;//存放本月model
}


@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _monthArray = [NSMutableArray array];
    _currentMonthArray = [NSMutableArray array];
    [self initWithDatasource];
    [self createCalendarView];
    
}
/*重载*/
- (void)bottomBtnAciton{
    NSInteger nowMonth = [[TimeTransform nowMonth] intValue];
    NSInteger nowMonthIndex = yearsCount/2 * 12 + nowMonth - 1;//当前月份所在index
    MonthViewController *monthVC = [MonthViewController new];
    monthVC.daysSource = _monthArray[nowMonthIndex];
    CalendarModel *model = _currentMonthArray[15];
    monthVC.currentIndex = yearsCount/2 * 12 + model.month - 1;
    [self.navigationController pushViewController:monthVC animated:YES];
}


- (void)initWithDatasource{
    CalendarLogic *calendarLogic = [CalendarLogic new];
    _monthArray = [calendarLogic getMonthModelFromYears:yearsCount];
    [CalendarDataSourceModel shareContactModel].monthModels = _monthArray;//持久化
    _currentMonthArray = [calendarLogic getCurrentMonthModel:[NSDate date]];
}

-(void)createCalendarView
{
    //布局
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    //设置item的宽高
    layout.itemSize=CGSizeMake((ScreenWidth - lineSpacing * 2)/3, (ScreenWidth- lineSpacing * 2)/3);
    //设置滑动方向
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    //设置行间距
    layout.minimumLineSpacing=0;
    //每列的最小间距
    layout.minimumInteritemSpacing = 0;
    //四周边距
    layout.sectionInset=UIEdgeInsetsMake(0, 5, 0,5);
    _calendarCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 114) collectionViewLayout:layout];
    [_calendarCollectionView registerNib:GetNIB(@"CalendarHeaderView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"calendarHeaderView"];
    [_calendarCollectionView registerNib:GetNIB(@"CalendarForYearCollectionViewCell") forCellWithReuseIdentifier:identifier];
    _calendarCollectionView.backgroundColor=[UIColor whiteColor];
    
    _calendarCollectionView.delegate=self;
    _calendarCollectionView.dataSource=self;
    _calendarCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_calendarCollectionView];
    NSInteger section = yearsCount/2 ;
    [_calendarCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    _calendarCollectionView.contentOffset = CGPointMake(0, _calendarCollectionView.contentOffset.y - headerHeight);
}

#pragma mark -UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _monthArray.count/12;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return monthCount;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarForYearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    NSLog(@"index = %lu",indexPath.section);
    [cell setSection:indexPath.section];
    [cell setIndexForRow:indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *days = _monthArray[indexPath.section * 12 + indexPath.row];
    CalendarModel *model = days[15];//获取当前点击年份
    
    //设置系统back Title
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = [NSString stringWithFormat:@"%lu",model.year];
    self.navigationItem.backBarButtonItem = backItem;
    MonthViewController *monthVC = [MonthViewController new];
    monthVC.daysSource = days;//给当前月份添加event用
    monthVC.currentIndex = indexPath.section * 12 + indexPath.row;
    [self.navigationController pushViewController:monthVC animated:YES];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CalendarHeaderView *calendarHeaderView = nil;
    if (kind == UICollectionElementKindSectionHeader){
        calendarHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"calendarHeaderView" forIndexPath:indexPath];
        /*取一个月中中间那天的年来作为header的title（因为其头尾掺杂有上下月的日期）*/
        CalendarModel *calendarModel = _monthArray[indexPath.section * 12][15];
        [calendarHeaderView.headerViewYearBtn setTitle:[NSString stringWithFormat:@"%ld年",calendarModel.year ] forState:UIControlStateNormal];
        [calendarHeaderView.headerViewYearBtn addTarget:self action:@selector(headerYearsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return calendarHeaderView;
}

- (void)headerYearsBtnAction:(UIButton *)sender{
    CustomDatePickerView *datePicker = [[CustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) delegate:self];
    [datePicker showInView:[self.view superview]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, headerHeight);
}


- (void)datePickerViewDidValueChanged:(UIDatePicker *)datePicker{
    UIDatePicker * control = (UIDatePicker*)datePicker;
    NSDate *_date = control.date;
    NSInteger year = [[TimeTransform dateToTimeYear:_date] intValue];
    NSInteger month = [[TimeTransform dateToTimeMonth:_date] integerValue];
    NSInteger day = [[TimeTransform dateToTimeDay:_date] integerValue];
    
    NSInteger nowYear = [[TimeTransform nowYear] intValue];
    NSInteger nowMonth = [[TimeTransform nowMonth] intValue];
    NSInteger nowMonthIndex = yearsCount/2 * 12 + nowMonth - 1;//当前月份所在index
    NSInteger section =year - (nowYear - yearsCount/2);
    NSInteger monthIndex = section * 12 + month - 1;//_date月份所在index
    if (section < 0 || section > yearsCount) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"所选年份不在该日历范围内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [_calendarCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    _calendarCollectionView.contentOffset = CGPointMake(0, _calendarCollectionView.contentOffset.y - headerHeight);
    
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:];
    for (CalendarModel *cModel in _monthArray[monthIndex]) {
        if (cModel.day == day && cModel.month == month) {
            if (cModel.style <= 1) {
                cModel.style = CellDayTypeMarker;
            }
            break;
        }
    }
    MonthViewController *monthVC = [MonthViewController new];
    monthVC.daysSource = _monthArray[nowMonthIndex];
    monthVC.currentIndex = monthIndex;
    [self.navigationController pushViewController:monthVC animated:YES];
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

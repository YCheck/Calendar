//
//  CalendarForYearCollectionViewCell.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/18.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "CalendarForYearCollectionViewCell.h"
#import "MonthHeaderView.h"
#import "MonthForDayCollectionViewCell.h"
#import "CalendarDataSourceModel.h"
NSString * const monthIdentifier = @"monthForDayCollectionViewCell";
NSInteger const monthHeaderHeight = 15;
NSInteger const monthLineSpacing = 1;
#define selfHeight (int)(ScreenWidth - 20)/3
@interface CalendarForYearCollectionViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_calendarCollectionView;
    UILabel *_monthLabel;
}
@end
@implementation CalendarForYearCollectionViewCell

- (void)setSection:(NSInteger)section{
    _section = section;
}

- (void)setIndexForRow:(NSInteger)indexForRow{
//    NSLog(@"--%lu",indexForRow);
    _indexForRow = indexForRow;
    [self createCalendarView];
}

-(void)createCalendarView
{
    if (!_monthLabel){
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.frame = CGRectMake(3, 0, self.frame.size.width, 15);
        _monthLabel.font = [UIFont systemFontOfSize:12];
        _monthLabel.adjustsFontSizeToFitWidth = YES;
        _monthLabel.textColor = [UIColor redColor];
        _monthLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_monthLabel];
    }
    _monthLabel.text = [NSString stringWithFormat:@"%ld月",_indexForRow + 1];
    NSInteger count = [[CalendarDataSourceModel shareContactModel].monthModels[_section * 12 + _indexForRow] count];
    int width = (selfHeight - 3)/7;
    int x = 0,y = 0;
    for (int i = 0; i < 42; i ++) {
        if (i < count) {
            CalendarModel *calendarModel = [CalendarDataSourceModel shareContactModel].monthModels[_section * 12 + _indexForRow][i];
            UILabel *_titleLabel = [self.contentView viewWithTag:i+100];
            if (!_titleLabel.tag) {
                _titleLabel = [[UILabel alloc] init];
                _titleLabel.font = [UIFont systemFontOfSize:10];
                _titleLabel.adjustsFontSizeToFitWidth = YES;
                _titleLabel.tag = i+100;
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                [self.contentView addSubview:_titleLabel];
            }
            _titleLabel.frame = CGRectMake(x,y + 15,width,width);
            x += width + monthLineSpacing;
            if ((i +1) % 7 == 0) {
                y += width + monthLineSpacing;
                x = 0;
            }
            _titleLabel.text = [NSString stringWithFormat:@"%lu",calendarModel.day];
            _titleLabel.textColor = HEXCOLOR(0x333333);
            _titleLabel.backgroundColor = [UIColor whiteColor];
            if (calendarModel.style == CellDayTypeNull) {
                _titleLabel.hidden = YES;
            }else if (calendarModel.style == CellDayTypeSelected || calendarModel.style == CellDayTypeSelectedAndEvent){
                _titleLabel.hidden = NO;
                _titleLabel.layer.cornerRadius = _titleLabel.frame.size.width/2;
                _titleLabel.clipsToBounds = YES;
                _titleLabel.backgroundColor = [UIColor redColor];
                _titleLabel.textColor = [UIColor whiteColor];
            }else{
                _titleLabel.hidden = NO;
            }
        }else{
            UILabel *_titleLabel = [self.contentView viewWithTag:i+100];
            _titleLabel.hidden = YES;
        }
        
    }
//    if (!_calendarCollectionView) {
//        //布局
//        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
//        //设置item的宽高
//        layout.itemSize=CGSizeMake((selfHeight - 6)/7, (selfHeight - 6)/7);
//        //设置滑动方向
//        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
//        //设置行间距
//        layout.minimumLineSpacing=monthLineSpacing;
//        //每列的最小间距
//        layout.minimumInteritemSpacing = monthLineSpacing;
//        //四周边距
//        layout.sectionInset=UIEdgeInsetsMake(0, 0, 0,0);
//        _calendarCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, selfHeight, selfHeight) collectionViewLayout:layout];
//        _calendarCollectionView.userInteractionEnabled = NO;
//        [_calendarCollectionView registerNib:GetNIB(@"MonthHeaderView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"monthHeaderView"];
//        [_calendarCollectionView registerNib:GetNIB(@"MonthForDayCollectionViewCell") forCellWithReuseIdentifier:monthIdentifier];
//        _calendarCollectionView.backgroundColor=[UIColor whiteColor];
//        _calendarCollectionView.showsVerticalScrollIndicator = NO;
//        _calendarCollectionView.delegate=self;
//        _calendarCollectionView.dataSource=self;
//        [self.contentView addSubview:_calendarCollectionView];
//    }
//        [_calendarCollectionView reloadData];
    
}

#pragma mark -UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"--count = =%ld----%@",[[CalendarDataSourceModel shareContactModel].monthModels[section] count],[CalendarDataSourceModel shareContactModel].monthModels[section]);
    return [[CalendarDataSourceModel shareContactModel].monthModels[_section * 12 + _indexForRow] count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MonthForDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:monthIdentifier forIndexPath:indexPath];
//    NSLog(@"------%lu======%lu",_section * 12 + _indexForRow,indexPath.row);
    cell.calendarModel = [CalendarDataSourceModel shareContactModel].monthModels[_section * 12 + _indexForRow][indexPath.row];
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
    }
    monthHeaderView.monthLabel.text = [NSString stringWithFormat:@"%ld月",_indexForRow + 1];
    return monthHeaderView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(selfHeight, monthHeaderHeight);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

@end

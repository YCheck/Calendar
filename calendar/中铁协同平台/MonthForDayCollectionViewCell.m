//
//  MonthForDayCollectionViewCell.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/19.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "MonthForDayCollectionViewCell.h"
@interface MonthForDayCollectionViewCell()
{
    UILabel *_titleLabel;
    UIView *_view;
    
    UIImageView *_firstTypeImage;
    UIButton *_secondTypeLabel;
    UIButton *_thirdTypeLabel;
}
@end
@implementation MonthForDayCollectionViewCell

- (void)setCalendarModel:(CalendarModel *)calendarModel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
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
    self.dayBtn.hidden = YES;
    
}

- (void)setMonthModel:(CalendarModel *)monthModel{
    if (!_view) {
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
        [self.contentView addSubview:_view];
    }
    _view.backgroundColor = HEXCOLOR(0x999999);
    NSInteger width = 14;
    if (!_firstTypeImage) {
        _firstTypeImage = [[UIImageView alloc] initWithFrame:RECT(-2, 3,width, width)];
        self.clipsToBounds = NO;
        _firstTypeImage.image = [UIImage imageNamed:@"小叹号"];
        [self.contentView addSubview:_firstTypeImage];
    }
    if (!_secondTypeLabel) {
        _secondTypeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _secondTypeLabel.frame =
        RECT(self.frame.size.width/2 - AUTO_WIDTH(width)/2, -4,width, width);
        _secondTypeLabel.titleLabel.font = [UIFont systemFontOfSize:8];
        _secondTypeLabel.clipsToBounds = NO;
        [_secondTypeLabel setBackgroundImage:[UIImage imageNamed:@"红圆"] forState:UIControlStateNormal];
        [_secondTypeLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _secondTypeLabel.layer.cornerRadius = _secondTypeLabel.frame.size.width/2;
        [self.contentView addSubview:_secondTypeLabel];
    }
    if (!_thirdTypeLabel) {
        _thirdTypeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _thirdTypeLabel.frame =
        RECT(self.frame.size.width + 2 - AUTO_WIDTH(width), 3,width, width);
        _thirdTypeLabel.titleLabel.font = [UIFont systemFontOfSize:8];
        _thirdTypeLabel.clipsToBounds = NO;
        [_thirdTypeLabel setBackgroundImage:[UIImage imageNamed:@"蓝圆"] forState:UIControlStateNormal];
        [_thirdTypeLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _thirdTypeLabel.layer.cornerRadius = _thirdTypeLabel.frame.size.width/2;
        [self.contentView addSubview:_thirdTypeLabel];
    }
    [self.dayBtn setTitle:[NSString stringWithFormat:@"%lu",monthModel.day] forState:UIControlStateNormal];
    self.dayBtn.layer.cornerRadius = self.frame.size.width/2;
    self.dayBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.dayBtn.clipsToBounds = YES;
    [self.dayBtn setBackgroundImage:[UIImage imageNamed:@"灰色背景"] forState:UIControlStateHighlighted];
    self.dayBtn.backgroundColor = [UIColor clearColor];
    
    if (monthModel.style == CellDayTypeNull) {
        self.dayBtn.hidden = YES;
        _view.backgroundColor = [UIColor clearColor];
        _firstTypeImage.hidden = YES;
        _secondTypeLabel.hidden = YES;
        _thirdTypeLabel.hidden = YES;
    }else if(monthModel.style == CellDayTypeSelected){
        [self.dayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.dayBtn.hidden = NO;
        self.dayBtn.backgroundColor = [UIColor redColor];
        _firstTypeImage.hidden = YES;
        _secondTypeLabel.hidden = YES;
        _thirdTypeLabel.hidden = YES;
    }else if(monthModel.style == CellDayTypePastAndEvent){
        [self.dayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.dayBtn.hidden = NO;
        self.dayBtn.backgroundColor = HEXCOLOR(0x999999);
        [_secondTypeLabel setTitle:[NSString stringWithFormat:@"%lu",monthModel.secondTypeCount] forState:UIControlStateNormal];
        [_thirdTypeLabel setTitle:[NSString stringWithFormat:@"%lu",monthModel.thirdTypeCount] forState:UIControlStateNormal];
        _firstTypeImage.hidden = NO;
        _secondTypeLabel.hidden = NO;
        _thirdTypeLabel.hidden = NO;
    }else if(monthModel.style == CellDayTypeMarker){
        [self.dayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.dayBtn.hidden = NO;
        self.dayBtn.backgroundColor = HEXCOLOR(0xd9d919);
        _firstTypeImage.hidden = YES;
        _secondTypeLabel.hidden = YES;
        _thirdTypeLabel.hidden = YES;
    }else if(monthModel.style == CellDayTypeFuturAndEvent || monthModel.style == CellDayTypeSelectedAndEvent){
        [self.dayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.dayBtn.hidden = NO;
        self.dayBtn.backgroundColor = [UIColor redColor];
        [_secondTypeLabel setTitle:[NSString stringWithFormat:@"%lu",monthModel.secondTypeCount] forState:UIControlStateNormal];
        [_thirdTypeLabel setTitle:[NSString stringWithFormat:@"%lu",monthModel.thirdTypeCount] forState:UIControlStateNormal];
        _firstTypeImage.hidden = NO;
        _secondTypeLabel.hidden = NO;
        _thirdTypeLabel.hidden = NO;
    }else{
        self.dayBtn.hidden = NO;
        _firstTypeImage.hidden = YES;
        _secondTypeLabel.hidden = YES;
        _thirdTypeLabel.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

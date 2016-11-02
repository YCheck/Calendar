//
//  UnderlineBtn.m
//  EasyToVote
//
//  Created by gu on 16/4/28.
//  Copyright © 2016年 yp. All rights reserved.
//

#import "UnderlineBtn.h"

@interface UnderlineBtn ()
{
    UIView *_lineView;
}
@end

@implementation UnderlineBtn

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
    [self addSubview:_lineView];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
    _lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_lineView];
}

- (void)setLineViewHeight:(CGFloat)lineViewHeight
{
    _lineViewHeight = lineViewHeight;
    _lineView.height = lineViewHeight;
    _lineView.bottom = self.bottom;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _lineView.backgroundColor = [self titleColorForState:UIControlStateSelected];
    if (selected) {
        _lineView.hidden = NO;
    }else
    {
        _lineView.hidden = YES;
    }
}

@end

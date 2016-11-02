//
//  TimeBtn.m
//  EasyToVote
//
//  Created by gu on 16/1/5.
//  Copyright © 2016年 yp. All rights reserved.
//

#import "TimeBtn.h"

@interface TimeBtn ()
{
    UIColor *_tempColor;
    NSInteger _num;
    NSString *_tempTitle;
    NSTimer *_timer;
}
@end

@implementation TimeBtn

- (void)countdownNum:(NSInteger)num color:(UIColor *)color
{
    _num = num;
    _tempTitle = self.titleLabel.text;
    _tempColor = self.backgroundColor;
    self.enabled = NO;
    [self setBackgroundColor:color];
    [self setTitle:[NSString stringWithFormat:@"%zi",_num] forState:UIControlStateNormal];
    self.titleLabel.text = [NSString stringWithFormat:@"%zi",_num];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown
{
    _num--;
    if (_num>0) {
        [self setTitle:[NSString stringWithFormat:@"%zi",_num] forState:UIControlStateNormal];
        self.titleLabel.text = [NSString stringWithFormat:@"%zi",_num];
    }else
    {
        self.enabled = YES;
        [_timer invalidate];
        _timer = nil;
        [self setTitle:_tempTitle forState:UIControlStateNormal];
        self.titleLabel.text = _tempTitle;
        [self setBackgroundColor:_tempColor];
    }
}

- (void)dealloc
{
    [_timer invalidate];
}


@end

//
//  faceView.m
//  微他
//
//  Created by 微他 on 14-8-13.
//  Copyright (c) 2014年 微他. All rights reserved.
//

#import "FaceView.h"
#import "GLScrollView.h"

@interface FaceView ()
{
    UIPageControl *_pageControl;
    GLScrollView *_scrollView;
}
@end

@implementation FaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initInterface];
    }
    return self;
}

- (void)initInterface
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:nil];
    NSString *str= [NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    
    _scrollView = [[GLScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.bounds))];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)  * 5,CGRectGetHeight(self.bounds));
    _scrollView.showsVerticalScrollIndicator  = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = HEXCOLOR(0xf2f2f2);
    [self addSubview:_scrollView];
    _pageControl = [[UIPageControl alloc] init];
//    [pageControl setBackgroundColor:[UIColor white]];
    _pageControl.frame = CGRectMake(130, 180, 60, 20);//指定位置大小
    _pageControl.numberOfPages = 5;//指定页面个数
    _pageControl.enabled = YES;
    _pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    _pageControl.center = CGPointMake(self.center.x, CGRectGetHeight(self.bounds) - 20);
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:205 / 255.0 green:210 / 255.0 blue:214 / 255.0 alpha:1];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:253 / 255.0 green:180 / 255.0 blue:43 / 255.0 alpha:1];
    [self addSubview:_pageControl];
    int j=0;//控制页;
    int m=0;//控制列;
    int n=0;//控制行
    
    int max_m = (ScreenWidth - 10) / 34;
    CGFloat x = (ScreenWidth - 34 * max_m) / 2;
    UIImageView *deletebtn = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.bounds) * 0 + 34 * (max_m - 1) + x + 5, 43 * 3 + 24.5  , 17.5, 14.5)];
    deletebtn.image = [UIImage imageNamed:@"face_del_ico_dafeult"];
    deletebtn.tag = 1000 + 118;
    deletebtn.userInteractionEnabled = YES;
    [_scrollView addSubview:deletebtn];
    
    for (int i=0; i<array.count; i++) {
        UIImageView *btn = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.bounds) * j + 34 * m + x + 5, 43 * n + 19  , 24, 24)];
        
        btn.userInteractionEnabled = YES;
        NSString *str = array[i];
        NSRange range = [str rangeOfString:@","];
        btn.image = [UIImage imageNamed:[str substringToIndex:range.location]];
        btn.tag = 1000 + i;
        [_scrollView addSubview:btn];
        m++;
        if (m == max_m) {
            m = 0;
            n++;
        }
        if ((i + 1) % (4 * max_m - 1) == 0) {
            m = 0;
            n = 0;
            j++;
            UIImageView *deletebtn = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.bounds) * j + 34 * (max_m - 1) + x + 5, 43 * 3 + 24.5  , 17.5, 14.5)];
            deletebtn.image = [UIImage imageNamed:@"face_del_ico_dafeult"];
            deletebtn.tag = 1000 + 118;
            deletebtn.userInteractionEnabled = YES;
            [_scrollView addSubview:deletebtn];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = sender.contentOffset.x / CGRectGetWidth(self.bounds);//通过滚动的偏移量来判断目前页面所对应的小白点
    _pageControl.currentPage = page;//pagecontroll响应值的变化
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view.tag >= 1000 && touch.view.tag < 1224) {
        [_delegate faceViewDelegate:touch.view.tag - 1000];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

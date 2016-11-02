//
//  ViewController.m
//  test
//
//  Created by 张鹏 on 14-4-30.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import "CycleScrollViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface CycleScrollViewController () <UIScrollViewDelegate,UIActionSheetDelegate> {
    
    NSArray *_imageNames;
    NSMutableArray *_imageViews;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSInteger _currentPageIndex;
    UIView *_reportMenuView;
    
    UIImageView *_longTapImageView;
}

@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (nonatomic,strong) UILongPressGestureRecognizer *longTap;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;

@property (nonatomic,strong) UIButton *jubaoButton;

@property (nonatomic,assign) CGFloat zoomScale;

@property (nonatomic,strong) UIDynamicAnimator *animator;

@property (nonatomic,strong) UIView *blackView;

@property (nonatomic) BOOL isMenuShown;

@property (nonatomic,copy) NSString *picID;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic) ScrollViewType type;

@property (nonatomic,strong) NSMutableDictionary *dic;

@property (nonatomic) BOOL isDetailShown;

- (void)initializeUserInterface;

- (void)updateScrollViewWithContentOffset:(CGPoint)contentOffset;

- (NSInteger)actualIndexWithIndex:(NSInteger)index;

@end

@implementation CycleScrollViewController

- (instancetype)initWithMixids:(NSArray *)mixId currentIndex:(int)index {
    
    return  [self initWithMixIDs:mixId currentIndex:index type:ScrollViewType_DefaultViewController dataSource:nil];
}

- (instancetype)initWithMixIDs:(NSArray *)mixIDs currentIndex:(int)index type:(ScrollViewType)type dataSource:(NSMutableDictionary *)dic {
    
    self = [super init];
    if (self) {
        
        _dic = [NSMutableDictionary dictionaryWithDictionary:dic];
        _imageNames = [NSMutableArray arrayWithArray:mixIDs];
        _imageViews = [NSMutableArray array];
        self.type = type;
        _currentPageIndex = index;
        self.isMenuShown = NO;
//        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (instancetype)initWithPicId:(NSString *)picId image:(UIImage *)image
{
    
    self = [super init];
    if (self) {
        if (image == nil) {
            self.picID = picId;
        }
        else {
            self.image = image;
        }
        _imageViews = [NSMutableArray array];
        _isMenuShown = NO;
        _currentPageIndex = 0;
    }
    return self;
}

- (void)dealloc {
    
    _imageNames = nil;
    _imageViews = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if (self.type == ScrollViewType_MailViewController) {
//        
//    }
    [self initializeUserInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (_type == ScrollViewType_MailViewController) {
        self.navigationController.navigationBar.alpha = 0;
        self.navigationController.navigationBar.hidden = YES;
    }
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if (_type == ScrollViewType_MailViewController) {
        self.navigationController.navigationBar.alpha = 1;
        self.navigationController.navigationBar.hidden = NO;
    }
    [super viewWillDisappear:animated];
}

- (void)initializeUserInterface {
    
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectInset(self.view.bounds, -4, 0)];
//    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.bounds), 0);
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.bounds) * 3,
                                         CGRectGetHeight(_scrollView.bounds));
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bouncesZoom = YES;
    _scrollView.bounces = YES;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.delaysContentTouches = YES;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    if (_imageNames.count == 1 || self.picID || self.image) {
        _scrollView.scrollEnabled = NO;
    }
    
    [self.view addSubview:_scrollView];
    if ([self needsupport]) {
        _jubaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    for (int i = 0; i < 3; i++) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.bounds = self.view.frame;
        scrollView.center = CGPointMake(CGRectGetWidth(_scrollView.bounds) / 2 + CGRectGetWidth(_scrollView.bounds) * i,
                                        CGRectGetHeight(_scrollView.bounds) / 2);
        scrollView.contentSize = self.view.frame.size;
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 2.0;
        scrollView.minimumZoomScale = 1.0;
        scrollView.zoomScale = 1.0;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView addSubview:scrollView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [_imageViews addObject:imageView];
        if (_imageNames) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imageNames[[self actualIndexWithIndex:_currentPageIndex -1 +i] ]]
                         placeholderImage:[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_imageNames[[self actualIndexWithIndex:_currentPageIndex -1 +i]]]
                                  options:SDWebImageCacheMemoryOnly
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    if ([self needsupport]) {
                                        if (i == 1) {
                                            CGSize size = imageView.image.size;
                                            NSLog(@"%@",NSStringFromCGSize(size));
                                            if (size.height != 0 && size.width != 0) {
                                                
                                                _jubaoButton.center = CGPointMake([self jubaoButtonOrigin].x +330,
                                                                                  [self jubaoButtonOrigin].y);
                                            }
                                        }
                                    }
                                }];
        }
        else if (self.picID) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imageNames[[self actualIndexWithIndex:_currentPageIndex -1 +i] ]]
                         placeholderImage:[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_imageNames[[self actualIndexWithIndex:_currentPageIndex -1 +i] ]]
                                  options:SDWebImageCacheMemoryOnly
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    if ([self needsupport]) {
                                        if (i == 1) {
                                            CGSize size = imageView.image.size;
                                            NSLog(@"%@",NSStringFromCGSize(size));
                                            if (size.height != 0 && size.width != 0) {
                                                
                                                _jubaoButton.center = CGPointMake([self jubaoButtonOrigin].x +330,
                                                                                  [self jubaoButtonOrigin].y);
                                            }
                                        }
                                    }
                                }];
        }
        else if (self.image) {
            
            imageView.image = self.image;
        }
        
        [scrollView addSubview:imageView];
        
        if (i == 1) {
            
            self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
            self.singleTap.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:self.singleTap];

            self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
            self.doubleTap.numberOfTapsRequired = 2;
            [imageView addGestureRecognizer:self.doubleTap];
            
            [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
            
            UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
//            ges.numberOfTapsRequired = 1;
            ges.minimumPressDuration = 1;
            [imageView addGestureRecognizer:ges];
        }
    }
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.bounds = CGRectMake(0, 0, 320, 20);
    _pageControl.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                      CGRectGetMaxY(self.view.bounds) - 50);
    if (_imageNames.count >1) {
        _pageControl.numberOfPages = [_imageNames count];
    }
    else {
        _pageControl.numberOfPages = 0;
    }
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPage = _currentPageIndex;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    [self.view addSubview:_pageControl];
    
    
    _blackView = [[UIView alloc] initWithFrame:self.view.frame];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0;
    _blackView.userInteractionEnabled = YES;
    [self.view insertSubview:_blackView belowSubview:_reportMenuView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reportMenuViewRemove)];
    [_blackView addGestureRecognizer:tap];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    if (self.type == ScrollViewType_MailViewController) {
        
        UIButton *fakeBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [fakeBack setFrame:CGRectMake(0, 33, self.view.bounds.size.width/4, 20)];
        [fakeBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [fakeBack setImage:[UIImage imageNamed:@"group_03"] forState:UIControlStateNormal];
        [fakeBack setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 60)];
        [fakeBack setTitle:@"返回" forState:UIControlStateNormal];
        [fakeBack setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
        [fakeBack.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        fakeBack.clipsToBounds = YES;
        [fakeBack addTarget:self action:@selector(popLastViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:fakeBack];
        
//        self.title = [NSString stringWithFormat:@"%@的个人资料",_dic[@"username"]];
//        [_jubaoButton removeFromSuperview];
        _pageControl.alpha = 0;
//        _scrollView.frame = CGRectInset(self.view.bounds, -4, -64);
        
        self.isDetailShown = YES;
        _scrollView.scrollEnabled = NO;
    }
}

-(BOOL)needsupport {
    
    if (self.picID || self.image) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)popLastViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)reportMenuViewMoveIn {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.7;
    }];
    
    [self.animator removeAllBehaviors];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:_reportMenuView
                                                    snapToPoint:CGPointMake(self.view.bounds.size.width/2,
                                                                            self.view.bounds.size.height/2)];
    snap.damping = arc4random_uniform(5) / 10.0 + 0.5;
    [self.animator addBehavior:snap];
    
    [self.view.window bringSubviewToFront:_reportMenuView];
    self.isMenuShown = YES;
}

- (void)reportMenuViewRemove {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0;
    }];
    
    [self.animator removeAllBehaviors];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:_reportMenuView
                                                    snapToPoint:CGPointMake(self.view.bounds.size.width *2,
                                                                            self.view.bounds.size.height/2)];
    snap.damping = arc4random_uniform(5) / 10.0 + 0.5;
    [self.animator addBehavior:snap];
    
    self.isMenuShown = NO;
}

#pragma mark - tapGestureEvent

- (void)singleTap:(UITapGestureRecognizer *)tap {
    
    NSLog(@"singleTap");
    if (self.type == ScrollViewType_DefaultViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.type == ScrollViewType_MailViewController) {
        UIView *view100 = [self.view viewWithTag:100];
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (_isDetailShown) {
                view100.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.view.frame) +100);
                view100.alpha = 0;
                _pageControl.alpha = 1;
            }
            else {
                view100.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetHeight(self.view.frame) -CGRectGetHeight(view100.frame)/2);
                view100.alpha = 1;
                _pageControl.alpha = 0;
            }

        } completion:^(BOOL finished) {
            self.isDetailShown = !self.isDetailShown;
            if (self.isDetailShown == NO) {
                if ([_imageNames count] > 1) {
                    _scrollView.scrollEnabled = YES;
                }
            }
            else {
                _scrollView.scrollEnabled = NO;
            }
        }];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    
    UIScrollView *scrollView = (UIScrollView *)tap.view.superview;
    NSLog(@"doubleTap");
    
//    if (_isDetailShown) {
//        return;
//    }
    
    if (scrollView.zoomScale == scrollView.minimumZoomScale) {
        // Zoom in
        CGPoint center = [tap locationInView:scrollView];
        CGSize size = CGSizeMake(scrollView.bounds.size.width / scrollView.maximumZoomScale,
                                 scrollView.bounds.size.height / scrollView.maximumZoomScale);
        CGRect rect = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        [scrollView zoomToRect:rect animated:YES];
    }
    else {
        // Zoom out
        [scrollView zoomToRect:scrollView.bounds animated:YES];
    }
}

- (void)longTap:(UILongPressGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        _longTapImageView = (UIImageView *)tap.view;
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        [act showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_longTapImageView screenshot:YES];
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

- (void)updateScrollViewWithContentOffset:(CGPoint)contentOffset {
    
    BOOL shouldUpdateScrollView = NO;
    
    if (contentOffset.x <= 0) {
        _currentPageIndex = [self actualIndexWithIndex:_currentPageIndex - 1];
        shouldUpdateScrollView = YES;
    }
    else if (contentOffset.x >= CGRectGetWidth(_scrollView.bounds) * 2) {
        _currentPageIndex = [self actualIndexWithIndex:_currentPageIndex + 1];
        shouldUpdateScrollView = YES;
    }
    if (!shouldUpdateScrollView) {
        return;
    }
    
    [(UIImageView *)_imageViews[0] sd_setImageWithURL:[NSURL URLWithString:_imageNames[[self actualIndexWithIndex:_currentPageIndex -1]]]
                                     placeholderImage:[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_imageNames[[self actualIndexWithIndex:_currentPageIndex -1]]]
                                              options:SDWebImageCacheMemoryOnly
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                            }];
    [(UIImageView *)_imageViews[1] sd_setImageWithURL:[NSURL URLWithString:_imageNames[[self actualIndexWithIndex:_currentPageIndex -0]]]
                                     placeholderImage:[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_imageNames[[self actualIndexWithIndex:_currentPageIndex -1]]]
                                              options:SDWebImageCacheMemoryOnly
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                            }];
    [(UIImageView *)_imageViews[2] sd_setImageWithURL:[NSURL URLWithString:_imageNames[[self actualIndexWithIndex:_currentPageIndex +1]]]
                                     placeholderImage:[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_imageNames[[self actualIndexWithIndex:_currentPageIndex -1]]]
                                              options:SDWebImageCacheMemoryOnly
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                            }];
    
    [(UIScrollView *)(((UIImageView *)_imageViews[1]).superview) setZoomScale:1.0];
    if ([self needsupport]) {
        if (((UIImageView *)_imageViews[1]).image.size.height != 0 &&
            ((UIImageView *)_imageViews[1]).image.size.width != 0) {
            
            _jubaoButton.center = CGPointMake([self jubaoButtonOrigin].x +330,
                                              [self jubaoButtonOrigin].y);
        }
    }
    
    _pageControl.currentPage = _currentPageIndex;
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.bounds), 0);
}

- (CGPoint)jubaoButtonOrigin {
    
    float Yposition;
    float Xposition;
    float scaleRate = self.view.bounds.size.height/self.view.bounds.size.width;
    float imageScaleRate;
    
    BOOL scaleYfull = ((UIImageView *)_imageViews[1]).image.size.height/((UIImageView *)_imageViews[1]).image.size.width >= scaleRate ? YES :NO;
    
    if (scaleYfull == YES) {
        
        imageScaleRate = self.view.bounds.size.height /((UIImageView *)_imageViews[1]).image.size.height;
        Yposition = 0;
        Xposition = (self.view.bounds.size.width -((UIImageView *)_imageViews[1]).image.size.width *imageScaleRate) /2;
    }
    
    else if (scaleYfull == NO){
        
        imageScaleRate = self.view.bounds.size.width /((UIImageView *)_imageViews[1]).image.size.width;
        Yposition = (self.view.bounds.size.height -((UIImageView *)_imageViews[1]).image.size.height *imageScaleRate) /2;
        Xposition = 0;
    }
    
    CGPoint point = CGPointMake(Xposition +_jubaoButton.bounds.size.height/2, Yposition +_jubaoButton.bounds.size.height/2);
    
    return point;
}

- (NSInteger)actualIndexWithIndex:(NSInteger)index {
    
    NSInteger maximumIndex = [_imageNames count] - 1;
    NSInteger minimumIndex = 0;
    if (index > maximumIndex) {
        index = minimumIndex;
    }
    else if (index < 0) {
        index = maximumIndex;
    }
    return index;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _scrollView) {
        [self updateScrollViewWithContentOffset:scrollView.contentOffset];
    }
}

@end






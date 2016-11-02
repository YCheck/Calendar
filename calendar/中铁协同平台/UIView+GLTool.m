//
//  UIView+GLTool.m
//  EasyToVote
//
//  Created by gu on 16/1/4.
//  Copyright © 2016年 yp. All rights reserved.
//

#import "UIView+GLTool.h"


@implementation UIView (GLTool)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (UIViewController*)getViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

static CGFloat height = 0.5;
//头尾描边
- (void)strokeViewHeader:(BOOL)header footer:(BOOL)footer
{
    //头部描边
    if (header) {
        UIView *headerStroke = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, height)];
        headerStroke.backgroundColor = HEXCOLOR(0xe8eae9);
        headerStroke.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:headerStroke];
    }
    //尾部描边
    if (footer) {
        UIView *footerStroke = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - height, self.bounds.size.width, height)];
        footerStroke.backgroundColor = HEXCOLOR(0xe8eae9);
        footerStroke.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:footerStroke];
    }
}

//按比例增加描边
- (void)strokeViewRatio:(NSInteger)ratio header:(BOOL)header footer:(BOOL)footer
{
    for (int i=1; i<=ratio; i++) {
        CGFloat y = self.height / ratio * i;
        UIView *headerStroke = [[UIView alloc] init];
        headerStroke.backgroundColor = HEXCOLOR(0xe8eae9);
        [self addSubview:headerStroke];
        headerStroke.sd_layout.leftSpaceToView(self,0).topSpaceToView(self,y).rightSpaceToView(self,0).heightIs(height);
    }
    [self strokeViewHeader:header footer:footer];
}

- (UIImage *)screenshot:(BOOL)saveToLocal
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 2);
    //    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewScreenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (saveToLocal)
    {
        UIImageWriteToSavedPhotosAlbum(viewScreenshotImage,nil,nil,nil);
    }
    
    return viewScreenshotImage;
}


- (UIView *)duplicate
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

@end

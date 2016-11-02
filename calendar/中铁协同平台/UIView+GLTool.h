//
//  UIView+GLTool.h
//  EasyToVote
//
//  Created by gu on 16/1/4.
//  Copyright © 2016年 yp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GLTool)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;
- (UIViewController*) getViewController;//得到当前view所在控制器

//描边
- (void)strokeViewHeader:(BOOL)header footer:(BOOL)footer;
- (void)strokeViewRatio:(NSInteger)ratio header:(BOOL)header footer:(BOOL)footer;

- (UIImage *)screenshot:(BOOL)saveToLocal;//把view画成image
- (UIView*)duplicate;//序列化view
@end

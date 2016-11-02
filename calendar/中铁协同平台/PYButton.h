//
//  PYButton.h
//  EasyToVote
//
//  Created by gu on 16/1/6.
//  Copyright © 2016年 yp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PYButtonTypeBothSides_left_Title,//两边对齐 字在左边
    PYButtonTypeImageView_left,//左边对齐，图片在左边
    PYButtonTypeBothSides_left_Image,//两边对齐 图片在左边
    PYButtonTypeBothSides_center,//设置中心点
} PYButtonType;

@interface PYButton : UIButton

@property (nonatomic,assign) PYButtonType type;
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat right;

@property (nonatomic,assign) CGPoint labelPoint;
@property (nonatomic,assign) CGPoint imagePoint;

- (void)setType:(PYButtonType)type left:(CGFloat)left right:(CGFloat)right;
- (void)setType:(PYButtonType)type labelPoint:(CGPoint)labelPoint imagePoint:(CGPoint)imagePoint;
@end

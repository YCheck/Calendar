//
//  PYButton.m
//  EasyToVote
//
//  Created by gu on 16/1/6.
//  Copyright © 2016年 yp. All rights reserved.
//

#import "PYButton.h"

@implementation PYButton

- (void)setType:(PYButtonType)type left:(CGFloat)left right:(CGFloat)right
{
    _type = type;
    _left = left;
    _right = right;
}

- (void)setType:(PYButtonType)type labelPoint:(CGPoint)labelPoint imagePoint:(CGPoint)imagePoint
{
    _type = type;
    _labelPoint = labelPoint;
    _imagePoint = imagePoint;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_type == PYButtonTypeBothSides_left_Title) {
        self.titleLabel.left = _left;
        self.imageView.right = _right;
    }else if (_type == PYButtonTypeImageView_left)
    {
        self.imageView.left = _left;
        self.titleLabel.left = self.imageView.right + 5;
    }else if (_type == PYButtonTypeBothSides_left_Image)
    {
        self.imageView.left = _left;
        self.titleLabel.right = _right;
    }else if (_type == PYButtonTypeBothSides_center)
    {
        self.imageView.center = _imagePoint;
        [self.titleLabel sizeToFit];
        self.titleLabel.center = _labelPoint;
    }
}

@end

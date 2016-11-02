//
//  UIButton+AddGesture.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/21.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "UIButton+AddGesture.h"

@implementation UIButton (AddGesture)

- (void)addTarget:(id)target longAction:(SEL)longaction{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:longaction];
    longPress.minimumPressDuration = 1.0;
    [self addGestureRecognizer:longPress];
}

@end

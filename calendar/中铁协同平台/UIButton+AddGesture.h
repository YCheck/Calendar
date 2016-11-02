//
//  UIButton+AddGesture.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/21.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (AddGesture)

//添加手势
- (void)addTarget:(id)target longAction:(SEL)longaction;

@end

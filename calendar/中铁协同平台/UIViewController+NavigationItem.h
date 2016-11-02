//
//  UIViewController+NavigationItem.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/26.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationItem)
/*
 自定义导航栏 右边按钮
 title:标题
 */
- (void)YCY_customNavigationRightButton:(NSString *)title;


/*
 自定义导航栏 右边按钮点击事件
 */
- (void)YCY_customNavigationRightButtonClicked;
@end

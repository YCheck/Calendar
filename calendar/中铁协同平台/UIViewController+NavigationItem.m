//
//  UIViewController+NavigationItem.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/26.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "UIViewController+NavigationItem.h"

@implementation UIViewController (NavigationItem)

- (void)YCY_customNavigationRightButton:(NSString *)title{
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:title
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(YCY_customNavigationRightButtonClicked)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)YCY_customNavigationRightButtonClicked{
    
}

@end

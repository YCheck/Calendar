//
//  BaseViewController.h
//  中铁协同平台
//
//  Created by gu on 16/7/20.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)setRootViewController:(BOOL)isLogin;
- (void)showAlter:(NSString *)message;


@end

//
//  AppDelegate.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/18.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;
- (void)setRootViewController:(BOOL)isLogin;

@end


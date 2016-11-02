//
//  AppDelegate.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/18.
//  Copyright © 2016年 YCheng. All rights reserved.
//


#import "AppDelegate.h"
#import "UIImage+GLTool.h"
#import "CalendarViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    //如果要关注网络及授权验证事件，请设定   generalDelegate参数
    BOOL ret = [_mapManager start:BMKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    NSDictionary *dictText = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIColor whiteColor], NSForegroundColorAttributeName,nil];
    [[UINavigationBar appearance] setTitleTextAttributes:dictText];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:RGB(46, 122, 201) size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    [self setRootViewController:YES];
    return YES;
}

- (void)setRootViewController:(BOOL)isLogin
{
    if (isLogin) {
        UIStoryboard *loginStoryBoard = [UIStoryboard  storyboardWithName:@"Login" bundle:nil];
        UINavigationController *loginNav = [loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginNav"];
        self.window.rootViewController = loginNav;
    }else{
        CalendarViewController *calendarVC = [CalendarViewController new];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:calendarVC];
        self.window.rootViewController = navigation;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

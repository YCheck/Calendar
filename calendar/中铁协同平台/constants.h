//
//  constants.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/19.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#ifndef constants_h
#define constants_h
/**加载nib文件*/
#define LOAD_NIB(_NibName_) [[NSBundle mainBundle] loadNibNamed:_NibName_ owner:nil options:nil][0]
#define GetNIB(nibName) [UINib nibWithNibName:nibName bundle:nil]

//等比放大
#define AUTO_HIGHT(number) ScreenHeight > 500 ? number / 568.0 * ScreenHeight : number
#define AUTO_WIDTH(number) number / 320.0 * ScreenWidth

#define RECT(x,y,w,h) CGRectMake(x, y, AUTO_WIDTH(w), AUTO_HIGHT(h))

//获取ios系统版本
#define SystemVersion  [[[UIDevice currentDevice] systemVersion] floatValue]
//颜色
#define RGB(r,g,b) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1.]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//本地存储
#define PUTNSUserDefault(key,value) [[NSUserDefaults standardUserDefaults] setValue:value forKey:key]
#define GETNSUserDefault(key) [[NSUserDefaults standardUserDefaults] valueForKey:key]
#define REMOVENSUserDefault(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
//宽高
#define ScreenHeight     [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth      [[UIScreen mainScreen] bounds].size.width


#define WEAK_SELF                                     __weak typeof(self) weakSelf = self;







//百度key
#define BMKey @"Q3qfnpn6Dc1RFzs5TeawGuvcQzaLZ9jU"







#endif /* constants_h */

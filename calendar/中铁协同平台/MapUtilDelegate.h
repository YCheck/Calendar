//
//  MapUtilDelegate.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/28.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MapUtilDelegate <NSObject>

@optional
/*
    反编码成功代理
 */
- (void)YCY_CoordinateToLocationStringSuccessed:(BMKReverseGeoCodeResult *)result;

@end

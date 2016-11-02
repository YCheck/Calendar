//
//  ChooseLocationViewController.h
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/26.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CurrentMapType) {
    MapTypeChooseLocation = 0,   //位置选择
    MapTypeMember,//成员地图
    MapTypeMessageClicked,//从聊天信息点击跳转过来
    MapTypeSatellite,//卫星地图
    MapTypeStandard,//标准地图
};

typedef void(^ChooseLocationCompletion)(NSDictionary *locationInfo, UIImage *locationImage);
@interface ChooseLocationViewController : UIViewController

@property (nonatomic, copy) ChooseLocationCompletion chooseLocaiton;

@property (nonatomic, assign) CurrentMapType type;
@property (nonatomic) NSDictionary *coorDic;

@end

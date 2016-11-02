//
//  BaiDuLocation.h
//  五粮特曲(业务员)
//
//  Created by yangchengyou on 16/4/1.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "MapUtilDelegate.h"
@interface BaiDuLocation : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>


@property (nonatomic,weak,nullable) id<MapUtilDelegate> geocodeDelegate;

@property (nonatomic,retain,nullable) BMKLocationService * locService;
@property (nonatomic,retain,nullable) BMKGeoCodeSearch *geoCodeSearch;


+ ( nullable __kindof BaiDuLocation*)sharedInstance;

- (void)startLocationService;
- (void)stopLocationService;
- (void)destroyEntity;

/*百度地图  ： 坐标转地址*/
-(void)onBMKMapReverseGeocode:(CLLocationCoordinate2D)coordinate;

@end

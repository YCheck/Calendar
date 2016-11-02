//
//  BaiDuLocation.m
//  五粮特曲(业务员)
//
//  Created by yangchengyou on 16/4/1.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "BaiDuLocation.h"

@implementation BaiDuLocation

+ (BaiDuLocation *)sharedInstance{
    static dispatch_once_t pred;
    __strong static BaiDuLocation *sharedInternal = nil;
    
    dispatch_once(&pred, ^{
        sharedInternal = [[BaiDuLocation alloc] init];
    });
    
    return sharedInternal;
}


- (id)init
{
    self = [super init];
    if (self) {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    }
    return self;
}


#pragma mark --百度地图 delegate
//方向改变时
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self onClickReverseGeocode:userLocation];
    [_locService stopUserLocationService];
}

#pragma mark -- 开始反编码解析
-(void)onClickReverseGeocode:(BMKUserLocation *)userLocation
{
    //缓存中心点
//    NSString * location = [NSString stringWithFormat:@"%f,%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

//地址向经纬度解码
-(void)onClickGeocode:(NSString *)address{
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    geoCodeSearchOption.address = _startCity;
//    geoCodeSearchOption.city = _startCity;
    BOOL flag = [_geoCodeSearch geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}


-(void)onBMKMapReverseGeocode:(CLLocationCoordinate2D)coordinate
{
    //缓存中心点
    //    NSString * location = [NSString stringWithFormat:@"%f,%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude];
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

//正编码解析结果代理
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"地址转坐标 = %@",result);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

//反编码解析结果代理
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"坐标转地址 = %@",result);
        if ([_geocodeDelegate respondsToSelector:@selector(YCY_CoordinateToLocationStringSuccessed:)]) {
            [_geocodeDelegate YCY_CoordinateToLocationStringSuccessed:result];
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)startLocationService{
    [_locService startUserLocationService];
}


- (void)stopLocationService{
    [_locService stopUserLocationService];
}

- (void)destroyEntity{
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
    _locService = nil;
    _geoCodeSearch = nil;
}

- (void)dealloc{
    
}

@end

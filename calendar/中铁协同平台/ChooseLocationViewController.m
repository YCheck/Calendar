//
//  ChooseLocationViewController.m
//  中铁协同平台
//
//  Created by yangchengyou on 16/7/26.
//  Copyright © 2016年 YCheng. All rights reserved.
//

#import "ChooseLocationViewController.h"
#import "UIViewController+NavigationItem.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "BaiDuLocation.h"
#import "UIImage+Watermark.h"
@interface ChooseLocationViewController ()<BMKLocationServiceDelegate, BMKMapViewDelegate,MapUtilDelegate>
{
    NSMutableDictionary *_locationInfo;
    UILabel *_headerLabel;
    NSMutableArray *_locations;
}


@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic,retain) BMKGeoCodeSearch *geoCodeSearch;
@end

@implementation ChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    _locationInfo = [[NSDictionary alloc] init];
    
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = self;
    if (self.type == MapTypeMember) {
        self.mapView.zoomLevel = 11;
    }else{
        self.mapView.zoomLevel = 15;
    }
    self.mapView.minZoomLevel = 5;
    [self.view addSubview:self.mapView];
    
    self.locationService = [[BMKLocationService alloc] init];
    //定位精准度
    _locationService.desiredAccuracy = kCLLocationAccuracyBest;
    //距离筛选器(超过某个距离后进行用户的数据更新)
    _locationService.distanceFilter = 100;
    self.locationService.delegate = self;
    [self.locationService startUserLocationService];
    
    
    if (self.type == MapTypeChooseLocation) {
        self.title = @"选择位置";
        [self YCY_customNavigationRightButton:@"发送"];
        [self initWithHeaderView];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin_red"]];
        imageView.center = (CGPoint){self.mapView.center.x, self.mapView.center.y - 15.0f};
        [self.view addSubview:imageView];
    }else if (self.type == MapTypeMember){
        self.title = @"成员位置";
        [self YCY_customNavigationRightButton:@"卫星地图"];
        _locations = [NSMutableArray array];
    }else if(self.type == MapTypeMessageClicked){
        self.title = @"位置信息";
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor2;
        coor2.latitude = [self.coorDic[@"latitude"] doubleValue];
        coor2.longitude = [self.coorDic[@"longitude"] doubleValue];
        annotation.coordinate = coor2;
        annotation.title = @"他的位置";
        [_mapView addAnnotation:annotation];
        [_mapView setCenterCoordinate:coor2 animated:YES];
    }
    
}

//成员地图
- (void)initMemberMap{
    NSMutableArray *locationArr = [NSMutableArray array];
    locationArr = [self unarchiveFile];
    
    for (NSDictionary *dic in locationArr) {
        BMKPointAnnotation* a2 = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor2;
        coor2.latitude = [dic[@"latitude"] doubleValue];
        coor2.longitude = [dic[@"longitude"] doubleValue];
        a2.coordinate = coor2;
        a2.title = [NSString stringWithFormat:@"%f   %f",[dic[@"latitude"] floatValue],[dic[@"longitude"] floatValue]];
        [_locations addObject:a2];
    }
    [_mapView addAnnotations:_locations];
    
//    NSDictionary *dic = locationArr[0];
//    CLLocationCoordinate2D coor1;
//    coor1.latitude = [dic[@"latitude"] doubleValue];
//    coor1.longitude = [dic[@"longitude"] doubleValue];
//    CGPoint point =[_mapView convertCoordinate:coor1 toPointToView:self.view];
//    CGFloat ltX, bigY, bigX, ltY;
//    ltX = point.x;bigY = point.y;bigX = point.x;ltY = point.y;
//    for (int i = 1; i < locationArr.count; i++) {
//        NSDictionary *dic = locationArr[i];
//        CLLocationCoordinate2D coor2;
//        coor2.latitude = [dic[@"latitude"] doubleValue];
//        coor2.longitude = [dic[@"longitude"] doubleValue];
//        CGPoint pt =[_mapView convertCoordinate:coor2 toPointToView:_mapView];
//        NSLog(@"%f----%f",pt.x,pt.y);
//        if (pt.x < ltX) {
//            ltX = pt.x;
//        }
//        if (pt.x > bigX) {
//            bigX = pt.x;
//        }
//        if (pt.y > bigY) {
//            bigY = pt.y;
//        }
//        if (pt.y < ltY) {
//            ltY = pt.y;
//        }
//    }
//    
//    BMKMapRect rect;
//    BMKMapPoint mapPoint;
//    BMKMapSize mapSize;
//    mapPoint.x = ltX;
//    mapPoint.y = bigY;
//    rect.origin = mapPoint;
//    mapSize.width = bigX - ltX + _mapView.frame.size.width;
//    mapSize.height = bigY - ltY + _mapView.frame.size.height;
//    rect.size = mapSize;
//    [_mapView setVisibleMapRect:rect];
//    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
    
}

- (void)initWithHeaderView{
    _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _headerLabel.numberOfLines = 2;
    _headerLabel.textColor = [UIColor whiteColor];
    _headerLabel.backgroundColor = HEXCOLOR(0x999999);
    _headerLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_headerLabel];
}

#pragma mark -- BMKLocationServiceDelegate, BMKMapViewDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    [self.mapView updateLocationData:userLocation];
    if (self.type == MapTypeMessageClicked) {
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = userLocation.location.coordinate;
        annotation.title = @"我的位置";
        [_mapView addAnnotation:annotation];
    }else if(self.type == MapTypeChooseLocation){
        [self.mapView setCenterCoordinate:userLocation.location.coordinate];
    }else if (self.type == MapTypeMember){
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = userLocation.location.coordinate;
        annotation.title = @"我的位置";
        [_locations addObject:annotation];
        [self initMemberMap];
        [self.mapView setCenterCoordinate:userLocation.location.coordinate];
    }
    
    [self.locationService stopUserLocationService];
    
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //一次性显示 此处没重用
    if (self.type == MapTypeMember) {
        BMKAnnotationView *view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        view.image = [UIImage imageNamed:@"头像"];
        return view;
    }
    return nil;
    
}

-(void) mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (self.type == MapTypeChooseLocation) {
        CLLocationCoordinate2D coordinate = mapView.centerCoordinate;
        NSDictionary *dic = @{@"latitude":@(coordinate.latitude),@"longitude":@(coordinate.longitude)};
        _locationInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
        BaiDuLocation *baidu = [BaiDuLocation sharedInstance];
        baidu.geocodeDelegate = self;
        [baidu onBMKMapReverseGeocode:coordinate];
    }
    
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"点击了标注");
}

//BaiDuLocation代理
- (void)YCY_CoordinateToLocationStringSuccessed:(BMKReverseGeoCodeResult *)result{
    
    _headerLabel.text = [NSString stringWithFormat:@"  %@",result.address];
    [_locationInfo setValue:_headerLabel.text forKey:@"address"];
}

//重载
- (void)YCY_customNavigationRightButtonClicked{
    if (self.type == MapTypeChooseLocation) {
        [[[[[self.mapView subviews] firstObject] subviews] lastObject] removeFromSuperview];
        NSInteger imageW = 200;
        UIImage *image = [self.mapView takeSnapshot:CGRectMake(_mapView.center.x - imageW/2, _mapView.center.y - imageW/2, imageW, imageW)];
//        UIImage *markImage = [UIImage watermarkImage:image withName:_headerLabel.text];
        if (self.chooseLocaiton) {
            self.chooseLocaiton(_locationInfo,image);
            [self writeFile:_locationInfo];
        }
        [self.navigationController popViewControllerAnimated:YES];

    }else if (self.type == MapTypeMember){
        if (_mapView.mapType == BMKMapTypeSatellite) {
            _mapView.mapType = BMKMapTypeStandard;
            [self YCY_customNavigationRightButton:@"卫星地图"];
        }else{
            _mapView.mapType = BMKMapTypeSatellite;
            [self YCY_customNavigationRightButton:@"标准地图"];
        }
    }
}

//archive存储
- (void)writeFile:(NSDictionary *)locationInfo
{
    NSMutableArray *locationArr = [NSMutableArray array];
    NSMutableArray *currentArr = [self unarchiveFile];
    if (currentArr) {
        locationArr = currentArr;
    }
    [locationArr addObject:locationInfo];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:locationArr forKey:@"locations"];
    [archiver finishEncoding];
    [data writeToFile:[self getPath] atomically:YES];
}
- (NSMutableArray *)unarchiveFile
{
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:[self getPath]];
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    array = [unarchive decodeObjectForKey:@"locations"];
    [unarchive finishDecoding];
    return array;
}


- (NSString *)getPath
{
    //获得文件夹的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newPath = [path stringByAppendingPathComponent:@"archiver"];
    return newPath;
}


- (void)dealloc{
    _locationService.delegate = nil;
    _locationService = nil;
    _mapView.delegate = nil;
    _mapView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

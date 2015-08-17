//
//  MAPViewController.m
//  jibaobao
//
//  Created by songjw on 15/6/29.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "MAPViewController.h"
#import "defines.h"
#import "UIView+MyView.h"
#import <MapKit/MapKit.h>
#import "JTabBarController.h"

#import "UIImage+Rotate.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

//路线
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

//static MAPViewController *mapMainView;

@interface MAPViewController (){
    BMKGeoCodeSearch *_searcher;
}

@end

@implementation MAPViewController

//+ (MAPViewController *)shareManager{
//    @synchronized(self){
//        if (mapMainView == nil) {
//            mapMainView = [[self alloc]init];
//        }
//    }
//    return mapMainView;
//}

- (void)pointAnnotationTitle:(NSString *)title city:(NSString *) city latitude:(CGFloat)x longitude:(CGFloat)y{
//    NSString *str = [NSString stringWithFormat:@"%@%@",city,title];
//    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    _endTitle = title;
    _endCity = city;
    _endLatitude = x;
    _endLongitude = y;
    _endCoordinate.latitude = x;
    _endCoordinate.longitude = y;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT,  HEIGHT_CONTROLLER_DEFAULT)];
    _mapView.delegate = self;
    
    //UI控件
    _mapView.zoomEnabled = YES;   //设定地图View能否支持用户多点缩放(双指)
    _mapView.scrollEnabled = YES;   //设定地图View能否支持用户移动地图
    _mapView.showMapScaleBar = YES;   //设定是否显式比例尺
    
    //自定义比例尺的位置
    _mapView.mapScaleBarPosition = CGPointMake(5, 5);
    [_mapView setCompassPosition:CGPointMake(10,10)];//指南针位置
    
    [self.view addSubview:_mapView];
    
    UIButton *locationBut = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBut.frame = CGRectMake(5, HEIGHT_CONTROLLER_DEFAULT-80, 30, 30);
    [locationBut setImage:[UIImage imageNamed:@"map_03.png"] forState:UIControlStateNormal];
    [locationBut addTarget:self action:@selector(locationButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBut];
    
    UIButton *backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame = CGRectMake(5, 45, 20, 26);
    [backBut setImage:[UIImage imageNamed:@"map_05.png"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(backButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBut];
    
    UIButton *pathBut = [UIButton buttonWithType:UIButtonTypeCustom];
    pathBut.frame = CGRectMake(5, 120, 30, 30);
    [pathBut setImage:[UIImage imageNamed:@"map_02.png"] forState:UIControlStateNormal];
    pathBut.tag = 0;
    [pathBut addTarget:self action:@selector(bottomButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pathBut];
    
    
    UIButton *localMapBut = [UIButton buttonWithType:UIButtonTypeCustom];
    localMapBut.frame = CGRectMake(5, 160, 30, 30);
    [localMapBut setImage:[UIImage imageNamed:@"map_01.png"] forState:UIControlStateNormal];
    localMapBut.tag = 1;
    [localMapBut addTarget:self action:@selector(bottomButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:localMapBut];
    
    _detialBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _detialBut.frame = CGRectMake(5, 200, 30, 30);
    [_detialBut setImage:[UIImage imageNamed:@"map_04.png"] forState:UIControlStateNormal];
    _detialBut.tag = 2;
    [_detialBut addTarget:self action:@selector(bottomButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_detialBut];
    _detialBut.hidden = YES;

    _pathDetialTable = [[UITableView alloc]initWithFrame:CGRectMake(5, 200, 0, 0) style:UITableViewStyleGrouped];
    _pathDetialTable.delegate = self;
    _pathDetialTable.dataSource = self;
    _pathDetialTable.hidden = YES;
    
    [self.view addSubview:_pathDetialTable];
   
    [self geographyCode];
    
    //路线
    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = self;
    //定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    JTabBarController *jTabBarVC = [JTabBarController sharedManager];
    [jTabBarVC.tabBarView setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    _locService.delegate = nil;
    [_locService stopUserLocationService];
}

#pragma mark tableView
- (void)showTableview{
    [UIView animateWithDuration:0.5 animations:^{
        _pathDetialTable.hidden = NO;
        _pathDetialTable.frame = CGRectMake(0, HEIGHT_CONTROLLER_DEFAULT-180, WIDTH_CONTROLLER_DEFAULT, 180);
        [_pathDetialTable reloadData];
        
    }];
    
}
- (void)hideTableview{
    
    [UIView animateWithDuration:0.5 animations:^{
        _pathDetialTable.frame = CGRectMake(5, 220, 0, 0);
        _pathDetialTable.contentOffset = CGPointMake(0, 0);
        [_pathDetialTable reloadData];
        
    } completion:^(BOOL finished) {
        _pathDetialTable.hidden = YES;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    float a = round(_plan.distance/100.0);
    
    if (pathType == 1) {
        return [NSString stringWithFormat:@"公交  距离:%.1f公里 时间:%d小时%d分钟 ",a/10,_plan.duration.hours,_plan.duration.minutes];
        
    }else if (pathType == 2){
        return [NSString stringWithFormat:@"驾车  距离:%.1f公里 时间:%d小时%d分钟 ",a/10,_plan.duration.hours,_plan.duration.minutes];
        
    }else if (pathType == 3){
        return [NSString stringWithFormat:@"步行  距离:%.1f公里 时间:%d小时%d分钟 ",a/10,_plan.duration.hours,_plan.duration.minutes];
    }
    return @"您还未选择路线！";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _plan.steps.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
//    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        
        _cellImageview = [[UIImageView alloc]initWithFrame:CGRectMake(2, 10.5, 20.5, 20.5)];
        cell.imageView.backgroundColor = [UIColor blackColor];
        
        _cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 0, WIDTH_CONTROLLER_DEFAULT-23, 45)];
        _cellLabel.numberOfLines = 0;
        [cell addSubview:_cellImageview];
        [cell addSubview:_cellLabel];
    if (indexPath.row < _plan.steps.count) {
        BMKDrivingStep* transitStep = [_plan.steps objectAtIndex:indexPath.row];
        
        if (pathType == 1) {
            _cellImageview.image = [UIImage imageNamed:@"map_bus.png"];
        }else if (pathType == 2){
            _cellImageview.image = [UIImage imageNamed:@"map_texi.png"];
        }else if (pathType == 3){
            _cellImageview.image = [UIImage imageNamed:@"map_walk.png"];
        }

        _cellLabel.text = transitStep.instruction;
    }
    
    
//    }
    
    return cell;
}

#pragma mark   底部buttonAction
- (void)backButAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bottomButAction:(id)sender{
    UIButton *but = (UIButton *)sender;
    if (but.tag == 0) {
        [self hideTableview];
        
        if (_userNowLocation == nil) {
            [self locationButAction];
        }
        
        _pathAS = [[UIActionSheet alloc]initWithTitle:@"查看路线" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"公交", @"TEXI", @"步行", nil];
        [_pathAS showInView:self.view];
        
    }else if (but.tag == 1){
        
        CLLocationCoordinate2D startCoor = _userNowLocation.location.coordinate;
        CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(startCoor.latitude+0.01, startCoor.longitude+0.01);
        
        if (SYSTEM_VERSION_LESS_THAN(@"6.0")) { // ios6以下，调用google map
            
            NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d",startCoor.latitude,startCoor.longitude,endCoor.latitude,endCoor.longitude];
            urlString =  [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *aURL = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:aURL];
        } else { // 直接调用ios自己带的apple map
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil]];
            toLocation.name = @"to name";
            
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            
        }
        
        
    }else if (but.tag == 2){
        if (_pathDetialTable.hidden) {
            [self showTableview];
        }else{
            [self hideTableview];
        }
        
        
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet == _pathAS) {
        _detialBut.hidden = NO;
        switch (buttonIndex) {
            case 0:
                [self onClickBusSearch];
                break;
            case 1:
                [self onClickDriveSearch];
                break;
            case 2:
                [self onClickWalkSearch];
                break;
                
            default:
                break;
        }
    }
    
}
#pragma mark 地理编码
//正向
- (void)geographyCode{
    _searcher = [[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city = _endCity;
    geoCodeSearchOption.address = _endTitle;
    BOOL flag = [_searcher geoCode:geoCodeSearchOption];
    if (flag) {
        NSLog(@"geo检索发送成功");
    }else{
        NSLog(@"geo检索发送失败");
    }
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"正常结果");
        _endCoordinate = result.location;
        [self geographyReverseCode];
    }else{
        NSLog(@"抱歉，未找到结果");
    }
}

//反向
- (void)geographyReverseCode{
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = _endCoordinate;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    }
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"正常结果");
        _endTitle = result.address;
        
        //大头针
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = result.location;
        annotation.title = _endTitle;
        [_mapView addAnnotation:annotation];
        
        //显示中心点和范围
        _region.center = result.location;                      //中心点
        _region.span.latitudeDelta = 0.01;         //经度范围（设置为0.1表示显示范围为0.2的纬度范围）
        _region.span.longitudeDelta = 0.01;       //纬度范围
        [_mapView setRegion:_region animated:YES];
        
    }else{
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //线路
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
        
    }
    
    //大头针
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"map_flag.png"];
        return newAnnotationView;
    }
    
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark 定位

//定位button
- (void)locationButAction{
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //指定最小距离更新（米）
    [BMKLocationService setLocationDistanceFilter:10.f];
    
    //启动locationService
    [_locService startUserLocationService];
    
    if (_userNowLocation == nil) {
        _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态  罗盘态
        //    //以下_mapView为BMKMapView对象
        _mapView.showsUserLocation = YES;//显示定位图层
    }
}

//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    //    NSLog(@"heading is %@",userLocation.heading);
    [_mapView updateLocationData:userLocation];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _userNowLocation = userLocation;
    //转换GPS坐标至百度坐标
    [_mapView updateLocationData:userLocation];
}



#pragma mark 路线

//线路图片路径
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}


// 线路图片布置
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}


//公交
- (void)onClickBusSearch{
    pathType = 1;
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    start.name = @"我的位置";
    start.pt = _userNowLocation.location.coordinate;
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    end.name = _endTitle;
    end.pt = _endCoordinate;
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city = _endCity;
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    if (flag) {
        NSLog(@"bus检索发送成功");
    } else {
        NSLog(@"bus检索发送失败");
    }
    
}

//TEXI
-(void)onClickDriveSearch
{
    pathType = 2;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = @"我的位置";
    start.cityName = _endCity;
    start.pt = _userNowLocation.location.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = _endTitle;
    end.cityName = _endCity;
    end.pt = _endCoordinate;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}

//步行
-(void)onClickWalkSearch
{
    pathType = 3;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = @"我的位置";
    start.cityName = _endCity;
    start.pt = _userNowLocation.location.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = _endTitle;
    end.cityName = _endCity;
    end.pt = _endCoordinate;
    
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
    
}

//公交
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        _plan = plan;
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"我的位置";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = _endTitle;
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
    
}

//TEXI
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine *plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        _plan = plan;
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"我的位置";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = _endTitle;
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        //        // 添加途经点
        //        if (plan.wayPoints) {
        //            for (BMKPlanNode* tempNode in plan.wayPoints) {
        //                RouteAnnotation* item = [[RouteAnnotation alloc]init];
        //                item = [[RouteAnnotation alloc]init];
        //                item.coordinate = tempNode.pt;
        //                item.type = 5;
        //                item.title = tempNode.name;
        //                [_mapView addAnnotation:item];
        //            }
        //        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
        
    }
}

//步行
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        _plan = plan;
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"我的位置";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = _endTitle;
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
    
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
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

//
//  MAPViewController.h
//  jibaobao
//
//  Created by songjw on 15/6/29.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface MAPViewController : UIViewController <UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    
    UIActionSheet *_pathAS;
    
    NSString *_endTitle;
    NSString *_endCity;
    CGFloat _endLatitude;
    CGFloat _endLongitude;
    CLLocationCoordinate2D _endCoordinate;
    
    BMKUserLocation *_userNowLocation;
    
    //路线
    BMKRouteSearch *_routesearch;
    BMKCoordinateRegion _region;    //表示范围的结构体
    UITableView *_pathDetialTable;
    
    int pathType;   // 1: bus 2:texi 3:walk
    
    BMKRouteLine* _plan;
    
    UIImageView *_cellImageview;
    UILabel *_cellLabel;
    UIButton *_detialBut;
}

//+ (MAPViewController *)shareManager;
- (void)pointAnnotationTitle:(NSString *)title city:(NSString *) city latitude:(CGFloat)x longitude:(CGFloat)y ;

@end

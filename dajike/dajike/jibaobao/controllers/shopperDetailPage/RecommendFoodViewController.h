//
//  RecommendFoodViewController.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/9.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
     类：:::  推荐菜
 */


//test

#import "BackNavigationViewController.h"
#import "ShopDetailInfoModel.h"
#import "CouponDetailModel.h"

@interface RecommendFoodViewController : BackNavigationViewController<BarButtonDelegate>
@property (retain, nonatomic) NSString * test;

@property (strong, nonatomic) ShopDetailInfoModel *shopDetailInfoModel;

@property (strong, nonatomic) CouponDetailModel *couponModel;


@end

//
//  CashCouponTitleTextViewController.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/9.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
    类：  代金券图文详情
 */

#import "BackNavigationViewController.h"
#import "CouponDetailModel.h"
#import "GoodsDetailModel.h"
#import "KuaidiModel.h"

@interface CashCouponTitleTextViewController : BackNavigationViewController<BarButtonDelegate>

@property (strong, nonatomic) NSString *goodId;
@property (strong, nonatomic) NSMutableArray *picturesArr;
@property (strong, nonatomic) NSString *flagStr;//0.商品  1.代金券

@property (strong, nonatomic) CouponDetailModel *model;
@property (strong, nonatomic) GoodsDetailModel *goodModel;
@property (strong, nonatomic) KuaidiModel   *kuaidiModel;

@end

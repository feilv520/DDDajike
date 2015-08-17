//
//  DCouponOrderDetailViewController.h
//  dajike
//
//  Created by swb on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//




/*
 ****** 代金券订单详情
 */

#import "DBackNavigationViewController.h"
#import "DMyOrderModel.h"

typedef void (^CallbackToDMyOrderListViewController)();

@interface DCouponOrderDetailViewController : DBackNavigationViewController

@property (strong, nonatomic) DMyOrderModel *model;

@property (strong, nonatomic) NSMutableArray *couponArr;

@property (strong, nonatomic) CallbackToDMyOrderListViewController block;

- (void)callback:(CallbackToDMyOrderListViewController)block;

@end

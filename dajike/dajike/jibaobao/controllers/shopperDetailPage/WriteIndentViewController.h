//
//  WriteIndentViewController.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 **  类：  填写订单
 */

#import "BackNavigationViewController.h"
#import "CouponDetailModel.h"

@interface WriteIndentViewController : BackNavigationViewController<BarButtonDelegate>


@property (strong, nonatomic) CouponDetailModel *model;

@end

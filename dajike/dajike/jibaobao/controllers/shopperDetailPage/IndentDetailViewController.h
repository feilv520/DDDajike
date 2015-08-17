//
//  IndentDetailViewController.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/9.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 **  类描述： 代金劵订单详情
 */

#import "BackNavigationViewController.h"
#import "UserInfoModel.h"
#import "MyOrdersAjaxListModel.h"
#import "JTabBarController.h"

@interface IndentDetailViewController : BackNavigationViewController<BarButtonDelegate>

@property (strong, nonatomic)UserInfoModel *userInfoModel;
@property (strong, nonatomic) MyOrdersAjaxListModel *myOrderListModel;

@end

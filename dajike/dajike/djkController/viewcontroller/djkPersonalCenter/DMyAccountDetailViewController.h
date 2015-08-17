//
//  DMyAccountDetailViewController.h
//  dajike
//
//  Created by songjw on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//
typedef enum {
    CHONGZHI,//充值金额
    CHOUJIANG,//抽奖收益
    JIFEN,//积分收益
    JIANGLI,//奖励收益
    ZHANGHU,//收益账户
    YINGYEE,//营业额
} AccountDetailType;
#import "DBackNavigationViewController.h"

@interface DMyAccountDetailViewController : DBackNavigationViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,assign) AccountDetailType AccountDetailType;
@property (nonatomic ,assign) NSString * totalAccount;

@end

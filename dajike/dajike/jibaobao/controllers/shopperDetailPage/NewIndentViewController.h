//
//  NewIndentViewController.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 **   类：支付方式
 */


#import "BackNavigationViewController.h"
#import "CreateDingDanModel.h"
#import "MyAddressModel.h"

@interface NewIndentViewController : BackNavigationViewController<BarButtonDelegate>

@property (weak, nonatomic) IBOutlet UILabel *moneyLb;

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

//个人中心 付款
@property (strong, nonatomic) NSString *order_id;

//商品
@property (strong, nonatomic) NSString *flagstr;

@property (strong, nonatomic) MyAddressModel *model;

@property (strong, nonatomic) NSString *goodsName;

@property (strong, nonatomic) NSString *money;

@property (strong, nonatomic) NSMutableArray *arr;

@property (strong, nonatomic) NSString *yunfei;

// 0.购买商品   1.购买代金券
@property (strong, nonatomic) NSString *buyType;

@property (strong, nonatomic) NSString *payJine;

@property (assign, nonatomic) BOOL  isChongzhiSelect;

@property (assign, nonatomic) BOOL  isShouyiSelect;

@property (strong, nonatomic) CreateDingDanModel *dingdaoModel;

- (IBAction)paySuccessAction:(id)sender;


- (IBAction)selectPayAction:(id)sender;

@end

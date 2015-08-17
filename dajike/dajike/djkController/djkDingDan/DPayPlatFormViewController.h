//
//  DPayPlatFormViewController.h
//  dajike
//
//  Created by swb on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//




/*
 *******  选择支付平台
 */

#import "DBackNavigationViewController.h"
#import "DGoodsDetailModel.h"
#import "MyAddressModel.h"
#import "DMyOrderModel.h"
typedef enum {
    CHOUSHU,    //凑数
    COUPON,     //代金券
    MATERIRAL,  //商品
}buyType;

@interface DPayPlatFormViewController : DBackNavigationViewController

@property (weak, nonatomic) IBOutlet UILabel *payMoneyLb;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payMoneyCon;

// 1.购买商品   2.购买代金券
@property (strong, nonatomic) NSString *comeFrom;
@property (strong, nonatomic) NSString *orderId;
@property (assign, nonatomic) buyType buyType;
@property (strong, nonatomic) NSString *orderSn;
@property (strong, nonatomic) NSString *authUserId;
@property (strong, nonatomic) NSString *authAppId;

@property (strong, nonatomic) NSString *payJine;

@property (assign, nonatomic) BOOL  isChongzhiSelect;

@property (assign, nonatomic) BOOL  isShouyiSelect;

@property (strong, nonatomic) DGoodsDetailModel *goodDetailModel;
@property (strong, nonatomic) NSMutableArray *mArr;
//购物车
@property (strong, nonatomic) NSString *allMoney;
@property (strong, nonatomic) NSMutableArray *orderSnsArr;
@property (strong, nonatomic) NSMutableArray *deleteArr;
@property (strong, nonatomic) MyAddressModel *addressModel;
@property (strong, nonatomic) DMyOrderModel *myOrderModel;

- (IBAction)payAction:(id)sender;

@end

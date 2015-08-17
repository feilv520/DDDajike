//
//  DProductBuySuccessViewController.h
//  dajike
//
//  Created by swb on 15/7/22.
//  Copyright (c) 2015年 haixia. All rights reserved.
//



/*
 ******  商品购买成功
 */

#import "DBackNavigationViewController.h"
#import "DGoodsDetailModel.h"
#import "MyAddressModel.h"
#import "DMyOrderModel.h"
typedef enum {
    GOU_MAI,
    DUI_HUAN,
}mType;

@interface DProductBuySuccessViewController : DBackNavigationViewController

@property (strong, nonatomic) NSString *buyNumSt;
@property (assign, nonatomic) mType getType;
@property (strong, nonatomic) NSString *comeFrom;
@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) DGoodsDetailModel *goodDetailModel;
@property (strong, nonatomic) DMyOrderModel *myOrderModel;
@property (strong, nonatomic) NSMutableArray *mArr;
//购物车
@property (strong, nonatomic) NSString *allMoney;
@property (strong, nonatomic) NSMutableArray *orderSnsArr;
@property (strong, nonatomic) MyAddressModel *addressModel;

@end

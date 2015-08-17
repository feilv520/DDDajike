//
//  OrdersDetailModel.h
//  jibaobao
//
//  Created by songjw on 15/6/4.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrdersDetailModel : NSObject

@property (strong, nonatomic)NSString *choujiangbili;
@property (strong, nonatomic)NSString *addTime;
@property (strong, nonatomic)NSString *goodsName;
@property (strong, nonatomic)NSString *orderAmount;
@property (strong, nonatomic)NSString *orderSn;
@property (strong, nonatomic)NSString *price;
@property (strong, nonatomic)NSString *quantity;
@property (strong, nonatomic)NSString *sales;
@property (strong, nonatomic)NSString *status;
@property (strong, nonatomic)NSString *specName1;
@property (strong, nonatomic)NSString *specName2;
@property (strong, nonatomic)NSString *shippingFee;
@property (strong, nonatomic)NSString *address;
@property (strong, nonatomic)NSString *consignee;
@property (strong, nonatomic)NSString *regionName;
@property (strong, nonatomic)NSString *goodsImage;
@property (strong, nonatomic)NSString *phoneMob;
@property (strong, nonatomic)NSString *payTime;
@property (strong, nonatomic)NSString *shipTime;
@property (strong, nonatomic)NSString *yueJine;
@property (strong, nonatomic)NSString *yue;
@property (strong, nonatomic)NSString *koushuiYue;
@property (strong, nonatomic)NSString *storeId;
@property (strong, nonatomic)NSString *jifen;
//商品订单详情

@property (strong, nonatomic)NSString *spec1;
@property (strong, nonatomic)NSString *spec2;
@property (strong, nonatomic)NSString *goodsDesc;

//代金券订单详情

@property (strong, nonatomic)NSString *is_guoqitui;
@property (strong, nonatomic)NSString *code;
@property (strong, nonatomic)NSString *endTime;
@property (strong, nonatomic)NSString *is_suishitui;





@end

//
//  DMyOrderModel.h
//  dajike
//
//  Created by swb on 15/7/15.
//  Copyright (c) 2015年 haixia. All rights reserved.
//


/*
 ******   我的订单  外层Model
 */

#import <Foundation/Foundation.h>

@interface DMyOrderModel : NSObject

@property (strong, nonatomic) NSString *buyer_id;   //买家id

@property (strong, nonatomic) NSString *seller_name;//卖家名称

@property (strong, nonatomic) NSString *koushui_yue;//扣税余额

@property (strong, nonatomic) NSString *yueJine;    //余额金额

@property (strong, nonatomic) NSString *zhifu;      //支付

@property (strong, nonatomic) NSString *status;     //状态:0取消订单,10已支付,11待支付,20待发货,30已发货,40交易成功完

@property (strong, nonatomic) NSString *is_ziying;  //0非自营，1自营

@property (strong, nonatomic) NSString *buyer_name; //买家名称

@property (strong, nonatomic) NSString *order_id;   //订单id

@property (strong, nonatomic) NSString *type;       //订单类型，material普通,coupon 代金券

@property (strong, nonatomic) NSString *shipping_fee;//运费

@property (strong, nonatomic) NSString *goods_amount;//商品金额

@property (strong, nonatomic) NSString *yue;        //支付的不扣税余额

@property (strong, nonatomic) NSString *order_amount;//订单金额

@property (strong, nonatomic) NSString *order_sn;   //订单编号

@property (strong, nonatomic) NSString *seller_id;  //卖家id

@property (strong, nonatomic) NSString *invoice_no; //发货单号及快递公司

@property (strong, nonatomic) NSString *jifen;      //记录已支付积分
@property (strong, nonatomic) NSString *authUserId;
@property (strong, nonatomic) NSString *authAppId;
//自加字段，购买商品数量
@property (assign, nonatomic) int       buyNum;     //自加字段，购买商品数量
@property (assign, nonatomic) BOOL      isCommented;//自加字段，是否评论过

@end

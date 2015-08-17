//
//  MyOrdersAjaxListModel.h
//  jibaobao
//
//  Created by songjw on 15/5/28.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrdersAjaxListModel : NSObject
@property (retain, nonatomic) NSString* orderGoods;

@property (retain, nonatomic) NSString* order_amount;
@property (retain, nonatomic) NSString* order_id;
@property (retain, nonatomic) NSString* order_sn;
@property (retain, nonatomic) NSString* osStatus;
@property (retain, nonatomic) NSString* shipping_fee;    //退还金额/补偿金额
@property (retain, nonatomic) NSString* status;
@property (retain, nonatomic) NSString* type;
@property (retain, nonatomic) NSString* authUserId;
@property (retain, nonatomic) NSString* yueJine;
@property (retain, nonatomic) NSString* authAppId;
@property (retain, nonatomic) NSString* zhifu;
@property (nonatomic) BOOL isChecked;
@end

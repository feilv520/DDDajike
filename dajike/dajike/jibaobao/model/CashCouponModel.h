//
//  CashCouponModel.h
//  jibaobao
//
//  Created by swb on 15/5/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//





/*
 *****   美食列表--代金券
 */


#import <Foundation/Foundation.h>

@interface CashCouponModel : NSObject


@property (strong, nonatomic) NSString *price;          //出售价格

@property (strong, nonatomic) NSString *yonjin;         //佣金

@property (strong, nonatomic) NSString *market_price;   //原价

@property (strong, nonatomic) NSString *sales;          //销量

@property (strong, nonatomic) NSString *goods_id;       //代金券ID

@property (strong, nonatomic) NSString *goods_name;     //代金券名

@property (strong, nonatomic) NSString *default_image;  //代金券照片

@property (strong, nonatomic) NSString *org_price;      //供货价

@property (strong, nonatomic) NSString *choujiang_bili; //抽奖比例

@end

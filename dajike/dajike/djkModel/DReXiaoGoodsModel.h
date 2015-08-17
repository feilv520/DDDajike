//
//  DReXiaoGoodsModel.h
//  dajike
//
//  Created by dajike on 15/7/13.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

//热销商品
#import <Foundation/Foundation.h>

@interface DReXiaoGoodsModel : NSObject
@property (retain, nonatomic) NSString *default_image;
@property (retain, nonatomic) NSString *goods_id;
@property (retain, nonatomic) NSString *goods_name;
@property (retain, nonatomic) NSString *last_update;
@property (retain, nonatomic) NSString *org_price;
@property (retain, nonatomic) NSString *price;
@property (retain, nonatomic) NSString *start_time;
@property (retain, nonatomic) NSString *collect;
@property (retain, nonatomic) NSString *cate_id;
@property (retain, nonatomic) NSString *store_id;

//自营 推荐商品
@property (retain, nonatomic) NSString *haoping;
@property (retain, nonatomic) NSString *sort_order;
@property (retain, nonatomic) NSString *yunfei;
@property (retain, nonatomic) NSString *comments;


@end

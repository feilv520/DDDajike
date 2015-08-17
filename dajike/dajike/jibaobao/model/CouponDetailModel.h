//
//  CouponDetailModel.h
//  jibaobao
//
//  Created by swb on 15/5/29.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 ****  代金券详情-基本信息 Goods.couponDetail
 */

#import <Foundation/Foundation.h>

@interface CouponDetailModel : NSObject


@property (strong, nonatomic) NSString *goods_desc;                 //商品描述

@property (strong, nonatomic) NSString *goodscomments;              //商品评论总数

@property (strong, nonatomic) NSString *tel;                        //商家电话

@property (strong, nonatomic) NSString *goods_name;                 //商品名称

@property (strong, nonatomic) NSString *store_logo;                 //商家LOGO

@property (strong, nonatomic) NSString *start_time;                  //有效期开始时间

@property (strong, nonatomic) NSString *end_time;                    //有效期结束时间

@property (strong, nonatomic) NSString *default_image;              //商品默认图片

@property (strong, nonatomic) NSString *avgXingji;                  //商品平均星级数

@property (strong, nonatomic) NSString *use_rule_desc;              //代金券使用规则说明

@property (strong, nonatomic) NSString *unuse_time_desc;            //不可用时间说明

@property (strong, nonatomic) NSString *use_time_desc;              //使用时间说明

@property (strong, nonatomic) NSString *region_name;                //商家所属地区

@property (strong, nonatomic) NSString *price;                      //代金券价格

@property (strong, nonatomic) NSString *market_price;               //原价

@property (strong, nonatomic) NSString *address;                    //商家地址

@property (strong, nonatomic) NSString *sales;                      //销量

@property (strong, nonatomic) NSString *goods_id;                   //商品Id

@property (strong, nonatomic) NSString *store_id;                   //商家Id

@property (strong, nonatomic) NSString *store_name;                 //商家名称

@property (strong, nonatomic) NSString *choujiang_bili;             //抽奖比例

@property (strong, nonatomic) NSString *is_suishitui;               //随时退

@property (strong, nonatomic) NSString *is_guoqitui;                //过期退

@property (strong, nonatomic) NSString *is_yuyue;                   //免预约

@property (strong, nonatomic) NSString *renjun;                     //人均

@property (strong, nonatomic) NSString *cate_id;                    //分类Id

@property (strong, nonatomic) NSString *collect;                    //是否收藏，1表示已收藏，0表示未收藏

@end

//
//  ShopListModel.h
//  jibaobao
//
//  Created by swb on 15/5/26.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 ***  商家列表   方法Stores.list
 ***  商家列表   Stores.list   dfd

 */

#import <Foundation/Foundation.h>

@interface ShopListModel : NSObject


@property (strong, nonatomic) NSString *couponCounts;           //代金券总数

@property (strong, nonatomic) NSString *tag;                    //标签

@property (strong, nonatomic) NSString *region_id;              //地区ID

@property (strong, nonatomic) NSString *store_id;               //商家ID

@property (strong, nonatomic) NSString *cate_id;                //商家分类ID

@property (strong, nonatomic) NSString *store_logo;             //店铺logo

@property (strong, nonatomic) NSString *commentCount;           //评价总数

@property (strong, nonatomic) NSString *coupons;                //代金券（数组）

@property (strong, nonatomic) NSString *region_name;            //地区名

@property (strong, nonatomic) NSString *distance;               //距离

@property (strong, nonatomic) NSString *address;                //详细地址

@property (strong, nonatomic) NSString *longitude;              //经度

@property (strong, nonatomic) NSString *latitude;               //纬度

@property (strong, nonatomic) NSString *store_name;             //商家名称

@property (strong, nonatomic) NSString *renjun;                 //人均费用

@property (strong, nonatomic) NSString *ordersCount;            //商家人气总数

@property (strong, nonatomic) NSString *cate_name;              //分类名

@property (strong, nonatomic) NSString *avgxingji;              //星级

@end

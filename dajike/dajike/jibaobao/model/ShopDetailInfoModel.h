//
//  ShopDetailInfoModel.h
//  jibaobao
//
//  Created by swb on 15/6/3.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
 *****  商家详情—基本信息  Stores.detail
 */

#import <Foundation/Foundation.h>

@interface ShopDetailInfoModel : NSObject

@property (strong, nonatomic) NSString *recommendGoodsList;      //推荐商品列表

@property (strong, nonatomic) NSString *couponList;     //优惠券列表

@property (strong, nonatomic) NSString *commentcount;   //评价总数

@property (strong, nonatomic) NSString *address;        //详细地址

@property (strong, nonatomic) NSString *avgxingji;      //星级

@property (strong, nonatomic) NSString *store_id;       //商家ID

@property (strong, nonatomic) NSString *tel;            //电话

@property (strong, nonatomic) NSString *file_path;            //相册封面

@property (strong, nonatomic) NSString *yye_time;       //营业时间

@property (strong, nonatomic) NSString *couponCount;    //代金券总数

@property (strong, nonatomic) NSString *store_logo;     //店铺图片

@property (strong, nonatomic) NSString *description2;   //简短描述

@property (strong, nonatomic) NSString *imageCount;       //照片总数

@property (strong, nonatomic) NSString *store_name;     //商家名称

@property (strong, nonatomic) NSString *collect;        //是否收藏，1表示已收藏，0表示未收藏

@property (strong, nonatomic) NSString *pregionName;

@property (strong, nonatomic) NSString *region_name;

@property (strong, nonatomic) NSString *longitude;

@property (strong, nonatomic) NSString *latitude;

@end

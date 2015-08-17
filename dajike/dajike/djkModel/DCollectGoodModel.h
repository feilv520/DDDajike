//
//  DCollectGoodModel.h
//  dajike
//
//  Created by songjw on 15/7/17.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCollectGoodModel : NSObject

@property (strong, nonatomic) NSString *price;          //商品价格
@property (strong, nonatomic) NSString *market_price;   //商品原价
@property (strong, nonatomic) NSString *sales;          //销量
@property (strong, nonatomic) NSString *item_id;
@property (strong, nonatomic) NSString *goods_id;       //商品id
@property (strong, nonatomic) NSString *goods_name;     //商品名称
@property (strong, nonatomic) NSString *add_time;       //收藏时间
@property (strong, nonatomic) NSString *type;           //商品类型--'material'为普通商品
@property (strong, nonatomic) NSString *default_image;  //图片路径
@property (strong, nonatomic) NSString *choujiang_bili; //抽奖比例
@property (strong, nonatomic) NSString *store_name;     //店铺名称
@property (strong, nonatomic) NSString *yunfei;
@property (strong, nonatomic) NSString *haoping;
@property (nonatomic) BOOL isChecked;

@end

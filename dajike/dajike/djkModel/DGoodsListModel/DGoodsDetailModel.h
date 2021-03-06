//
//  DGoodsDetailModel.h
//  dajike
//
//  Created by swb on 15/7/23.
//  Copyright (c) 2015年 haixia. All rights reserved.
//



/*
 *****  商品详情Model
 */

#import <Foundation/Foundation.h>

@interface DGoodsDetailModel : NSObject

@property (strong, nonatomic) NSString *goodsId;
@property (strong, nonatomic) NSString *spec1;
@property (strong, nonatomic) NSString *specName1;
@property (strong, nonatomic) NSString *spec2;
@property (strong, nonatomic) NSString *specName2;
@property (strong, nonatomic) NSString *storeId;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeLogo;
@property (strong, nonatomic) NSString *goodsName;
@property (strong, nonatomic) NSString *goodsDefaultImage;
@property (strong, nonatomic) NSString *specId;
@property (strong, nonatomic) NSString *goodsPrice;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *stock;
@property (strong, nonatomic) NSString *ifJifen;

@end

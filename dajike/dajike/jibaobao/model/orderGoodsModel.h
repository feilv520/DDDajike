//
//  orderGoodsModel.h
//  jibaobao
//
//  Created by songjw on 15/5/28.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderGoodsModel : NSObject

@property (retain, nonatomic) NSString* goods_image;
@property (retain, nonatomic) NSString* goods_name;
@property (retain, nonatomic) NSString* price;
@property (retain, nonatomic) NSString* quantity;
@property (retain, nonatomic) NSString* rec_id;
@property (retain, nonatomic) NSString* specification;
@property (retain, nonatomic) NSString* comments;
@property (strong, nonatomic) NSString* if_jifen;
//大集客订单
@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *create_time;
//自加字段，判断有木有评论过
@property (assign, nonatomic) BOOL isCommented;

@end
//
//  GoodsCommentModel.h
//  jibaobao
//
//  Created by swb on 15/5/25.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 **  商品详情---- 评论methode : Goods.comments
 */

#import <Foundation/Foundation.h>

@interface GoodsCommentModel : NSObject


@property (strong, nonatomic) NSString *xingji;                          //评价级别

@property (strong, nonatomic) NSString *commentTime;                    //评价时间

@property (strong, nonatomic) NSString *content;                        //评价内容

@property (strong, nonatomic) NSString *buyerName;                      //买家用户名

@property (strong, nonatomic) NSString *img;                         //评论对应图片（可能为空或是数组，不是必输出字段）

@property (strong, nonatomic) NSString *rec;                            //频道

@property (strong, nonatomic) NSString *is_anony;                       //是否匿名(0为否 1为是)


@end

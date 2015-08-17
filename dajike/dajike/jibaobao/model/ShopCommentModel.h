//
//  ShopCommentModel.h
//  jibaobao
//
//  Created by swb on 15/6/3.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 *商家详情—商家评论  Stores.comments
 */

#import <Foundation/Foundation.h>

@interface ShopCommentModel : NSObject

@property (strong, nonatomic) NSString *user_name;      //用户名

@property (strong, nonatomic) NSString *xingji;         //星级

//@property (strong, nonatomic) NSString *title;          //标题

@property (strong, nonatomic) NSString *img;      //评论附带照片

@property (strong, nonatomic) NSString *time_comment;   //评论时间

@property (strong, nonatomic) NSString *store_name;     //商家名

@property (strong, nonatomic) NSString *comments;       //评论内容

@property (strong, nonatomic) NSString *is_anony;       //是否匿名 1为匿名

@property (strong, nonatomic) NSString *user_id;        //

@property (strong, nonatomic) NSString *comments_id;

@end

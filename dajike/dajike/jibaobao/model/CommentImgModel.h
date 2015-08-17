//
//  CommentImgModel.h
//  jibaobao
//
//  Created by swb on 15/6/16.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 
 *****  带图评论
 */

#import <Foundation/Foundation.h>

@interface CommentImgModel : NSObject

@property (strong, nonatomic) NSString *img_url;    //图片路径

@property (strong, nonatomic) NSString *create_time;    //图片创建时间

@end

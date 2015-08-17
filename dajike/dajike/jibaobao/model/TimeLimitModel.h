//
//  TimeLimitModel.h
//  jibaobao
//
//  Created by dajike on 15/5/25.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

/*
 限时优惠
 */
#import <Foundation/Foundation.h>

@interface TimeLimitModel : NSObject
//ID
@property (retain, nonatomic) NSString* id;
//图片链接
@property (retain, nonatomic) NSString* img;
//原价
@property (retain, nonatomic) NSString* marketPrice;
//商家名称
@property (retain, nonatomic) NSString* name;
//价格
@property (retain, nonatomic) NSString* price;
//类型
@property (retain, nonatomic) NSString* type;
@end

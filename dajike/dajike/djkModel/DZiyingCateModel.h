//
//  DZiyingCateModel.h
//  dajike
//
//  Created by dajike on 15/7/21.
//  Copyright (c) 2015年 haixia. All rights reserved.
//


//大集客自营 除推荐商品页面的cell model
#import <Foundation/Foundation.h>

@interface DZiyingCateModel : NSObject
@property (strong, nonatomic) NSString *cateId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subcate;
@property (strong, nonatomic) NSString *img;
@property (strong, nonatomic) NSString *linkType;

@property (strong, nonatomic) NSString *goodsId;
@end

//
//  ProductDetailViewController.h
//  jibaobao
//
//  Created by swb on 15/5/22.
//  Copyright (c) 2015年 dajike. All rights reserved.
//






/*
 **   商品详情
 */

#import "BackNavigationViewController.h"

@interface ProductDetailViewController : BackNavigationViewController<BarButtonDelegate>

@property (strong, nonatomic) NSString *goodId;
@property (strong, nonatomic) NSString *goodsImageStr;

@end

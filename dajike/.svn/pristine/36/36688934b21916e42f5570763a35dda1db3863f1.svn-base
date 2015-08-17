//
//  ProductSortViewController.h
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
  **   商品列表---》商品分类
 */

#import "BackNavigationViewController.h"

typedef void (^CallbackAllProductBlock)(NSString *cateId,NSString *tit);

@interface ProductSortViewController : BackNavigationViewController<BarButtonDelegate>

@property (strong, nonatomic) CallbackAllProductBlock block;

- (void)callBackProduct:(CallbackAllProductBlock)block;

@end

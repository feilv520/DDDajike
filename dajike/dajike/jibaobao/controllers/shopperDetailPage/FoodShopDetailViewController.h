//
//  FoodShopDetailViewController.h
//  jibaobao
//
//  Created by swb on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 **   类：  美食商家详情
 */

#import "BackNavigationViewController.h"

typedef void (^CallBackFoodVCBlock)();

@interface FoodShopDetailViewController : BackNavigationViewController<BarButtonDelegate>

@property (strong, nonatomic) NSString *flagStr;
@property (strong, nonatomic) NSString *storeId;
@property (strong, nonatomic) NSString *cityName;

@property (strong, nonatomic) CallBackFoodVCBlock block;

- (void)callBackFoodVC:(CallBackFoodVCBlock)block;

@end

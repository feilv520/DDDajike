//
//  BuySuccessViewController.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
 
    类 ：   购买成功
 */


#import "BackNavigationViewController.h"

@interface BuySuccessViewController : BackNavigationViewController<BarButtonDelegate>

@property (strong, nonatomic) NSString *goodName;

@property (strong, nonatomic) NSMutableArray *arr;

@end

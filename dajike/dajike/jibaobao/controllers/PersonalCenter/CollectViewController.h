//
//  CollectViewController.h
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

/*
 我的收藏  商家／优惠券
 */

typedef enum {
    COUPON,//优惠券
    SHOPS,//商家
} collectType;
#import "BackNavigationViewController.h"

@interface CollectViewController : BackNavigationViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, assign) collectType collectType;
@end

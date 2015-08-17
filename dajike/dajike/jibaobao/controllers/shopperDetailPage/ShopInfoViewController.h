//
//  ShopInfoViewController.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/9.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



//  类 ：  商家详情   图片

#import "BackNavigationViewController.h"
#import "DMLazyScrollView.h"
#import "MySelectView.h"

@interface ShopInfoViewController : BackNavigationViewController<BarButtonDelegate,ViewSelectDelegate,DMLazyScrollViewDelegate>
{
    MySelectView        *_mySelectView;
    DMLazyScrollView    *_lazyScrollView;
    NSMutableArray      *_viewControllerArray;
}

@property (strong, nonatomic) NSString *storeId;

@end

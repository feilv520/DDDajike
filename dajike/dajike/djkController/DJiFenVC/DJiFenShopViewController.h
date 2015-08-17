//
//  DJiFenShopViewController.h
//  dajike
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBaseViewController.h"

typedef void (^CallBackDWebViewController)();

@interface DJiFenShopViewController : DBaseViewController

@property (nonatomic, strong) NSString *storeId;

@property (strong,nonatomic)    CallBackDWebViewController block;

- (void)callBack:(CallBackDWebViewController)block;

@end

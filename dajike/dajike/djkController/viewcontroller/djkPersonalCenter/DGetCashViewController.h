//
//  DGetCashViewController.h
//  dajike
//
//  Created by songjw on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBackNavigationViewController.h"

@interface DGetCashViewController : DBackNavigationViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *totalAccount;

@end

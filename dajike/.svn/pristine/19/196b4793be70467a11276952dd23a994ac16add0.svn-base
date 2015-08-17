//
//  DMyAddressListViewController.h
//  dajike
//
//  Created by songjw on 15/7/13.
//  Copyright (c) 2015年 haixia. All rights reserved.
//




/*
 *****  安全设置和收货地址列表共用界面
 */

#import "DBackNavigationViewController.h"
@class MyAddressModel;
typedef enum{
    ADDRESS,
    SAFE,
}Address_Safe;

typedef void (^CallbackDConfirmOrderViewController)(MyAddressModel *addressModel);

@interface DMyAddressListAndSafeViewController : DBackNavigationViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) Address_Safe address_safe;
@property (strong, nonatomic) NSString *fromWhere;

@property (strong, nonatomic) CallbackDConfirmOrderViewController block;
- (void)callback:(CallbackDConfirmOrderViewController)block;

@end

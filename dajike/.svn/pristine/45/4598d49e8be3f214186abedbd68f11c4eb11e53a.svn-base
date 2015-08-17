//
//  MyAddressListViewController.h
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

/*
 地址管理
 */
#import "BackNavigationViewController.h"
#import "MyAddressModel.h"

typedef void (^CallBackAddressBlock)(MyAddressModel *addressModel);

@interface MyAddressListViewController : BackNavigationViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) CallBackAddressBlock mBlock;

@property (strong, nonatomic) NSString *flagStr;

- (void)callBackAddress:(CallBackAddressBlock)block;

@end

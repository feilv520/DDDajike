//
//  SafetySettingViewController.h
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 安全设置
 */
#import "BackNavigationViewController.h"
#import "UserInfoModel.h"
@interface SafetySettingViewController : BackNavigationViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)UserInfoModel *userInfoModel;
@end

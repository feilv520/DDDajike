//
//  MyNameViewController.h
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

/*
 姓名
 */
#import "BackNavigationViewController.h"
#import "UserInfoModel.h"
@interface MyNameViewController : BackNavigationViewController

@property (strong,nonatomic) UserInfoModel *userInfoModel;
@end

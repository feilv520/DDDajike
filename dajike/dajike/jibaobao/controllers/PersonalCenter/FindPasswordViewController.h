//
//  FindPasswordViewController.h
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 找回密码 手机 邮箱 邮箱发送成功
 */

//typedef enum {
//    PHONEPAGE,//优惠券
//    SHOPS,//商家
//} collectType;
#import "BackNavigationViewController.h"
#import "UserInfoModel.h"

@interface FindPasswordViewController : BackNavigationViewController
@property (strong, nonatomic) UserInfoModel *userModel;

@end

//
//  SendOutHongBaoViewController.h
//  jibaobao
//
//  Created by swb on 15/6/1.
//  Copyright (c) 2015年 dajike. All rights reserved.
//





/*
 ****   发出红包详情---- 领完   未领完
 */

#import "BackNavigationViewController.h"

@interface SendOutHongBaoViewController : BackNavigationViewController<BarButtonDelegate>

@property (strong, nonatomic) NSString *hongbao_id;

@end

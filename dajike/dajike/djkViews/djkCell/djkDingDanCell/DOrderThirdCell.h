//
//  DOrderThirdCell.h
//  dajike
//
//  Created by swb on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMyOrderModel.h"
#import "OrdersDetailModel.h"

@interface DOrderThirdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLb;
@property (weak, nonatomic) IBOutlet UILabel *yueLb;
@property (weak, nonatomic) IBOutlet UILabel *chongzhiLb;
@property (weak, nonatomic) IBOutlet UILabel *shifukuanLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView1Con;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView2Con;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView3Con;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView4Con;

@property (strong, nonatomic) DMyOrderModel *model;
@property (strong, nonatomic) OrdersDetailModel *orderDetailModel;

@end
//
//  DOrderFirstCell.h
//  dajike
//
//  Created by swb on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrdersDetailModel.h"
#import "DGoodsDetailModel.h"

@interface DOrderFirstCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLb;

@property (strong, nonatomic) OrdersDetailModel *model;
@property (strong, nonatomic) DGoodsDetailModel *goodsDetailModel;
@property (assign, nonatomic) int ifJiFen;

@end

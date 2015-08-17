//
//  SwbCell5.h
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrdersDetailModel.h"

@interface SwbCell5 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *orderAmount;

@property (strong, nonatomic)OrdersDetailModel *ordersDetailModel;

@end

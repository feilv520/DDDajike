//
//  SwbCell8.h
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrdersDetailModel.h"

@interface SwbCell8 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;

@property (strong, nonatomic)OrdersDetailModel *ordersDetailModel;
@end

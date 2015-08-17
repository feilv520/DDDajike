//
//  DOrderFourthCell.h
//  dajike
//
//  Created by swb on 15/8/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrdersDetailModel.h"

@interface DOrderFourthCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *xiadanTime;
@property (weak, nonatomic) IBOutlet UILabel *fahuoTime;

@property (strong, nonatomic) OrdersDetailModel *model;
@end

//
//  AccountDetail2Cell.h
//  jibaobao
//
//  Created by dajike on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountDetailModel.h"

@interface AccountDetail2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *lab_1;

//充值金额
@property (retain, nonatomic)AccountDetailModel *accountDetailModel;
@end

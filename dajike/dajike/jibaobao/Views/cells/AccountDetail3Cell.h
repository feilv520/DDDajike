//
//  AccountDetail3Cell.h
//  jibaobao
//
//  Created by dajike on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountDetailModel.h"

@interface AccountDetail3Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *money1Label;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label1;
//收益账户
@property (retain, nonatomic)AccountDetailModel *accountDetailModel;
@end

//
//  BoundBankCardCell.h
//  jibaobao
//
//  Created by dajike on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

//绑定银行卡
#import <UIKit/UIKit.h>
#import "BankBoundListModel.h"

@interface BoundBankCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bandIconImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNumberLabel;
@property (retain, nonatomic) BankBoundListModel *bankBoundModel;

@end

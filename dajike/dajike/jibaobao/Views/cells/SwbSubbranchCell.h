//
//  SwbSubbranchCell.h
//  jibaobao
//
//  Created by swb on 15/5/20.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CouponDetailModel.h"

typedef void (^PhoneCallBlock)();

@interface SwbSubbranchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storLogoImg;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLb;

@property (weak, nonatomic) IBOutlet UILabel *shopAddressLb;

@property (strong, nonatomic) PhoneCallBlock block;

@property (strong, nonatomic) CouponDetailModel *model;

- (IBAction)phoneCallAction:(id)sender;

- (void)callBackPhoneCall:(PhoneCallBlock)block;

@end

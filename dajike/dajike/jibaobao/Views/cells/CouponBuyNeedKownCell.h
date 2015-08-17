//
//  CouponBuyNeedKownCell.h
//  jibaobao
//
//  Created by swb on 15/5/29.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponDetailModel.h"

@interface CouponBuyNeedKownCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *youxiaoqiLb;

@property (weak, nonatomic) IBOutlet UILabel *unUseTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *useTimeiLb;
@property (weak, nonatomic) IBOutlet UILabel *useRuleLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unUseTimeCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *useTimeCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *useRuleCon;

@property (strong, nonatomic) CouponDetailModel *model;

@end

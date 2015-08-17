//
//  CouponBuyNeedKownCell.m
//  jibaobao
//
//  Created by swb on 15/5/29.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "CouponBuyNeedKownCell.h"
#import "defines.h"

@implementation CouponBuyNeedKownCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(CouponDetailModel *)model
{
    NSString *startTime = [commonTools timesToDate:[NSString stringWithFormat:@"%@",model.start_time]];
    NSString *endTime   = [commonTools timesToDate:[NSString stringWithFormat:@"%@",model.end_time]];
    
    self.youxiaoqiLb.text       = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
    self.unUseTimeLb.text       = [NSString stringWithFormat:@"%@",model.unuse_time_desc];
    CGRect rect1 = [self contentAdaptionLabel:self.unUseTimeLb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:13.0f];
    self.unUseTimeCon.constant  = rect1.size.height + 5;
    
    self.useTimeiLb.text        = [NSString stringWithFormat:@"%@",model.use_time_desc];
    CGRect rect2 = [self contentAdaptionLabel:self.useTimeiLb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:13.0f];
    self.useTimeCon.constant    = rect2.size.height + 5;
    
    self.useRuleLb.text         = [NSString stringWithFormat:@"%@",model.use_rule_desc];
    CGRect rect3 = [self contentAdaptionLabel:self.useRuleLb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:13.0f];
    self.useRuleCon.constant    = rect3.size.height + 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

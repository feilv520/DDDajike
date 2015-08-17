//
//  CashCouponCell.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/7.
//  Copyright (c) 2015年 dajike. All rights reserved.
//





/*
 *8   \\  代金券的CEll
 */

#import "CashCouponCell.h"
#import "defines.h"

@implementation CashCouponCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(CashCouponModel *)model
{
    self.priceLb.text       = [NSString stringWithFormat:@"¥%.1f",[model.price floatValue]];
    CGRect rect1 = [self contentAdaptionLabel:self.priceLb.text withSize:CGSizeMake(100, 30) withTextFont:15.0f];
    self.priceWidthCon.constant = rect1.size.width+5;
    
    
    if ([model.market_price floatValue]>0) {
        self.notPriceLb.text    = [NSString stringWithFormat:@"%.1f",[model.market_price floatValue]];
        CGRect rect2 = [self contentAdaptionLabel:self.notPriceLb.text withSize:CGSizeMake(100, 30) withTextFont:13.0f];
        self.norPriceWidthCon.constant = rect2.size.width+5;
        self.notPriceLb.hidden = NO;
    }else {
        self.norPriceWidthCon.constant = 1;
        self.notPriceLb.hidden = YES;
    }
    
    
    self.discriptionLb.text = model.goods_name;
    self.lotteryLb.text     = [NSString stringWithFormat:@"%.0f%%累计抽奖",[model.choujiang_bili floatValue]*100];
    self.cellOutLb.text     = [NSString stringWithFormat:@"已售%d",[model.sales intValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

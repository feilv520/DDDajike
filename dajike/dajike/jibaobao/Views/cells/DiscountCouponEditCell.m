//
//  DiscountCouponEditCell.m
//  jibaobao
//
//  Created by dajike on 15/5/13.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "DiscountCouponEditCell.h"
#include "UIImageView+WebCache.h"
@implementation DiscountCouponEditCell



- (void)confng:(CollectModel *)model
{
    
    self.SoldNumberLabel.text = [NSString stringWithFormat:@"已售:%@",model.sales];
    self.ProbabilityLabel.text = [NSString stringWithFormat:@"%@%%累计抽奖",model.choujiang_bili];//model.choujiang_bili;
    self.JIanjieLabel.text = model.goods_name;
    self.TitleLabel.text = model.store_name;
    // [self.HeadImageView sd_setImageWithURL:[NSURL URLWithString:model.store_logo]];//图片
    self.NewPriceLabel.text = [NSString stringWithFormat:@"%d 元",[model.market_price intValue]];
    self.OldPriceLabel.text  = [NSString stringWithFormat:@"%d 元",[model.price intValue]];
    // self.statusImageView.image = [UIImage imageNamed:@"img_no_selected.png"];
    self.HeadImageView.image = [UIImage imageNamed:@"img_jiazai"];//代替图片
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

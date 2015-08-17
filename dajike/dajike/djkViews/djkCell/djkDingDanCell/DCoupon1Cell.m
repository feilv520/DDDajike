//
//  DCoupon1Cell.m
//  dajike
//
//  Created by swb on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DCoupon1Cell.h"
#import "dDefine.h"

@implementation DCoupon1Cell

- (void)awakeFromNib {
    // Initialization code
    self.goodImg.layer.cornerRadius = 6.0f;
    self.goodImg.layer.masksToBounds = YES;
}

- (void)setModel:(OrdersDetailModel *)model
{
    [self.goodImg setImageWithURL:[commonTools getImgURL:model.goodsImage] placeholderImage:DPlaceholderImage];
    self.goodName.text = model.goodsName;
    self.priceLb.text = [NSString stringWithFormat:@"%.2f元",[model.price floatValue]];
    self.salesLb.text = [NSString stringWithFormat:@"已售%d",[model.sales intValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

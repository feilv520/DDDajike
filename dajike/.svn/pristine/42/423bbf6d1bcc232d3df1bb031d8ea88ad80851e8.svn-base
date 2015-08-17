//
//  IndentDetailCell1.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "IndentDetailCell1.h"
#import "defines.h"
#import "commonTools.h"

@implementation IndentDetailCell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setOrdersDetailModel:(OrdersDetailModel *)ordersDetailModel{
    self.descriptionLb.text = ordersDetailModel.goodsName;
    self.sellOutLb.text = [NSString stringWithFormat:@"已售%@",ordersDetailModel.sales];
    self.priceLb.text = [NSString stringWithFormat:@"¥%d元",[ordersDetailModel.price intValue]];
    self.notPriceLb.text = [NSString stringWithFormat:@"%d",[ordersDetailModel.price intValue]];
    self.notPriceLb.strikeThroughEnabled = YES;
    self.notPriceLb.strikeThroughColor = [UIColor redColor];
    self.lotteryLb.text = [NSString stringWithFormat:@"%.0f%%累计抽奖",[ordersDetailModel.choujiangbili floatValue]*100];
    [self.headImgVC setImageWithURL:[commonTools getImgURL:ordersDetailModel.goodsImage] placeholderImage:PlaceholderImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

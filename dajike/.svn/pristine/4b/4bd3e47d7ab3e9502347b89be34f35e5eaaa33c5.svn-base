//
//  IndentDetailCell3.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "IndentDetailCell3.h"
#import "commonTools.h"

@implementation IndentDetailCell3

- (void)awakeFromNib {
    // Initialization code
}

- (void)setOrdersDetailModel:(OrdersDetailModel *)ordersDetailModel{
    self.orderSnLb.text = ordersDetailModel.orderSn;
    self.addTimeLb.text = [commonTools timeAndDateFromStamp:ordersDetailModel.addTime];
    self.quantityLb.text = ordersDetailModel.quantity;
    self.orderAmountLb.text = [NSString stringWithFormat:@"%@ 元",ordersDetailModel.orderAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  SwbCell5.m
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SwbCell5.h"

@implementation SwbCell5

- (void)awakeFromNib {
    // Initialization code
}

- (void)setOrdersDetailModel:(OrdersDetailModel *)ordersDetailModel{
    self.nameLb.font = [UIFont fontWithName: @"ArialHebrew-Bold" size:15.0];
    if (ordersDetailModel.goodsName == nil) {
        self.nameLb.text = @"无";
    }else{
        self.nameLb.text = ordersDetailModel.goodsName;
    }
    if (ordersDetailModel.orderAmount == nil) {
        self.orderAmount.text = @"无";
    }else{
        self.orderAmount.text = ordersDetailModel.orderAmount;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  SwbCell7.m
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SwbCell7.h"
#import "commonTools.h"

@implementation SwbCell7

- (void)awakeFromNib {
    // Initialization code
}

- (void)setOrdersDetailModel:(OrdersDetailModel *)ordersDetailModel{
    if (ordersDetailModel.orderSn == nil) {
        self.orderSn.text = @"无";
    }else{
        self.orderSn.text = ordersDetailModel.orderSn;
    }
    if (ordersDetailModel == nil) {
        self.addTime.text = @"无";
    }else{
        self.addTime.text = [commonTools timeAndDateFromStamp:ordersDetailModel.addTime];
    }
    if (ordersDetailModel.phoneMob == nil) {
        self.phoneMob.text = @"无";
    }else{
        self.phoneMob.text = ordersDetailModel.phoneMob;
    }
    if (ordersDetailModel.quantity == nil) {
        self.quantity.text = @"无";
    }else{
        self.quantity.text = ordersDetailModel.quantity;
    }
    if (ordersDetailModel.orderAmount == nil) {
        self.orderAmount.text = @"无";
    }else{
        self.orderAmount.text = [NSString stringWithFormat:@"%@ 元",ordersDetailModel.orderAmount];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

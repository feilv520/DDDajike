//
//  SwbCell8.m
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SwbCell8.h"
#import "commonTools.h"

@implementation SwbCell8

- (void)awakeFromNib {
    // Initialization code
}

- (void)setOrdersDetailModel:(OrdersDetailModel *)ordersDetailModel{
    self.statusLb.text = @"缺";
    self.dateLb.text = [commonTools timeAndDateFromStamp:ordersDetailModel.addTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

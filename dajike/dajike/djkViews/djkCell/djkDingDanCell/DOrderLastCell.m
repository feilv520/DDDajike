//
//  DOrderLastCell.m
//  dajike
//
//  Created by swb on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DOrderLastCell.h"
#import "dDefine.h"

@implementation DOrderLastCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(OrdersDetailModel *)model
{
    self.dingdanbianhaoLb.text = model.orderSn;
    if ([commonTools isNull:[NSString stringWithFormat:@"%@",model.addTime]]) {
        self.xiadanLb.text = @"暂无";
    }else
        self.xiadanLb.text = [commonTools timeAndDateFromStamp:[NSString stringWithFormat:@"%@",model.addTime]];
    
    if ([commonTools isNull:[NSString stringWithFormat:@"%@",model.payTime]]) {
        self.fukuan.text = @"暂无";
    }else
        self.fukuan.text = [commonTools timeAndDateFromStamp:[NSString stringWithFormat:@"%@",model.payTime]];
    if ([commonTools isNull:[NSString stringWithFormat:@"%@",model.shipTime]]) {
        self.fahuoLb.text = @"暂无";
    }else
        self.fahuoLb.text = [commonTools timeAndDateFromStamp:[NSString stringWithFormat:@"%@",model.shipTime]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

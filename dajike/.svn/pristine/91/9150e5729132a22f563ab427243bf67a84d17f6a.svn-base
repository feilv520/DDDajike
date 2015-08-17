//
//  DOrderThirdCell.m
//  dajike
//
//  Created by swb on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DOrderThirdCell.h"

@implementation DOrderThirdCell

- (void)awakeFromNib {
    // Initialization code
    self.lineView1Con.constant = 0.5f;
    self.lineView2Con.constant = 0.5f;
    self.lineView3Con.constant = 0.5f;
    self.lineView4Con.constant = 0.5f;
}

- (void)setModel:(DMyOrderModel *)model
{
    self.allMoneyLb.text = [NSString stringWithFormat:@"¥%.2f",[model.order_amount floatValue]];
    self.yunfeiLb.text = [NSString stringWithFormat:@"¥%.2f",[model.shipping_fee floatValue]];
    self.yueLb.text = [NSString stringWithFormat:@"-¥%.2f",[model.koushui_yue floatValue]];
    self.chongzhiLb.text = [NSString stringWithFormat:@"-¥%.2f",[model.yue floatValue]];
    self.shifukuanLb.text = [NSString stringWithFormat:@"¥%.2f",[model.yueJine floatValue]];
}
- (void)setOrderDetailModel:(OrdersDetailModel *)orderDetailModel
{
    self.allMoneyLb.text = [NSString stringWithFormat:@"¥%.2f",[orderDetailModel.orderAmount floatValue]];
    self.yunfeiLb.text = [NSString stringWithFormat:@"¥%.2f",[orderDetailModel.shippingFee floatValue]];
    self.yueLb.text = [NSString stringWithFormat:@"-¥%.2f",[orderDetailModel.koushuiYue floatValue]];
    self.chongzhiLb.text = [NSString stringWithFormat:@"-¥%.2f",[orderDetailModel.yue floatValue]];
    self.shifukuanLb.text = [NSString stringWithFormat:@"¥%.2f",[orderDetailModel.yueJine floatValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

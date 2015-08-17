//
//  DOrderFirstCell.m
//  dajike
//
//  Created by swb on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DOrderFirstCell.h"

@implementation DOrderFirstCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(OrdersDetailModel *)model
{
    switch ([model.status intValue]) {
        case 0:
            self.statusLb.text = @"已取消!";
            break;
        case 10:
            self.statusLb.text = @"已支付!";
            break;
        case 11:
            self.statusLb.text = @"待付款!";
            break;
        case 20:
            self.statusLb.text = @"待发货!";
            break;
        case 30:
            self.statusLb.text = @"待收货!";
            break;
        case 40:{
            if (self.ifJiFen==0 && [self.goodsDetailModel.ifJifen intValue]==0) {
                self.statusLb.text = @"交易成功!";
            }else
                self.statusLb.text = @"兑换成功!";
        }
            
            break;
            
        default:
            break;
    }
    if (self.ifJiFen==0 && [self.goodsDetailModel.ifJifen intValue]==0) {
        self.allMoneyLb.text = [NSString stringWithFormat:@"订单总额（含运费）：¥%.2f",[model.orderAmount floatValue]];
    }else {
        self.allMoneyLb.text = [NSString stringWithFormat:@"兑换积分：%d",self.ifJiFen==0?[self.goodsDetailModel.ifJifen intValue]:self.ifJiFen];
    }
    if ([NSString stringWithFormat:@"%.2f",[model.shippingFee floatValue]] && ![[NSString stringWithFormat:@"%.2f",[model.shippingFee floatValue]] isEqualToString:@"0.00"]) {
        self.yunfeiLb.text = [NSString stringWithFormat:@"运费：%.2f",[model.shippingFee floatValue]];
    }else
        self.yunfeiLb.text = @"运费：免运费";
//    self.yunfeiLb.text = [NSString stringWithFormat:@"运费：¥%.2f",[model.shippingFee floatValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

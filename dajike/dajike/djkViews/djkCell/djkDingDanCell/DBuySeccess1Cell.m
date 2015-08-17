//
//  DBuySeccess1Cell.m
//  dajike
//
//  Created by swb on 15/7/22.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBuySeccess1Cell.h"
#import "dDefine.h"

@implementation DBuySeccess1Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(OrdersDetailModel *)model
{
    self.moneyLb.text = [NSString stringWithFormat:@"%.2f",[model.orderAmount floatValue]];
    UILabel *titleLb = [[UILabel alloc]initWithFrame:DRect(8, 8, 65, 20)];
    titleLb.textColor = DColor_666666;
    titleLb.font = [UIFont systemFontOfSize:13.0f];
    titleLb.text = @"订单编号：";
    [self.orderSnView addSubview:titleLb];
    UILabel *orderSnLb = [[UILabel alloc]initWithFrame:DRect(CGRectGetMaxX(titleLb.frame), 8, 200, 20)];
    orderSnLb.textColor = DColor_666666;
    orderSnLb.font = [UIFont systemFontOfSize:13.0f];
    orderSnLb.text = [NSString stringWithFormat:@"%@",model.orderSn];
    [self.orderSnView addSubview:orderSnLb];
}

- (void)setOrderSnArr:(NSMutableArray *)orderSnArr
{
    if ([self.flag isEqualToString:@"duihuan"]) {
        self.titleLb.text = @"兑换积分：";
    }else
        self.titleLb.text = @"总金额：";
    CGRect rect = [self contentAdaptionLabel:self.titleLb.text withSize:CGSizeMake(500, 20) withTextFont:13.0f];
    self.titleLbCon.constant = rect.size.width + 5;
    self.moneyLb.text = self.allMoney;
    self.orderSnViewCon.constant = orderSnArr.count * 30;
    for (int i=0; i<orderSnArr.count;i++) {
        UILabel *titleLb = [[UILabel alloc]initWithFrame:DRect(8, 8+i*30, 75, 20)];
        titleLb.textColor = DColor_666666;
        titleLb.font = [UIFont systemFontOfSize:13.0f];
        if (orderSnArr.count == 1) {
            titleLb.text = @"订单编号：";
        }else
            titleLb.text = [NSString stringWithFormat:@"订单%d编号：",i+1];
        CGRect rect1 = [self contentAdaptionLabel:titleLb.text withSize:CGSizeMake(500, 20) withTextFont:13.0f];
        titleLb.frame = DRect(8, 8+i*30, rect1.size.width+5, 20);
        [self.orderSnView addSubview:titleLb];
        UILabel *orderSnLb = [[UILabel alloc]initWithFrame:DRect(CGRectGetMaxX(titleLb.frame)+8, 8+i*30, 200, 20)];
        orderSnLb.textColor = DColor_666666;
        orderSnLb.font = [UIFont systemFontOfSize:13.0f];
        orderSnLb.text = [orderSnArr objectAtIndex:i];
        [self.orderSnView addSubview:orderSnLb];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

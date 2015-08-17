//
//  AccountDetail3Cell.m
//  jibaobao
//
//  Created by dajike on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "AccountDetail3Cell.h"
#import "commonTools.h"

@implementation AccountDetail3Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setAccountDetailModel:(AccountDetailModel *)model
{
    self.money1Label.text = [NSString stringWithFormat:@"￥%@",[commonTools moneyTolayout:model.jine]];
//    -1未知,0抽奖,1未抽奖平均,2取消订单,21修改订单商品,3提现,31取消提现,4营业额,5支付,6收益,61收益转出,62收益转入,7充值
//    NSDictionary *dic = @{@"-1":@"未知",@"0":@"抽奖",@"1":@"未抽奖平均",@"2":@"取消订单",@"21":@"修改订单商品",@"3":@"提现",@"31":@"取消提现",@"4":@"营业额",@"5":@"支付",@"6":@"收益",@"61":@"收益转出",@"62":@"收益转入",@"7":@"充值"};
//    -1未知,0抽奖,1未抽奖平均,2取消订单,21修改订单商品,3提现,31取消提现,4营业额,5支付,6收益,61收益转出,62收益转入,7充值
     NSDictionary *dic = @{@"-1":@"(未知)",@"0":@"(抽奖)",@"1":@"(未抽奖平均)",@"2":@"(取消订单)",@"3":@"(提现)",@"4":@"(营业额)",@"5":@"(支付)",@"6":@"(收益)",@"7":@"(充值)",@"61":@"(收益转出)",@"62":@"(收益转入)",@"8":@"(包红包)",@"81":@"(抢红包)",@"82":@"(取消红包)",@"21":@"(修改订单商品)",@"31":@"(取消提现)"};
    self.typeLabel.text = [dic objectForKey:model.type];
    self.codeLabel.text = [NSString stringWithFormat:@"￥%@",[commonTools moneyTolayout:model.jine]];
    //undo 订单金额
    self.timeLabel.text = [commonTools timesToDate:model.createTime];
    
}

@end

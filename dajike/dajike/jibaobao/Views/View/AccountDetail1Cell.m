//
//  AccountDetail1Cell.m
//  jibaobao
//
//  Created by dajike on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "AccountDetail1Cell.h"
#import "commonTools.h"

@implementation AccountDetail1Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setAccountDetailModel:(AccountDetailModel *)model
{
    self.mingxiLabel.text = model.beizhu;
   
    NSDictionary *typeDic = @{@"-1":@"未知",@"0":@"抽奖",@"1":@"未抽奖平均",@"2":@"取消订单",@"21":@"修改订单商品",@"3":@"提现",@"31":@"取消提现",@"4":@"营业额",@"5":@"支付",@"6":@"收益",@"61":@"收益转出",@"62":@"收益转入",@"7":@"充值"};
    self.typeLabel.text = [NSString stringWithFormat:@"%@",[typeDic objectForKey:[NSString stringWithFormat:@"%@",model.type]]];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",[commonTools moneyTolayout:model.jine]];
    self.dayLabel.text = [commonTools timeAndDateFromStamp:[NSString stringWithFormat:@"%@",model.create_time]];
}
- (void)setChoujiangModel:(AccountDetailModel *)model
{
    self.mingxiLabel.text = model.beizhu;
    NSDictionary *typeDic = @{@"-1":@"未知",@"0":@"抽奖",@"1":@"未抽奖自动分配",@"2":@"帮人注册送积分",@"21":@"关注大集客",@"22":@"阅读推广文章",@"3":@"取消订单退积分",@"31":@"修改订单商品",@"5":@"支付",@"6":@"收益"};
    self.typeLabel.text = [NSString stringWithFormat:@"%@",[typeDic objectForKey:[NSString stringWithFormat:@"%@",model.type]]];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",[commonTools moneyTolayout:model.jine]];
    self.dayLabel.text = [commonTools timeAndDateFromStamp:[NSString stringWithFormat:@"%@",model.create_time]];
}

- (void)setYingyeeModel:(AccountDetailModel *)model
{
    self.mingxiLabel.text = model.beizhu;
//    -1未知,0抽奖,1未抽奖平均,2取消订单,21修改订单商品,3提现,31取消提现,4营业额,5支付,6收益,61收益转出,62收益转入,7充值
    NSDictionary *typeDic = @{@"-1":@"未知",@"0":@"抽奖",@"1":@"未抽奖平均",@"2":@"取消订单",@"21":@"修改订单商品",@"3":@"提现",@"31":@"取消提现",@"4":@"营业额",@"5":@"支付",@"6":@"收益",@"61":@"收益转出",@"62":@"收益转入",@"7":@"充值"};
    self.typeLabel.text = [NSString stringWithFormat:@"%@",[typeDic objectForKey:[NSString stringWithFormat:@"%@",model.type]]];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",[commonTools moneyTolayout:model.jine]];
    self.dayLabel.text = [commonTools timeAndDateFromStamp:[NSString stringWithFormat:@"%@",model.createTime]];
    
}

@end

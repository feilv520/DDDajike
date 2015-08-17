//
//  AccountDetail0Cell.m
//  jibaobao
//
//  Created by dajike on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "AccountDetail0Cell.h"
#import "commonTools.h"

@implementation AccountDetail0Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setAccountDetailModel:(AccountDetailModel *)model
{
    NSDictionary *typeDic = @{@"-1":@"未知",@"0":@"抽奖",@"1":@"未抽奖自动分配",@"2":@"帮人注册送积分",@"21":@"关注大集客",@"22":@"阅读推广文章",@"3":@"取消订单退积分",@"31":@"修改订单商品",@"5":@"支付",@"6":@"收益"};
    self.label0.text = [NSString stringWithFormat:@"%@",[typeDic objectForKey:[NSString stringWithFormat:@"%@",model.type]]];
    self.label1.text = [NSString stringWithFormat:@"%@",model.jifen];
    self.label3.text = model.beizhu;
    self.label4.text = [commonTools timeAndDateFromStamp:[NSString stringWithFormat:@"%@",model.createTime]];
   
}

@end

//
//  WriteIndentCell.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "WriteIndentCell.h"
#import "defines.h"

@implementation WriteIndentCell

- (void)awakeFromNib {
    // Initialization code
//    self.shouyiBtn.selected = NO;
//    self.chongzhiBtn.selected = NO;
//    self.jifenBtn.selected = NO;
}

- (void)setModel:(AccountOverViewModel *)model
{
    self.shouyiLb.text = [NSString stringWithFormat:@"账户可用余额：¥%.2f元",[model.shouyi_yue_forPay_enable floatValue]/2];
    
    
    self.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[model.chongzhi_jine_index floatValue]];
//    self.jifenLb.text = [NSString stringWithFormat:@"可用%.2f积分抵制10元",[model.jifen floatValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectPayAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.block((int)btn.tag);
}

- (void)callBackSelectPayType:(SelectPayTypeBlock)block
{
    self.block = block;
}
@end

//
//  BoundBankCardCell.m
//  jibaobao
//
//  Created by dajike on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "BoundBankCardCell.h"

@implementation BoundBankCardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setBankBoundModel:(BankBoundListModel *)model
{
self.bankNameLabel.text = model.bankName;
    NSMutableString *kahao = [NSMutableString stringWithString:model.kahao];
//    [kahao substringWithRange:NSMakeRange(kahao.length-4, 4)];
    self.bankCardNumberLabel.text = [NSString stringWithFormat:@"尾号%@储蓄卡",[kahao substringWithRange:NSMakeRange(kahao.length-4, 4)]];
//    self.bankCardNumberLabel.text = model.kahao;
    //undo
    [self.bandIconImageVIew setImage:[UIImage imageNamed:@"img_yl.png"]];

}

@end

//
//  DConfirmOrder2Cell.m
//  dajike
//
//  Created by swb on 15/7/22.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DConfirmOrder2Cell.h"

@implementation DConfirmOrder2Cell

- (void)awakeFromNib {
    // Initialization code
    [self.jiaBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 18)];
    [self.jianBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.block(btn.tag);
}
- (void)callBack:(CallbackJiaJianBtnClicked)block
{
    self.block = block;
}
@end

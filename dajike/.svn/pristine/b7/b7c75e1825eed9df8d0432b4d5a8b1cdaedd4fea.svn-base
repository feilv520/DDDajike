//
//  DConfirmOrder3Cell.m
//  dajike
//
//  Created by swb on 15/7/22.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DConfirmOrder3Cell.h"

@implementation DConfirmOrder3Cell

- (void)awakeFromNib {
    // Initialization code
    [self.shouyiBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 13, 6, 13)];
    [self.chongzhiBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 13, 6, 13)];
    [self.shouyiBtn setImage:[UIImage imageNamed:@"img_car_04"] forState:UIControlStateNormal];
    [self.shouyiBtn setImage:[UIImage imageNamed:@"img_car_02"] forState:UIControlStateSelected];
    [self.chongzhiBtn setImage:[UIImage imageNamed:@"img_car_04"] forState:UIControlStateNormal];
    [self.chongzhiBtn setImage:[UIImage imageNamed:@"img_car_02"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.block(btn.tag);
}
- (void)callBack:(CallbackPayTypeSelect)block
{
    self.block = block;
}
@end

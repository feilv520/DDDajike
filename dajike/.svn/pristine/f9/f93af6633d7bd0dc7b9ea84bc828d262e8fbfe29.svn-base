//
//  DgouwucheOneCell.m
//  dajike
//
//  Created by swb on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DgouwucheOneCell.h"

@implementation DgouwucheOneCell

- (void)awakeFromNib {
    // Initialization code
    self.selectBtn.selected = NO;
    [self.selectBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 10, 6, 10)];
    [self.selectBtn setImage:[UIImage imageNamed:@"img_car_04"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"img_car_02"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectBtnAction:(id)sender {
//    UIButton *btn = (UIButton *)sender;
//    btn.selected = !btn.selected;
    self.block();
}
- (void)callAllSelectBtnClicked:(CallAllSelectBtnClicked)block
{
    self.block = block;
}
@end

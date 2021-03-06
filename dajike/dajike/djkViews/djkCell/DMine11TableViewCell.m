//
//  DMine11TableViewCell.m
//  dajike
//
//  Created by songjw on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DMine11TableViewCell.h"
#import "dDefine.h"
#import "DTools.h"

@implementation DMine11TableViewCell

- (void)awakeFromNib {
    // Initialization code
    [DTools setLable:self.lab_1 Font:DFont_12 titleColor:DColor_808080 backColor:[UIColor clearColor]];

    [DTools setLable:self.lab_2 Font:DFont_12 titleColor:DColor_808080 backColor:[UIColor clearColor]];

    [DTools setLable:self.lab_3 Font:DFont_12 titleColor:DColor_808080 backColor:[UIColor clearColor]];

    [DTools setLable:self.lab_4 Font:DFont_12 titleColor:DColor_808080 backColor:[UIColor clearColor]];

    [DTools setLable:self.lab_5 Font:DFont_12 titleColor:DColor_808080 backColor:[UIColor clearColor]];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.block(btn.tag);
}
- (void)callBack:(CallbackBtnClicked)block
{
    self.block = block;
}
@end

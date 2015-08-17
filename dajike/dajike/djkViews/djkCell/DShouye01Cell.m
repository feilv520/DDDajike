//
//  DShouye01Cell.m
//  dajike
//
//  Created by dajike on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DShouye01Cell.h"
#import "dDefine.h"

@implementation DShouye01Cell

- (void)awakeFromNib {
    // Initialization code
    [self.titleLabel01 setFont:DFont_11];
    [self.titleLabel01 setTextColor:DColor_666666];
    
    [self.titleLabel02 setFont:DFont_11];
    [self.titleLabel02 setTextColor:DColor_666666];
    
    [self.titleLabel03 setFont:DFont_11];
    [self.titleLabel03 setTextColor:DColor_666666];
    
    [self.titleLabel04 setFont:DFont_11];
    [self.titleLabel04 setTextColor:DColor_666666];
    
    self.titleLabel01.text = @"大集客自营";
     self.titleLabel02.text = @"集宝宝";
     self.titleLabel03.text = @"区域直营";
     self.titleLabel04.text = @"我要抽奖";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClip:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    if (self.delegate) {
        [self.delegate shouyeButtonClipAtIndex:tag];
    }
}

@end

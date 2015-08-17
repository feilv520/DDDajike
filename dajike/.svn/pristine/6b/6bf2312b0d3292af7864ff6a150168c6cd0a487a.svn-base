//
//  DgouwucheKongCell.m
//  dajike
//
//  Created by swb on 15/7/21.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DgouwucheKongCell.h"
#import "dDefine.h"

@implementation DgouwucheKongCell

- (void)awakeFromNib {
    // Initialization code
    self.guangguangBtn.layer.cornerRadius = 3.5f;
    self.guangguangBtn.layer.masksToBounds = YES;
    self.guangguangBtn.layer.borderColor = DColor_line_bg.CGColor;
    self.guangguangBtn.layer.borderWidth = 0.6;
    
    self.storeBtn.layer.cornerRadius = 3.5f;
    self.storeBtn.layer.masksToBounds = YES;
    self.storeBtn.layer.borderColor = DColor_line_bg.CGColor;
    self.storeBtn.layer.borderWidth = 0.6;
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

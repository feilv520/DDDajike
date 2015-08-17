//
//  AllProductSortCell.m
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "AllProductSortCell.h"



@implementation AllProductSortCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)seachAllBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.block((int)btn.tag);
}

- (void)callBackAllProduct:(AllProductBlock)blcok
{
    self.block = blcok;
}
@end

//
//  IndentDetailCell2.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "IndentDetailCell2.h"

@implementation IndentDetailCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setOrderDetailModel:(OrdersDetailModel *)orderDetailModel{
    if ([orderDetailModel.is_suishitui intValue] == 1) {
        self.lab_1.hidden = NO;
        self.img_1.hidden = NO;
    }else{
        self.lab_1.hidden = YES;
        self.img_1.hidden = YES;
    }
    if ([orderDetailModel.is_guoqitui intValue] == 1) {
        self.lab_2.hidden = NO;
        self.img_2.hidden = NO;
    }else{
        self.lab_2.hidden = YES;
        self.img_2.hidden = YES;
    }
    
}

@end

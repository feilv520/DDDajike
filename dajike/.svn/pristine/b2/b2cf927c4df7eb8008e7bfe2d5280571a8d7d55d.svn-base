//
//  ShopDecCell.m
//  jibaobao
//
//  Created by swb on 15/6/3.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "ShopDecCell.h"
#import "defines.h"
@implementation ShopDecCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(ShopDetailInfoModel *)model
{
    if (![commonTools isNull:model.yye_time]) {
        self.yytimeLb.text  = [NSString stringWithFormat:@"营业时间:%@",model.yye_time];
    }else
        self.yytimeLb.text  = @"营业时间:暂无";
    
//    self.yytimeLb.text  = [NSString stringWithFormat:@"营业时间:%@",model.yye_time];
    self.decLb.text     = model.description2;
    CGRect rect = [self contentAdaptionLabel:self.decLb.text withSize:CGSizeMake(WIDTH_CONTROLLER_DEFAULT-16, 500) withTextFont:12.0f];
    
    if ((int)rect.size.height >= 30) {
        self.arowImg.hidden = NO;
        self.decsHeightCon.constant = 29;
    }else {
        self.arowImg.hidden = YES;
        self.decsHeightCon.constant = rect.size.height+5;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

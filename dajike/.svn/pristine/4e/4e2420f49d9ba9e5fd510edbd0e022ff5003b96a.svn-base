//
//  DTodayNewGoodsCell.m
//  dajike
//
//  Created by dajike on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DTodayNewGoodsCell.h"
#import "dDefine.h"

@implementation DTodayNewGoodsCell

- (void)awakeFromNib {
    // Initialization code
    [self.titleLabel setFont:DFont_11];
    [self.titleLabel setTextColor:DColor_mainRed];
}


//首页今日新品
- (void) setTodayNewModel:(DTodayNewMOdel *) model
{
    [self.headImageView setImageWithURL:[NSURL URLWithString:model.default_image] placeholderImage:DPlaceholderImage];
    self.titleLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.price floatValue]];
}
@end

//
//  DZhutijie02Cell.m
//  dajike
//
//  Created by dajike on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DZhutijie02Cell.h"
#import "dDefine.h"

@implementation DZhutijie02Cell

- (void)awakeFromNib {
    // Initialization code
    [self.titleLabel01 setFont:DFont_Nav];
    [self.titleLabel01 setTextColor:DColor_000000];
    
    [self.titleLabel02 setFont:DFont_11];
    [self.titleLabel02 setTextColor:DColor_666666];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setZhutijiemodel:(ShouyeBannerModel *)model
{
    [self.headImageView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:DPlaceholderImage_5_2];
    self.titleLabel01.text = model.title;
    self.titleLabel02.text = model.desc;
}

@end

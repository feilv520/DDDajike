//
//  DRexiaoGoodsCell.m
//  dajike
//
//  Created by dajike on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DRexiaoGoodsCell.h"
#import "dDefine.h"

@implementation DRexiaoGoodsCell

- (void)awakeFromNib {
    // Initialization code
    [self.titleLabel setFont:DFont_11];
    [self.titleLabel setTextColor:DColor_666666];
    
    [self.priceLabel.layer setCornerRadius:2.0];
    [self.priceLabel setFont:DFont_11];
    [self.priceLabel setTextColor:DColor_ffffff];
    [self.priceLabel setBackgroundColor:DColor_mainRed];
    self.priceLabel.layer.borderColor  = [[UIColor clearColor] CGColor];
    self.priceLabel.layer.borderWidth = 3.0;
    [self.priceLabel.layer setMasksToBounds:YES];
    
    //图片不变形
    [self.shoucangImageView setContentMode:UIViewContentModeScaleAspectFit];
    //图片圆角
    [self.mainImageVIew.layer setMasksToBounds:YES];
    self.mainImageVIew.layer.cornerRadius = 4.0;
}

//热销商品
- (void) setRexiaoModel:(DReXiaoGoodsModel *)model
{
    [self.mainImageVIew setImageWithURL:[NSURL URLWithString:model.default_image] placeholderImage:DPlaceholderImage];
    
    [self.titleLabel setText:[NSString stringWithFormat:@"%@",model.goods_name]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    //是否处于收藏状态
    if ([model.collect isEqualToString:@"1"]) {
        [self.shoucangImageView setImage:[UIImage imageNamed:@"djk_index_18"]];
    }else{
        [self.shoucangImageView setImage:[UIImage imageNamed:@"djk_index_19"]];
    }
}



@end

//
//  RecommendFoodCell.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/9.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "RecommendFoodCell.h"
#import "commonTools.h"
#import "defines.h"

@implementation RecommendFoodCell

- (void)awakeFromNib {
    // Initialization code
    [self.storBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 1, 6, 11)];
    
}

- (void)setGoodsListModel:(GoodsListModel *)goodsListModel{
    self.nameLab.text = goodsListModel.goods_name;
    self.nameLab.numberOfLines = 0;
    self.goodNumLab.text = [NSString stringWithFormat:@"%@人收藏",goodsListModel.collects];
    self.PriceLab.text = [NSString stringWithFormat:@"¥%@元",goodsListModel.price];
    [self.headImgV setImageWithURL:[commonTools getImgURL:goodsListModel.default_image] placeholderImage:PlaceholderImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

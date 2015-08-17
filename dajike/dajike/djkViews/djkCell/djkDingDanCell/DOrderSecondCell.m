//
//  DOrderSecondCell.m
//  dajike
//
//  Created by swb on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DOrderSecondCell.h"
#import "dDefine.h"

@implementation DOrderSecondCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(DMyOrderModel *)model
{
    self.storeLb.text = model.seller_name;
    CGRect rect = [self contentAdaptionLabel:self.storeLb.text withSize:CGSizeMake(500, 20) withTextFont:13.0f];
    self.storeLbCon.constant = rect.size.width+5;
    [self.storeLogoImg setImageWithURL:[commonTools getImgURL:@""] placeholderImage:DPlaceholderImage];
}
- (void)setGoodsDetailModel:(DGoodsDetailModel *)goodsDetailModel
{
    self.storeLb.text = goodsDetailModel.storeName;
    CGRect rect = [self contentAdaptionLabel:self.storeLb.text withSize:CGSizeMake(500, 20) withTextFont:13.0f];
    self.storeLbCon.constant = rect.size.width+5;
    [self.storeLogoImg setImageWithURL:[commonTools getImgURL:goodsDetailModel.storeLogo] placeholderImage:DPlaceholderImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

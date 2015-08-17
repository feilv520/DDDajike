//
//  DGoodsListCollectionViewCell.m
//  dajike
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DGoodsListCollectionViewCell.h"
#import "dDefine.h"

@implementation DGoodsListCollectionViewCell

- (void)awakeFromNib {
//    self.goodsImageView.layer.masksToBounds= YES;
//    [self.goodsImageView.layer setCornerRadius:8];
    [self.goodsImageView setContentMode:UIViewContentModeScaleToFill];
    
    self.layer.masksToBounds = YES;
    [self.layer setCornerRadius:6.0];

    
    [self.goodsName setFont:DFont_11];
    [self.goodsName setTextColor:DColor_666666];
    
    [self.moneyLabel setFont:DFont_11];
    [self.moneyLabel setTextColor:DColor_c4291f];
    
    [self.commitLabel setFont:DFont_9];
    [self.commitLabel setTextColor:DColor_999999];
}

@end

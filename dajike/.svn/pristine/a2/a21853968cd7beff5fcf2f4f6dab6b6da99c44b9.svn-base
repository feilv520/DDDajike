//
//  CouponListCell.m
//  jibaobao
//
//  Created by dajike on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "CouponListCell.h"
#import "commonTools.h"

@implementation CouponListCell

- (void)setCouponListModel:(CouponListModel *)couponListModel{
    self.titleLabel1.text =couponListModel.goods_name;
    self.titleLavel2.text =[commonTools timesToDate:couponListModel.end_time];
}

- (void)setCouponDetailModel:(CouponDetailsListModel *)couponDetailModel{
    self.titleLabel1.text = couponDetailModel.goods_name;
    self.titleLavel2.text =[commonTools timesToDate:couponDetailModel.end_time];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

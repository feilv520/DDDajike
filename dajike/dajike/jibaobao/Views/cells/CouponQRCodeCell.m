//
//  CouponQRCodeCell.m
//  jibaobao
//
//  Created by dajike on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "CouponQRCodeCell.h"
#import "UIImageView+WebCache.h"
#import "QRCodeGenerator.h"
#import "defines.h"

@implementation CouponQRCodeCell

- (void)setCouponDetailModel:(CouponDetailsListModel *)couponDetailModel{
    UIImage *image = [QRCodeGenerator qrImageForString:couponDetailModel.code imageSize:180];
    self.QRCodeImageView.image = image;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

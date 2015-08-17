//
//  SwbSubbranchCell.m
//  jibaobao
//
//  Created by swb on 15/5/20.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SwbSubbranchCell.h"
#import "defines.h"

@implementation SwbSubbranchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(CouponDetailModel *)model
{
    [self.storLogoImg setImageWithURL:[commonTools getImgURL:model.store_logo] placeholderImage:PlaceholderImage];
    self.shopNameLb.text        = model.store_name;
    self.shopAddressLb.text     = model.address;
}

- (void)callBackPhoneCall:(PhoneCallBlock)block
{
    self.block = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)phoneCallAction:(id)sender {
    self.block();
}
@end

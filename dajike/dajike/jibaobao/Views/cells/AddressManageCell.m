//
//  AddressManageCell.m
//  jibaobao
//
//  Created by dajike on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "AddressManageCell.h"

@implementation AddressManageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(MyAddressModel *)model
{
    self.nameLabel.text     = model.consignee;
    self.phoneLabel.text    = model.phoneMob;
    self.addressLaebl.text  = model.address;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

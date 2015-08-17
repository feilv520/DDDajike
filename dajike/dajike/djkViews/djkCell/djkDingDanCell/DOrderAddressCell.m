//
//  DOrderAddressCell.m
//  dajike
//
//  Created by swb on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DOrderAddressCell.h"

@implementation DOrderAddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(OrdersDetailModel *)model
{
    self.nameLb.text = [NSString stringWithFormat:@"收货人：%@",model.consignee];
    self.phoneLb.text = [NSString stringWithFormat:@"%@",model.phoneMob];
    self.addressLb.text = [NSString stringWithFormat:@"收货地址：%@",model.address];
}
- (void)setAddressModel:(MyAddressModel *)addressModel
{
    self.nameLb.text = [NSString stringWithFormat:@"收货人：%@",addressModel.consignee];
    self.phoneLb.text = [NSString stringWithFormat:@"%@",addressModel.phoneMob];
    self.addressLb.text = [NSString stringWithFormat:@"收货地址：%@",addressModel.address];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

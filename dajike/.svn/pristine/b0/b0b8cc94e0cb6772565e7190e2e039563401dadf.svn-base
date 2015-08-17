//
//  ReceiveAddressCell.m
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "ReceiveAddressCell.h"

@implementation ReceiveAddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setOrdersDetailModel:(OrdersDetailModel *)ordersDetailModel{
    if (ordersDetailModel.consignee == nil) {
        self.consignee.text = @"无";
    }else{
        self.consignee.text = [NSString stringWithFormat:@"收货人:%@",ordersDetailModel.consignee];
    }
    if (ordersDetailModel.regionName == nil&&
        ordersDetailModel.address == nil) {
        self.address.text = @"无";
    }else if (ordersDetailModel.regionName == nil&&
              ordersDetailModel.address != nil){
        self.address.text = [NSString stringWithFormat:@"收货地址:%@",ordersDetailModel.address];
    }else if (ordersDetailModel.regionName != nil&&
              ordersDetailModel.address == nil){
        self.address.text = [NSString stringWithFormat:@"收货地址:%@",ordersDetailModel.regionName];
    }else{
        self.address.text = [NSString stringWithFormat:@"收货地址:%@ %@",ordersDetailModel.regionName,ordersDetailModel.address];
    }
    if (ordersDetailModel.phoneMob == nil) {
        self.phoneMob.text = @"无";
    }else{
        self.phoneMob.text = ordersDetailModel.phoneMob;
    }
    
    
}

- (void)setModel:(MyAddressModel *)model
{
//    self.consignee.text = [NSString stringWithFormat:@"收货人:%@",model.consignee];
//    self.address.text = [NSString stringWithFormat:@"收货地址:%@ %@",model.regionName,model.address];
//    self.phoneMob.text = model.phoneMob;
    if (model.consignee == nil) {
        self.consignee.text = @"无";
    }else{
        self.consignee.text = [NSString stringWithFormat:@"收货人:%@",model.consignee];
    }
    if (model.regionName == nil&&
        model.address == nil) {
        self.address.text = @"无";
    }else if (model.regionName == nil&&
              model.address != nil){
        self.address.text = [NSString stringWithFormat:@"收货地址:%@",model.address];
    }else if (model.regionName != nil&&
              model.address == nil){
        self.address.text = [NSString stringWithFormat:@"收货地址:%@",model.regionName];
    }else{
        self.address.text = [NSString stringWithFormat:@"收货地址:%@ %@",model.regionName,model.address];
    }
    if (model.phoneMob == nil) {
        self.phoneMob.text = @"无";
    }else{
        self.phoneMob.text = model.phoneMob;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

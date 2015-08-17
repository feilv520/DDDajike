//
//  SwbCell6.m
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SwbCell6.h"

@implementation SwbCell6

- (void)awakeFromNib {
    // Initialization code
}

- (void)setOrdersDetailModel:(OrdersDetailModel *)ordersDetailModel{
    self.typeName3.hidden = NO;
    self.typeValue3.hidden = NO;
    self.typeName1.text = @"类型:";
    if (ordersDetailModel.spec1 == nil &&
        ordersDetailModel.spec2 == nil) {
        self.typeValue1.text = @"无";
    }else if (ordersDetailModel.spec1 != nil&&
              ordersDetailModel.spec2 == nil){
        self.typeValue1.text = [NSString stringWithFormat:@"%@",ordersDetailModel.spec1];
    }else if (ordersDetailModel.spec1 == nil&&
              ordersDetailModel.spec2 != nil){
        self.typeValue1.text = [NSString stringWithFormat:@"%@",ordersDetailModel.spec2];
    }else{
        self.typeValue1.text = [NSString stringWithFormat:@"%@#%@",ordersDetailModel.spec1,ordersDetailModel.spec2];
    }
    self.typeName2.text = @"数量:";
    if (ordersDetailModel.quantity == nil) {
        self.typeValue2.text = @"0";
    }else{
        self.typeValue2.text = [NSString stringWithFormat:@"共%@件",ordersDetailModel.quantity];
    }
    
    self.typeName3.text = @"运费:";
    if (ordersDetailModel.shippingFee == nil) {
        self.typeValue3.text = @"0";
    }else{
        self.typeValue3.text = ordersDetailModel.shippingFee;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

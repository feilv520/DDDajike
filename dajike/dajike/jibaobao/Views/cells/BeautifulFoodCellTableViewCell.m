//
//  BeautifulFoodCellTableViewCell.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/7.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "BeautifulFoodCellTableViewCell.h"
#import "defines.h"

@implementation BeautifulFoodCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(CashCouponModel *)model
{
    if (model.goods_name == nil) {
        self.nameLb.text = @"无";
    }else{
        self.nameLb.text        = model.goods_name;
    }
    if (model.price == nil) {
        self.priceLb.text = @"0";
    }else{
        self.priceLb.text       = [NSString stringWithFormat:@"¥%.1f",[model.price floatValue]];
    }
    CGRect rect1            = [self contentAdaptionLabel:self.priceLb.text withSize:CGSizeMake(100, 19) withTextFont:17.0f];
    self.priceWidthCon.constant = rect1.size.width+5;
    
    if (model.market_price == nil) {
        self.orgPriceLb.text = @"0";
    }else{
        self.orgPriceLb.text    = [NSString stringWithFormat:@"%.1f",[model.market_price floatValue]];
    }
    CGRect rect2 = [self contentAdaptionLabel:self.orgPriceLb.text withSize:CGSizeMake(100, 19) withTextFont:13];
    self.orgPriceWidthCon.constant = rect2.size.width+5;
    
    if (model.choujiang_bili == nil) {
        self.choujiangLb.text = @"0%%累计抽奖";
    }else{
        self.choujiangLb.text   = [NSString stringWithFormat:@"%.0f%%累计抽奖",[model.choujiang_bili floatValue]*100];
    }
    
    if (model.sales == nil) {
        self.salesLb.text = @"0";
    }else{
        self.salesLb.text       = [NSString stringWithFormat:@"已售%d",[model.sales intValue]];
    }
    CGRect rect3 = [self contentAdaptionLabel:self.salesLb.text withSize:CGSizeMake(200, 21) withTextFont:13.0f];
    self.salesWidthCon.constant = rect3.size.width;
    [self.imgView setImageWithURL:[commonTools getImgURL:model.default_image] placeholderImage:PlaceholderImage];
}

- (void)setOrdersDetailModel:(OrdersDetailModel *)ordersDetailModel{
    if (ordersDetailModel.goodsDesc == nil) {
        self.nameLb.text = @"无";
    }else{
        self.nameLb.text = ordersDetailModel.goodsDesc;
    }
    if (ordersDetailModel.price == nil) {
        self.priceLb.text = @"¥0";
        self.orgPriceLb.text = @"0";
    }else{
        self.priceLb.text       = [NSString stringWithFormat:@"¥%d",[ordersDetailModel.price intValue]];
        self.orgPriceLb.text    = [NSString stringWithFormat:@"%d",[ordersDetailModel.price intValue]];
    }
    if (ordersDetailModel.choujiangbili == nil) {
        self.choujiangLb.text = @"0%%累计抽奖";
    }else{
        self.choujiangLb.text   = [NSString stringWithFormat:@"%.0f%%累计抽奖",[ordersDetailModel.choujiangbili floatValue]*100];
    }
    if (ordersDetailModel.sales == nil) {
        self.salesLb.text = @"已售0";
    }else{
        self.salesLb.text = [NSString stringWithFormat:@"已售%d",[ordersDetailModel.sales intValue]];
    }
    
    
    
    [self.imgView setImageWithURL:[commonTools getImgURL:ordersDetailModel.goodsImage] placeholderImage:PlaceholderImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

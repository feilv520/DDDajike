//
//  BeautifulFoodCellTableViewCell.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/7.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OriPriceLabel.h"

#import "CashCouponModel.h"
#import "OrdersDetailModel.h"

@interface BeautifulFoodCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet OriPriceLabel *orgPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *choujiangLb;
@property (weak, nonatomic) IBOutlet UILabel *salesLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orgPriceWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salesWidthCon;

@property (strong, nonatomic) CashCouponModel *model;
@property (strong, nonatomic) OrdersDetailModel *ordersDetailModel;


@end

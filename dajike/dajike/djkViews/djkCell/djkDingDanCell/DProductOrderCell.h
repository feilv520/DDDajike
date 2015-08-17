//
//  DProductOrderCell.h
//  dajike
//
//  Created by swb on 15/7/14.
//  Copyright (c) 2015年 haixia. All rights reserved.
//




/*
 ***  订单 商品cell
 */

#import <UIKit/UIKit.h>
#import "orderGoodsModel.h"
#import "DGoodsDetailModel.h"

@interface DProductOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodSepcLb;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLb;

@property (strong, nonatomic) NSString *buyNum;

@property (strong, nonatomic) orderGoodsModel *orderGoodModel;

@property (strong, nonatomic) DGoodsDetailModel *goodsDetailModel;
@property (strong, nonatomic) NSMutableDictionary *dic;

@end

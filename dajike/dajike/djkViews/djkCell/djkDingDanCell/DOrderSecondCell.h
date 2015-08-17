//
//  DOrderSecondCell.h
//  dajike
//
//  Created by swb on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMyOrderModel.h"
#import "DGoodsDetailModel.h"

@interface DOrderSecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *storeLb;
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeLbCon;

@property (strong, nonatomic) DMyOrderModel *model;
@property (strong, nonatomic) DGoodsDetailModel *goodsDetailModel;

@end

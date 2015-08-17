//
//  DRexiaoGoodsCell.h
//  dajike
//
//  Created by dajike on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//


//首页热销商品  cell
#import <UIKit/UIKit.h>
#import "DReXiaoGoodsModel.h"

@interface DRexiaoGoodsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *shoucangLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shoucangImageView;

@property (weak, nonatomic) DReXiaoGoodsModel *rexiaoModel;

@end

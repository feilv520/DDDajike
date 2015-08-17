//
//  DGoodsListCollectionViewCell.h
//  dajike
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DGoodsListCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (strong, nonatomic) IBOutlet UILabel *goodsName;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *commitLabel;

@end

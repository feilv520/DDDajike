//
//  DiscountCouponCell.h
//  jibaobao
//
//  Created by dajike on 15/4/29.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OriPriceLabel.h"

#import "GoodsListModel.h"
#import "NearPrivilegeModel.h"
#include "CollectModel.h"

@interface DiscountCouponCell : UITableViewCell{
@private
    UIImageView*	m_checkImageView;
    BOOL			m_checked;
}
@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *JIanjieLabel;
@property (weak, nonatomic) IBOutlet UILabel *DistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *NewPriceLabel;
@property (weak, nonatomic) IBOutlet OriPriceLabel *OldPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *ProbabilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *SoldNumberLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldPriceWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salesWidthCon;

//首页附近优惠model 
@property (strong, nonatomic) GoodsListModel *model;

@property (strong, nonatomic) NearPrivilegeModel *nearbyYouhuiModel;

//我的收藏
@property (strong,nonatomic) CollectModel *CollectModel;


- (void)config:(CollectModel *)model;

- (void) setChecked:(BOOL)checked;

//- (void) moveToRight;
@end

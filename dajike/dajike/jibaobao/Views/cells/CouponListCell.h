//
//  CouponListCell.h
//  jibaobao
//
//  Created by dajike on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponListModel.h"
#import "CouponDetailsListModel.h"

@interface CouponListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLavel2;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (strong, nonatomic) CouponListModel *couponListModel;
@property (strong, nonatomic) CouponDetailsListModel *couponDetailModel;

@end

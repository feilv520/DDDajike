//
//  CouponQRCodeCell.h
//  jibaobao
//
//  Created by dajike on 15/5/12.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponDetailsListModel.h"
@interface CouponQRCodeCell : UITableViewCell

@property(nonatomic,strong)NSString *code;

@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;

@property (strong, nonatomic) CouponDetailsListModel *couponDetailModel;


@end

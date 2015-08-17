//
//  DOrderAddressCell.h
//  dajike
//
//  Created by swb on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrdersDetailModel.h"
#import "MyAddressModel.h"

@interface DOrderAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;

@property (strong, nonatomic) OrdersDetailModel *model;
@property (strong, nonatomic) MyAddressModel *addressModel;

@end

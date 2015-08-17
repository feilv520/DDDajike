//
//  SwbCell6.h
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrdersDetailModel.h"

@interface SwbCell6 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeName1;
@property (weak, nonatomic) IBOutlet UILabel *typeName2;
@property (weak, nonatomic) IBOutlet UILabel *typeName3;
@property (weak, nonatomic) IBOutlet UILabel *typeValue1;
@property (weak, nonatomic) IBOutlet UILabel *typeValue2;
@property (weak, nonatomic) IBOutlet UILabel *typeValue3;

@property (strong, nonatomic)OrdersDetailModel *ordersDetailModel;

@end

//
//  DMine11TableViewCell.h
//  dajike
//
//  Created by songjw on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallbackBtnClicked)(NSInteger btnTag);

@interface DMine11TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *but_1;
@property (weak, nonatomic) IBOutlet UIButton *but_2;
@property (weak, nonatomic) IBOutlet UIButton *but_3;
@property (weak, nonatomic) IBOutlet UIButton *but_4;
@property (weak, nonatomic) IBOutlet UIButton *but_5;

@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;
@property (weak, nonatomic) IBOutlet UILabel *lab_3;
@property (weak, nonatomic) IBOutlet UILabel *lab_4;
@property (weak, nonatomic) IBOutlet UILabel *lab_5;
@property (strong, nonatomic) CallbackBtnClicked block;
//tag=1.待付款   tag=2.待发货  tag=3.待收货  tag=4.待评价  tag=5.帮助
- (IBAction)btnClicked:(id)sender;
- (void)callBack:(CallbackBtnClicked)block;
@end

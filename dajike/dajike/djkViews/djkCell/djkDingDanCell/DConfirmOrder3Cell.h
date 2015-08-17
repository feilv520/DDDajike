//
//  DConfirmOrder3Cell.h
//  dajike
//
//  Created by swb on 15/7/22.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallbackPayTypeSelect)(NSInteger btnTag);

@interface DConfirmOrder3Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shouyiLb;
@property (weak, nonatomic) IBOutlet UILabel *chongzhiLb;
@property (weak, nonatomic) IBOutlet UIButton *shouyiBtn;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiBtn;
@property (strong, nonatomic) CallbackPayTypeSelect block;
//tag=1.收益  2.充值
- (IBAction)btnClicked:(id)sender;
- (void)callBack:(CallbackPayTypeSelect)block;

@end

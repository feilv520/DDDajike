//
//  DConfirmOrder2Cell.h
//  dajike
//
//  Created by swb on 15/7/22.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallbackJiaJianBtnClicked)(NSInteger btnTag);

@interface DConfirmOrder2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buyNum;
@property (weak, nonatomic) IBOutlet UIButton *jianBtn;
@property (weak, nonatomic) IBOutlet UIButton *jiaBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (strong, nonatomic) CallbackJiaJianBtnClicked block;
//tag=2.减  3.加
- (IBAction)btnClicked:(id)sender;
- (void)callBack:(CallbackJiaJianBtnClicked)block;

@end

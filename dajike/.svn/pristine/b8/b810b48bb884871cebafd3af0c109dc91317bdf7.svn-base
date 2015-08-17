//
//  DgouwucheKongCell.h
//  dajike
//
//  Created by swb on 15/7/21.
//  Copyright (c) 2015年 haixia. All rights reserved.
//


//购物车里为空的时候的cell

#import <UIKit/UIKit.h>

typedef void (^CallbackBtnClicked)(NSInteger btnTag);

@interface DgouwucheKongCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *guangguangBtn;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;

@property (strong, nonatomic) CallbackBtnClicked block;
//tag=1.逛逛  2.收藏
- (IBAction)btnClicked:(id)sender;

- (void)callBack:(CallbackBtnClicked)block;

@end

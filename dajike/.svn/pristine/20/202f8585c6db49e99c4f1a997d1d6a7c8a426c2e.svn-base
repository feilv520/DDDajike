//
//  DgouwucheOneCell.h
//  dajike
//
//  Created by swb on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//


/*
 ****   购物车 第一行cell
 */

#import <UIKit/UIKit.h>
typedef void (^CallAllSelectBtnClicked)();

@interface DgouwucheOneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLb;

@property (strong, nonatomic) CallAllSelectBtnClicked block;

- (IBAction)selectBtnAction:(id)sender;

- (void)callAllSelectBtnClicked:(CallAllSelectBtnClicked)block;
@end

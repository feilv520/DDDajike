//
//  DgouwucheCell.h
//  dajike
//
//  Created by swb on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//


/*
 ****  购物车 购买商品cell
 */

#import <UIKit/UIKit.h>

typedef void (^CallBtnClicked)(int btnTag);

@interface DgouwucheCell : UITableViewCell

@property (strong, nonatomic) NSString *buyNum;
@property (strong, nonatomic) NSMutableDictionary *mDic;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *jianBtn;
@property (weak, nonatomic) IBOutlet UIButton *jiaBtn;

@property (weak, nonatomic) IBOutlet UIImageView *productLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *productDescLb;
@property (weak, nonatomic) IBOutlet UILabel *productGuiGeLb;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *buyNumLb;

@property (strong, nonatomic) CallBtnClicked block;

- (IBAction)btnClicked:(id)sender;
- (void)callBtnClicked:(CallBtnClicked)block;

@end

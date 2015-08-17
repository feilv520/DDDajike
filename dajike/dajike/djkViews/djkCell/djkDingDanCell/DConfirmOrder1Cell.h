//
//  DConfirmOrder1Cell.h
//  dajike
//
//  Created by swb on 15/7/22.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGoodsDetailModel.h"

typedef void (^CallbackCellClicked)();

@interface DConfirmOrder1Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumLb;
@property (weak, nonatomic) IBOutlet UILabel *storeLb;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLb;
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *shifukuanLb;
@property (weak, nonatomic) IBOutlet UILabel *productNumLb;
@property (weak, nonatomic) IBOutlet UIView *cellViewBg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView1Con;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView2Con;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shifukuanCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productNumCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeLbCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yunfeiLbCon;

@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *xiaoji;
@property (strong, nonatomic) NSString *storeLogo;

@property (strong, nonatomic) NSString *flag;
@property (strong, nonatomic) NSString *buyNum;
@property (strong, nonatomic) NSString *yunfei;
@property (strong, nonatomic) DGoodsDetailModel *goodsDetailModel;
@property (strong, nonatomic) NSMutableDictionary *dic;
@property (strong, nonatomic) CallbackCellClicked blcok;

- (IBAction)btnClicked:(id)sender;
- (void)callBack:(CallbackCellClicked)block;

@end

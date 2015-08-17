//
//  DMyOrderCell.h
//  dajike
//
//  Created by swb on 15/7/14.
//  Copyright (c) 2015年 haixia. All rights reserved.
//


/*
 ********  订单  外层 Cell
 */

#import <UIKit/UIKit.h>
#import "DMyOrderModel.h"
#import "MyClickLb.h"

typedef void (^CallBackMyOrderBlock)(NSString *lbTitle);

@interface DMyOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellViewBg;
@property (weak, nonatomic) IBOutlet UIImageView *storeImgV;
@property (weak, nonatomic) IBOutlet UILabel *storeLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet UILabel *productNumLb;
@property (weak, nonatomic) IBOutlet UILabel *shifukuanLb;
@property (weak, nonatomic) IBOutlet MyClickLb *lbRight;
@property (weak, nonatomic) IBOutlet MyClickLb *lbCenter;
@property (weak, nonatomic) IBOutlet MyClickLb *lbLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView1Con;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView2Con;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView3Con;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productNumCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbCenterCon;

@property (strong, nonatomic) DMyOrderModel *myOrderModel;
@property (strong, nonatomic) CallBackMyOrderBlock block;


- (IBAction)btnClicked:(id)sender;
- (void)callBackBtnClicked:(CallBackMyOrderBlock)block;
@end

//
//  DGoodCommetViewController.h
//  dajike
//
//  Created by swb on 15/7/17.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

/*
 ******   商品评价
 */

#import "DBackNavigationViewController.h"

typedef void (^CallbackToDOrderDetailVCandDMyOrderListVC)();

@interface DGoodCommetViewController : DBackNavigationViewController

@property (strong, nonatomic) NSMutableArray *productAarry;
@property (strong, nonatomic) NSString *orderId;
//------------------------
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBG;
@property (weak, nonatomic) IBOutlet UIImageView *goodImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLb;
@property (weak, nonatomic) IBOutlet UILabel *goodSpecLb;
@property (weak, nonatomic) IBOutlet UILabel *goodNumLb;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *pingfenLb;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLb;
@property (weak, nonatomic) IBOutlet UILabel *wordsNumLb;
@property (weak, nonatomic) IBOutlet UITextView *pingyuTV;
@property (weak, nonatomic) IBOutlet UITableView *goodListTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tijiaoBtnCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCon;
//5个评分小Btn
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;

@property (weak, nonatomic) IBOutlet UIButton *shaidanBtn;
@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;

@property (strong, nonatomic) CallbackToDOrderDetailVCandDMyOrderListVC block;
//集成Btn点击事件
- (IBAction)btnClicked:(id)sender;

- (void)callBack:(CallbackToDOrderDetailVCandDMyOrderListVC)block;

@end

//
//  OrderCommentViewController.h
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

/*
 我的全部订单 评价
 */
#import "BackNavigationViewController.h"
#import "orderGoodsModel.h"
#import "MyOrdersAjaxListModel.h"
#import "UserInfoModel.h"

typedef void (^CallBackCommentShopBlock)();

@interface OrderCommentViewController : BackNavigationViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property (nonatomic, assign) NSInteger goodsOrOrder; //1 是给商家评论   2 是给订单评论
@property (nonatomic, strong) NSString *storeId; // 商家ID

@property (strong, nonatomic) UserInfoModel *userInfoModel;
@property (strong, nonatomic) orderGoodsModel *orderGoodsModel;
@property (strong, nonatomic) MyOrdersAjaxListModel *myOrderListModel;

@property (weak, nonatomic) IBOutlet UIButton *xing1;
@property (weak, nonatomic) IBOutlet UIButton *xing2;
@property (weak, nonatomic) IBOutlet UIButton *xing3;
@property (weak, nonatomic) IBOutlet UIButton *xing4;
@property (weak, nonatomic) IBOutlet UIButton *xing5;
- (IBAction) xingButtonClip:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *niMingLabel;
@property (weak, nonatomic) IBOutlet UIButton *nimingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageVIew;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *publikButton;

@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UIImageView *photoView1;
@property (strong, nonatomic) IBOutlet UIImageView *photoView2;
@property (strong, nonatomic) IBOutlet UIImageView *photoView3;
@property (strong, nonatomic) IBOutlet UIImageView *photoView4;
@property (strong, nonatomic) IBOutlet UIImageView *photoView5;
@property (strong, nonatomic) IBOutlet UIImageView *photoView6;
@property (strong, nonatomic) IBOutlet UIImageView *photoView7;

@property (strong, nonatomic) CallBackCommentShopBlock block;


- (IBAction)nimingButtobClip:(id)sender;

- (IBAction)photoButtonClip:(id)sender;
- (IBAction)moreButtonClip:(id)sender;
- (IBAction)publikButtonClip:(id)sender;

- (void)callBackShopComment:(CallBackCommentShopBlock)block;

@end

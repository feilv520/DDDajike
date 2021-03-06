//
//  GeneralHongBaoViewController.h
//  jibaobao
//
//  Created by swb on 15/6/1.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
 **      发红包---普通红包    拼手气红包
 */

#import "BackNavigationViewController.h"

@interface GeneralHongBaoViewController : BackNavigationViewController<BarButtonDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UITextField *jineTf;
@property (weak, nonatomic) IBOutlet UITextField *numTf;
@property (weak, nonatomic) IBOutlet UILabel *AllMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UILabel *jineLb;
@property (weak, nonatomic) IBOutlet UITextView *wordTV;

@property (strong, nonatomic) IBOutlet UILabel *hongBaoType;

@property (weak, nonatomic) IBOutlet UIView *viewBG;
@property (weak, nonatomic) IBOutlet UILabel *keyongMoney;
@property (strong, nonatomic) IBOutlet UILabel *keyongLabel;
@property (weak, nonatomic) IBOutlet UILabel *chongzhiAccount;
@property (strong, nonatomic) IBOutlet UILabel *chongzhilabel;
@property (weak, nonatomic) IBOutlet UIView *popView;

@property (weak, nonatomic) IBOutlet UIButton *querenBtn;


@property (weak, nonatomic) IBOutlet UIButton *pinRenqiBtn;
@property (weak, nonatomic) IBOutlet UIButton *faHongBaoBtn;

@property (strong, nonatomic) IBOutlet UITextField *onePassword;
@property (strong, nonatomic) IBOutlet UITextField *twoPassword;
@property (strong, nonatomic) IBOutlet UITextField *threePassword;
@property (strong, nonatomic) IBOutlet UITextField *fourPassword;
@property (strong, nonatomic) IBOutlet UITextField *fivePassword;
@property (strong, nonatomic) IBOutlet UITextField *sixPassword;

@property (strong, nonatomic) NSString *userId;

- (IBAction)pinRenQiBtnAction:(id)sender;
- (IBAction)faHongBaoBtnAction:(id)sender;
- (IBAction)tapCancel:(id)sender;

- (IBAction)querenBtnAction:(id)sender;
- (IBAction)onLineBtnAction:(id)sender;

@end

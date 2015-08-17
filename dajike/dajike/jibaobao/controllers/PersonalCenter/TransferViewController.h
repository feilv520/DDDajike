//
//  TransferViewController.h
//  jibaobao
//
//  Created by swb on 15/6/6.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 **    转账
 */

#import "BackNavigationViewController.h"

@interface TransferViewController : BackNavigationViewController<BarButtonDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *jineLb;
@property (weak, nonatomic) IBOutlet UITextField *jineTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UIButton *applyForBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jineLbWidthCon;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *totalAccount;

- (IBAction)forgetPasswordBtnAction:(id)sender;
- (IBAction)applyForBtnAction:(id)sender;

@end

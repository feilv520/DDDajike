//
//  DTransferViewController.h
//  dajike
//
//  Created by songjw on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBackNavigationViewController.h"

@interface DTransferViewController : DBackNavigationViewController
@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;
@property (weak, nonatomic) IBOutlet UILabel *lab_3;
@property (weak, nonatomic) IBOutlet UILabel *lab_4;
@property (weak, nonatomic) IBOutlet UILabel *lab_5;
@property (weak, nonatomic) IBOutlet UILabel *lab_6;
@property (weak, nonatomic) IBOutlet UIButton *forgetBut;

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

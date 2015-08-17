//
//  DFindPasswordViewController.h
//  dajike
//
//  Created by songjw on 15/7/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBackNavigationViewController.h"
#import "UserInfoModel.h"

@interface DFindPasswordViewController : DBackNavigationViewController
@property (strong, nonatomic)UserInfoModel *userInfoModel;
@property (weak, nonatomic) IBOutlet UILabel *helloLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *selectTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UITextField *putCOdeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *updownIMageVIew;
@property (weak, nonatomic) IBOutlet UIView *shouSelectVIew;
@property (weak, nonatomic) IBOutlet UIView *tishiVIew;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;
@property (weak, nonatomic) IBOutlet UILabel *lab_3;

@property (weak, nonatomic) IBOutlet UILabel *findTypeLab;
@property (weak, nonatomic) IBOutlet UIButton *phoneBut;
@property (weak, nonatomic) IBOutlet UIButton *emailBut;

- (IBAction)getCodeBUttonClip:(id)sender;
- (IBAction)mainButtonClip:(id)sender;
- (IBAction)upDownBUttonClip:(id)sender;
- (IBAction)selectphoneClip:(id)sender;
- (IBAction)selectEmailClip:(id)sender;

@end
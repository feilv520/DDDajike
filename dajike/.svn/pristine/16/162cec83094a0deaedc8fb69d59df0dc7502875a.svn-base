//
//  LoginViewController.h
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 登陆
 */
#import "BackNavigationViewController.h"

typedef void (^BackToWriteIndentViewControllerBlock)();

@interface LoginViewController : BackNavigationViewController
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) BackToWriteIndentViewControllerBlock block;
@property (strong, nonatomic) NSString *flagStr;

- (IBAction)loginButtonClip:(id)sender;
- (IBAction)findPasswordButtonClip:(id)sender;
- (IBAction)quickLoginBUttonClip:(id)sender;
- (IBAction)qqLoginButtonClip:(id)sender;
- (IBAction)weichatLoginButtonClip:(id)sender;

- (void)callBackToWriteIndentViewController:(BackToWriteIndentViewControllerBlock)block;

@end

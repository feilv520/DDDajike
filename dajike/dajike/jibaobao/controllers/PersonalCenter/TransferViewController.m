//
//  TransferViewController.m
//  jibaobao
//
//  Created by swb on 15/6/6.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
 **    转账
 */

#import "TransferViewController.h"
#import "defines.h"
#import "BoundPhoneViewController.h"

@interface TransferViewController ()

@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    self.delegate = self;
    titleLabel.text = @"转账";
    [self setScrollBtnHidden:YES];
    
    self.jineTf.layer.cornerRadius = 3.0f;
    self.jineTf.layer.masksToBounds= YES;
    self.jineTf.layer.borderColor = Color_line_bg.CGColor;
    self.jineTf.layer.borderWidth = 1.0f;
    
    self.passwordTf.layer.cornerRadius = 3.0f;
    self.passwordTf.layer.masksToBounds = YES;
    self.passwordTf.layer.borderWidth = 1.0f;
    self.passwordTf.layer.borderColor = Color_line_bg.CGColor;
    [self.passwordTf setSecureTextEntry:YES];
    
    self.applyForBtn.layer.cornerRadius = 3.0f;
    self.applyForBtn.layer.masksToBounds= YES;
    
    self.jineLb.text = self.totalAccount;
    self.jineTf.placeholder = @"转账金额必须大于100!";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)forgetPasswordBtnAction:(id)sender {
    BoundPhoneViewController *vc = [[BoundPhoneViewController alloc]init];
    vc.phoneType = ZFMIMA_VERIFY;
    [vc callBackRegisterSuccess:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)applyForBtnAction:(id)sender {
    [self myBanksTiXian];
}

- (void)myBanksTiXian{
    NSDictionary *parameter = @{@"userId":[FileOperation getUserId],@"type":self.type,@"jine":self.jineTf.text,@"password":[DES3Util encrypt:self.passwordTf.text]};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyBanks.tixian" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            [ProgressHUD showMessage:@"请求成功，等待处理！" Width:100 High:80];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
    
}

@end

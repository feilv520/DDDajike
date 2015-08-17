//
//  FindPassword0ViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "FindPassword0ViewController.h"
#import "FindPasswordViewController.h"

#import "defines.h"

#import "UserInfoModel.h"

@interface FindPassword0ViewController ()

@end

@implementation FindPassword0ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"找回密码";
        
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userTextField.layer.borderWidth = 0.5;
    self.userTextField.layer.borderColor = [Color_gray4 CGColor];
    
    self.codeTextField.layer.borderWidth = 0.5;
    self.codeTextField.layer.borderColor = [Color_gray4 CGColor];
    
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
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

//找回密码， 根据用户名查找用户信息
- (void)findByUserName{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:self.userTextField.text,@"userName",nil];
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.findByUserName" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        NSLog(@"result = %@",responseObject.result);
        if (responseObject.succeed) {
            
            NSDictionary *resultDic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
            UserInfoModel *userModel = [[UserInfoModel alloc]init];
            userModel = [JsonStringTransfer dictionary:resultDic ToModel:userModel];
            
            FindPasswordViewController *FindPasswordVC = [[FindPasswordViewController alloc]initWithNibName:nil bundle:nil];
            FindPasswordVC.userModel = userModel;
            [self.navigationController pushViewController:FindPasswordVC animated:YES];
            
        }else{
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//找回密码  下一步
- (IBAction)nextButtonClip:(id)sender {
    if ([self.userTextField.text isEqualToString:@""]) {
        [MBProgressHUD show:@"请您填写用户名/邮箱/手机号!" icon:nil view:self.view afterDelay:0.7];
        
    }else if ([self.codeTextField.text isEqualToString:self.codeVIew.changeString]||
              [self.codeTextField.text isEqualToString:self.codeVIew.codeString]){
        
        [self findByUserName];
        
    }else{
        [MBProgressHUD show:@"请您填写正确的验证码!" icon:nil view:self.view afterDelay:0.7];
    }
}

- (IBAction)changeCodeBtnClip:(id)sender {
    [self.codeVIew change];
}
@end

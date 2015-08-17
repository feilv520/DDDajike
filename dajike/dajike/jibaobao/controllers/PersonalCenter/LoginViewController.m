//
//  LoginViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "LoginViewController.h"
#import "JTabBarController.h"
#import "FindPassword0ViewController.h"
#import "BoundPhoneViewController.h"

#import "defines.h"


#import "ShareObject.h"

 #import "UMSocial.h"



@interface LoginViewController ()
{
    NSString        *_userId;
}

@end

@implementation LoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"登录";
        
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    UIButton *saveBut = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBut.frame = CGRectMake(0, 0, 45, 45);
    [saveBut setTitle:@"注册" forState:UIControlStateNormal];
    [saveBut setTitleColor:Color_mainColor forState:UIControlStateNormal];
    [saveBut addTarget:self action:@selector(registerButtonClip) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:saveBut];
    
    self.navigationItem.rightBarButtonItem = rightBut;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////左边返回按钮
//- (void) navLeftButtonTapped:(id)sender
//{
////    [JTabBarController sharedManager].selectedIndex = 0;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//注册
- (void) registerButtonClip
{
    BoundPhoneViewController *reginterVC = [[BoundPhoneViewController alloc]initWithNibName:nil bundle:nil];
    //注册状态
    reginterVC.phoneType = REGISTER_USER;
    [self.navigationController pushViewController:reginterVC animated:YES];
}

- (IBAction)loginButtonClip:(id)sender {
    
//    [commonTools shareUM:nil presentSnsIconSheetView:self delegate:self];
//    [[ShareObject shared]shareUM:nil presentSnsIconSheetView:self delegate:self]; 
    
   
    //如果为空
    if ([commonTools isEmpty:self.userTextField.text]) {
        [MBProgressHUD show:@"请输入账号" icon:nil view:self.view afterDelay:0.7];
    }else if([commonTools isEmpty:self.passwordTextField.text])
    {
        [MBProgressHUD show:@"请输入密码" icon:nil view:self.view afterDelay:0.7];
    }else
    {
        [self login];
        //获取用户会员信息
//        [self getUerInfo];
    }
    
}

//登录
- (void) login
{
    NSLog(@"-%@-\n-%@-",self.userTextField.text,self.passwordTextField.text);
    NSString *username = [DES3Util encrypt:self.userTextField.text];
    NSString *password = [DES3Util encrypt:self.passwordTextField.text];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:password,@"password",username,@"username", nil];
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyAccounts.login" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        NSLog(@"operation = %@",operation);
        if (responseObject.succeed) {
            
            //保存userid 和password
            [FileOperation saveUserId:responseObject.result];
            [FileOperation savePassword:[DES3Util encrypt:self.passwordTextField.text]];
            
            //设置
            NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
            [FileOperation setPlistObject:@"1" forKey:kIsLogin ofFilePath:filePath];
            
            //解密: 得到用户userId
            _userId = [AnalysisData decodeToString:responseObject.result];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
                //获取用户会员信息
                [self getUerInfo];
                
            });
        
            
            
        }else{
            [MBProgressHUD show:@"账号或密码错误，请重新输入" icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

//获取用户会员信息，存入本地
- (void)getUerInfo
{
    NSLog(@"%@",[FileOperation getUserId]);
    NSDictionary *parameter = @{@"userId":_userId};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyUserInfos.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSString *jsonStr = [AnalysisData decodeToString:responseObject.result];
            NSMutableDictionary *userInfoDic = [[JsonStringTransfer jsonStringToDictionary:jsonStr]mutableCopy];
            NSString *filePath = [FileOperation creatPlistIfNotExist:jibaobaoUser];
            [FileOperation writeToPlistFile:filePath withDic:userInfoDic];
            if ([self.flagStr intValue] == 1) {
                self.block();
            }
            [self.navigationController popViewControllerAnimated:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

- (IBAction)findPasswordButtonClip:(id)sender {
    //找回密码
    FindPassword0ViewController *FindPassword0VC = [[FindPassword0ViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:FindPassword0VC animated:YES];
}

- (IBAction)quickLoginBUttonClip:(id)sender {
    
//    NSDictionary *dic = @{@"page":@"1",@"pageSize":@"10"};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.GoodsDetail" parameters:nil ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"%@",responseObject.result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    //无密码手机快捷登录
    BoundPhoneViewController *quickLoginVC = [[BoundPhoneViewController alloc]initWithNibName:nil bundle:nil];
    quickLoginVC.phoneType = LOGIN_FAST;
    [self.navigationController pushViewController:quickLoginVC animated:YES];
}

//QQ登录
- (IBAction)qqLoginButtonClip:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            //qq登陆
            NSDictionary *parmeter = @{@"openId":snsAccount.openId,@"nickName":snsAccount.userName};
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.qqLogin" parameters:parmeter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"responseObject.result = %@",responseObject.result);
                    //保存userid 和password
                    [FileOperation saveUserId:[responseObject.result objectForKey:@"authUserId"]];
                    _userId = [DES3Util decrypt:[responseObject.result objectForKey:@"authUserId"]];
                    
                    //设置
                    NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
                    [FileOperation setPlistObject:@"1" forKey:kIsLogin ofFilePath:filePath];
//                    //保存用户信息
//                    NSDictionary *userInfoDic = @{@"userId":[DES3Util decrypt:[responseObject.result objectForKey:@"authUserId"]],@"nickName":[responseObject.result objectForKey:@"nickName"]};
//                    [FileOperation writeToPlistFile:[FileOperation creatPlistIfNotExist:jibaobaoUser] withDic:[NSMutableDictionary dictionaryWithDictionary:userInfoDic]];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        //获取用户会员信息
                        [self getUerInfo];
                        
                    });
                    [MBProgressHUD show:@"登陆成功！" icon:nil view:self.view afterDelay:0.5];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
            }];

            
//            //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
//            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
//                NSLog(@"SnsInformation is %@",response.data);
//                NSLog(@"SnsInformation is response %@",response);
//            }];
            
        }});
    
    


}

//微信登录
- (IBAction)weichatLoginButtonClip:(id)sender {
    
    
    //测试分享
//    [[ShareObject shared]shareUM:nil presentSnsIconSheetView:self delegate:self];
    
    //微信登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            //微信登陆
            NSDictionary *parmeter = @{@"openId":snsAccount.openId,@"unionId":snsAccount.unionId,@"nickName":snsAccount.userName};
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.weixinLogin" parameters:parmeter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"responseObject.result = %@",responseObject.result);
                    //保存userid 和password
                    [FileOperation saveUserId:[responseObject.result objectForKey:@"authUserId"]];
                    _userId = [DES3Util decrypt:[responseObject.result objectForKey:@"authUserId"]];
                    
                    //设置
                    NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
                    [FileOperation setPlistObject:@"1" forKey:kIsLogin ofFilePath:filePath];
//                    //保存用户信息
//                    NSDictionary *userInfoDic = @{@"userId":[DES3Util decrypt:[responseObject.result objectForKey:@"authUserId"]],@"userName":[responseObject.result objectForKey:@"nickName"]};
//                    [FileOperation writeToPlistFile:[FileOperation creatPlistIfNotExist:jibaobaoUser] withDic:[NSMutableDictionary dictionaryWithDictionary:userInfoDic]];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        //获取用户会员信息
                        [self getUerInfo];
                        
                    });
                    [MBProgressHUD show:@"登陆成功！" icon:nil view:self.view afterDelay:0.5];
                }else{
                    [MBProgressHUD show:@"登陆失败！" icon:nil view:self.view afterDelay:0.5];

                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
            }];

            
//            //得到的数据在回调Block对象形参respone的data属性
//            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
//                NSLog(@"SnsInformation is %@",response.data);
//                NSLog(@"SnsInformation is response %@",response);
//               
//            }];

    
            
        }
        
    });
     
     
     
    
     
   }

- (void)callBackToWriteIndentViewController:(BackToWriteIndentViewControllerBlock)block
{
    self.block = block;
}
@end

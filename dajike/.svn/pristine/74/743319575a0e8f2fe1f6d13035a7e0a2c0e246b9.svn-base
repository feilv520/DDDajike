//
//  DLoginViewController.m
//  dajike
//
//  Created by songjw on 15/7/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DLoginViewController.h"
#import "DBaseNavView.h"
#import "DVerifyPhoneNumViewController.h"
#import "DFindPassword0ViewController.h"
#import "dDefine.h"
#import "defines.h"
#import "DES3Util.h"
#import "DMyAfHTTPClient.h"
#import "MBProgressHUD+Add.h"
#import "FileOperation.h"
#import "AnalysisData.h"
#import "DTools.h"
#import "DGouWuCheOperation.h"

//#import "ShareObject.h"

#import "UMSocial.h"

@interface DLoginViewController (){
    DImgButton *_leftBut;
    DImgButton *_rightBut;
    
}
- (IBAction)QQLogin:(id)sender;
- (IBAction)WeiXinLogin:(id)sender;

@end

@implementation DLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviBarTitle:@"登录"];
    [self.view setBackgroundColor:DColor_f3f3f3];
    [DTools setTextfield:self.userTextfield Font:DFont_12 titleColor:DColor_cccccc backColor:DColor_ffffff];
    [DTools setTextfield:self.passwordTextfield Font:DFont_12 titleColor:DColor_cccccc backColor:DColor_ffffff];
    [DTools setButtton:self.loginBut Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
    [DTools setButtton:self.findBut Font:DFont_12 titleColor:DColor_808080 backColor:[UIColor clearColor]];
    [DTools setButtton:self.fastBut Font:DFont_12 titleColor:DColor_808080 backColor:[UIColor clearColor]];
    [DTools setLable:self.agreeLab Font:DFont_12 titleColor:DColor_808080 backColor:DColor_f3f3f3];
    [self.loginBut.layer setMasksToBounds:YES];
    [self.loginBut.layer setCornerRadius:4.0];

    _leftBut = [DBaseNavView  createNavBtnWithTitle:@"取消" target:self action:@selector(leftButAction)];
    [self setNaviBarLeftBtn:_leftBut];
    _rightBut = [DBaseNavView createNavBtnWithTitle:@"注册" target:self action:@selector(rightButAction)];
    [self setNaviBarRightBtn:_rightBut];
    
}
- (void)leftButAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButAction{
    DVerifyPhoneNumViewController *registerVerifyVC = [[DVerifyPhoneNumViewController alloc]initWithNibName:@"DVerifyPhoneNumViewController" bundle:nil];
    registerVerifyVC.verigyTape = register_verify;
    [self.navigationController pushViewController:registerVerifyVC animated:YES];
}

- (IBAction)buttonAction:(id)sender {
    UIButton *but = (UIButton *)sender;
    if (but.tag == 0) {
        [self login];
    }else if (but.tag == 1) {
        DFindPassword0ViewController *findVC = [[DFindPassword0ViewController alloc]initWithNibName:@"DFindPassword0ViewController" bundle:nil];
        [self.navigationController pushViewController:findVC animated:YES];
    }else if (but.tag == 2){//快速登录
        DVerifyPhoneNumViewController *registerVerifyVC = [[DVerifyPhoneNumViewController alloc]initWithNibName:@"DVerifyPhoneNumViewController" bundle:nil];
        registerVerifyVC.verigyTape = quick_login;
        [self.navigationController pushViewController:registerVerifyVC animated:YES];
    }
    
}
//登录
- (void)login{
    NSLog(@"-%@-\n-%@-",self.userTextfield.text,self.passwordTextfield.text);
    NSString *username = [DES3Util encrypt:self.userTextfield.text];
    NSString *password = [DES3Util encrypt:self.passwordTextfield.text];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:password,@"password",username,@"username", nil];
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.login" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation = %@",operation);
        NSLog(@"result:%@",responseObject.result);
        if (responseObject.succeed) {
            //保存userid 和password
            [FileOperation saveUserId:responseObject.result];
            [FileOperation savePassword:[DES3Util encrypt:self.passwordTextfield.text]];
            
            //设置
            NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
            [FileOperation setPlistObject:@"1" forKey:kIsLogin ofFilePath:filePath];
        }else{
            [MBProgressHUD show:@"账号或密码错误，请重新输入" icon:nil view:self.view afterDelay:0.7];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //获取用户会员信息
            [self getUerInfo];
            //同步购物车获取购物车数量
            [self getGouWuCheGoodsNum];
            
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

- (void)getGouWuCheGoodsNum
{
    NSMutableDictionary *dic = [[DGouWuCheOperation syncGouWuChe]mutableCopy];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",[[JsonStringTransfer objectToJsonString:dic] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"map", nil];
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Carts.get" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            [DGouWuCheOperation updateStatus];
            [FileOperation setPlistObject:[NSString stringWithFormat:@"%@",[responseObject.result objectForKey:@"specCount"]] forKey:@"cartCount" ofFilePath:[FileOperation creatPlistIfNotExist:jibaobaoUser]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeGouWuCheNum" object:nil];
        }else
            showMessage(responseObject.msg);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

- (void)getUerInfo{
    NSLog(@"%@",[FileOperation getUserId]);
    NSDictionary *parameter = @{@"userId":[NSString stringWithString:[FileOperation getUserId]]};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyUserInfos.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation = %@",operation);
        NSLog(@"result:%@",responseObject.result);
        if (responseObject.succeed) {
            
            NSString *jsonStr = [AnalysisData decodeToString:responseObject.result];
            NSMutableDictionary *userInfoDic = [[JsonStringTransfer jsonStringToDictionary:jsonStr]mutableCopy];
            NSString *filePath = [FileOperation creatPlistIfNotExist:dajikeUser];
            [FileOperation writeToPlistFile:filePath withDic:userInfoDic];
            if (self.fromVC == GOUWUCHE_VC||
                self.fromVC == GOODSDETAIL) {
                self.block();
            }
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            
        }
        
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];

}

- (void)callBack:(CallbackToGouWuCheVC)block
{
    self.block = block;
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


//QQ登录
- (IBAction)QQLogin:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            //qq登陆
            NSDictionary *parmeter = @{@"openId":snsAccount.openId,@"nickName":snsAccount.userName};
            [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.qqLogin" parameters:parmeter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"responseObject.result = %@",responseObject.result);
                    //保存userid 和password
                    [FileOperation saveUserId:[responseObject.result objectForKey:@"authUserId"]];
//                    _userId = [DES3Util decrypt:[responseObject.result objectForKey:@"authUserId"]];
                    
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
//微信登陆
- (IBAction)WeiXinLogin:(id)sender {
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
            [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.weixinLogin" parameters:parmeter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"responseObject.result = %@",responseObject.result);
                    //保存userid 和password
                    [FileOperation saveUserId:[responseObject.result objectForKey:@"authUserId"]];
//                    _userId = [DES3Util decrypt:[responseObject.result objectForKey:@"authUserId"]];
                    
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
@end

//
//  DVerifyPhoneNumViewController.m
//  dajike
//
//  Created by songjw on 15/7/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DVerifyPhoneNumViewController.h"
#import "DPayPasswordSetViewController.h"
#import "dDefine.h"
#import "MBProgressHUD+Add.h"
#import "DES3Util.h"
#import "FileOperation.h"
#import "AnalysisData.h"

#import "DWebViewController.h"

static int _restTime = 60;

@interface DVerifyPhoneNumViewController (){
    NSTimer *_timer;
}
@property (nonatomic, strong) NSString *verifyNumber; // 验证码
@end

@implementation DVerifyPhoneNumViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    
}

- (void)initView{
    [self.view setBackgroundColor:DColor_f3f3f3];
    [DTools setTextfield:self.phoneTextField Font:DFont_13 titleColor:DColor_cccccc backColor:DColor_ffffff];
    [DTools setTextfield:self.verifyTextField Font:DFont_13 titleColor:DColor_cccccc backColor:DColor_ffffff];
    [DTools setButtton:self.getCodeBut Font:DFont_11 titleColor:DColor_ffffff backColor:DColor_c4291f];
    [DTools setButtton:self.verifyBut Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
    [DTools setLable:self.meTooLab Font:DFont_12 titleColor:DColor_808080 backColor:[UIColor clearColor]];
    [DTools setButtton:self.agreementBut Font:DFont_12 titleColor:DColor_c4291f backColor:[UIColor clearColor]];
    [self.getCodeBut.layer setMasksToBounds:YES];
    [self.getCodeBut.layer setCornerRadius:4.0];
    [self.verifyBut.layer setMasksToBounds:YES];
    [self.verifyBut.layer setCornerRadius:4.0];
    
    self.phoneTextField.layer.borderWidth = 0.5;
    self.phoneTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.phoneTextField.layer setMasksToBounds:YES];
    [self.phoneTextField.layer setCornerRadius:4.0];
    self.verifyTextField.layer.borderWidth = 0.5;
    self.verifyTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.verifyTextField.layer setMasksToBounds:YES];
    [self.verifyTextField.layer setCornerRadius:4.0];
    self.threeTextField.layer.borderWidth = 0.5;
    self.threeTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.threeTextField.layer setMasksToBounds:YES];
    [self.threeTextField.layer setCornerRadius:4.0];
    
    self.selectBut.hidden = YES;
    self.selectImg.hidden = YES;
    self.agreementBut.hidden = YES;
    self.meTooLab.hidden = YES;
    self.getCodeBut.hidden = NO;
    if (self.verigyTape == register_verify) {
        [self setNaviBarTitle:@"注册"];
        self.selectBut.hidden = NO;
        self.selectImg.hidden = NO;
        self.agreementBut.hidden = NO;
        self.meTooLab.hidden = NO;
        self.getCodeBut.hidden = NO;
        [self.verifyBut setTitle:@"下一步" forState:UIControlStateNormal];
        
    }else if (self.verigyTape == boud_verify||
              self.verigyTape == safe_phone_verify||
              self.verigyTape == safe_password_verify||
              self.verigyTape == safe_password2_verify||
              self.verigyTape == password2_verify){
        NSMutableString *phoneNum =[NSMutableString stringWithString:_userModel.phoneMob];
        [phoneNum replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        self.phoneTextField.placeholder = phoneNum;
        self.phoneTextField.userInteractionEnabled = NO;
        [self setNaviBarTitle:@"验证手机号"];
        [self.verifyBut setTitle:@"验证" forState:UIControlStateNormal];
        
    }else if (self.verigyTape == quick_login){
        [self setNaviBarTitle:@"无密码手机快捷登录"];
        self.phoneTextField.placeholder = @"请输入手机号码";
        [self.verifyBut setTitle:@"登录" forState:UIControlStateNormal];
        
    }else if (self.verigyTape == set_password||
              self.verigyTape == register_set_password){
        [self setNaviBarTitle:@"设置密码"];
        self.getCodeBut.hidden = YES;
        self.phoneTextField.placeholder = @"新密码（其输入6-20位字母或数字密码）";
        self.verifyTextField.placeholder = @"确认密码";
        self.phoneTextField.secureTextEntry = YES;
        self.verifyTextField.secureTextEntry = YES;
        [self.verifyBut setTitle:@"完成" forState:UIControlStateNormal];
        
    }else if (self.verigyTape == safe_phone||
              self.verigyTape == safe_phone_bound||
              self.verigyTape == safe_password_bound||
              self.verigyTape == safe_password2_bound){
        [self setNaviBarTitle:@"绑定手机"];
        self.phoneTextField.placeholder = @"请输入手机号码";
        [self.verifyBut setTitle:@"绑定" forState:UIControlStateNormal];
    }else if (self.verigyTape == safe_password){
        [self setNaviBarTitle:@"修改登录密码"];
        self.getCodeBut.hidden = YES;
        self.threeTextField.hidden = NO;
        self.phoneTextField.secureTextEntry = YES;
        self.verifyTextField.secureTextEntry = YES;
        self.threeTextField.secureTextEntry = YES;
        self.phoneTextField.placeholder = @"旧密码";
        self.verifyTextField.placeholder = @"新密码";
        self.threeTextField.placeholder = @"确认密码";
        [self.verifyBut setTitle:@"修改" forState:UIControlStateNormal];
    }
}


- (IBAction)butAction:(id)sender {
//    UIButton *but = (UIButton *)sender;
    if (self.verigyTape == register_verify||
        self.verigyTape == quick_login) {
        if (![self checkPhone]) {
            return;
        }
    }
    if (self.verigyTape == register_verify) {//注册
        
        DVerifyPhoneNumViewController *setPasswordVC = [[DVerifyPhoneNumViewController alloc]initWithNibName:@"DVerifyPhoneNumViewController" bundle:nil];
        setPasswordVC.verigyTape = register_set_password;
        setPasswordVC.phoneNumStr = self.phoneTextField.text;
        setPasswordVC.messageCode = self.verifyTextField.text;
        setPasswordVC.userModel = self.userModel;
        [self.navigationController pushViewController:setPasswordVC animated:YES];
    }else if (self.verigyTape == quick_login) {
        [self fastLogin];
    }else if (self.verigyTape == register_set_password) {
        [self registry];
    }else if (self.verigyTape == boud_verify||
              self.verigyTape == safe_phone_verify||
              self.verigyTape == safe_password_verify||
              self.verigyTape == safe_password2_verify||
              self.verigyTape == set_password_verify||
              self.verigyTape == password2_verify) {
        [self checkCodeAndPhone];
    }else if (self.verigyTape == safe_phone||
              self.verigyTape == safe_phone_bound||
              self.verigyTape == safe_password_bound||
              self.verigyTape == safe_password2_bound||
              self.verigyTape == set_password_bound){
        [self boundModbilePhone];
        
    }else if (self.verigyTape == safe_password){
        if ([self.phoneTextField.text isEqualToString:[FileOperation getPassword]]) {
            [self updatePassword];
        }else{
            [MBProgressHUD show:@"旧密码有误！" icon:nil view:self.view];
        }
        
    }else if (self.verigyTape == set_password){
        [self findPassword];
    }

}
- (void)elsePushVC{
    if (self.verigyTape == safe_phone_verify||
        self.verigyTape == safe_phone_bound) {
        DVerifyPhoneNumViewController *setPasswordVC = [[DVerifyPhoneNumViewController alloc]initWithNibName:@"DVerifyPhoneNumViewController" bundle:nil];
        setPasswordVC.verigyTape = safe_phone;
        setPasswordVC.userModel = self.userModel;
        [setPasswordVC backToSafetySettingViewController:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:setPasswordVC animated:YES];
    }else if (self.verigyTape == safe_password_verify||
              self.verigyTape == safe_password_bound){
        DVerifyPhoneNumViewController *setPasswordVC = [[DVerifyPhoneNumViewController alloc]initWithNibName:@"DVerifyPhoneNumViewController" bundle:nil];
        setPasswordVC.verigyTape = safe_password;
        setPasswordVC.userModel = self.userModel;
        [setPasswordVC backToSafetySettingViewController:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:setPasswordVC animated:YES];
    }else if (self.verigyTape == safe_password2_verify||
              self.verigyTape == safe_password2_bound||
              self.verigyTape == password2_verify){
        DPayPasswordSetViewController *vc = [[DPayPasswordSetViewController alloc]initWithNibName:@"DPayPasswordSetViewController" bundle:nil];
        [vc backToSafetySettingViewController:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (self.verigyTape == boud_verify){
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.verigyTape == set_password_verify||
              self.verigyTape == set_password_bound){
        DVerifyPhoneNumViewController *setPasswordVC = [[DVerifyPhoneNumViewController alloc]initWithNibName:@"DVerifyPhoneNumViewController" bundle:nil];
        setPasswordVC.verigyTape = safe_password;
        setPasswordVC.userModel = self.userModel;
        [self.navigationController pushViewController:setPasswordVC animated:YES];
    }
}
- (IBAction)lookOverArgument:(id)sender {
    DWebViewController *vc = [[DWebViewController alloc]init];
    vc.isHelp = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

//获取验证码
- (IBAction)getVerifyCodeAction:(id)sender {
    NSDictionary *parameter;
    if (self.verigyTape == boud_verify||
        self.verigyTape == safe_phone_verify||
        self.verigyTape == safe_password_verify||
        self.verigyTape == safe_password2_verify||
        self.verigyTape == set_password_verify||
        self.verigyTape == password2_verify){
        parameter = @{@"mobile_phone":_userModel.phoneMob};
    }else if (self.verigyTape == safe_phone||
              self.verigyTape == safe_phone_bound||
              self.verigyTape == safe_password_bound||
              self.verigyTape == safe_password2_bound||
              self.verigyTape == set_password_bound){
        parameter = @{@"mobile_phone":self.phoneTextField.text,@"type":@"bindMobile"};
    }else if (self.verigyTape == register_verify){
        parameter = @{@"mobile_phone":self.phoneTextField.text,@"type":@"registry"};
    }else if (self.verigyTape == quick_login){
        parameter = @{@"mobile_phone":self.phoneTextField.text,@"type":@"login"};
    }
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Sends.sms" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            self.verifyNumber = responseObject.result;
//            [self startTimer];
        } else {
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

//启动定时器
- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
}
//走秒
- (void)timeBegin
{
    _restTime--;
    if (_restTime>0) {
        self.getCodeBut.userInteractionEnabled = NO;
        [self.getCodeBut setTitle:[NSString stringWithFormat:@"%d秒后重新获取",_restTime] forState:UIControlStateNormal];
        self.getCodeBut.backgroundColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1];
    }else {
        _restTime = 60;
        self.getCodeBut.userInteractionEnabled = YES;
        [self.getCodeBut setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getCodeBut.backgroundColor = DColor_mainColor;
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
    }
}

//注册
- (void)registry{
    if ([self.phoneTextField.text isEqualToString:self.verifyTextField.text]) {
        NSDictionary *parameter = @{@"mobile_phone":[DES3Util encrypt:self.phoneNumStr],@"yanzhengma":[DES3Util encrypt:self.messageCode],@"password":[DES3Util encrypt:self.phoneTextField.text],@"password1":[DES3Util encrypt:self.verifyTextField.text]};
        [[DMyAfHTTPClient sharedClient] postPathWithMethod:@"MyAccounts.registry" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                
                //保存userid 和password
                [FileOperation saveUserId:responseObject.result];
                [FileOperation savePassword:[DES3Util encrypt:self.phoneTextField.text]];
                
                //设置
                NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
                [FileOperation setPlistObject:@"1" forKey:kIsLogin ofFilePath:filePath];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //获取用户会员信息
                    [self getUerInfo];
                });
                
            }else {
                [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
        }];
    }else{
        [MBProgressHUD show:@"新密码和确认密码不一致！" icon:nil view:self.view afterDelay:0.7];
    }
    
}

//快速登录
- (void)fastLogin{
    if ([self.phoneTextField.text isEqualToString:@""]) {
        [MBProgressHUD show:@"请您填写正确的手机号码!" icon:nil view:self.view afterDelay:0.7];
    }else if ([self.verifyTextField.text isEqualToString:@""]){
        [MBProgressHUD show:@"请您填写正确的验证码!" icon:nil view:self.view afterDelay:0.7];
    }
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:[DES3Util encrypt:self.phoneTextField.text],@"mobilePhone", [DES3Util encrypt:self.verifyTextField.text],@"yanZhengMa", nil];
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.fastLogin" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation = %@",operation);
        NSLog(@"--%@--",responseObject.result);
        if (responseObject.succeed) {
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                //保存userid
                [FileOperation saveUserId:responseObject.result];
                
                //设置
                NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
                [FileOperation setPlistObject:@"1" forKey:kIsLogin ofFilePath:filePath];
                
                //获取用户会员信息
                [self getUerInfo];
                
            });
        }else{
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
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
            if (self.verigyTape == set_password||
                self.verigyTape == register_set_password||
                self.verigyTape == quick_login) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else if (self.verigyTape == safe_phone||
                      self.verigyTape == safe_password){
                [self.navigationController popViewControllerAnimated:NO];
                self.backBlock();
            }
        }else{
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
    
}
//验证手机和验证码
- (void)checkCodeAndPhone{
    NSDictionary *parameter;
    if ([FileOperation isLogin]) {
        parameter = @{@"userId":self.userModel.userId,@"phoneMob":[DES3Util encrypt:self.userModel.phoneMob],@"phone_codes":[DES3Util encrypt:self.verifyTextField.text],@"type":@"login"};
    }else{
        parameter = @{@"userId":self.userModel.userId,@"phoneMob":[DES3Util encrypt:self.userModel.phoneMob],@"phone_codes":[DES3Util encrypt:self.verifyTextField.text]};
    }
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.checkCode" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed){
            [self elsePushVC];
        }else{
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}
//绑定手机
- (void)boundModbilePhone{
    NSDictionary *paramsDic = [[NSDictionary alloc]init];
    paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:self.userModel.userId,@"userId", [DES3Util encrypt:self.phoneTextField.text],@"mobilePhone", [DES3Util encrypt:self.verifyTextField.text],@"yanzhengma", nil];
    [[DMyAfHTTPClient sharedClient] postPathWithMethod:@"MyUserInfos.bindMobilePhone" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //获取用户会员信息
                [self getUerInfo];
            });
            [self elsePushVC];
        }else{
            
        }
        [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}
//修改密码
- (void)updatePassword{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:self.userModel.userId,@"userId", [DES3Util encrypt:self.phoneTextField.text],@"oldPassword", [DES3Util encrypt:self.threeTextField.text],@"password", [DES3Util encrypt:self.verifyTextField.text],@"password1", nil];
    [[DMyAfHTTPClient sharedClient] postPathWithMethod:@"MyUserInfos.updatePassword" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            [FileOperation savePassword:[DES3Util encrypt:self.phoneTextField.text]];
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //获取用户会员信息
                [self getUerInfo];
            });

            
        }else{
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

//找回密码
- (void)findPassword{
    NSString *userName = [[NSString alloc]init];
    if (![self.userModel.email isEqualToString:@""]&&
        ![self.userModel.email isEqualToString:@"<null>"]) {
        userName = self.userModel.email;
    }else if (![self.userModel.nickName isEqualToString:@""]&&
              ![self.userModel.nickName isEqualToString:@"<null>"]){
        userName = self.userModel.nickName;
    }else if (![self.userModel.phoneMob isEqualToString:@""]&&
              ![self.userModel.phoneMob isEqualToString:@"<null>"]){
        userName = self.userModel.phoneMob;
    }
     NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:[ DES3Util encrypt:userName],@"userName", [DES3Util encrypt:self.phoneTextField.text],@"password", [DES3Util encrypt:self.verifyTextField.text],@"password1", [DES3Util encrypt:self.userModel.phoneMob],@"phoneMob",[DES3Util encrypt:self.messageCode],@"phone_codes",nil];
    [[DMyAfHTTPClient sharedClient] postPathWithMethod:@"MyAccounts.findPassword" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            
            [MBProgressHUD show:@"设置密码成功，请您重新登录！" icon:nil view:self.view afterDelay:3.0];
            [NSThread sleepForTimeInterval:3.0];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}


- (void)backToSafetySettingViewController:(BackBlock)block1
{
    self.backBlock = block1;
}

- (BOOL)checkPhone
{
    if ([commonTools isEmpty:self.phoneTextField.text]) {
        //        [ProgressHUD showMessage:@"手机号不能为空" Width:100 High:80];
        [MBProgressHUD show:@"手机号不能为空" icon:nil view:self.view afterDelay:1.0];
        return NO;
    }else if (![commonTools isValidPhone:self.phoneTextField.text]) {
        //        [ProgressHUD showMessage:@"输入有误，请输入正确的号码" Width:100 High:80];
        [MBProgressHUD show:@"输入有误，请输入正确的号码" icon:nil view:self.view afterDelay:1.0];
        
        return NO;
    }
    return YES;
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

@end

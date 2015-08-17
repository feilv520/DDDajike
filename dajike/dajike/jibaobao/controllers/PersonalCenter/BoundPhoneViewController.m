//
//  BoundPhoneViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/13.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "BoundPhoneViewController.h"
#import "defines.h"
#import "SetPaymentCodeViewController.h"
#import "HelpCenterViewController.h"

static int _restTime = 60;
@interface BoundPhoneViewController ()<UITextFieldDelegate>{
    NSString *_userId;
    NSTimer *_timer;
}

@property (nonatomic, strong) NSString *verifyNumber; // 验证码

@end

@implementation BoundPhoneViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.navigationItem.title = @"我的";
        
        
        
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    [self.getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getVerifyButton.userInteractionEnabled = YES;
    _restTime = 60;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    Bound_PHONE,//绑定手机号
//    VERIFY_PHONE,//验证手机号
//    REGISTER_USER,//注册
//    LOGIN_FAST,//无密码快速登录
//    SET_PASSWORD,//设置密码
    
    if (self.phoneType != FIND_PASSWORD) {
        [self initUserInfoModel];
    }
    if (self.phoneType == Bound_PHONE) {
        //绑定手机号
        titleLabel.text = @"绑定新手机号";
        self.phoneTextField.layer.borderWidth = 0.5;
        self.phoneTextField.layer.borderColor = [Color_gray4 CGColor];
        self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.yanzhengTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.yanzhengButton setTitle:@"绑定" forState:UIControlStateNormal];
//        if ([self.userInfoModel.phoneMobBindStatus isEqualToString:@"0"]) {
//            [self.phoneTextField setPlaceholder:@"请输入手机号码"];
//        }else{
//            if ([commonTools isNull:self.userInfoModel.phoneMob]){
//                [self.phoneTextField setPlaceholder:@""];
//            }else {
//                NSMutableString *phoneMob = [NSMutableString stringWithString:self.userInfoModel.phoneMob];
//                [phoneMob replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
//                [self.phoneTextField setPlaceholder:phoneMob];
//                [self.phoneTextField setText:self.userInfoModel.phoneMob];
//                self.phoneTextField.userInteractionEnabled = YES;
//            }
//        }
        if ([FileOperation isLogin]) {
            _userId = [FileOperation getUserId];
        }
        self.yanzhengTextField.layer.borderWidth = 0.5;
        self.yanzhengTextField.layer.borderColor = [Color_gray4 CGColor];
        
    }else if(self.phoneType == VERIFY_PHONE||
             self.phoneType == ZFMIMA_VERIFY||
             self.phoneType == MIMA_VERIFY||
             self.phoneType == PHONE_VERIFY){
        if (self.phoneType == PHONE_VERIFY) {
            self.phoneTextField.userInteractionEnabled = NO;
        }
        //验证手机号
        titleLabel.text = @"验证手机号";
        self.phoneTextField.layer.borderWidth = 0.5;
        self.phoneTextField.layer.borderColor = [Color_gray4 CGColor];
        self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.yanzhengTextField.keyboardType = UIKeyboardTypeNumberPad;
        if ([self.userInfoModel.phoneMobBindStatus isEqualToString:@"0"]) {
            [self.phoneTextField setPlaceholder:@"请输入手机号码"];
        }else{
            if ([commonTools isNull:self.userInfoModel.phoneMob]){
                [self.phoneTextField setPlaceholder:@""];
            }else {
                NSMutableString *phoneMob = [NSMutableString stringWithString:self.userInfoModel.phoneMob];
                [phoneMob replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
                [self.phoneTextField setPlaceholder:phoneMob];
                [self.phoneTextField setText:self.userInfoModel.phoneMob];
                self.phoneTextField.userInteractionEnabled = NO;
            }
        }
        self.yanzhengTextField.layer.borderWidth = 0.5;
        self.yanzhengTextField.layer.borderColor = [Color_gray4 CGColor];
        
    }else if(self.phoneType == REGISTER_USER){
        //注册
        titleLabel.text = @"注册";
        self.phoneTextField.layer.borderWidth = 0.5;
        self.phoneTextField.layer.borderColor = [Color_gray4 CGColor];
        [self.phoneTextField setPlaceholder:@"请输入手机号码"];
        self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.yanzhengTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        self.yanzhengTextField.layer.borderWidth = 0.5;
        self.yanzhengTextField.layer.borderColor = [Color_gray4 CGColor];
        [self.yanzhengTextField setPlaceholder:@"请输入验证码"];
        
        [self.yanzhengButton setTitle:@"下一步" forState:UIControlStateNormal];
        [self.yanzhengButton setBackgroundColor:[UIColor lightGrayColor]];
        [self.yanzhengButton setUserInteractionEnabled:NO];
        [self.statusImageVIew setHidden:NO];
        [self.argumentLabel setHidden:NO];
        [self.argumentBtn setHidden:NO];
        [self.argumentBut setHidden:NO];
        self.argumentBtn.selected = YES;
        [self.yanzhengButton setUserInteractionEnabled:YES];
        self.yanzhengButton.backgroundColor = Color_mainColor;
        
    }else if(self.phoneType == LOGIN_FAST){
        //无密码快速登录
        titleLabel.text = @"无密码快速登录";
        self.phoneTextField.layer.borderWidth = 0.5;
        self.phoneTextField.layer.borderColor = [Color_gray4 CGColor];
        [self.phoneTextField setPlaceholder:@"请输入手机号码"];
        
        self.yanzhengTextField.layer.borderWidth = 0.5;
        self.yanzhengTextField.layer.borderColor = [Color_gray4 CGColor];
        [self.yanzhengTextField setPlaceholder:@"请输入验证码"];
        
        self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.yanzhengTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        [self.yanzhengButton setTitle:@"登录" forState:UIControlStateNormal];
        
    }else if(self.phoneType == SET_PASSWORD||
             self.phoneType == REGISTER_PASSWORD||
             self.phoneType == FIND_PASSWORD){
        //设置密码
        titleLabel.text = @"设置密码";
        self.phoneTextField.layer.borderWidth = 0.5;
        self.phoneTextField.layer.borderColor = [Color_gray4 CGColor];
        [self.phoneTextField setPlaceholder:@"请输入6-20位字母或数字密码"];
        self.phoneTextField.secureTextEntry = YES;

        self.phoneTextField.keyboardType = UIKeyboardTypeDefault;
        self.yanzhengTextField.keyboardType = UIKeyboardTypeDefault;
        
        self.yanzhengTextField.layer.borderWidth = 0.5;
        self.yanzhengTextField.layer.borderColor = [Color_gray4 CGColor];
        [self.yanzhengTextField setPlaceholder:@"请再次输入密码"];
        self.yanzhengTextField.secureTextEntry = YES;
        
        [self.yanzhengButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.getVerifyButton setHidden:YES];
        _userId = self.userInfoModel.userId;
    }
    [self.phoneTextField addTarget:self action:@selector(inputWord:) forControlEvents:UIControlEventEditingChanged];
    [self.yanzhengTextField addTarget:self action:@selector(inputWord:) forControlEvents:UIControlEventEditingChanged];
    self.yanzhengTextField.delegate = self;
    
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUserInfoModel{
    if ([FileOperation isLogin]) {
        NSDictionary *userInfoDic = [[NSMutableDictionary alloc]init];
        userInfoDic = [[FileOperation readFileToDictionary:jibaobaoUser]mutableCopy];
        
        self.userInfoModel = [[UserInfoModel alloc]init];
        self.userInfoModel = [JsonStringTransfer dictionary:userInfoDic ToModel:self.userInfoModel];
    }else{
        
    }
}

//控制电话号码输入的长度  11 位
- (void)inputWord:(UITextField *)textField
{
    if (textField == self.phoneTextField) {
        if (self.phoneType == REGISTER_USER) {
            if (textField.text.length >= 11) {
                textField.text = [textField.text substringToIndex:11];
            }
        }
        if (self.phoneType == SET_PASSWORD||
            self.phoneType == REGISTER_PASSWORD||
            self.phoneType == FIND_PASSWORD) {
            if (textField.text.length > 20) {
                textField.text = [textField.text substringToIndex:20];
            }
        }
    }
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    if (textField == self.yanzhengTextField) {
//        if (self.phoneType == REGISTER_USER) {
//            if (![self checkPhone]) {
//                return YES;
//            }
//        }
//        if (self.phoneType == SET_PASSWORD||
//            self.phoneType == REGISTER_PASSWORD||
//            self.phoneType == FIND_PASSWORD) {
//            if ([commonTools isEmpty:self.phoneTextField.text]) {
//                [ProgressHUD showMessage:@"请先输入6-20位字母或数字密码" Width:100 High:80];
//                return NO;
//            }else if ([self.phoneTextField.text length] < 6) {
//                [ProgressHUD showMessage:@"密码不能低于6位" Width:100 High:80];
//                return NO;
//            }
//        }
//        
//    }
//    return YES;
//}



//检查电话号码输入数据的正确性
- (BOOL)checkPhone
{
    if ([commonTools isEmpty:self.phoneTextField.text]) {
        [ProgressHUD showMessage:@"手机号不能为空" Width:100 High:80];
        return NO;
    }else if (![commonTools isValidPhone:self.phoneTextField.text]) {
        [ProgressHUD showMessage:@"输入有误，请输入正确的号码" Width:100 High:80];
        return NO;
    }
    return YES;
}

//检查验证码数据输入
- (BOOL)checkCode
{
    if ([self checkPhone]) {
        if ([commonTools isEmpty:self.yanzhengTextField.text]) {
            [ProgressHUD showMessage:@"请输入验证码" Width:100 High:80];
            return NO;

        }else if (self.yanzhengTextField.text.length !=4 ||
                  [self.yanzhengTextField.text intValue] == 0){
            [ProgressHUD showMessage:@"请输入正确验证码" Width:100 High:80];
            return NO;


        } else if (![self.yanzhengTextField.text isEqualToString:[DES3Util decrypt:self.verifyNumber]]){
            [ProgressHUD showMessage:@"请输入正确验证码" Width:100 High:80];
            return NO;
        }
    }else{
        return NO;
    }
    return YES;
}

//检查数据的正确性
- (BOOL)checkDataIsRight
{
    
    if (self.phoneType == SET_PASSWORD||
        self.phoneType == REGISTER_PASSWORD||
        self.phoneType == FIND_PASSWORD) {
        if ([commonTools isEmpty:self.phoneTextField.text]) {
            [ProgressHUD showMessage:@"请先输入6-20位字母或数字密码" Width:100 High:80];
            return NO;
        }else if ([self.phoneTextField.text length] < 6) {
            [ProgressHUD showMessage:@"密码不能低于6位" Width:100 High:80];
            return NO;
        }else if ([commonTools isEmpty:self.yanzhengTextField.text]) {
            [ProgressHUD showMessage:@"请再次输入密码" Width:100 High:80];
            return NO;
        }
        else if (![self.phoneTextField.text isEqualToString:self.yanzhengTextField.text]) {
            [ProgressHUD showMessage:@"两次输入密码不相同" Width:100 High:80];
            return NO;
        }
    }
    return YES;
}


//获取验证码
- (IBAction)getVerifyCodeButtonClip:(id)sender {
    [self.view endEditing:YES];
    if ([self checkPhone]) {
        [self sendsSMS];
    }
}
//验证或完成
- (IBAction)verifyCodeButtonClip:(id)sender {
    [self.view endEditing:YES];
    if (self.phoneType == Bound_PHONE) {//绑定手机号 验证
        if ([self checkCode]) {
            [self binModbilePhone];
        }
        
    }else if (self.phoneType == VERIFY_PHONE||
              self.phoneType == ZFMIMA_VERIFY||
              self.phoneType == MIMA_VERIFY||
              self.phoneType == PHONE_VERIFY){//验证手机号 验证
        if ([self checkCode]) {
            [self checkPhoneCode];
        }
        
    }else if (self.phoneType == REGISTER_USER){//注册 下一步
        
        if ([self checkCode]) {
            BoundPhoneViewController *vc = [[BoundPhoneViewController alloc]init];
            vc.phoneType = REGISTER_PASSWORD;
            vc.phoneNumStr = self.phoneTextField.text;
            vc.messageCode = self.yanzhengTextField.text;
            [vc callBackRegisterSuccess:^{
                [self.navigationController popViewControllerAnimated:NO];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (self.phoneType == LOGIN_FAST){//无密码快速登录 登录
        if ([self checkCode]) {
            [self fastLogin];
        }
        
    }else if (self.phoneType == SET_PASSWORD){
        
        if ([self checkDataIsRight]) {
            
            [self updatePassword];
        }
        
        
    }else if (self.phoneType == REGISTER_PASSWORD){
        if ([self checkDataIsRight]) {
            [self registry];
        }
    }else if (self.phoneType == FIND_PASSWORD){
        if ([self checkDataIsRight]) {
            [self findPassword];
        }
    }
}

//手机验证
- (void)checkPhoneCode{
    NSString *phoneStr = [[NSString alloc]init];
    if (self.phoneType == PHONE_VERIFY) {
        phoneStr = self.userInfoModel.phoneMob;
    }else{
        phoneStr = self.phoneTextField.text;
    }
    NSDictionary *parameter;
    if ([FileOperation isLogin]) {
        parameter = @{@"userId":self.userInfoModel.userId,@"phoneMob":[DES3Util encrypt:phoneStr],@"phone_codes":[DES3Util encrypt:self.yanzhengTextField.text],@"type":@"login"};
    }else{
        parameter = @{@"userId":self.userInfoModel.userId,@"phoneMob":[DES3Util encrypt:phoneStr],@"phone_codes":[DES3Util encrypt:self.yanzhengTextField.text]};
    }
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.checkCode" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {

            if (self.phoneType == ZFMIMA_VERIFY) {
                SetPaymentCodeViewController *SetPaymentCodeVC = [[SetPaymentCodeViewController alloc]initWithNibName:nil bundle:nil];
                SetPaymentCodeVC.phoneCode = self.yanzhengTextField.text;
                [SetPaymentCodeVC callBackRegisterSuccess11:^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    self.block();
                }];
                [self.navigationController pushViewController:SetPaymentCodeVC animated:YES];
            }else if (self.phoneType == MIMA_VERIFY){
                BoundPhoneViewController *vc = [[BoundPhoneViewController alloc]init];
                vc.phoneType = SET_PASSWORD;
                vc.phoneNumStr = self.phoneTextField.text;
                vc.messageCode = self.yanzhengTextField.text;
                [vc backToSafetySettingViewController:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }else if (self.phoneType == PHONE_VERIFY){
                BoundPhoneViewController *vc = [[BoundPhoneViewController alloc]init];
                vc.phoneType = Bound_PHONE;
//                vc.phoneNumStr = self.phoneTextField.text;
//                vc.messageCode = self.yanzhengTextField.text;
                [vc backToSafetySettingViewController:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
//获取验证码
- (void)sendsSMS{
    NSDictionary *parameter;
    if (self.phoneType == Bound_PHONE) {//绑定手机
        parameter = @{@"mobile_phone":self.phoneTextField.text,@"type":@"bindMobile"};
    }else if (self.phoneType == REGISTER_USER) {//注册
        parameter = @{@"mobile_phone":self.phoneTextField.text,@"type":@"registry"};
    }else if (self.phoneType == LOGIN_FAST) {//快速登录
        parameter = @{@"mobile_phone":self.phoneTextField.text,@"type":@"login"};
    }else{
        parameter = @{@"mobile_phone":self.phoneTextField.text};
    }
//    NSDictionary *parameter = @{@"mobile_phone":self.phoneTextField.text,@"type":smsType};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Sends.sms" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            self.verifyNumber = responseObject.result;
            [self startTimer];
        } else {
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
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
        self.getVerifyButton.userInteractionEnabled = NO;
        [self.getVerifyButton setTitle:[NSString stringWithFormat:@"%d秒后重新获取",_restTime] forState:UIControlStateNormal];
        self.getVerifyButton.backgroundColor = Color_line_bg;
    }else {
        _restTime = 60;
        self.getVerifyButton.userInteractionEnabled = YES;
        [self.getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getVerifyButton.backgroundColor = Color_mainColor;
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
    }
}

//注册
- (void)registry{
    NSLog(@"%@;%@;%@;%@",self.phoneNumStr,self.messageCode,self.phoneTextField.text,self.yanzhengTextField.text);
    NSDictionary *parameter = @{@"mobile_phone":[DES3Util encrypt:self.phoneNumStr],@"yanzhengma":[DES3Util encrypt:self.messageCode],@"password":[DES3Util encrypt:self.phoneTextField.text],@"password1":[DES3Util encrypt:self.yanzhengTextField.text]};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.registry" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        
        if (responseObject.succeed) {
            
            //保存userid 和password
            [FileOperation saveUserId:responseObject.result];
            [FileOperation savePassword:[DES3Util encrypt:self.phoneTextField.text]];
            
            //设置
            NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
            [FileOperation setPlistObject:@"1" forKey:kIsLogin ofFilePath:filePath];
            _userId = [AnalysisData decodeToString:responseObject.result];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //获取用户会员信息
                [self getUerInfo];
            });
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else {
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];

    
}

//获取用户会员信息，存入本地
- (void)getUerInfo
{
    NSDictionary *parameter = @{@"userId":_userId};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyUserInfos.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSString *jsonStr = [AnalysisData decodeToString:responseObject.result];
            NSMutableDictionary *userInfoDic = [[JsonStringTransfer jsonStringToDictionary:jsonStr]mutableCopy];
            NSString *filePath = [FileOperation creatPlistIfNotExist:jibaobaoUser];
            [FileOperation writeToPlistFile:filePath withDic:userInfoDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
//找回密码
- (void)findPassword{
    NSString *userName = [[NSString alloc]init];
    if (![self.userInfoModel.email isEqualToString:@""]&&
        ![self.userInfoModel.email isEqualToString:@"<null>"]) {
        userName = self.userInfoModel.email;
    }else if (![self.userInfoModel.nickName isEqualToString:@""]&&
              ![self.userInfoModel.nickName isEqualToString:@"<null>"]){
        userName = self.userInfoModel.nickName;
    }else if (![self.userInfoModel.phoneMob isEqualToString:@""]&&
              ![self.userInfoModel.phoneMob isEqualToString:@"<null>"]){
        userName = self.userInfoModel.phoneMob;
    }

    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:[ DES3Util encrypt:userName],@"userName", [DES3Util encrypt:self.phoneTextField.text],@"password", [DES3Util encrypt:self.yanzhengTextField.text],@"password1", [DES3Util encrypt:self.userInfoModel.phoneMob],@"phoneMob",[DES3Util encrypt:self.messageCode],@"phone_codes",nil];
    
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyAccounts.findPassword" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        if (responseObject.succeed) {
            
            [MBProgressHUD show:@"设置密码成功，请您重新登录！" icon:nil view:self.view afterDelay:0.7];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];

}

//修改密码 完成
-(void)updatePassword{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:self.userInfoModel.userId,@"userId", [DES3Util encrypt:[FileOperation getPassword]],@"oldPassword", [DES3Util encrypt:self.phoneTextField.text],@"password", [DES3Util encrypt:self.yanzhengTextField.text],@"password1", nil];
    
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyUserInfos.updatePassword" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        if (responseObject.succeed) {
            [FileOperation savePassword:[DES3Util encrypt:self.phoneTextField.text]];
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //获取用户会员信息
                [self getUerInfo];
            });
            [self.navigationController popViewControllerAnimated:NO];
            self.mBlock();
            
        }else{
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];

}

//绑定手机
-(void)binModbilePhone{
    
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:self.userInfoModel.userId,@"userId", [DES3Util encrypt:self.phoneTextField.text],@"mobilePhone", [DES3Util encrypt:self.yanzhengTextField.text],@"yanzhengma", nil];
    
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyUserInfos.bindMobilePhone" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        NSLog(@"operation = %@",operation);
        NSLog(@"--%@--",responseObject.result);
        if (responseObject.succeed) {
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //获取用户会员信息
                [self getUerInfo];
            });
            if ([self.flagStr intValue] == 808) {
                self.fillInIndentViewControllerBlock(self.phoneTextField.text);
            }
            [self.navigationController popViewControllerAnimated:NO];
            self.mBlock();
            
        }else{
            
        }
        [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
    
}
//无密码快速登录
- (void)fastLogin{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:[DES3Util encrypt:self.phoneTextField.text],@"mobilePhone", [DES3Util encrypt:self.yanzhengTextField.text],@"yanZhengMa", nil];
    
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyAccounts.fastLogin" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        NSLog(@"operation = %@",operation);
        NSLog(@"--%@--",responseObject.result);
        if (responseObject.succeed) {
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                _userId = [DES3Util decrypt:responseObject.result];
                //保存userid
                [FileOperation saveUserId:responseObject.result];
                
                //设置
                NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
                [FileOperation setPlistObject:@"1" forKey:kIsLogin ofFilePath:filePath];

                //获取用户会员信息
                [self getUerInfo];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];

}

//是否同意协议内容
- (IBAction)argumentButtonClip:(id)sender {
    [self.view endEditing:YES];
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (self.phoneType == REGISTER_USER) {
        if (btn.selected) {
            [self.statusImageVIew setImage:[UIImage imageNamed:@"img_selected"]];
            [self.yanzhengButton setUserInteractionEnabled:YES];
            self.yanzhengButton.backgroundColor = Color_mainColor;
        }else {
            [self.statusImageVIew setImage:[UIImage imageNamed:@"img_no_selected"]];
            [self.yanzhengButton setUserInteractionEnabled:NO];
            self.yanzhengButton.backgroundColor = [UIColor lightGrayColor];
        }
    }
}

- (IBAction)lookOverArgument:(id)sender {
    HelpCenterViewController *helpCenterVC = [[HelpCenterViewController alloc]initWithNibName:nil bundle:nil];
    helpCenterVC.isHelp = 3;
    [self.navigationController pushViewController:helpCenterVC animated:YES];
}

- (void)callBackRegisterSuccess:(RegisterSuccessBlock)block
{
    self.block = block;
}
- (void)backToSafetySettingViewController:(BackBlock)block1
{
    self.mBlock = block1;
}
- (void)backToFillInIndentViewController:(BackToFillInIndentViewControllerBlock)block2
{
    self.fillInIndentViewControllerBlock = block2;
}

@end

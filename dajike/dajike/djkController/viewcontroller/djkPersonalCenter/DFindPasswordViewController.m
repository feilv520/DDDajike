//
//  DFindPasswordViewController.m
//  dajike
//
//  Created by songjw on 15/7/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DFindPasswordViewController.h"
#import "DVerifyPhoneNumViewController.h"
#import "dDefine.h"
#import "DTools.h"
#import "MBProgressHUD+Add.h"
#import "DES3Util.h"

static int _restTime = 60;

@interface DFindPasswordViewController (){
    NSInteger pageStatus;//0:手机  1:邮箱  2:邮箱验证码发送成功
    NSTimer *_timer;
}
@property (nonatomic, strong) NSString *verifyNumber; // 验证码
@end

@implementation DFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:DColor_f3f3f3];
    [self.tishiVIew setBackgroundColor:DColor_f3f3f3];
    [DTools setLable:self.lab_1 Font:DFont_13 titleColor:DColor_808080 backColor:[UIColor clearColor]];
    [DTools setLable:self.lab_2 Font:DFont_13 titleColor:DColor_c4291f backColor:[UIColor clearColor]];
    [DTools setLable:self.lab_3 Font:DFont_13 titleColor:DColor_808080 backColor:[UIColor clearColor]];
    [DTools setButtton:self.mainButton Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
    [DTools setLable:self.helloLabel Font:DFont_12 titleColor:DColor_808080 backColor:[UIColor clearColor]];
    [DTools setLable:self.findTypeLab Font:DFont_12 titleColor:DColor_808080 backColor:[UIColor clearColor]];
    [DTools setTextfield:self.selectTextFiled Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setLable:self.phoneLabel Font:DFont_13 titleColor:DColor_808080 backColor:[UIColor clearColor]];
    [DTools setTextfield:self.putCOdeTextField Font:DFont_13 titleColor:DColor_cccccc backColor:DColor_ffffff];
    [DTools setButtton:self.getCodeButton Font:DFont_11 titleColor:DColor_ffffff backColor:DColor_c4291f];
    [DTools setButtton:self.phoneBut Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.emailBut Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];


    [self setNaviBarTitle:@"找回密码"];
    
    [self.mainButton.layer setMasksToBounds:YES];
    [self.mainButton.layer setCornerRadius:4.0];
    [self.getCodeButton.layer setMasksToBounds:YES];
    [self.getCodeButton.layer setCornerRadius:4.0];
    
    //获取验证码 加到填写验证码的文本框上面
    [self.view insertSubview:self.getCodeButton aboveSubview:self.putCOdeTextField];
    self.selectTextFiled.layer.borderWidth = 0.5;
    self.selectTextFiled.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.putCOdeTextField.layer.borderWidth = 0.5;
    self.putCOdeTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.selectTextFiled.layer setMasksToBounds:YES];
    [self.selectTextFiled.layer setCornerRadius:4.0];
    [self.putCOdeTextField.layer setMasksToBounds:YES];
    [self.putCOdeTextField.layer setCornerRadius:4.0];
    self.shouSelectVIew.backgroundColor = [UIColor whiteColor];
    
    
    self.helloLabel.text = [NSString stringWithFormat:@"%@,您好",self.userInfoModel.nickName];
    if ([self.userInfoModel.phoneMob isEqualToString:@"<null>"]||
        self.userInfoModel.phoneMob == nil){
        [self showEmail];
    }else{
        [self showPhone];
    }
}

- (void) hiddenAll
{
    for (UIView *view in self.view.subviews) {
        [view setHidden:YES];
    }
}
- (void) showAll
{
    for (UIView *view in self.view.subviews) {
        [view setHidden:NO];
    }
}
//手机验证码的形式找回密码
- (void) showPhone
{
    
    pageStatus = 0;
    [self showAll];
    [self.mainButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.shouSelectVIew setHidden:YES];
    [self.tishiVIew setHidden:YES];
    self.selectTextFiled.text = @"   手机";
    NSMutableString *phoneNum = [NSMutableString stringWithString:self.userInfoModel.phoneMob];
    [phoneNum replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    self.phoneLabel.text = phoneNum;

    
}

//邮件的形式找回密码
- (void) showEmail
{
    pageStatus = 1;
    [self showAll];
    [self.mainButton setTitle:@"发送验证邮箱" forState:UIControlStateNormal];
    [self.shouSelectVIew setHidden:YES];
    [self.tishiVIew setHidden:YES];
    [self.putCOdeTextField setHidden:YES];
    [self.getCodeButton setHidden:YES];
    self.selectTextFiled.text = @"   邮箱";
    [self.phoneLabel setText:self.userInfoModel.email];
}

//验证码已发送到邮箱
- (void) showSuccess
{
    pageStatus = 2;
//    [self hiddenAll];
    [self.tishiVIew setHidden:NO];
    [self.mainButton setHidden:NO];
    [self.mainButton setTitle:@"返回登录页面" forState:UIControlStateNormal];
}
- (IBAction)getCodeBUttonClip:(id)sender{
    NSDictionary *parameter = @{@"mobile_phone":self.userInfoModel.phoneMob};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Sends.sms" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            self.verifyNumber = [DES3Util decrypt:responseObject.result] ;
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
        self.getCodeButton.userInteractionEnabled = NO;
        [self.getCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重新获取",_restTime] forState:UIControlStateNormal];
        self.getCodeButton.backgroundColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1];
    }else {
        _restTime = 60;
        self.getCodeButton.userInteractionEnabled = YES;
        [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getCodeButton.backgroundColor = DColor_mainColor;
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
    }
}
- (IBAction)mainButtonClip:(id)sender{
    //0:手机  1:邮箱  2:邮箱验证码发送成功
    if (pageStatus == 0) {
        if ([self.verifyNumber isEqualToString:self.putCOdeTextField.text]) {
            DVerifyPhoneNumViewController *setPasswordVC = [[DVerifyPhoneNumViewController alloc]initWithNibName:@"DVerifyPhoneNumViewController" bundle:nil];
            setPasswordVC.verigyTape = set_password;
            setPasswordVC.phoneNumStr = self.userInfoModel.phoneMob;
            setPasswordVC.messageCode = self.putCOdeTextField.text;
            setPasswordVC.userModel = _userInfoModel;
            [self.navigationController pushViewController:setPasswordVC animated:YES];
        }else{
            [MBProgressHUD show:@"请输入正确的验证码！　" icon:nil view:self.view afterDelay:0.7];
        }
    }else if (pageStatus == 1){
        [self sendsEmail];
    }else if (pageStatus == 2){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
//展开 和收起
- (IBAction)upDownBUttonClip:(id)sender{
    if (self.shouSelectVIew.isHidden == YES) {
        [self.shouSelectVIew setHidden:NO];
        [self.updownIMageVIew setImage:[UIImage imageNamed:@"img_arrow_03_up"]];
    }else{
        [self.shouSelectVIew setHidden:YES];
        [self.updownIMageVIew setImage:[UIImage imageNamed:@"img_arrow_03_down"]];
    }
}
//选择手机形式
- (IBAction)selectphoneClip:(id)sender {
    if ([self.userInfoModel.phoneMob isEqualToString:@"<null>"]||
        self.userInfoModel.phoneMob == nil){
        [self showEmail];
        [MBProgressHUD show:@"手机为空" icon:nil view:self.view];
    }else{
        [self showPhone];
    }
    [self.updownIMageVIew setImage:[UIImage imageNamed:@"img_arrow_03_down"]];
    
}

//选择邮箱形式
- (IBAction)selectEmailClip:(id)sender {
    if ([self.userInfoModel.email isEqualToString:@"<null>"]||
        self.userInfoModel.phoneMob == nil){
        [self showPhone];
        [MBProgressHUD show:@"邮箱为空" icon:nil view:self.view];
    }else{
        [self showEmail];
    }

    [self.updownIMageVIew setImage:[UIImage imageNamed:@"img_arrow_03_down"]];
}
//发邮件
- (void)sendsEmail{
    NSDictionary *parameter = @{@"address":self.userInfoModel.email,@"type":@"findPassword"};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Sends.email" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            [self showSuccess];
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
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

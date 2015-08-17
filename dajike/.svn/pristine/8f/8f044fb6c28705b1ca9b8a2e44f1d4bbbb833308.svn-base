//
//  FindPasswordViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "MyAfHTTPClient.h"
#import "BoundPhoneViewController.h"
#import "defines.h"

@interface FindPasswordViewController ()
{
    NSInteger pageStatus;//0:手机  1:邮箱  2:邮箱验证码发送成功
}
@property (weak, nonatomic) IBOutlet UILabel *helloLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *selectTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UITextField *putCOdeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *updownIMageVIew;
@property (weak, nonatomic) IBOutlet UIView *shouSelectVIew;
@property (weak, nonatomic) IBOutlet UIView *tishiVIew;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

- (IBAction)getCodeBUttonClip:(id)sender;
- (IBAction)mainButtonClip:(id)sender;
- (IBAction)upDownBUttonClip:(id)sender;
- (IBAction)selectphoneClip:(id)sender;
- (IBAction)selectEmailClip:(id)sender;

@end

@implementation FindPasswordViewController
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
    // Do any additional setup after loading the view.
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    //获取验证码 加到填写验证码的文本框上面
    [self.view insertSubview:self.getCodeButton aboveSubview:self.putCOdeTextField];
    self.helloLabel.text = self.userModel.nickName;
    [self showPhone];
    
    
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
    NSMutableString *phoneStr = [self.userModel.phoneMob mutableCopy];
    [phoneStr replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    [self.phoneLabel setText: phoneStr];
    
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
    [self.phoneLabel setText:self.userModel.email];
}

//验证码已发送到邮箱
- (void) showSuccess
{
    pageStatus = 2;
    [self hiddenAll];
    [self.tishiVIew setHidden:NO];
    [self.mainButton setHidden:NO];
    [self.mainButton setTitle:@"返回登录页面" forState:UIControlStateNormal];
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
//获取验证码
- (IBAction)getCodeBUttonClip:(id)sender {
    NSLog(@"获取验证码");
    NSDictionary *parameter = @{@"mobile_phone":self.userModel.phoneMob};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Sends.sms" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];

}

//邮箱发送
- (void)sendsEmail{
    NSDictionary *parameter = @{@"address":self.userModel.email,@"type":@"findPassword"};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Sends.email" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            [self showSuccess];
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

//红色按钮  事件
- (IBAction)mainButtonClip:(id)sender {
    if (pageStatus == 0) {//手机发送
        if ([self.putCOdeTextField.text isEqualToString:@""]) {
            [MBProgressHUD show:@"验证码不正确!" icon:nil view:self.view afterDelay:0.7];
            return;
        }
        BoundPhoneViewController *setPasswordVC = [[BoundPhoneViewController alloc]init];
        setPasswordVC.userInfoModel = self.userModel;
        setPasswordVC.phoneType = FIND_PASSWORD;
        setPasswordVC.messageCode = self.putCOdeTextField.text;
        
        [self.navigationController pushViewController:setPasswordVC animated:YES];
        
    }else if(pageStatus == 1){//邮箱发送
        [self sendsEmail];
        
    }else if(pageStatus == 2){//邮箱成功
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//展开 和收起
- (IBAction)upDownBUttonClip:(id)sender {
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
    [self showPhone];
    [self.updownIMageVIew setImage:[UIImage imageNamed:@"img_arrow_03_down"]];
}

//选择邮箱形式
- (IBAction)selectEmailClip:(id)sender {
    [self showEmail];
    [self.updownIMageVIew setImage:[UIImage imageNamed:@"img_arrow_03_down"]];
}
@end

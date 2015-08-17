//
//  BankCardInfoViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "BankCardInfoViewController.h"
#import "defines.h"
#import "BankBoundListModel.h"
#import "BoundPhoneViewController.h"

@interface BankCardInfoViewController ()<UITextFieldDelegate>
{
    //支付密码
    NSString *paymentPassword;
}
@property (weak, nonatomic) IBOutlet UIImageView *bankIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLAbel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
- (IBAction)trashButtonClip:(id)sender;

//解绑银行卡
@property (weak, nonatomic) IBOutlet UIView *jiabangVIew;
@property (weak, nonatomic) IBOutlet UIView *mengbanVIew;

@property (weak, nonatomic) IBOutlet UITextField *textField0;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *textField5;
//只是用来调出数字键盘
@property (weak, nonatomic) IBOutlet UITextField *testTextField;

//银行卡信息model
@property (retain, nonatomic) BankBoundListModel *bankBoundListItem;
- (IBAction)cancleBUttonClip:(id)sender;
- (IBAction)ensureButtonClip:(id)sender;
- (IBAction)rememberPassword:(id)sender;

@end

@implementation BankCardInfoViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"银行卡信息";
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    [self.mengbanVIew setHidden:YES];
    
}

//获取银行卡信息
- (void)getBankCardInfo
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId],@"userId",self.bankId,@"bankId", nil];
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyBanks.show" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSDictionary *resultDic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
            BankBoundListModel *bantItem= [[BankBoundListModel alloc]init];
            bantItem = [JsonStringTransfer dictionary:resultDic ToModel:bantItem];
            self.bankBoundListItem = bantItem;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation = %@",operation);
        NSLog(@"error = %@",error);
    }];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getBankCardInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//展示银行卡信息
- (void)setBankBoundListItem:(BankBoundListModel *)model
{
    [self.bankIconImageView setImage:[UIImage imageNamed:@"img_yl.png"]];//undo
    self.bankNameLabel.text = model.bankName;
    NSMutableString *kahao = [NSMutableString stringWithString:model.kahao];
    self.cardNumberLabel.text = [NSString stringWithFormat:@"尾号 %@  储蓄卡",[kahao substringWithRange:NSMakeRange(kahao.length-4, 4)]];
    self.nameLAbel.text = model.userName;
    NSString *IDCard = model.shenfenzheng;
    if (![model.shenfenzheng isEqualToString:@""]) {
        IDCard = [model.shenfenzheng stringByReplacingCharactersInRange:NSMakeRange(6,8) withString:@"********"];
    }
    
    self.idCardLabel.text = IDCard;
}
//解绑
- (IBAction)trashButtonClip:(id)sender {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    UIView *rootView = topController.view;
    self.mengbanVIew.frame = rootView.bounds;
    [self.mengbanVIew setHidden:NO];
//    [rootView addSubview:self.mengbanVIew];
    [rootView bringSubviewToFront:self.mengbanVIew];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.jiabangVIew.alpha = 1.0f;
        self.jiabangVIew.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);}
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.12 animations:^{
                             self.jiabangVIew.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);} completion:^(BOOL finished) {
                                 
                                 [UIView animateWithDuration:0.12 animations:^{
                                     self.jiabangVIew.transform = CGAffineTransformIdentity;
                                 } completion:^(BOOL finished) {
                                     NSLog(@"hello");
                                     [self.testTextField becomeFirstResponder];
                                     self.testTextField.text = @"";
                                     
                                 }];
                             }];
                     }];

}
//取消
- (IBAction)cancleBUttonClip:(id)sender {
    [UIView animateWithDuration:0.12 animations:^{
//         UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
//        while (topController.presentedViewController) {
//            topController = topController.presentedViewController;
//        }
//        UIView *rootView = topController.view;
        [self.mengbanVIew setHidden:YES];
    } completion:^(BOOL finished) {
        [self resetTextField];
        [self.testTextField endEditing:YES];
        
    }];
}
//确定
- (IBAction)ensureButtonClip:(id)sender {
    [UIView animateWithDuration:0.12 animations:^{
        [self.mengbanVIew setHidden:YES];
    } completion:^(BOOL finished) {
        NSLog(@"hello");
        [self resetTextField];
        [self.testTextField endEditing:YES];
        
    }];
    
    //确保支付密码为6位数字
    if (paymentPassword.length >= 6) {//至少6位
        NSString *password = [paymentPassword substringToIndex:6];
        if ([commonTools isAllNum:password]) {//全为数字
            //解绑银行卡
            NSDictionary *parameter = @{@"userId":[FileOperation getUserId],@"bankId":self.bankId,@"password":[DES3Util encrypt:password]};
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyBanks.delete" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.5];
                    //退出当前页面
                    [self performSelector:@selector(back) withObject:self afterDelay:0.6];
                }else{
                    [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.5];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
            }];
        }else{
             [MBProgressHUD show:@"请输入正确的6位支付密码！" icon:nil view:self.view afterDelay:0.5];
        }
    }else{
        [MBProgressHUD show:@"请输入正确的6位支付密码！" icon:nil view:self.view afterDelay:0.5];
    }
    
    
}
//忘记密码
- (IBAction)rememberPassword:(id)sender {
//    [self cancleBUttonClip:nil];
    BoundPhoneViewController *vc = [[BoundPhoneViewController alloc]init];
    vc.phoneType = ZFMIMA_VERIFY;
    [vc callBackRegisterSuccess:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}

//初始化textField
-(void) resetTextField
{
    self.textField0.text = @"";
    self.textField1.text = @"";
    self.textField2.text = @"";
    self.textField3.text = @"";
    self.textField4.text = @"";
    self.textField5.text = @"";
}

//退出当前页面
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  mark---------
#pragma mark---------UITextFieldDelegate-------------
- (void) textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"string = %@",string);
    if (textField.text.length > 1) {
         NSLog(@"[textField.text substringWithRange:NSMakeRange(0, 1)] = %@",[textField.text substringWithRange:NSMakeRange(0, 1)]);
    }
   
    if (range.location == 0){
        [self resetTextField];
        self.textField0.text = string;
    }else if (range.location == 1){
        self.textField0.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
        self.textField1.text = string;
        self.textField2.text = @"";
        self.textField3.text = @"";
        self.textField4.text = @"";
        self.textField5.text = @"";
    }else if (range.location == 2){
        self.textField0.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
        self.textField1.text = [textField.text substringWithRange:NSMakeRange(1, 1)];
        self.textField2.text = string;
        self.textField3.text = @"";
        self.textField4.text = @"";
        self.textField5.text = @"";
    }else if (range.location == 3){
        self.textField0.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
        self.textField1.text = [textField.text substringWithRange:NSMakeRange(1, 1)];
        self.textField2.text = [textField.text substringWithRange:NSMakeRange(2, 1)];
        self.textField3.text = string;
        self.textField4.text = @"";
        self.textField5.text = @"";
    }else if (range.location == 4){
        self.textField0.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
        self.textField1.text = [textField.text substringWithRange:NSMakeRange(1, 1)];
        self.textField2.text = [textField.text substringWithRange:NSMakeRange(2, 1)];
        self.textField3.text = [textField.text substringWithRange:NSMakeRange(3, 1)];
        self.textField4.text = string;
        self.textField5.text = @"";
    }else if (range.location == 5){
        self.textField0.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
        self.textField1.text = [textField.text substringWithRange:NSMakeRange(1, 1)];
        self.textField2.text = [textField.text substringWithRange:NSMakeRange(2, 1)];
        self.textField3.text = [textField.text substringWithRange:NSMakeRange(3, 1)];
        self.textField4.text = [textField.text substringWithRange:NSMakeRange(4, 1)];
        self.textField5.text = string;
    }else if (range.location == 6){
        [self.testTextField endEditing:YES];
    }
    paymentPassword = [NSString stringWithFormat:@"%@%@",textField.text,string];
    return YES;
}




@end

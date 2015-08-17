//
//  DBankCardInfoViewController.m
//  dajike
//
//  Created by songjw on 15/7/15.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBankCardInfoViewController.h"
#import "dDefine.h"
#import "DMyAfHTTPClient.h"
#import "AnalysisData.h"
#import "DES3Util.h"
#import "DVerifyPhoneNumViewController.h"
#import "BankBoundListModel.h"
#import "UserInfoModel.h"

@interface DBankCardInfoViewController (){
    //支付密码
    NSMutableString *paymentPassword;
    NSMutableArray *codeArr;
    NSInteger currentIndex;
}
@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;
@property (weak, nonatomic) IBOutlet UIImageView *bankIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLAbel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
- (IBAction)trashButtonClip:(id)sender;

//解绑银行卡
@property (weak, nonatomic) IBOutlet UIView *jiabangVIew;
@property (weak, nonatomic) IBOutlet UIView *mengbanVIew;

@property (weak, nonatomic) IBOutlet UILabel *lab_4;
@property (weak, nonatomic) IBOutlet UILabel *lab_5;
@property (weak, nonatomic) IBOutlet UIButton *forgetBut;
@property (weak, nonatomic) IBOutlet UIButton *nextBut;
@property (weak, nonatomic) IBOutlet UITextField *textField0;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *textField5;
//只是用来调出数字键盘
@property (weak, nonatomic) IBOutlet UITextField *testTextField;
@property (weak, nonatomic) IBOutlet UIButton *but_1;
@property (weak, nonatomic) IBOutlet UIButton *but_2;
@property (weak, nonatomic) IBOutlet UIButton *but_3;
@property (weak, nonatomic) IBOutlet UIButton *but_4;
@property (weak, nonatomic) IBOutlet UIButton *but_5;
@property (weak, nonatomic) IBOutlet UIButton *but_6;
@property (weak, nonatomic) IBOutlet UIButton *but_7;
@property (weak, nonatomic) IBOutlet UIButton *but_8;
@property (weak, nonatomic) IBOutlet UIButton *but_9;
@property (weak, nonatomic) IBOutlet UIButton *but_del;
@property (weak, nonatomic) IBOutlet UIButton *but_0;

//银行卡信息model
@property (retain, nonatomic) BankBoundListModel *bankBoundListItem;
- (IBAction)cancleBUttonClip:(id)sender;
- (IBAction)ensureButtonClip:(id)sender;
- (IBAction)rememberPassword:(id)sender;
@end

@implementation DBankCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviBarTitle:@"银行卡信息"];
    [self.view setBackgroundColor:DColor_f3f3f3];
    [DTools setLable:self.bankNameLabel Font:DFont_12 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setLable:self.cardNumberLabel Font:DFont_11 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setLable:self.lab_1 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setLable:self.lab_2 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setLable:self.nameLAbel Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setLable:self.idCardLabel Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    
//    [self.mengbanVIew setBackgroundColor:DColor_a0a0a0];
//    self.mengbanVIew.alpha = 1.0;
    [self.jiabangVIew setBackgroundColor:DColor_ffffff];
    [DTools setLable:self.lab_4 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setLable:self.lab_5 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.forgetBut Font:DFont_11 titleColor:DColor_c4291f backColor:DColor_ffffff];
    [DTools setButtton:self.nextBut Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
    
    [DTools setButtton:self.but_0 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_1 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_2 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_3 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_4 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_5 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_6 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_7 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_8 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_9 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];

    
    [self.mengbanVIew setHidden:YES];
    [self getBankCardInfo];
}


//获取银行卡信息
- (void)getBankCardInfo
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId],@"userId",self.bankId,@"bankId", nil];
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyBanks.show" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSDictionary *resultDic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
            BankBoundListModel *bantItem= [[BankBoundListModel alloc]init];
            bantItem = [JsonStringTransfer dictionary:resultDic ToModel:bantItem];
            self.bankBoundListItem = bantItem;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
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
    currentIndex = 0;
    codeArr = [[NSMutableArray alloc]init];
    //    [rootView addSubview:self.mengbanVIew];
    [rootView bringSubviewToFront:self.mengbanVIew];

    [UIView animateWithDuration:0.2 animations:^{
        self.jiabangVIew.alpha = 1.0f;
        self.jiabangVIew.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);}
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.12 animations:^{
                             self.jiabangVIew.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);} completion:^(BOOL finished) {
                                 
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
    paymentPassword = [self arrayToString:codeArr];
    //确保支付密码为6位数字
    if (paymentPassword.length >= 6) {//至少6位
//        NSString *password = [paymentPassword substringToIndex:6];
        if ([commonTools isAllNum:paymentPassword]) {//全为数字
            //解绑银行卡
            NSDictionary *parameter = @{@"userId":[FileOperation getUserId],@"bankId":self.bankId,@"password":[DES3Util encrypt:paymentPassword]};
            [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyBanks.delete" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
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
    DVerifyPhoneNumViewController *vc = [[DVerifyPhoneNumViewController alloc]initWithNibName:@"DVerifyPhoneNumViewController" bundle:nil];
    vc.verigyTape = password2_verify;
    NSDictionary *userInfoDic = [[NSDictionary alloc]init];
    userInfoDic = [[FileOperation readFileToDictionary:dajikeUser]mutableCopy];
    UserInfoModel *model = [[UserInfoModel alloc]init];
    model = [JsonStringTransfer dictionary:userInfoDic ToModel:model];
    vc.userModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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
//- (void) textFieldDidBeginEditing:(UITextField *)textField{
//    
//}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSLog(@"string = %@",string);
//    if (textField.text.length > 1) {
//        NSLog(@"[textField.text substringWithRange:NSMakeRange(0, 1)] = %@",[textField.text substringWithRange:NSMakeRange(0, 1)]);
//    }
//    
//    if (range.location == 0){
//        [self resetTextField];
//        self.textField0.text = string;
//    }else if (range.location == 1){
//        self.textField0.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
//        self.textField1.text = string;
//        self.textField2.text = @"";
//        self.textField3.text = @"";
//        self.textField4.text = @"";
//        self.textField5.text = @"";
//    }else if (range.location == 2){
//        self.textField0.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
//        self.textField1.text = [textField.text substringWithRange:NSMakeRange(1, 1)];
//        self.textField2.text = string;
//        self.textField3.text = @"";
//        self.textField4.text = @"";
//        self.textField5.text = @"";
//    }else if (range.location == 3){
//        self.textField0.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
//        self.textField1.text = [textField.text substringWithRange:NSMakeRange(1, 1)];
//        self.textField2.text = [textField.text substringWithRange:NSMakeRange(2, 1)];
//        self.textField3.text = string;
//        self.textField4.text = @"";
//        self.textField5.text = @"";
//    }else if (range.location == 4){
//        self.textField0.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
//        self.textField1.text = [textField.text substringWithRange:NSMakeRange(1, 1)];
//        self.textField2.text = [textField.text substringWithRange:NSMakeRange(2, 1)];
//        self.textField3.text = [textField.text substringWithRange:NSMakeRange(3, 1)];
//        self.textField4.text = string;
//        self.textField5.text = @"";
//    }else if (range.location == 5){
//        self.textField0.text = [textField.text substringWithRange:NSMakeRange(0, 1)];
//        self.textField1.text = [textField.text substringWithRange:NSMakeRange(1, 1)];
//        self.textField2.text = [textField.text substringWithRange:NSMakeRange(2, 1)];
//        self.textField3.text = [textField.text substringWithRange:NSMakeRange(3, 1)];
//        self.textField4.text = [textField.text substringWithRange:NSMakeRange(4, 1)];
//        self.textField5.text = string;
//    }else if (range.location == 6){
//        [self.testTextField endEditing:YES];
//    }
//    paymentPassword = [NSString stringWithFormat:@"%@%@",textField.text,string];
//    return YES;
//}

- (IBAction) keyBordButtonClip:(id) sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag >= 10) {
        switch (currentIndex) {
            case 0:
            {
            }
                break;
            case 1:
            {
                self.textField0.text = @"";
                [codeArr removeLastObject];
                currentIndex--;
            }
                break;
            case 2:
            {
                self.textField1.text = @"";
                [codeArr removeLastObject];
                currentIndex--;
            }
                break;
            case 3:
            {
                self.textField2.text = @"";
                [codeArr removeLastObject];
                currentIndex--;
            }
                break;
            case 4:
            {
                self.textField3.text = @"";
                [codeArr removeLastObject];
                currentIndex--;
            }
                break;
            case 5:
            {
                self.textField4.text = @"";
                [codeArr removeLastObject];
                currentIndex--;
            }
                break;
            case 6:
            {
                self.textField5.text = @"";
                [codeArr removeLastObject];
                currentIndex--;
            }
                break;
                
            default:
                break;
        }
        
    }else{
        switch (currentIndex) {
            case 0:
            {
                self.textField0.text = [NSString stringWithFormat:@"%ld",btn.tag];
                [codeArr addObject:self.textField0.text];
                currentIndex++;
                
            }
                break;
            case 1:
            {
                self.textField1.text = [NSString stringWithFormat:@"%ld",btn.tag];
                [codeArr addObject:self.textField1.text];
                currentIndex++;
            }
                break;
            case 2:
            {
                self.textField2.text = [NSString stringWithFormat:@"%ld",btn.tag];
                [codeArr addObject:self.textField2.text];
                currentIndex++;
            }
                break;
            case 3:
            {
                self.textField3.text = [NSString stringWithFormat:@"%ld",btn.tag];
                [codeArr addObject:self.textField3.text];
                currentIndex++;
            }
                break;
            case 4:
            {
                self.textField4.text = [NSString stringWithFormat:@"%ld",btn.tag];
                [codeArr addObject:self.textField4.text];
                currentIndex++;
            }
                break;
            case 5:
            {
                self.textField5.text = [NSString stringWithFormat:@"%ld",btn.tag];
                [codeArr addObject:self.textField5.text];
                currentIndex++;
            }
                break;                
                
            default:
                break;
        }
        
    }
    
    
}
- (NSMutableString *)arrayToString:(NSMutableArray *)arr{
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i = 0; i < [arr count]; i++) {
        [str appendString:arr[i]];
    }
    return str;
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

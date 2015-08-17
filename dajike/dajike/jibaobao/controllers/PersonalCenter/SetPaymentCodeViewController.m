//
//  SetPaymentCodeViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SetPaymentCodeViewController.h"
#import "defines.h"
#import "UserInfoModel.h"

@interface SetPaymentCodeViewController ()
{
    NSMutableArray *codeArr;
    NSMutableArray *encodeArr;
    NSInteger currentIndex;
    UserInfoModel *_userInfoModel;
}
@end

@implementation SetPaymentCodeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       titleLabel.text = @"设置支付密码";
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
//    if (HEIGHT_CONTROLLER_DEFAULT <= 480) {
//        CGRect frame = self.doneButton.frame;
//        frame.origin.y -= 80;
//        self.doneButton.frame = frame;
//    }
    
    [self initViewAndUserInfo];
    
    codeArr = [NSMutableArray arrayWithCapacity:6];
    encodeArr = [NSMutableArray arrayWithCapacity:6];
    _payMentStatusType = SET_ONCE;
}
- (void)initViewAndUserInfo{
    
    NSDictionary *userInfoDic = [[NSDictionary alloc]init];
    userInfoDic = [[FileOperation readFileToDictionary:jibaobaoUser]mutableCopy];
    _userInfoModel = [[UserInfoModel alloc]init];
    _userInfoModel = [JsonStringTransfer dictionary:userInfoDic ToModel:_userInfoModel];
    
    [self layoutSubViews];

}

- (void)layoutSubViews
{
    currentIndex = 0;
    self.textField0.text = @"";
    self.textField1.text = @"";
    self.textField2.text = @"";
    self.textField3.text = @"";
    self.textField4.text = @"";
    self.textField5.text = @"";
    if (_payMentStatusType == SET_ONCE) {
        self.reminderLabel.text = @"请设置大集客支付密码，用于支付验证";
        [self.doneButton setHidden:YES];
        
    }else if (_payMentStatusType == SET_TWO) {
        self.reminderLabel.text = @"请再次输入大集客支付密码";
        [self.doneButton setHidden:NO];
    }
    CGRect frame = self.keybordView.frame;
    frame.origin.y = 100;
    frame.size.height = self.keybordView.frame.size.height;
    [self.keybordView setFrame:frame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) keyBordButtonClip:(id) sender
{
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
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr removeLastObject];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr removeLastObject];
                }
                currentIndex--;
            }
                break;
            case 2:
            {
                self.textField1.text = @"";
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr removeLastObject];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr removeLastObject];
                }
                currentIndex--;
            }
                break;
            case 3:
            {
                self.textField2.text = @"";
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr removeLastObject];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr removeLastObject];
                }
                currentIndex--;
            }
                break;
            case 4:
            {
                self.textField3.text = @"";
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr removeLastObject];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr removeLastObject];
                }
                currentIndex--;
            }
                break;
            case 5:
            {
                self.textField4.text = @"";
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr removeLastObject];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr removeLastObject];
                }
                currentIndex--;
            }
                break;
            case 6:
            {
                self.textField5.text = @"";
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr removeLastObject];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr removeLastObject];
                }
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
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr addObject:self.textField0.text];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr addObject:self.textField0.text];
                }
                currentIndex++;
                
            }
                break;
            case 1:
            {
                self.textField1.text = [NSString stringWithFormat:@"%ld",btn.tag];
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr addObject:self.textField1.text];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr addObject:self.textField1.text];
                }
                currentIndex++;
            }
                break;
            case 2:
            {
                self.textField2.text = [NSString stringWithFormat:@"%ld",btn.tag];
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr addObject:self.textField2.text];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr addObject:self.textField2.text];
                }
                currentIndex++;
            }
                break;
            case 3:
            {
                self.textField3.text = [NSString stringWithFormat:@"%ld",btn.tag];
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr addObject:self.textField3.text];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr addObject:self.textField3.text];
                }
                currentIndex++;
            }
                break;
            case 4:
            {
                self.textField4.text = [NSString stringWithFormat:@"%ld",btn.tag];
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr addObject:self.textField4.text];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr addObject:self.textField4.text];
                }
                currentIndex++;
            }
                break;
            case 5:
            {
                self.textField5.text = [NSString stringWithFormat:@"%ld",btn.tag];
                if (_payMentStatusType == SET_ONCE) {
                    [codeArr addObject:self.textField5.text];
                }else if (_payMentStatusType == SET_TWO){
                    [encodeArr addObject:self.textField5.text];
                }
                currentIndex++;
            }
//                break;
            case 6:
            {
                if (_payMentStatusType == SET_ONCE) {
                    _payMentStatusType = SET_TWO;
                    [self layoutSubViews];
                }else if (_payMentStatusType == SET_TWO){
//                    [self.keybordView setHidden:YES];
                }
            }
                break;
                
            default:
                break;
        }
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableString *)arrayToString:(NSMutableArray *)arr{
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i = 0; i < [arr count]; i++) {
        [str appendString:arr[i]];
    }
    return str;
}

//修改支付密码
- (void)updatePassword2code:(NSString *)code with:(NSString *)encode{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:_userInfoModel.userId,@"userId", [DES3Util encrypt:code],@"new_password2",  [DES3Util encrypt:encode],@"conform_password2",[DES3Util encrypt:self.phoneCode],@"code",nil];
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyUserInfos.updatePassword2" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        NSLog(@"operation = %@",operation);
        NSLog(@"--%@--",responseObject.result);
        if (responseObject.succeed) {
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            
            [self.navigationController popViewControllerAnimated:NO];
            self.block();
        }else{
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];

}
//设置支付密码
- (void)setPassword2code:(NSString *)code with:(NSString *)encode{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:_userInfoModel.userId,@"userId", [DES3Util encrypt:code],@"new_password",  [DES3Util encrypt:encode],@"conform_password",nil];
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyAccounts.setPassword2" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        NSLog(@"operation = %@",operation);
        NSLog(@"--%@--",responseObject.result);
        if (responseObject.succeed) {
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            self.block();
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];

}

- (IBAction)doneButAction:(id)sender {
    NSMutableString *codeStr = [self arrayToString:codeArr];
    NSMutableString *encodeStr = [self arrayToString:encodeArr];
   if (![codeStr isEqualToString:encodeStr]){
        [MBProgressHUD show:@"请确认密码和设置密码不一致！" icon:nil view:self.view afterDelay:0.7];
   }else if ([_userInfoModel.phoneMobBindStatus isEqualToString:@"0"]) {
       [MBProgressHUD show:@"您尚未绑定手机号，请先绑定手机号" icon:nil view:self.view afterDelay:0.7];
   }else{
       if ([_userInfoModel.password2 intValue] == 0) {
           [self setPassword2code:codeStr with:encodeStr];
       }else{
           [self updatePassword2code:codeStr with:encodeStr];
       }
       
   }
    
}

- (void)callBackRegisterSuccess11:(RegisterSuccessBlock11)block
{
    self.block = block;
}

@end

//
//  DPayPasswordSetViewController.m
//  dajike
//
//  Created by songjw on 15/7/13.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DPayPasswordSetViewController.h"
#import "MBProgressHUD+Add.h"
#import "dDefine.h"
#import "UserInfoModel.h"
#import "DMyAfHTTPClient.h"
#import "DES3Util.h"
#import "DTools.h"


@interface DPayPasswordSetViewController (){
    NSMutableArray *codeArr;
    NSMutableArray *encodeArr;
    NSInteger currentIndex;
    UserInfoModel *_userInfoModel;
}

@end

@implementation DPayPasswordSetViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviBarTitle:@"设置支付密码"];
    [self.view setBackgroundColor:DColor_f3f3f3];
    self.keybordView.backgroundColor = DColor_cccccc;
    [DTools setLable:self.reminderLabel Font:DFont_13 titleColor:DColor_808080 backColor:[UIColor clearColor]];
    [DTools setButtton:self.but_0 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_2 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_3 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_4 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_5 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_6 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_7 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_8 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_9 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.but_del Font:DFont_15 titleColor:DColor_808080 backColor:DColor_cccccc];
    
    
    codeArr = [NSMutableArray arrayWithCapacity:6];
    encodeArr = [NSMutableArray arrayWithCapacity:6];
    _payMentStatusType = SET_ONCE;
    [self initViewAndUserInfo];
}

- (void)initViewAndUserInfo{
    NSDictionary *userInfoDic = [[NSDictionary alloc]init];
    userInfoDic = [[FileOperation readFileToDictionary:dajikeUser]mutableCopy];
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
- (NSMutableString *)arrayToString:(NSMutableArray *)arr{
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i = 0; i < [arr count]; i++) {
        [str appendString:arr[i]];
    }
    return str;
}
- (IBAction)doneButAction:(id)sender{
    NSMutableString *codeStr = [self arrayToString:codeArr];
    NSMutableString *encodeStr = [self arrayToString:encodeArr];
    if ([codeStr isEqualToString:encodeStr]) {
        if ([_userInfoModel.password2 intValue] == 0) {
            [self setPassword2code:codeStr with:encodeStr];
        }else{
            [self updatePassword2code:codeStr with:encodeStr];
        }
    }else{
        [MBProgressHUD show:@"请确认密码和设置密码不一致！" icon:nil view:self.view afterDelay:0.7];
    }
}
//设置支付密码
- (void)setPassword2code:(NSString *)code with:(NSString *)encode{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:_userInfoModel.userId,@"userId", [DES3Util encrypt:code],@"new_password",  [DES3Util encrypt:encode],@"conform_password",nil];
    [[DMyAfHTTPClient sharedClient] postPathWithMethod:@"MyAccounts.setPassword2" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        NSLog(@"operation = %@",operation);
        NSLog(@"--%@--",responseObject.result);
        if (responseObject.succeed) {
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            [self getUerInfo];
            
        }else{
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
    
}
//修改支付密码
- (void)updatePassword2code:(NSString *)code with:(NSString *)encode{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:_userInfoModel.userId,@"userId", [DES3Util encrypt:code],@"new_password2",  [DES3Util encrypt:encode],@"conform_password2",[DES3Util encrypt:self.phoneCode],@"code",nil];
    [[DMyAfHTTPClient sharedClient] postPathWithMethod:@"MyUserInfos.updatePassword2" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        NSLog(@"operation = %@",operation);
        NSLog(@"--%@--",responseObject.result);
        if (responseObject.succeed) {
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            [self getUerInfo];
        }else{
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
    
}
- (void)getUerInfo{
    NSLog(@"%@",[FileOperation getUserId]);
    NSDictionary *parameter = @{@"userId":[NSString stringWithString:[FileOperation getUserId]]};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyUserInfos.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation = %@",operation);
        NSLog(@"result:%@",responseObject.result);
        if (responseObject.succeed) {
            [self.navigationController popViewControllerAnimated:NO];
            self.backBlock();
        }else{
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
    
}

- (void)backToSafetySettingViewController:(BackBlock)block1{
    self.backBlock = block1;
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

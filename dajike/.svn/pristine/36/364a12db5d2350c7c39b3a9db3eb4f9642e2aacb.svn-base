//
//  GeneralHongBaoViewController.m
//  jibaobao
//
//  Created by swb on 15/6/1.
//  Copyright (c) 2015年 dajike. All rights reserved.
//







/*
 **      发红包---普通红包    拼手气红包
 */

#import "GeneralHongBaoViewController.h"
#import "defines.h"
#import "HongBaoMessageViewController.h"
#import "HongBaoShareViewController.h"


@interface GeneralHongBaoViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSString *typeHB;
@property (nonatomic, strong) NSString *validatePassword;
@property (nonatomic, assign) float allMoney;
@end

@implementation GeneralHongBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.scrollView setContentSize:CGSizeMake(1, 700)];
    
    titleLabel.text = @"普通红包";
    self.delegate = self;
    [self setNavType:WORD_TYPE action:@"消息"];
    [self setScrollBtnHidden:YES];
    
    self.view1.layer.cornerRadius       = 3.0f;
    self.view1.layer.masksToBounds      = YES;
    self.view1.layer.borderColor        = [Color_line_bg CGColor];
    self.view1.layer.borderWidth        = 1.0f;
    
    self.view2.layer.cornerRadius       = 3.0f;
    self.view2.layer.masksToBounds      = YES;
    self.view2.layer.borderColor        = [Color_line_bg CGColor];
    self.view2.layer.borderWidth        = 1.0f;
    
    self.faHongBaoBtn.layer.cornerRadius    = 3.0f;
    self.faHongBaoBtn.layer.masksToBounds   = YES;
    
    self.popView.layer.cornerRadius     = 3.0f;
    self.popView.layer.masksToBounds    = YES;
    self.popView.layer.borderWidth      = 0.8f;
    self.popView.layer.borderColor      = [Color_line_bg CGColor];
    
    self.querenBtn.layer.cornerRadius   = 3.0f;
    self.querenBtn.layer.masksToBounds  = YES;
    
    self.jineTf.delegate = self;
    self.numTf.delegate = self;
    self.onePassword.delegate = self;
    self.twoPassword.delegate = self;
    self.threePassword.delegate = self;
    self.fourPassword.delegate = self;
    self.fivePassword.delegate = self;
    self.sixPassword.delegate = self;
    
    [self.twoPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.threePassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.fourPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.fivePassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.sixPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.jineTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.jineTf setTintColor:[UIColor blueColor]];
    self.numTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.numTf setTintColor:[UIColor blueColor]];
    
    self.pinRenqiBtn.selected           = NO;
    [self.pinRenqiBtn setTitleColor:Color_mainColor forState:UIControlStateSelected];
    
    self.pinRenqiBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.pinRenqiBtn setTitle:@"拼手气红包" forState:UIControlStateNormal];
    [self.pinRenqiBtn setTitle:@"普通红包" forState:UIControlStateSelected];
    self.typeHB = @"0";
    
    self.AllMoneyLb.text = @"¥0.00元";
    
    self.viewBG.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allMoney:) name:@"allMoney" object:nil];
    
}

//监听方法实现
- (void) textFieldDidChange:(UITextField *) TextField{
    if (TextField == self.twoPassword) {
        if ([TextField.text isEqualToString:@""]) {
            [self.onePassword becomeFirstResponder];
        }
    } else if (TextField == self.threePassword) {
        if ([TextField.text isEqualToString:@""]) {
            [self.twoPassword becomeFirstResponder];
        }
    } else if (TextField == self.fourPassword) {
        if ([TextField.text isEqualToString:@""]) {
            [self.threePassword becomeFirstResponder];
        }
    } else if (TextField == self.fivePassword) {
        if ([TextField.text isEqualToString:@""]) {
            [self.fourPassword becomeFirstResponder];
        }
    } else if (TextField == self.sixPassword) {
        if ([TextField.text isEqualToString:@""]) {
            [self.fivePassword becomeFirstResponder];
        } else {
            [self.sixPassword resignFirstResponder];
        }
    }
}

// -------------------------- 分割线 ---------------------------------
- (void)wordBtnCliped:(id)sender
{
    HongBaoMessageViewController *vc = [[HongBaoMessageViewController alloc]init];
    vc.userId = self.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (![self.jineTf.text isEqualToString:@""] && ![self.numTf.text isEqualToString:@""]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allMoney" object:nil];
    }
}

- (IBAction)pinRenQiBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        titleLabel.text = @"拼手气红包";
        self.jineLb.text = @"总金额";
        self.descLb.text = @"运气好的小伙伴能拿的更多";
        self.hongBaoType.text = @"拼手气红包,改成";
        self.typeHB = @"1";
        if (![self.jineTf.text isEqualToString:@""] && ![self.numTf.text isEqualToString:@""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"allMoney" object:nil];
        }
    }else
    {
        titleLabel.text = @"普通红包";
        self.jineLb.text = @"金额";
        self.descLb.text = @"每个小伙伴都能拿到一样的钱哦";
        self.hongBaoType.text = @"普通红包,改成";
        self.typeHB= @"0";
        if (![self.jineTf.text isEqualToString:@""] && ![self.numTf.text isEqualToString:@""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"allMoney" object:nil];
        }
    }
}

- (IBAction)faHongBaoBtnAction:(id)sender {
    if (self.allMoney > 200) {
        [ProgressHUD showMessage:@"为了你的账户安全,红包总金额不能大于200元." Width:100 High:80];
    } else if (self.allMoney <= 0){
        [ProgressHUD showMessage:@"至少要发一元喔." Width:100 High:80];
    } else {
        self.viewBG.hidden = !self.viewBG.hidden;
        [self getUserAccount];
        [self.onePassword becomeFirstResponder];
    }
}

- (IBAction)tapCancel:(id)sender {
    self.viewBG.hidden = !self.viewBG.hidden;
    self.onePassword.text = @"";
    self.twoPassword.text = @"";
    self.threePassword.text = @"";
    self.fourPassword.text = @"";
    self.fivePassword.text = @"";
    self.sixPassword.text = @"";
}

- (IBAction)querenBtnAction:(id)sender {
    
    self.validatePassword = [NSString stringWithFormat:@"%@%@%@%@%@%@",self.onePassword.text,self.twoPassword.text,self.threePassword.text,self.fourPassword.text,self.fivePassword.text,self.sixPassword.text];
    if (![self.validatePassword isEqualToString:@""] && self.validatePassword.length != 6) {
        [ProgressHUD showMessage:@"请确认支付密码" Width:100 High:80];
    } else {
        [self validatePW];
    }
    
}

//发送红包
- (void)sendHB{
    NSDictionary *parameter = @{@"userId":self.userId,@"type":self.typeHB,@"jine":[NSString stringWithFormat:@"%.2lf",self.allMoney],@"num":self.numTf.text,@"yueType":@"2",@"desc":self.wordTV.text};
    NSLog(@"111111%@",parameter);
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyHongBaos.send" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            HongBaoShareViewController *share = [[HongBaoShareViewController alloc] init];
            share.hongBaoId = [NSString stringWithFormat:@"%@",responseObject.result];
            share.hongbaoZhufu = self.wordTV.text;
            [self.navigationController pushViewController:share animated:YES];
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

- (IBAction)onLineBtnAction:(id)sender {
    self.viewBG.hidden = !self.viewBG.hidden;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.onePassword) {
        if (![commonTools isEmpty:self.sixPassword.text]) {
            [self.sixPassword becomeFirstResponder];
            return NO;
        }
    }
    if (textField == self.twoPassword) {
        if ([commonTools isEmpty:self.onePassword.text]) {
            [self.onePassword becomeFirstResponder];
            return NO;
        }
        if (![commonTools isEmpty:self.sixPassword.text]) {
            [self.sixPassword becomeFirstResponder];
            return NO;
        }
    }
    if (textField == self.threePassword) {
        if (![commonTools isEmpty:self.sixPassword.text]) {
            [self.sixPassword becomeFirstResponder];
            return NO;
        }
        if ([commonTools isEmpty:self.onePassword.text]) {
            [self.onePassword becomeFirstResponder];
            return NO;
        }
    }
    if (textField == self.fourPassword) {
        if (![commonTools isEmpty:self.sixPassword.text]) {
            [self.sixPassword becomeFirstResponder];
            return NO;
        }
        if ([commonTools isEmpty:self.onePassword.text]) {
            [self.onePassword becomeFirstResponder];
            return NO;
        }
    }
    if (textField == self.fivePassword) {
        if (![commonTools isEmpty:self.sixPassword.text]) {
            [self.sixPassword becomeFirstResponder];
            return NO;
        }
        if ([commonTools isEmpty:self.onePassword.text]) {
            [self.onePassword becomeFirstResponder];
            return NO;
        }
    }
    if (textField == self.sixPassword) {
        if ([commonTools isEmpty:self.onePassword.text]) {
            [self.onePassword becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}

//获取支付密码
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.onePassword) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 1) {
            [self.twoPassword becomeFirstResponder];
        }
    } else if (textField == self.twoPassword){
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 1) {
            [self.threePassword becomeFirstResponder];
        }
    } else if (textField == self.threePassword){
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 1) {
            [self.fourPassword becomeFirstResponder];
        }
    } else if (textField == self.fourPassword){
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 1) {
            [self.fivePassword becomeFirstResponder];
        }
    } else if (textField == self.fivePassword){
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 1) {
            [self.sixPassword becomeFirstResponder];
        }
    } else if (textField == self.sixPassword){
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 1) {
            [self.sixPassword resignFirstResponder];
        }
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.onePassword resignFirstResponder];
    [self.twoPassword resignFirstResponder];
    [self.threePassword resignFirstResponder];
    [self.fourPassword resignFirstResponder];
    [self.fivePassword resignFirstResponder];
    [self.sixPassword resignFirstResponder];
}

//验证支付密码
- (void)validatePW{
//    NSLog(@"%@",[DES3Util encrypt:@"123456"]);
//    NSLog(@"%@",self.validatePassword);
//    NSLog(@"%@",[DES3Util encrypt:self.validatePassword]);
    NSDictionary *parameter = @{@"userId":[FileOperation getUserId],@"password":[DES3Util encrypt:self.validatePassword]};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.validatePassword" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            [self sendHB];
            self.viewBG.hidden = !self.viewBG.hidden;
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];

}

//获取充值账户金额
- (void)getUserAccount{
    NSDictionary *parameter = @{@"userId":[FileOperation getUserId]};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSDictionary *resultDic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
            NSLog(@"%@",resultDic);
            _chongzhiAccount.text = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"chongzhi_jine_index"]];
            _keyongMoney.text = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"shouyi_yue"]];
            float allM = self.allMoney;
            float chongzhiM = [self.chongzhiAccount.text floatValue];
            float keyongM = [self.keyongMoney.text floatValue];
            NSLog(@"%lf,%lf,%lf",allM,chongzhiM,keyongM);
            if (allM > keyongM && allM > chongzhiM) {
                _chongzhilabel.hidden = YES;
                _keyongLabel.hidden = YES;
                _chongzhiAccount.hidden = YES;
                _keyongMoney.hidden = YES;
                [_querenBtn setTitle:@"请充值" forState:UIControlStateNormal];
                [_querenBtn setBackgroundColor:Color_gray4];
                [_querenBtn setEnabled:NO];
            } else if (allM <= keyongM && allM > chongzhiM) {
                _keyongMoney.hidden = NO;
                _keyongLabel.hidden = NO;
                _chongzhilabel.hidden = YES;
                _chongzhiAccount.hidden = YES;
                [_querenBtn setTitle:@"确认" forState:UIControlStateNormal];
                [_querenBtn setBackgroundColor:Color_mainColor];
                [_querenBtn setEnabled:YES];
            } else if (allM <= keyongM || allM <= chongzhiM) {
                _keyongMoney.hidden = YES;
                _keyongLabel.hidden = YES;
                _chongzhilabel.hidden = NO;
                _chongzhiAccount.hidden = NO;
                [_querenBtn setTitle:@"确认" forState:UIControlStateNormal];
                [_querenBtn setBackgroundColor:Color_mainColor];
                [_querenBtn setEnabled:YES];
            }
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

//计算总金额
- (void)allMoney:(NSNotificationCenter *)not{
    if ([self.typeHB isEqualToString:@"1"]) {
        self.allMoney = [self.jineTf.text floatValue];
        self.AllMoneyLb.text = [NSString stringWithFormat:@"¥%.2lf元",self.allMoney];
    } else {
        self.allMoney = [self.numTf.text floatValue] * [self.jineTf.text floatValue];
        self.AllMoneyLb.text = [NSString stringWithFormat:@"¥%.2lf元",self.allMoney];
    }
}

@end

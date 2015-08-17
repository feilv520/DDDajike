//
//  WriteIndentViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 **  类：  填写订单
 */

#import "WriteIndentViewController.h"
#import "defines.h"
#import "WriteIndentCell.h"
#import "UIView+MyView.h"
#import "NewIndentViewController.h"     //支付方式
#import "ProgressHUD.h"
#import "LoginViewController.h"
#import "BoundPhoneViewController.h"
#import "AccountOverViewModel.h"
#import "CreateDingDanModel.h"
#import "PayView.h"
#import "PayPopView.h"
#import "BuySuccessViewController.h"
#import "FindPassword0ViewController.h"
#import "ShouYiBiLiPayObject.h"

#import "IQKeyboardManager.h"
static NSString *swbCell = @"swbCell00";

// 读秒数
static int _restTime = 60;

@interface WriteIndentViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WriteIndentViewController
{
    UILabel     *_moneyNumLb;       //界面下方的实付款数额
    UILabel *_yuanLb;
    UILabel *_sifukuanLb;
    UIButton    *_codeBtn;          //获取验证码
    
    int         _num;
    
    BOOL        _isLogin;
    
    float           _jineNum;
    
    float           _allMoney;
    
    float           _shouyiPay;
    
    NSString   *_tel;
//    int         _isBoundPhone;
    
    UITextField *_phoneTf;
    UITextField *_codeTf;
    
    BOOL            _shouyiPaySelect;
    BOOL            _chongzhiPaySelect;
    BOOL            _jifenPaySelect;
    
    NSString    *_userId;
    
    NSString    *_specId;
    
    AccountOverViewModel *_accountModel;
    CreateDingDanModel *_dingdanModel;
    
    NSMutableArray *_orderArr;
    
    BOOL _wasKeyboardManagerEnabled;
    NSTimer *_timer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getZhangHuYuE];
    //键盘弹出通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘退回通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _restTime = 60;
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _codeBtn.userInteractionEnabled = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleLabel.text = @"填写订单";
    _specId = @"";
    
    _isLogin = NO;
    _shouyiPaySelect      = NO;
    _chongzhiPaySelect  = NO;
    _jifenPaySelect = NO;
//    _isBoundPhone = -1;
    _tel = nil;
    _jineNum = 0.00f;
    _shouyiPay = 0.00f;
    _allMoney = [self.model.price floatValue];
    if ([FileOperation isLogin]) {
        _isLogin = YES;
    }
    else
        _isLogin = NO;
    
    NSString *userInfoPath = [FileOperation creatPlistIfNotExist:jibaobaoUser];
    _tel = [FileOperation getobjectForKey:@"phoneMob" ofFilePath:userInfoPath];
//    _isBoundPhone = [[FileOperation getobjectForKey:@"phoneMobBindStatus" ofFilePath:userInfoPath]intValue];
    _userId = @"";
    _userId = [FileOperation getUserId];
    _num = 1;
    _accountModel = [[AccountOverViewModel alloc]init];
    _dingdanModel = [[CreateDingDanModel alloc]init];
    _orderArr     = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    
    [self addTableView:UITableViewStyleGrouped];
    [self setScrollBtnHidden:YES];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    self.mainTabview.backgroundColor = [UIColor whiteColor];
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"WriteIndentCell" bundle:nil] forCellReuseIdentifier:swbCell];
    
    [self addBottomView];
    
    [self getData];
}

///-------------- 我是分割线 -----------------------------

//键盘弹出通知
- (void)keyboardWillShow:(NSNotification *)notify
{
    CGFloat keyboardHeight = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect codeRect = [self.view convertRect:_codeTf.frame fromView:_codeTf.superview];
    CGFloat topY = HEIGHT_CONTROLLER_DEFAULT-codeRect.origin.y-keyboardHeight-100;
    if (topY > 0) {
        return;
    }
    [UIView animateWithDuration:duration animations:^{
        [self.mainTabview setFrame:CGRectMake(0, topY, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64)];
    } completion:^(BOOL finished) {
        
    }];
}
//键盘退出
- (void)keyboardWillHidden:(NSNotification *)notify
{
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.mainTabview setFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64)];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)getData
{
    if ([_specId isEqualToString:@""]) {
        if ([commonTools isNull:self.model.goods_id]) {
            [ProgressHUD showMessage:@"无数据" Width:100 High:80];
            UIButton *btn = (UIButton *)[self.view viewWithTag:14];
            if (btn) {
                btn.backgroundColor = Color_bg;
                btn.userInteractionEnabled = NO;
            }
            return;
        }
        NSDictionary *dic = @{@"goodsId":self.model.goods_id};
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.getGuiGe" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"%@",responseObject.result);
                NSArray *arr = [responseObject.result allKeys];
                _specId = [arr firstObject];
            }
            else
            {
                if ([responseObject.msg length] == 0) {
                    [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
                }else
                    [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
    [ShouYiBiLiPayObject getShouYiBiLiPayJinE:^(NSMutableDictionary *ret) {
        _shouyiPay = [[ret objectForKey:@"shouyiPayBili"]floatValue];
        [self.mainTabview reloadData];
    }];
}
//获取账户可用余额
- (void)getZhangHuYuE
{
    if (_userId == nil) {
        return;
    }
    NSDictionary *parameter2 = @{@"userId":_userId};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.index" parameters:parameter2 ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"responseObject.result = %@",responseObject.result);
            NSDictionary *dic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
            _accountModel = [JsonStringTransfer dictionary:dic ToModel:_accountModel];
            [self.mainTabview reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

//屏幕下方的View
- (void)addBottomView
{
    UIView *viewBg = [self.view createViewWithFrame:CGRectMake(0, HEIGHT_CONTROLLER_DEFAULT-114, WIDTH_CONTROLLER_DEFAULT, 50) andBackgroundColor:[UIColor whiteColor]];
    UIView *lineView = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 1) andBackgroundColor:Color_line_bg];
    [viewBg addSubview:lineView];
    _sifukuanLb = [self.view creatLabelWithFrame:CGRectMake(10, 10, 80, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"实付款：" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
    CGRect rect0 = [self.view contentAdaptionLabel:_sifukuanLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
    _sifukuanLb.frame = CGRectMake(10, 10, rect0.size.width, 30);
    [viewBg addSubview:_sifukuanLb];
    _moneyNumLb = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(_sifukuanLb.frame)+5, 10, 100, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:[NSString stringWithFormat:@"%.2f",[self.model.price floatValue]] AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_mainColor andCornerRadius:0.0f];
    CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
    _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_sifukuanLb.frame)+5, 10, rect.size.width, 30);
    [viewBg addSubview:_moneyNumLb];
    _yuanLb = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+5, 10, 20, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"元" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    [viewBg addSubview:_yuanLb];
    UIButton *okBtn = [self.view createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-90, 10, 80, 30) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:@"确认" andTag:14];
    okBtn.backgroundColor = Color_mainColor;
    okBtn.layer.cornerRadius = 2.0f;
    okBtn.layer.masksToBounds = YES;
    [viewBg addSubview:okBtn];
    [self.view addSubview:viewBg];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isLogin) {
        return 6;
    }
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        if (_isLogin) {
            return 80;
        }
        return 44;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_isLogin) {
        return 60;
    }
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *mView = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 60) andBackgroundColor:[UIColor whiteColor]];
    int frameY = _isLogin?20:118;
    if (!_isLogin) {
        UIView *tmpView = [self.view createViewWithFrame:CGRectMake(10, 10, WIDTH_CONTROLLER_DEFAULT-20, 88) andBackgroundColor:[UIColor clearColor]];
        [mView addSubview:tmpView];
        UIView *lineView1 = [self.view createViewWithFrame:CGRectMake(0, 0, tmpView.frame.size.width, 0.5) andBackgroundColor:[UIColor lightGrayColor]];
        [tmpView addSubview:lineView1];
        UIView *lineView2 = [self.view createViewWithFrame:CGRectMake(0, 0, 0.5, tmpView.frame.size.height) andBackgroundColor:[UIColor lightGrayColor]];
        [tmpView addSubview:lineView2];
        UIImageView *phoneIv = [self.view createImageViewWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame)+5, 10, 25, 25) andImageName:@"img_character"];
        [tmpView addSubview:phoneIv];
        _phoneTf = [self.view createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(phoneIv.frame)+10, 7, 120, 30) andPlaceholder:@"请输入您的手机号" andPassWord:NO andLeftImageView:nil andRightImageView:nil andFont:15.0f];
        [_phoneTf addTarget:self action:@selector(inputValue:) forControlEvents:UIControlEventEditingChanged];
        _phoneTf.borderStyle = UITextBorderStyleNone;
        _phoneTf.keyboardType = UIKeyboardTypePhonePad;
        _phoneTf.userInteractionEnabled = YES;
//        [_phoneTf setEnabled:YES];
        [tmpView addSubview:_phoneTf];
        _codeBtn = [self.view createButtonWithFrame:CGRectMake(tmpView.frame.size.width-120, 7, 110, 30) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:@"获取验证码" andTag:15];
        _codeBtn.backgroundColor = Color_mainColor;
        _codeBtn.layer.cornerRadius = 2.0f;
        _codeBtn.layer.masksToBounds = YES;
        [tmpView addSubview:_codeBtn];
        UIView *lineView3 = [self.view createViewWithFrame:CGRectMake(0, CGRectGetMaxY(_codeBtn.frame)+7, tmpView.frame.size.width, 0.5) andBackgroundColor:[UIColor lightGrayColor]];
        [tmpView addSubview:lineView3];
        UIView *lineView4 = [self.view createViewWithFrame:CGRectMake(tmpView.frame.size.width-0.5, 0, 0.5, tmpView.frame.size.height) andBackgroundColor:[UIColor lightGrayColor]];
        [tmpView addSubview:lineView4];
        UIImageView *codeIv = [self.view createImageViewWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame)+5, CGRectGetMaxY(lineView3.frame)+7, 22.5, 30) andImageName:@"img_key"];
        [tmpView addSubview:codeIv];

        _codeTf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneIv.frame)+10, CGRectGetMaxY(lineView3.frame)+7, 120, 30)]  ;
        _codeTf.placeholder = @"请输入验证码";
        _codeTf.textAlignment = NSTextAlignmentLeft;
        _codeTf.borderStyle = UITextBorderStyleNone;
        _codeTf.autocapitalizationType = NO;

        _codeTf.font = [UIFont systemFontOfSize:15.0f];
        _codeTf.textColor = [UIColor blackColor];
//        _codeTf.borderStyle = UITextBorderStyleNone;
        _codeTf.keyboardType = UIKeyboardTypePhonePad;
        _codeTf.userInteractionEnabled = YES;
        [_codeTf setEnabled:YES];
        [tmpView addSubview:_codeTf];
        UIView *lineView5 = [self.view createViewWithFrame:CGRectMake(0, tmpView.frame.size.height-0.5, tmpView.frame.size.width, 0.5) andBackgroundColor:[UIColor lightGrayColor]];
        [tmpView addSubview:lineView5];
    }
    float x1 = 10;
    float x2 = 10;
    UIImageView *iv1 = [self.view createImageViewWithFrame:CGRectMake(10, frameY, 20, 20) andImageName:@"img_re_01"];
    [iv1 setHidden:YES];
    [mView addSubview:iv1];
    UILabel *lb1 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(iv1.frame)+5, frameY, 80, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"随时退" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
    lb1.hidden = YES;
    [mView addSubview:lb1];
    
    if ([self.model.is_suishitui intValue] == 1) {
        iv1.hidden = NO;
        lb1.hidden = NO;
        x1 = CGRectGetMaxX(lb1.frame);
    }
    
    UIImageView *iv2 = [self.view createImageViewWithFrame:CGRectMake(x1, frameY, 20, 20) andImageName:@"img_re_02"];
    iv2.hidden = YES;
    [mView addSubview:iv2];
    UILabel *lb2 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(iv2.frame)+5, frameY, 80, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"过期退" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
    lb2.hidden = YES;
    [mView addSubview:lb2];
    
    if ([self.model.is_guoqitui intValue] == 1) {
        iv2.hidden = NO;
        lb2.hidden = NO;
        x2 = CGRectGetMaxX(lb2.frame);
    }else if ([self.model.is_suishitui intValue] == 1) {
        x2 = CGRectGetMaxX(lb1.frame);
    }
    
    UIImageView *iv3 = [self.view createImageViewWithFrame:CGRectMake(x2, frameY, 20, 20) andImageName:@"img_re_03"];
    iv3.hidden = YES;
    [mView addSubview:iv3];
    UILabel *lb3 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(iv3.frame)+5, frameY, 80, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"免预约" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
    lb3.hidden = YES;
    [mView addSubview:lb3];
    
    if ([self.model.is_yuyue intValue]==1) {
        iv3.hidden = NO;
        lb3.hidden = NO;
    }
    
    return mView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        if (!_isLogin) {
            static NSString *cell123 = @"cell555";
            UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell123];
            if (!myCell) {
                myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell123];
                UILabel *lb = [self.view creatLabelWithFrame:CGRectMake(10, 7, 120, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"免登录直接购买或" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
                CGRect rect = [self.view contentAdaptionLabel:lb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                lb.frame = CGRectMake(10, 7, rect.size.width, 30);
                [myCell.contentView addSubview:lb];
                UIButton *btn = [self.view createButtonWithFrame:CGRectMake(CGRectGetMaxX(lb.frame), 7, 60, 30) andBackImageName:nil andTarget:self andAction:@selector(nowLoginAction:) andTitle:@"立即登录" andTag:5];
                btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                [btn setTitleColor:Color_mainColor forState:UIControlStateNormal];
                [myCell addSubview:btn];
            }
            return myCell;
        }else
        {
            WriteIndentCell *mCell = [tableView dequeueReusableCellWithIdentifier:swbCell];
            
            if (mCell.shouyiBtn.selected) {
                mCell.shouyiImg.image = [UIImage imageNamed:@"img_box_02"];
            }else
                mCell.shouyiImg.image = [UIImage imageNamed:@"img_box_01"];
            
            if (mCell.chongzhiBtn.selected) {
                mCell.chongzhiImg.image = [UIImage imageNamed:@"img_box_02"];
            }else
                mCell.chongzhiImg.image = [UIImage imageNamed:@"img_box_01"];
            
            if (mCell.shouyiBtn.selected) {
                if (_allMoney*_shouyiPay > [_accountModel.shouyi_yue_forPay_enable floatValue]) {
                    mCell.shouyiLb.text = [NSString stringWithFormat:@"账户可用余额：¥%.2f元",[_accountModel.shouyi_yue_forPay_enable floatValue]];
                    
                }else
                    mCell.shouyiLb.text = [NSString stringWithFormat:@"账户可用余额：¥%.2f元",_shouyiPay*_allMoney];
            }else
                mCell.shouyiLb.text = [NSString stringWithFormat:@"账户可用余额：¥%.2f元",[_accountModel.shouyi_yue_forPay_enable floatValue]];
//            if (mCell.chongzhiBtn.selected) {
//                if (mCell.shouyiBtn.selected) {
//                    if ([self.model.price floatValue]-[mCell.shouyiLb.text floatValue] > [_accountModel.chongzhi_jine_index floatValue]) {
//                        mCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
//                    }else {
//                        mCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[self.model.price floatValue]-[mCell.shouyiLb.text floatValue]];
//                    }
//                    
//                }else {
//                    if ([self.model.price floatValue] > [_accountModel.chongzhi_jine_index floatValue]) {
//                        mCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
//                    }else
//                        mCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[self.model.price floatValue]];
//                }
//            }else {
                mCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
//            }
            
            if (fabs([_accountModel.shouyi_yue_forPay_enable floatValue]-0.01)<=0.01) {
                mCell.shouyiBtn.userInteractionEnabled = NO;
                mCell.shouyiLb.textColor = [UIColor lightGrayColor];
            }else {
                mCell.shouyiBtn.userInteractionEnabled = YES;
                mCell.shouyiLb.textColor = Color_word_bg;
            }
            
            if (fabs([_accountModel.chongzhi_jine_index floatValue]-0.01)<=0.01) {
                mCell.chongzhiBtn.userInteractionEnabled = NO;
                mCell.chongzhiLb.textColor = [UIColor lightGrayColor];
            }else {
                mCell.chongzhiBtn.userInteractionEnabled = YES;
                mCell.chongzhiLb.textColor = Color_word_bg;
            }
            
            [mCell callBackSelectPayType:^(int btnTag) {
                if (btnTag == 888) {
                    NSLog(@"收益账户");
                    
                    mCell.shouyiBtn.selected = !mCell.shouyiBtn.selected;
                    _shouyiPaySelect = !_shouyiPaySelect;
                    if (mCell.shouyiBtn.selected) {
                        _jineNum = _jineNum + (_shouyiPay*_allMoney > [_accountModel.shouyi_yue_forPay_enable floatValue]?[_accountModel.shouyi_yue_forPay_enable floatValue]:_shouyiPay*_allMoney);
                    }else
                        _jineNum = _jineNum - (_shouyiPay*_allMoney > [_accountModel.shouyi_yue_forPay_enable floatValue]?[_accountModel.shouyi_yue_forPay_enable floatValue]:_shouyiPay*_allMoney);
                    
                }
                if (btnTag == 777) {
                    NSLog(@"充值账户");
                    mCell.chongzhiBtn.selected = !mCell.chongzhiBtn.selected;
                    _chongzhiPaySelect = !_chongzhiPaySelect;
                    if (mCell.chongzhiBtn.selected) {
                        _jineNum = _jineNum + [_accountModel.chongzhi_jine_index floatValue];
                    }else
                        _jineNum = _jineNum - [_accountModel.chongzhi_jine_index floatValue];
                }
                if (btnTag == 666) {
                    NSLog(@"积分");
                    mCell.jifenBtn.selected = !mCell.jifenBtn.selected;
                    _jifenPaySelect = !_jifenPaySelect;
                }
                
                if (_allMoney > _jineNum) {
                    _moneyNumLb.text = [NSString stringWithFormat:@"%.2f",_allMoney-_jineNum];
                    CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                    _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_sifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                    _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
                }else
                {
                    _moneyNumLb.text = @"0.00";
                    CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                    _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_sifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                    _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
                }
                
                [self.mainTabview reloadData];
            }];
            return mCell;
        }
        
    }
    else
    {
        static NSString *swbCell2 = @"cell222";
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell2];
        
        
        
        
        if (!myCell) {
            myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:swbCell2];
            
        }
        UILabel *lb1 = (UILabel *)[myCell.contentView viewWithTag:50];
        if (!lb1) {
            lb1 = [self.view creatLabelWithFrame:CGRectMake(10, 7, 150, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
            lb1.tag = 50;
            [myCell.contentView addSubview:lb1];
        }
        
        UILabel *lb2 = (UILabel *)[myCell.contentView viewWithTag:51];
        if (!lb2) {
            lb2 = [self.view creatLabelWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-110, 7, 100, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentRight AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
            lb2.tag = 51;
            [myCell.contentView addSubview:lb2];
        }
        
        UIView *iv = (UIView *)[myCell.contentView viewWithTag:52];
        if (!iv) {
            iv = [self.view createViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-100, 7, 90, 30) andBackgroundColor:Color_bg];
            iv.tag = 52;
            [myCell.contentView addSubview:iv];
        }
        
        UIButton *minusBtn = (UIButton *)[iv viewWithTag:12];
        if (!minusBtn) {
            minusBtn = [self.view createButtonWithFrame:CGRectMake(0, 0, 30, 30) andBackImageName:@"img_jian" andTarget:self andAction:@selector(btnClickedAction:) andTitle:nil andTag:12];
            [iv addSubview:minusBtn];
        }
        
        //            [minusBtn setTitleColor:Color_word_bg forState:UIControlStateNormal];
        NSLog(@"%@",iv.subviews);
        UITextField *tf = (UITextField *)[iv viewWithTag:996];
        if (!tf) {
            tf = [self.view createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(minusBtn.frame), 0.5, 30, 29) andPlaceholder:nil andPassWord:NO andLeftImageView:nil andRightImageView:nil andFont:15.0f];
            tf.tag = 996;
            [tf setEnabled:NO];
            tf.textAlignment = NSTextAlignmentCenter;
            tf.borderStyle = UITextBorderStyleNone;
            tf.backgroundColor = [UIColor whiteColor];
            [iv addSubview:tf];
        }
        
        tf.text = [NSString stringWithFormat:@"%d",_num];
        
        UIButton *plusBtn = (UIButton *)[iv viewWithTag:13];
        if (!plusBtn) {
            plusBtn = [self.view createButtonWithFrame:CGRectMake(CGRectGetMaxX(tf.frame), 0, 30, 30) andBackImageName:@"img_jia" andTarget:self andAction:@selector(btnClickedAction:) andTitle:nil andTag:13];
            plusBtn.backgroundColor = [UIColor clearColor];
            [iv addSubview:plusBtn];
        }
        
        if (indexPath.row == 0) {
            lb1.text = self.model.goods_name;
            lb2.text = [NSString stringWithFormat:@"¥%.2f元",[self.model.price floatValue]];
            iv.hidden = YES;
        }
        if (indexPath.row == 1) {
            lb1.text = @"数量：";
            lb2.hidden = YES;
            iv.hidden = NO;
        }
        if (indexPath.row == 2) {
            lb1.text = @"小计：";
            lb2.text = [NSString stringWithFormat:@"¥%.2f元",_num*[self.model.price floatValue]];
            lb2.textColor = Color_mainColor;
            iv.hidden = YES;
        }
        if (indexPath.row == 4) {
            lb1.text = @"你已绑定的手机号码";
            lb2.hidden = YES;
            iv.hidden = YES;
        }
        if (indexPath.row == 5) {
            if (!([_tel isEqualToString:@""]||[commonTools isEmpty:_tel]||[_tel isEqual:[NSNull null]])) {
                lb1.text = [NSString stringWithFormat:@"%@****%@",[_tel substringToIndex:3],[_tel substringFromIndex:7]];
            }else{
                lb1.text = @"";
            }
            
            lb2.text = @"绑定新号码";
            lb2.frame = CGRectMake(WIDTH_CONTROLLER_DEFAULT-130, 7, 100, 30);
            iv.hidden = YES;
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return myCell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 5) {
        BoundPhoneViewController *vc = [[BoundPhoneViewController alloc]init];
        vc.flagStr = @"808";
        if ([commonTools isNull:_tel]) {
            vc.phoneType = Bound_PHONE;
        }else{
            vc.phoneType = PHONE_VERIFY;
        }
        [vc backToFillInIndentViewController:^(NSString *telNum) {
            _tel = telNum;
            [self.mainTabview reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//  tag ==   12.减    13.加  14.确认  15.获取验证码
- (void)btnClickedAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UITextField *tf = (UITextField *)[self.view viewWithTag:996];
    _num = [tf.text intValue];
    if (btn.tag == 12) {
        NSLog(@"-");
        if (_num <= 1) {
            [ProgressHUD showMessage:@"数量不能少于1" Width:100 High:40];
        }else {
            _num--;
            
            if (_shouyiPaySelect) {
                _jineNum = _jineNum + _shouyiPay*[self.model.price floatValue];
            }
            
            _allMoney = _allMoney-[self.model.price floatValue];
            if (_allMoney > _jineNum) {
                _moneyNumLb.text = [NSString stringWithFormat:@"%.2f",_allMoney-_jineNum];
                CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_sifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
            }else
            {
                _moneyNumLb.text = @"0.00";
                CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_sifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
            }
            
//            _moneyNumLb.text = [NSString stringWithFormat:@"%.2f",_num*[self.model.price floatValue]];
//            CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
//            _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_sifukuanLb.frame)+5, 10, rect.size.width+5, 30);
//            _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
        }
        [self.mainTabview reloadData];
    }
    if (btn.tag == 13) {
        NSLog(@"+");
        _num++;
        _allMoney =[self.model.price floatValue]+_allMoney;
        if (_shouyiPaySelect) {
            _jineNum = _jineNum - _shouyiPay*[self.model.price floatValue];
        }
        
        if (_allMoney > _jineNum) {
            _moneyNumLb.text = [NSString stringWithFormat:@"%.2f",_allMoney-_jineNum];
            CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
            _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_sifukuanLb.frame)+5, 10, rect.size.width+5, 30);
            _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
        }else
        {
            _moneyNumLb.text = @"0.00";
            CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
            _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_sifukuanLb.frame)+5, 10, rect.size.width+5, 30);
            _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
        }
//        _moneyNumLb.text = [NSString stringWithFormat:@"%.2f",_num*[self.model.price floatValue]];
//        CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
//        _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_sifukuanLb.frame)+5, 10, rect.size.width+5, 30);
//        _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
        [self.mainTabview reloadData];
    }
    if (btn.tag == 14) {
        NSLog(@"确认");
        if (_isLogin) {
            [self creatDingDan];
            
        }else
        {
            [self beforeLoginCreateDingDan];
        }
        
    }
    if (btn.tag == 15) {
        NSLog(@"验证码");
        if ([self checkPhone]) {
            NSDictionary *parameter = @{@"mobile_phone":_phoneTf.text};
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Sends.sms" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"result = %@",responseObject.result);
                    [ProgressHUD showMessage:@"验证码已发送" Width:100 High:80];
                    [self startTimer];
                }else
                    [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
                NSLog(@"operation6 = %@",operation);
            }];
        }
        
    }
}
//计时器启动
- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
}
//开始计时
-(void)timeBegin
{
    _restTime--;
    if (_restTime>0) {
        _codeBtn.userInteractionEnabled = NO;
        [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",_restTime] forState:UIControlStateNormal];
        _codeBtn.backgroundColor = Color_line_bg;
    }else {
        _restTime = 60;
        _codeBtn.userInteractionEnabled = YES;
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeBtn.backgroundColor = Color_mainColor;
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
    }
}

// 未登录状态下创建订单
- (void)beforeLoginCreateDingDan
{
    if ([self checkCode]) {
        NSDictionary *parameter = @{@"mobile_phone":_phoneTf.text,@"yanzhengma":_codeTf.text};
        
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.createOrderBeforeLogin" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                
                _userId = [AnalysisData decodeToString:responseObject.result];
                //保存密码，修改登陆状态
                [FileOperation saveUserId:responseObject.result];
                NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
                [FileOperation setPlistObject:@"1" forKey:kIsLogin ofFilePath:filePath];
                _tel = _phoneTf.text;
                _isLogin = YES;
                
                [self getZhangHuYuE];
                
//                [self.mainTabview reloadData];
                
                
                //                    if ([responseObject.result isEqualToString:@"该用户未注册，请注册！"]) {
                //                        BoundPhoneViewController *BoundPhoneVC = [[BoundPhoneViewController alloc]initWithNibName:nil bundle:nil];
                //                        //绑定手机号状态
                //                        BoundPhoneVC.phoneType = Bound_PHONE;
                //                        [BoundPhoneVC callBackRegisterSuccess:^{
                //                            [ProgressHUD showMessage:@"注册成功" Width:100 High:80];
                //                        }];
                //                        [self.navigationController pushViewController:BoundPhoneVC animated:YES];
                
                //                    }
                
                
                
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
    
}

//创建订单
- (void)creatDingDan
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%d",_num] forKey:_specId];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:dic];
//    if ([self checkData]) {
    if ([commonTools isNull:_tel]) {
        [ProgressHUD showMessage:@"您还未绑定手机号" Width:100 High:80];
        return;
    }
        NSDictionary *parameter = @{@"goodsId":self.model.goods_id,@"userId":_userId,@"list":[JsonStringTransfer objectToJsonString:arr],@"cellphone":_tel};
        
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.createOrder" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                
                NSMutableDictionary *dic = [responseObject.result mutableCopy];
                
                _dingdanModel = [JsonStringTransfer dictionary:dic ToModel:_dingdanModel];
                
                _orderArr = [[JsonStringTransfer jsonStringToDictionary:[dic objectForKey:@"order"]]mutableCopy];
                
                if (!_chongzhiPaySelect && !_shouyiPaySelect) {
                    [self noSelectPayType];
                }else {
                    [self inputDaJiKePayPassword];
                }
            }
            else
            {
                if ([responseObject.msg length] == 0) {
                    [ProgressHUD showMessage:@"创建订单失败" Width:100 High:80];
                }else
                    [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            NSLog(@"operation6 = %@",operation);
        }];
//    }
    
}

//如果什么支付方式都没选或者所选支付方式不足以支付，直接跳三方支付平台
- (void)noSelectPayType
{
    NewIndentViewController *vc = [[NewIndentViewController alloc]init];
    vc.payJine = _moneyNumLb.text;
    vc.isChongzhiSelect = _chongzhiPaySelect;
    vc.isShouyiSelect = _shouyiPaySelect;
    vc.dingdaoModel = _dingdanModel;
    vc.buyType = @"2";
    
    vc.goodsName = self.model.goods_name;
//    if ([_moneyNumLb.text floatValue]>0) {
        vc.money = _moneyNumLb.text;
//    }else
//        vc.money = [NSString stringWithFormat:@"%.2f",_allMoney];
    vc.arr = [_orderArr mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}

// 选择支付方式需要输入大集客支付密码
- (void)inputDaJiKePayPassword
{
    PayPopView *vv = [[PayPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT)];
    vv.tag = 8008;
    if ([_moneyNumLb.text floatValue]>0) {
        vv.jineLb.text = [NSString stringWithFormat:@"¥%.2f元",[_moneyNumLb.text floatValue]];
    }else
        vv.jineLb.text = [NSString stringWithFormat:@"¥%.2f元",_allMoney];
    vv.backgroundColor = [UIColor clearColor];
    
    __weak WriteIndentViewController *weakSelf = self;
    [vv.mimaLb callbackClickedLb:^(MyClickLb *clickLb) {
        NSLog(@"忘记密码");
        //找回密码
        FindPassword0ViewController *FindPassword0VC = [[FindPassword0ViewController alloc]initWithNibName:nil bundle:nil];
        [weakSelf.navigationController pushViewController:FindPassword0VC animated:YES];
    }];
    [vv callbackHidden:^(int flag,NSString *password){
        
        if (flag == 0)
        {
            [UIView animateWithDuration:0.25f animations:^{
                vv.alpha = 0.1f;
            } completion:^(BOOL finished) {
                [vv setHidden:YES];
            }];
        }
        if (flag == 1)
        {
            [weakSelf checkPayPassword:password];
            NSLog(@"支付吧--____%@",password);
        }
    }];
    [self.view addSubview:vv];
}

//校验支付密码
- (void)checkPayPassword:(NSString *)password
{
    NSDictionary *dic = @{@"userId":_userId,@"password":[DES3Util encrypt:password]};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.validatePassword" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject)
    {
        NSLog(@"%@",responseObject.result);
        if (responseObject.succeed)
        {
            PayPopView *vv = (PayPopView *)[self.view viewWithTag:8008];
            if (vv) {
                [UIView animateWithDuration:0.25f animations:^{
                    
                    vv.alpha = 0.1f;
                    [vv setHidden:YES];
                } completion:^(BOOL finished) {
                    
                }];
            }
            if ([_moneyNumLb.text floatValue]>0) {
                [self noSelectPayType];
            }else {
                [self payAction];
            }
        }
        else
        {
            [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

// 支付
- (void)payAction
{
    NSString *shouyi = [self checkPayTypeHas:_shouyiPaySelect];
    NSString *chongzhi = [self checkPayTypeHas:_chongzhiPaySelect];
    NSDictionary *dic = @{@"orderSns":_dingdanModel.orderSns,@"shouyi":shouyi,@"chongzhi":chongzhi,@"authUserId":_dingdanModel.authUserId,@"authAppId":_dingdanModel.authAppId};
    
    PayView *payV = [[PayView alloc]initWithFrame:CGRectMake(0, 0, 0.5, 0.5)];
    [payV payRequestWithParam:dic ifAddActivityIndicator:NO success:^(id ret) {
        NSLog(@"%@",ret);
        
        if ([[ret objectForKey:@"result_code"]intValue] == 200) {
            [self paySuccess];
        }
        else
        {
            if ([[ret objectForKey:@"msg"]length] == 0) {
                [ProgressHUD showMessage:@"支付失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:[ret objectForKey:@"msg"] Width:100 High:80];
        }
        
        
    }];
    [self.view addSubview:payV];
    
    NSLog(@"支付");
}
//支付成功后
- (void)paySuccess
{
    BuySuccessViewController *vc = [[BuySuccessViewController alloc]init];
    vc.goodName = self.model.goods_name;
    vc.arr = [_orderArr mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}

// 判断支付方式
- (NSString *)checkPayTypeHas:(BOOL)payType
{
    if (payType) {
        return @"true";
    }else
        return @"false";
}

//控制手机号输入不超过11位
- (void)inputValue:(UITextField *)tf
{
    if (tf == _phoneTf) {
        if (tf.text.length >11) {
            tf.text = [tf.text substringToIndex:11];
        }
    }
    
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if (textField == _phoneTf) {
//        return YES;
//    }
//    if (textField == _codeTf) {
//        if (![self checkPhone]) {
////            [_phoneTf becomeFirstResponder];
//            return NO;
//        }
//    }
//    return YES;
//}

//检查电话号码输入数据的正确性
- (BOOL)checkPhone
{
    if ([commonTools isEmpty:_phoneTf.text]) {
        [ProgressHUD showMessage:@"手机号不能为空" Width:100 High:80];
        return NO;
    }else if (![commonTools isMobileNumber:_phoneTf.text]) {
        [ProgressHUD showMessage:@"输入有误，请输入正确的号码" Width:100 High:80];
        return NO;
    }
    return YES;
}
//检查验证码
- (BOOL)checkCode
{
    if ([self checkPhone]) {
        if ([commonTools isEmpty:_codeTf.text]) {
            [ProgressHUD showMessage:@"验证码不能为空" Width:100 High:80];
            return NO;
        }
    }else
        return NO;
    return YES;
}
// 立即登录
- (void)nowLoginAction:(id)sender
{
    NSLog(@"登录");
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.flagStr = @"1";
    [loginVC callBackToWriteIndentViewController:^{
        _isLogin = YES;
        [self getZhangHuYuE];
        [self.mainTabview reloadData];
    }];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (BOOL)checkData
{
    if (!_shouyiPaySelect && !_chongzhiPaySelect && !_jifenPaySelect) {
        [ProgressHUD showMessage:@"请选择支付方式" Width:100 High:80];
        return NO;
    }
    return YES;
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_phoneTf]) {
        [self.mainTabview setFrame:CGRectMake(0, -100, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64)];
    }else{
        [self.mainTabview setFrame:CGRectMake(0, -(100+30), WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64)];
    }
}
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_phoneTf]) {
        [self.mainTabview setFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64)];
    }else{
        [self.mainTabview setFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64)];
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

@end

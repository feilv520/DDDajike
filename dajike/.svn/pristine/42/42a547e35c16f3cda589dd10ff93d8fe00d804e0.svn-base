//
//  BoundPhoneViewController.h
//  jibaobao
//
//  Created by dajike on 15/5/13.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 绑定手机号
 验证手机号
 注册
 无密码手机快速登录
 设置密码
 */
typedef enum {
    Bound_PHONE,//绑定手机号
    VERIFY_PHONE,//验证手机号
    REGISTER_USER,//注册
    LOGIN_FAST,//无密码快速登录
    SET_PASSWORD,//设置密码
    REGISTER_PASSWORD,//注册 设置密码
    FIND_PASSWORD,//找回密码
    ZFMIMA_VERIFY,//支付密码手机验证
    MIMA_VERIFY,//修改密码手机验证
    PHONE_VERIFY,//绑定手机验证
} phoneType;
#import "BackNavigationViewController.h"
#import "UserInfoModel.h"

typedef void (^RegisterSuccessBlock)();

typedef void (^BackBlock)();
//填写订单界面绑定手机号
typedef void (^BackToFillInIndentViewControllerBlock)(NSString *telNum);

@interface BoundPhoneViewController : BackNavigationViewController
@property (nonatomic, assign) phoneType phoneType;
@property (strong, nonatomic)UserInfoModel *userInfoModel;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyButton;
@property (weak, nonatomic) IBOutlet UIButton *yanzhengButton;
@property (weak, nonatomic) IBOutlet UIButton *argumentBtn;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *argumentLabel;
@property (weak, nonatomic) IBOutlet UIButton *argumentBut;

@property (strong, nonatomic) NSString *phoneNumStr;
@property (strong, nonatomic) NSString *messageCode;

@property (strong, nonatomic) NSString *flagStr;

@property (strong, nonatomic) RegisterSuccessBlock block;
@property (strong, nonatomic) BackBlock mBlock;
//填写订单界面绑定手机号
@property (strong, nonatomic) BackToFillInIndentViewControllerBlock fillInIndentViewControllerBlock;

- (IBAction)getVerifyCodeButtonClip:(id)sender;
- (IBAction)verifyCodeButtonClip:(id)sender;
- (IBAction)argumentButtonClip:(id)sender;
- (IBAction)lookOverArgument:(id)sender;

- (void)callBackRegisterSuccess:(RegisterSuccessBlock)block;
- (void)backToSafetySettingViewController:(BackBlock)block1;

//填写订单界面绑定手机号
- (void)backToFillInIndentViewController:(BackToFillInIndentViewControllerBlock)block2;
@end

//
//  DLoginViewController.h
//  dajike
//
//  Created by songjw on 15/7/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBackNavigationViewController.h"

typedef enum {
    ZHANWEI,//没什么用
    GOUWUCHE_VC,//购物车
    GOODSDETAIL,//商品详情
}FromWhatVC;

typedef void (^CallbackToGouWuCheVC)();

@interface DLoginViewController : DBackNavigationViewController

@property (assign, nonatomic) FromWhatVC fromVC;

@property (weak, nonatomic) IBOutlet UIButton *loginBut;
@property (weak, nonatomic) IBOutlet UIButton *findBut;
@property (weak, nonatomic) IBOutlet UIButton *fastBut;
@property (weak, nonatomic) IBOutlet UILabel *agreeLab;
@property (weak, nonatomic) IBOutlet UITextField *userTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@property (strong, nonatomic) CallbackToGouWuCheVC block;

- (IBAction)buttonAction:(id)sender;//0 登录  1 找回密码  2 快速登录

- (void)callBack:(CallbackToGouWuCheVC)block;

@end

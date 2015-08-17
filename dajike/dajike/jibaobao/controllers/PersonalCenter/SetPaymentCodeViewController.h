//
//  SetPaymentCodeViewController.h
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

/*
 设置支付密码
 */
typedef enum {
    SET_ONCE,//首次输入
    SET_TWO,//再次输入
} payMentStatusType;
#import "BackNavigationViewController.h"
typedef void (^RegisterSuccessBlock11)();

@interface SetPaymentCodeViewController : BackNavigationViewController<UITextFieldDelegate>{
    payMentStatusType  _payMentStatusType;
}
//test
@property (strong,nonatomic) NSString *phoneCode;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField0;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *textField5;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) RegisterSuccessBlock11 block;

- (IBAction)doneButAction:(id)sender;
- (void)callBackRegisterSuccess11:(RegisterSuccessBlock11)block;


@property (weak, nonatomic) IBOutlet UIView *keybordView;


@end

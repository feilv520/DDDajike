//
//  DPayPasswordSetViewController.h
//  dajike
//
//  Created by songjw on 15/7/13.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBackNavigationViewController.h"
typedef enum {
    SET_ONCE,//首次输入
    SET_TWO,//再次输入
} payMentStatusType;

typedef void(^BackBlock) ();
@interface DPayPasswordSetViewController : DBackNavigationViewController<UITextFieldDelegate>{
    payMentStatusType  _payMentStatusType;
}
@property (strong,nonatomic) NSString *phoneCode;
@property (strong,nonatomic) BackBlock backBlock;


@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField0;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *textField5;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UIButton *but_1;
@property (weak, nonatomic) IBOutlet UIButton *but_2;
@property (weak, nonatomic) IBOutlet UIButton *but_4;
@property (weak, nonatomic) IBOutlet UIButton *but_5;
@property (weak, nonatomic) IBOutlet UIButton *but_6;
@property (weak, nonatomic) IBOutlet UIButton *but_7;
@property (weak, nonatomic) IBOutlet UIButton *but_8;
@property (weak, nonatomic) IBOutlet UIButton *but_9;
@property (weak, nonatomic) IBOutlet UIButton *but_3;
@property (weak, nonatomic) IBOutlet UIButton *but_del;
@property (weak, nonatomic) IBOutlet UIButton *but_0;
@property (weak, nonatomic) IBOutlet UIImageView *img_del;

- (IBAction)doneButAction:(id)sender;

- (void)backToSafetySettingViewController:(BackBlock)block1;


@property (weak, nonatomic) IBOutlet UIView *keybordView;
@end

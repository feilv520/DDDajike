//
//  DFindPassword0ViewController.h
//  dajike
//
//  Created by songjw on 15/7/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBackNavigationViewController.h"
#import "PooCodeView.h"
@interface DFindPassword0ViewController : DBackNavigationViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet PooCodeView *codeView;
@property (weak, nonatomic) IBOutlet UIButton *nextBut;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UIButton *changeBut;
@property (weak, nonatomic) IBOutlet UIView *changeView;

- (IBAction)buttonAction:(id)sender;//0 换一张   1 下一步

@end

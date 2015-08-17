//
//  RechargeAccountViewController.m
//  jibaobao
//
//  Created by swb on 15/6/13.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
 ****  充值
 */

#import "RechargeAccountViewController.h"
#import "defines.h"

@interface RechargeAccountViewController ()

@end

@implementation RechargeAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleLabel.text = @"充值";
    
    self.delegate = self;
    
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    self.viewBg.layer.cornerRadius = 6.0f;
    self.viewBg.layer.masksToBounds = YES;
    self.viewBg.layer.borderColor = Color_line_bg.CGColor;
    self.viewBg.layer.borderWidth = 0.6f;
    
    self.okBtn.layer.cornerRadius = 6.0f;
    self.okBtn.layer.masksToBounds = YES;
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

- (IBAction)okBtnAction:(id)sender {
    NSLog(@"充值");
}
@end

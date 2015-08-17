//
//  FilterViewController.m
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 **   购物--》筛选
 */

#import "FilterViewController.h"
#import "SearchViewController.h"
#import "defines.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleLabel.text = @"筛选";
    self.delegate = self;
    [self setNavType:SEARCH_BUTTON];
    [self setScrollBtnHidden:YES];
    
    self.littleTf.layer.cornerRadius = 5.0f;
    self.littleTf.layer.masksToBounds = YES;
    self.littleTf.layer.borderColor = [Color_word_bg CGColor];
    self.littleTf.layer.borderWidth = 0.5f;
    self.bigTf.layer.cornerRadius = 5.0f;
    self.bigTf.layer.masksToBounds = YES;
    self.bigTf.layer.borderColor = [Color_word_bg CGColor];
    self.bigTf.layer.borderWidth = 0.5f;
    self.okBtn.layer.cornerRadius = 3.0f;
    self.okBtn.layer.masksToBounds = YES;
    
    // 监听键盘的即将显示事件. UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 监听键盘即将消失的事件. UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

// ----------------------- 分割线 -------------------------------

- (void)callBackFilter:(CallBackFilterBlock)block
{
    self.block = block;
}

- (void) keyboardWillShow:(NSNotification *)notify {
    
    CGFloat kbHeight = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;//获取键盘高度，在不同设备上，以及中英文下是不同的，很多网友的解决方案都把它定死了。
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration animations:^{
        self.bottomCon.constant = kbHeight;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) keyboardWillHidden:(NSNotification *)notify {//键盘消失
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.bottomCon.constant = 0;
    } completion:^(BOOL finished) {
        
    }];
}
//移除通知
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)right0ButtonClicked:(id)sender
{
    NSLog(@"%s",__func__);
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
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
    [self.view endEditing:YES];
    if (([self.littleTf.text floatValue] < 0)||([self.bigTf.text floatValue] < 0)||([self.bigTf.text floatValue] < [self.littleTf.text floatValue])) {
        [ProgressHUD showMessage:@"价格区间不合理" Width:280 High:10];
        return;
    }
    self.block(self.littleTf.text,self.bigTf.text);
    [self.navigationController popViewControllerAnimated:YES];
}
@end

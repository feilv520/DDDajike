//
//  DMainViewController.m
//  dajike
//
//  Created by dajike on 15/7/7.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DMainViewController.h"
#import "JTabBarController.h"
#import "AppDelegate.h"
#import "FoodShopDetailViewController.h"

@interface DMainViewController ()
- (IBAction)toJIbaobao:(id)sender;

@end

@implementation DMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)btnc
{
    FoodShopDetailViewController *vc = [[FoodShopDetailViewController alloc]init];
    vc.storeId = @"";
    [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)toJIbaobao:(id)sender {
    [self addTabBarViews];
}
- (void) addTabBarViews
{
    JTabBarController *tabbarVC = [JTabBarController sharedManager];
    
    [self setRootVC:tabbarVC];
    
}



- (void)setRootVC:(id)sender
{
    //获取当前的应用程序
    UIApplication *app = [UIApplication sharedApplication];
    //委托
    AppDelegate *del = app.delegate;
    //设置根视图
    del.window.rootViewController = sender;
}

@end

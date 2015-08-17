//
//  DBaseNavigationController.m
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBaseNavigationController.h"
#import "dDefine.h"

@interface DBaseNavigationController ()

@end

@implementation DBaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarHidden:NO];       // 使导航条有效
    [self.navigationBar setHidden:YES];     // 隐藏导航条，但由于导航条有效，系统的返回按钮页有效，所以可以使用系统的右滑返回手势。
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)bCanDragBack
{
    if (DIS_IOS7)
    {
        self.interactivePopGestureRecognizer.enabled = bCanDragBack;
    }else{}
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

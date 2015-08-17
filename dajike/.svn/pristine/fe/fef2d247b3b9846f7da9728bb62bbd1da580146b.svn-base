//
//  DHelpViewController.m
//  dajike
//
//  Created by swb on 15/7/22.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DHelpViewController.h"
#import "MethodHead.h"
#import "dDefine.h"

@interface DHelpViewController ()

@end

@implementation DHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNaviBarTitle:@"帮助中心"];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT+5)];
    NSURL *url = [NSURL URLWithString:HELP_CENTER];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    webView.paginationMode = UIWebPaginationModeTopToBottom;
    [self.view addSubview:webView];
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

@end

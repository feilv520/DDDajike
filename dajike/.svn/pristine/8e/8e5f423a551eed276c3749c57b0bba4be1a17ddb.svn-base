//
//  HelpCenterViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "MethodHead.h"
#import "defines.h"

@interface HelpCenterViewController ()

@end

@implementation HelpCenterViewController
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
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    if (self.isHelp == 1) {
        titleLabel.text = @"帮助中心";
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64)];
        NSURL *url = [NSURL URLWithString:HELP_CENTER];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        webView.paginationMode = UIWebPaginationModeTopToBottom;
//        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
    }
    if (self.isHelp == 2) {
        titleLabel.text = @"关于我们";
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64)];
        NSURL *url = [NSURL URLWithString:ABOUT_US];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        webView.paginationMode = UIWebPaginationModeTopToBottom;
        [self.view addSubview:webView];
    }
    if (self.isHelp == 3) {
        titleLabel.text = @"大集客用户协议公告";
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64)];
        NSURL *url = [NSURL URLWithString:DJK_USER_ARGUMENT];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        webView.paginationMode = UIWebPaginationModeTopToBottom;
        [self.view addSubview:webView];
    }
    if (self.isHelp == 4) {
        titleLabel.text = @"特别声明";
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64)];
        NSURL *url = [NSURL URLWithString:SPECIAL_DECLEAR];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        webView.paginationMode = UIWebPaginationModeTopToBottom;
        [self.view addSubview:webView];
    }
    if (self.isHelp == 5) {
        titleLabel.text = @"抽奖规则";
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64)];
        NSURL *url = [NSURL URLWithString:CHOUJIANG_RULE];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        webView.paginationMode = UIWebPaginationModeTopToBottom;
        [self.view addSubview:webView];
    }

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

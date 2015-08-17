//
//  PayView.m
//  jibaobao
//
//  Created by swb on 15/6/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "PayView.h"
#import "defines.h"
#import "Reachability.h"

#import "ActivityIndicator.h"
#import "AppDelegate.h"
@implementation PayView
{
    //转菊花对象
    ActivityIndicator *_indicator;
    BOOL        _flag;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        _flag = NO;
    }
    return self;
}

- (void)payRequestWithParam:(NSDictionary *)params ifAddActivityIndicator:(BOOL)hasActivityIndicator success:(success111)success
{
    self.suc = [success copy];
    
    NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
    NSString *payDomainstr = [FileOperation getobjectForKey:@"payment_domain" ofFilePath:filePath];
    NSString *payURLstr = [FileOperation getobjectForKey:@"payment_url" ofFilePath:filePath];
    
    NSString *pay_Domain_url = [NSString stringWithFormat:@"%@%@?",payDomainstr,payURLstr];
    NSLog(@"pay_Domain_url = %@",pay_Domain_url);
    
    NSLog(@"\n=======================dic = %@",params);
    
    NSMutableString *pay_url = [pay_Domain_url mutableCopy];
    
    NSArray *keyArr = [params allKeys];
    
    for (int i =0; i<keyArr.count; i++) {
        if (i>0) {
            [pay_url appendFormat:@"&%@=%@",[keyArr objectAtIndex:i],[params objectForKey:[keyArr objectAtIndex:i]]];
        }else
            [pay_url appendFormat:@"%@=%@",[keyArr objectAtIndex:i],[params objectForKey:[keyArr objectAtIndex:i]]];
    }
    [pay_url appendFormat:@"&%@=%@",@"srcApp",@"dajike-jibaobao-ios"];
    NSLog(@"\n_____pay_url = %@",pay_url);
    
    if(![self isConnectionAvailable])
    {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
        }
        
        [ProgressHUD showMessage:@"当前网络不可用，请检查你的网络设置。" Width:280 High:10];
        
        return;
    }
    
    
    if (hasActivityIndicator) {
        _flag = YES;
        //显示菊花
        _indicator = [ActivityIndicator sharedManager];
        AppDelegate *delegateApp = [[UIApplication sharedApplication]delegate];
        //设置计数，为了处理并发请求操作，animatCount ＝ 0的时候才可以显示indicator animatCount ＝ 0了才可以移除indicator，防止indicator显示出现混乱
        if(!_indicator.animatCount)
            [_indicator progressHudShowInView:delegateApp.window];
        _indicator.animatCount++;
    }
    
    UIWebView *webView = [[UIWebView alloc]init];
    webView.delegate = self;
    
    NSURL *url =[[NSURL alloc] initWithString:pay_url];
    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
    
    [self addSubview:webView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"支付完成");
    
    if (_flag) {
        //菊花停止转动
        if(_indicator.animatCount)
            _indicator.animatCount = 0;
        [_indicator progresshHUDRemoved];
        
    }
    
    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
    
    NSString * currentHTML = [webView stringByEvaluatingJavaScriptFromString:lJs];
    
    NSArray *arr = [currentHTML componentsSeparatedByString:@"'"];
    
    NSString *str1 = [arr objectAtIndex:1];
    NSDictionary *resultDic = [JsonStringTransfer jsonStringToDictionary:str1];
    
    self.suc(resultDic);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"请求失败_____%@",error);
    if (_flag) {
        //菊花停止转动
        if(_indicator.animatCount)
            _indicator.animatCount = 0;
        [_indicator progresshHUDRemoved];
        
    }
    
}

//判断网络连接状态
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    
    return isExistenceNetwork;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

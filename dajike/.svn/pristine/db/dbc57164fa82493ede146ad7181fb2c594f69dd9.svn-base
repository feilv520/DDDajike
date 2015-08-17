////
////  PayHttpRequest.m
////  jibaobao
////
////  Created by swb on 15/6/9.
////  Copyright (c) 2015年 dajike. All rights reserved.
////
//
//#import "PayHttpRequest.h"
//#import "defines.h"
//#import "AppDelegate.h"
//#import "PostData.h"
//#import "ActivityIndicator.h"
//#import "Reachability.h"
//
//@implementation PayHttpRequest
//{
////    ASIFormDataRequest *_request;
//    //转菊花对象
//    ActivityIndicator *_indicator;
//    
////    AFHTTPRequestOperationManager *_httpManager;
//    int _retryTime;
//}
//static PayHttpRequest  *httpRequest;
//
//- (void)setRetryCount:(int)retryCount0
//{
//    _retryCount = retryCount0;
//}
////支付请求  get
////- (void)payHttpRequestWithURLString:(NSString *)urlStr andDic:(NSDictionary *)params ifAddActivityIndicator:(BOOL)hasActivityIndicator success:(void (^)(AFHTTPRequestOperation *operation, PostData * responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
////{
////    NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
////    NSString *payDomainstr = [FileOperation getobjectForKey:@"payment_domain" ofFilePath:filePath];
////    NSString *payURLstr = [FileOperation getobjectForKey:@"payment_url" ofFilePath:filePath];
////    
////    NSString *pay_Domain_url = [NSString stringWithFormat:@"%@%@",payDomainstr,payURLstr];
////    NSLog(@"pay_Domain_url = %@",pay_Domain_url);
////    
////    NSLog(@"\n=======================dic = %@",params);
////
////    _retryCount = 1;
////    //先判断网络连接，如果网络连接失败，直接提示，返回，不进行网络请求
////    
////    if(![self isConnectionAvailable])
////    {
////        if (hasActivityIndicator) {
////            //菊花停止转动
////            if(_indicator.animatCount)
////                _indicator.animatCount = 0;
////            [_indicator progresshHUDRemoved];
////        }
////        
////        if(self.err)
////        {
////            if(self.err())
////            {
////                self.err = nil;
////                return ;
////            }
////        }
////        [ProgressHUD showMessage:@"当前网络不可用，请检查你的网络设置。" Width:280 High:10];
////        failure(nil,nil);
////        return;
////    }
////    
////    
////    if (hasActivityIndicator) {
////        //显示菊花
////        _indicator = [ActivityIndicator sharedManager];
////        AppDelegate *delegateApp = [[UIApplication sharedApplication]delegate];
////        //设置计数，为了处理并发请求操作，animatCount ＝ 0的时候才可以显示indicator animatCount ＝ 0了才可以移除indicator，防止indicator显示出现混乱
////        if(!_indicator.animatCount)
////            [_indicator progressHudShowInView:delegateApp.window];
////        _indicator.animatCount++;
////    }
////    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
////
////    [httpManager GET:pay_Domain_url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        if (hasActivityIndicator) {
////            //菊花停止转动
////            if(_indicator.animatCount)
////                _indicator.animatCount = 0;
////            [_indicator progresshHUDRemoved];
////            
////        }
////        //result对象
////        PostData *responseData = [[PostData alloc]init];
////        responseData.msg = [NSString stringWithString:[responseObject objectForKey:@"msg"]];
////        responseData.code = [[responseObject objectForKey:@"result_code"] integerValue];
////        if ([[responseObject objectForKey:@"result_code"] integerValue] == 200) {
////            responseData.succeed = YES;
////        }else{
////            responseData.succeed = NO;
////        }
////        responseData.result = [responseObject objectForKey:@"data"];
////        success(operation,responseData);
//////        success(operation.responseData);
////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        if (hasActivityIndicator) {
////            //菊花停止转动
////            if(_indicator.animatCount)
////                _indicator.animatCount = 0;
////            [_indicator progresshHUDRemoved];
////        }
////        failure(operation,error);
////        
////    }/*autoRetry:_retryCount*/]; //重试次数3次
////}
//
//
////请求支付
//- (void)payHttpRequestWithParam:(NSDictionary *)params ifAddActivityIndicator:(BOOL)hasActivityIndicator success:(success)success
//{
//    NSString *filePath = [FileOperation creatPlistIfNotExist:SET_PLIST];
//    NSString *payDomainstr = [FileOperation getobjectForKey:@"payment_domain" ofFilePath:filePath];
//    NSString *payURLstr = [FileOperation getobjectForKey:@"payment_url" ofFilePath:filePath];
//    
//    NSString *pay_Domain_url = [NSString stringWithFormat:@"%@%@?",payDomainstr,payURLstr];
//    NSLog(@"pay_Domain_url = %@",pay_Domain_url);
//    
//    NSLog(@"\n=======================dic = %@",params);
//    
//    NSMutableString *pay_url = [pay_Domain_url mutableCopy];
//    
//    NSArray *keyArr = [params allKeys];
//    
//    for (int i =0; i<keyArr.count; i++) {
//        [pay_url appendFormat:@"%@=%@",[keyArr objectAtIndex:i],[params objectForKey:[keyArr objectAtIndex:i]]];
//    }
//    NSLog(@"\n_____pay_url = %@",pay_url);
//    
//    _retryCount = 1;
//    //先判断网络连接，如果网络连接失败，直接提示，返回，不进行网络请求
//    
//    if(![self isConnectionAvailable])
//    {
//        if (hasActivityIndicator) {
//            //菊花停止转动
//            if(_indicator.animatCount)
//                _indicator.animatCount = 0;
//            [_indicator progresshHUDRemoved];
//        }
//        
//        [ProgressHUD showMessage:@"当前网络不可用，请检查你的网络设置。" Width:280 High:10];
//        
//        return;
//    }
//    
//    
//    if (hasActivityIndicator) {
//        //显示菊花
//        _indicator = [ActivityIndicator sharedManager];
//        AppDelegate *delegateApp = [[UIApplication sharedApplication]delegate];
//        //设置计数，为了处理并发请求操作，animatCount ＝ 0的时候才可以显示indicator animatCount ＝ 0了才可以移除indicator，防止indicator显示出现混乱
//        if(!_indicator.animatCount)
//            [_indicator progressHudShowInView:delegateApp.window];
//        _indicator.animatCount++;
//    }
//    
//    UIWebView *webView = [[UIWebView alloc]init];
//    webView.delegate = self;
//    
//    NSURL *url =[[NSURL alloc] initWithString:pay_url];
//    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:url];
//    [webView loadRequest:request];
////    [self addSubview:webview];
//}
//
//#pragma mark 取消网络请求
//- (void)cancelHttpRequest
//{
////    [_httpManager.operationQueue cancelAllOperations];
//}
////判断网络连接状态
//-(BOOL) isConnectionAvailable{
//    
//    BOOL isExistenceNetwork = YES;
//    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    
//    switch ([reach currentReachabilityStatus]) {
//        case NotReachable:
//            isExistenceNetwork = NO;
//            //NSLog(@"notReachable");
//            break;
//        case ReachableViaWiFi:
//            isExistenceNetwork = YES;
//            //NSLog(@"WIFI");
//            break;
//        case ReachableViaWWAN:
//            isExistenceNetwork = YES;
//            //NSLog(@"3G");
//            break;
//    }
//    
//    
//    return isExistenceNetwork;
//}
//
//+(PayHttpRequest *)sharedNetAccess
//{
//    if(httpRequest == nil)
//    {
//        httpRequest = [[PayHttpRequest alloc]init];
//    }
//    
//    return httpRequest;
//}
//
//
//
//@end

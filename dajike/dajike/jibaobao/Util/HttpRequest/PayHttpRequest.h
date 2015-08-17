////
////  PayHttpRequest.h
////  jibaobao
////
////  Created by swb on 15/6/9.
////  Copyright (c) 2015年 dajike. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
////#import "ASIFormDataRequest.h"
////#import "AFHTTPRequestOperationManager.h"
//#import "PostData.h"
//
//
//////网络请求成功，回掉的块
////typedef void (^success)(AFHTTPRequestOperation *operation, id responseObject);
////
//////网络请求成功，其他错误比如登陆信息错误，回掉的块
////typedef void (^failure)(AFHTTPRequestOperation *operation, NSError *error);
//////网络请求错误
////typedef BOOL (^httpError)();
//
//
////网络请求成功，回掉的块
//typedef void (^success)(id ret);
//
//@interface PayHttpRequest : NSObject<UIWebViewDelegate>
//
//- (void)cancelHttpRequest;
//@property (nonatomic, strong)success suc;
////@property (nonatomic, strong)failure fail;
////@property (nonatomic, strong)httpError err;
//
////- (void)payHttpRequestWithURLString:(NSString *)urlStr andDic:(NSDictionary *)params ifAddActivityIndicator:(BOOL)hasActivityIndicator success:(void (^)(AFHTTPRequestOperation *operation, PostData * responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//
//- (void)payHttpRequestWithParam:(NSDictionary *)params ifAddActivityIndicator:(BOOL)hasActivityIndicator success:(success)success;
//
//
//+(PayHttpRequest *)sharedNetAccess;
//
///**
// *  判断网络链接
// */
//-(BOOL) isConnectionAvailable;
//
////网络失败请求的次数
//@property (nonatomic,assign)int retryCount;
//
////timeout时间
//@property (nonatomic,assign)int timeOutTime;
//
//@end

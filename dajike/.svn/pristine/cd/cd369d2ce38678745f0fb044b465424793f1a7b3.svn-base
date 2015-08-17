//
//  MyAfHTTPManager.m
//  jibaobao
//
//  Created by dajike on 15/5/8.
//  Copyright (c) 2015年 dajike. All rights reserved.
//获取屏幕宽高
#define MAIN_SCREEN_WIDTH0   [[UIScreen mainScreen] applicationFrame].size.width
#define MAIN_SCREEN_HEIGHT0 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?[[UIScreen mainScreen] applicationFrame].size.height+20:[[UIScreen mainScreen] applicationFrame].size.height)
//

#import "MyAfHTTPClient.h"
#import "ASIFormDataRequest.h"
#import "DES3Util.h"
//#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworking.h"
#import "ActivityIndicator.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
#import "Reachability.h"
#import "MyMD5.h"
#import "JsonStringTransfer.h"
#import "JSONKit.h"
#import "MyAfHttpHeader.h"
#import "FileOperation.h"


//static NSString * const AFAppDotNetAPIBaseURLString = @"http://192.168.0.127:9003";
//static NSString * const AFAppDotNetAPIBaseURLString = @"http://app.mandi.net.cn";
static NSString * const AFPortStr = @"/Jbbs/call";

//static NSString * const AFAppDotNetAPIBaseURLString = @"http://weixin.mandi.net.cn";
//static NSString * const AFAppDotNetAPIBaseURLString = @"http://weixin1.mandi.com";
static NSString * const key = @"DaJiKe128jInIANlU928hao1013SHIwd_*jibaobao*_$app$";

@implementation MyAfHTTPClient
{
    ASIFormDataRequest *_request;
    //请求次数
     int _retryTime;
    NSDictionary *deviveANdAppInfo;
}
//static MyAfHTTPClient *sharedClient;

+ (instancetype)sharedClient {
    static MyAfHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MyAfHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:MYAFHTTP_BASEURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // 设置请求格式
//        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer]; 
        // 设置返回格式
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    });
    
    return _sharedClient;
}
- (void)setRetryCount:(int)retryCount0
{
    _retryCount = retryCount0;
}

//image 路径拼接等操作
- (NSString *)getImageUrlPathWithStr:(NSString *)oldPath
{
    return @"";
}


/*
 get Request
 */
- (void) getPathWithMethod:(NSString *)method parameters:(NSDictionary *)parameters ifAddActivityIndicator:(BOOL)hasActivityIndicator
                    success:(void (^)(AFHTTPRequestOperation *operation, PostData * responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //获取设备 app等信息
    [self getDiviceAndAppInfo];
    NSMutableDictionary *parameters0 = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    [parameters0 setObject:[deviveANdAppInfo objectForKey:@"time_stamp"] forKey:@"time_stamp"];
    
    NSMutableString *signStr0 = [[NSMutableString alloc]init];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSMutableArray *keyArr = [[NSMutableArray alloc]init];
    for (NSString *key1 in parameters0.allKeys) {
        [keyArr addObject:key1];
    }
    NSArray *resultArray = [keyArr sortedArrayUsingDescriptors:descriptors];
    NSLog(@"%@", resultArray);
    for (int i = 0; i < resultArray.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@=%@&",[resultArray objectAtIndex:i],[parameters0 objectForKey:[resultArray objectAtIndex:i]]];
        [signStr0 appendString:str];
    }
    [signStr0 appendFormat:@"key=%@",key];
    NSString *sign = [MyMD5 md5:signStr0];
    //deviceInfo
    NSDictionary *deviceInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:[deviveANdAppInfo objectForKey:@"os"],@"os",[deviveANdAppInfo objectForKey:@"deviceVersion"],@"version",[deviveANdAppInfo objectForKey:@"uuid"],@"id",[FileOperation getDeviceToken],@"number", nil];
    
    NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:sign,@"sign",[deviveANdAppInfo objectForKey:@"version"],@"version",method,@"method",parameters0,@"params",deviceInfoDic,@"deviceInfo", nil];
    //     NSString *str1 = [NSString stringWithString:[dic0 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic0 options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *dataStr =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];
    NSString *encodedValue1 = [formDataRequest encodeURL:dataStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:encodedValue1,@"data", nil];
    
    
    
    _retryCount = 1;
    //先判断网络连接，如果网络连接失败，直接提示，返回，不进行网络请求
    
    if(![self isConnectionAvailable])
    {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
        }
        
        if(self.err)
        {
            if(self.err())
            {
                self.err = nil;
                return ;
            }
        }
        [ProgressHUD showMessage:@"当前网络不可用，请检查你的网络设置。" Width:280 High:10];
        failure(nil,nil);
        return;
    }
    
    
    if (hasActivityIndicator) {
        //显示菊花
        _indicator = [ActivityIndicator sharedManager];
        AppDelegate *delegateApp = [[UIApplication sharedApplication]delegate];
        //设置计数，为了处理并发请求操作，animatCount ＝ 0的时候才可以显示indicator animatCount ＝ 0了才可以移除indicator，防止indicator显示出现混乱
        if(!_indicator.animatCount)
            [_indicator progressHudShowInView:delegateApp.window];
        _indicator.animatCount++;
    }
    
    [self GET:AFPortStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
            
        }
        //result对象
        PostData *responseData = [[PostData alloc]init];
        responseData.msg = [NSString stringWithString:[responseObject objectForKey:@"msg"]];
        responseData.code = [[responseObject objectForKey:@"result_code"] integerValue];
        if ([[responseObject objectForKey:@"result_code"] integerValue] == 200) {
            responseData.succeed = YES;
        }else{
            responseData.succeed = NO;
        }
        responseData.result = [responseObject objectForKey:@"data"];
        success(operation,responseData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
        }
        failure(operation,error);
    }];
    
}
- (void) getPath:(NSString *)path parameters:(NSDictionary *)parameters ifAddActivityIndicator:(BOOL)hasActivityIndicator
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    _retryCount = 1;
    //先判断网络连接，如果网络连接失败，直接提示，返回，不进行网络请求

    if(![self isConnectionAvailable])
    {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
        }
        
        if(self.err)
        {
            if(self.err())
            {
                self.err = nil;
                return ;
            }
        }
        [ProgressHUD showMessage:@"当前网络不可用，请检查你的网络设置。" Width:280 High:10];
        failure(nil,nil);
        return;
    }
    
    
    if (hasActivityIndicator) {
        //显示菊花
        _indicator = [ActivityIndicator sharedManager];
        AppDelegate *delegateApp = [[UIApplication sharedApplication]delegate];
        //设置计数，为了处理并发请求操作，animatCount ＝ 0的时候才可以显示indicator animatCount ＝ 0了才可以移除indicator，防止indicator显示出现混乱
        if(!_indicator.animatCount)
            [_indicator progressHudShowInView:delegateApp.window];
        _indicator.animatCount++;
    }
    
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];

        }
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
        }
        success(operation,error);
    }];
   
}






/*
 post Request
 */

- (void) postPathWithMethod:(NSString *)method parameters:(NSDictionary *)parameters ifAddActivityIndicator:(BOOL)hasActivityIndicator 
          success:(void (^)(AFHTTPRequestOperation *operation, PostData * responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //获取设备 app等信息
    [self getDiviceAndAppInfo];
    NSMutableDictionary *parameters0 = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    [parameters0 setObject:[deviveANdAppInfo objectForKey:@"time_stamp"] forKey:@"time_stamp"];
    
    NSMutableString *signStr0 = [[NSMutableString alloc]init];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSMutableArray *keyArr = [[NSMutableArray alloc]init];
    //如果参数值为空的话，不参与生成签名
    for (NSString *key1 in parameters0.allKeys) {
        NSString *tmpStr = [NSString stringWithFormat:@"%@",[parameters0 objectForKey:key1]];
        if (!([tmpStr isEqualToString:@""]||[tmpStr isEqual:[NSNull null]]))
        {
            [keyArr addObject:key1];
        }
    }
    NSArray *resultArray = [keyArr sortedArrayUsingDescriptors:descriptors];
    NSLog(@"%@", resultArray);
    for (int i = 0; i < resultArray.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@=%@&",[resultArray objectAtIndex:i],[parameters0 objectForKey:[resultArray objectAtIndex:i]]];
        [signStr0 appendString:str];
    }
    [signStr0 appendFormat:@"key=%@",key];
    NSString *sign = [MyMD5 md5:signStr0];
    //deviceInfo
    NSDictionary *deviceInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:[deviveANdAppInfo objectForKey:@"os"],@"os",[deviveANdAppInfo objectForKey:@"deviceVersion"],@"version",[deviveANdAppInfo objectForKey:@"uuid"],@"id",[deviveANdAppInfo objectForKey:@"number"],@"number", nil];
    
    NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:sign,@"sign",[deviveANdAppInfo objectForKey:@"version"],@"version",method,@"method",parameters0,@"params",deviceInfoDic,@"deviceInfo", nil];

    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic0 options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *dataStr =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSString *dataStr01 = [dataStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *dataStr02 = [NSString stringWithContentsOfURL:[NSURL URLWithString:dataStr01] encoding:NSUTF8StringEncoding error:nil];
    ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];
    NSString *encodedValue1 = [formDataRequest encodeURL:dataStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:encodedValue1,@"data", nil];
    
    NSLog(@"dic0 = %@",dic0);
    
    _retryCount = 1;
    //先判断网络连接，如果网络连接失败，直接提示，返回，不进行网络请求
    
    if(![self isConnectionAvailable])
    {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
        }
        
        if(self.err)
        {
            if(self.err())
            {
                self.err = nil;
                return ;
            }
        }
        [ProgressHUD showMessage:@"当前网络不可用，请检查你的网络设置。" Width:280 High:10];
        failure(nil,nil);
        return;
    }
    
    
    if (hasActivityIndicator) {
        //显示菊花
        _indicator = [ActivityIndicator sharedManager];
        AppDelegate *delegateApp = [[UIApplication sharedApplication]delegate];
        //设置计数，为了处理并发请求操作，animatCount ＝ 0的时候才可以显示indicator animatCount ＝ 0了才可以移除indicator，防止indicator显示出现混乱
        if(!_indicator.animatCount)
            [_indicator progressHudShowInView:delegateApp.window];
        _indicator.animatCount++;
    }
    
    [self POST:AFPortStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (hasActivityIndicator) {
            //菊花停止转动
            //恢复加载frame
            [self reSetIndicatorFrame];
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
            
        }
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil]];
        //result对象
        PostData *responseData = [[PostData alloc]init];
        responseData.code = [[tmpDic objectForKey:@"result_code"] integerValue];
        if ([[tmpDic objectForKey:@"result_code"] integerValue] == 200) {
            responseData.succeed = YES;
            if ([tmpDic objectForKey:@"msg"] == [NSNull null]) {
                responseData.msg  = @"";
            }else{
                responseData.msg = [NSString stringWithString:[tmpDic objectForKey:@"msg"]];
            }
            if ([tmpDic objectForKey:@"data"] == [NSNull null]) {
                responseData.result = @"";
            }else
                responseData.result = [tmpDic objectForKey:@"data"];
        }else if([[tmpDic objectForKey:@"result_code"] integerValue] == 0){
            responseData.succeed = NO;
            BOOL hasMsg = NO;
            for (NSString *key in ((NSDictionary *)tmpDic).allKeys) {
                if ([key isEqualToString:@"msg"]) {
                    hasMsg = YES;
                }
            }
            if (([tmpDic objectForKey:@"msg"] == [NSNull null])||(hasMsg == NO)) {//msg==nil或msg不存在
                responseData.msg  = @"";
            }else{
                responseData.msg = [NSString stringWithString:[tmpDic objectForKey:@"msg"]];
            }
        }
        NSLog(@"method = %@",method);
        NSLog(@"responseData.msg = %@",responseData.msg);
        NSLog(@"responseData.code = %ld",(long)responseData.code);
        success(operation,responseData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (hasActivityIndicator) {
            //菊花停止转动
            //恢复加载frame
            [self reSetIndicatorFrame];
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
        }
        failure(operation,error);
    }];
    

}

- (void) postPath:(NSString *)path parameters:(NSDictionary *)parameters ifAddActivityIndicator:(BOOL)hasActivityIndicator
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    _retryCount = 1;
    //先判断网络连接，如果网络连接失败，直接提示，返回，不进行网络请求
    
    if(![self isConnectionAvailable])
    {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
        }
        
        if(self.err)
        {
            if(self.err())
            {
                self.err = nil;
                return ;
            }
        }
        [ProgressHUD showMessage:@"当前网络不可用，请检查你的网络设置。" Width:280 High:10];
        failure(nil,nil);
        return;
    }
    
    
    if (hasActivityIndicator) {
        //显示菊花
        _indicator = [ActivityIndicator sharedManager];
        AppDelegate *delegateApp = [[UIApplication sharedApplication]delegate];
        //设置计数，为了处理并发请求操作，animatCount ＝ 0的时候才可以显示indicator animatCount ＝ 0了才可以移除indicator，防止indicator显示出现混乱
        if(!_indicator.animatCount)
            [_indicator progressHudShowInView:delegateApp.window];
        _indicator.animatCount++;
    }
    
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
            
        }
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
        }
        success(operation,error);
    }];
}

/*
 image
 */

//ASI上传图片

- (void)chatAsiHttpRequestWithUrl:(NSString *)method andImagePaths:(NSDictionary *)paths andDic:(NSDictionary *)params ifAddActivityIndicator:(BOOL)hasActivityIndicator success:(void (^)(AFHTTPRequestOperation *operation,  PostData * responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //获取设备信息 app信息
    [self getDiviceAndAppInfo];
    
    NSMutableDictionary *param0 = [[NSMutableDictionary alloc]initWithDictionary:params];
    [param0 setObject:[deviveANdAppInfo objectForKey:@"time_stamp"] forKey:@"time_stamp"];
    
    NSMutableString *str0   = [[NSMutableString alloc]init];
    NSSortDescriptor *desc0 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *mArr           = [NSArray arrayWithObject:desc0];
    NSMutableArray *keyArr  = [[NSMutableArray alloc]init];
    //如果参数值为空，不参与生成签名
    for (NSString *key0 in param0.allKeys) {
        if (![[param0 objectForKey:key0]isEqualToString:@""]) {
            [keyArr addObject:key0];
        }
    }
    NSArray *resArr = [keyArr sortedArrayUsingDescriptors:mArr];
    NSLog(@"mArr = %@",resArr);
    
    for (int i=0; i<resArr.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@=%@&",[resArr objectAtIndex:i],[param0 objectForKey:[resArr objectAtIndex:i]]];
        [str0 appendString:str];
    }
    
    [str0 appendFormat:@"key=%@",key];
    NSLog(@"str0 = %@",str0);
    //加密后得到签名
    NSString *sign = [MyMD5 md5:str0];
    
    //deviceInfo
    NSDictionary *deviceInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:[deviveANdAppInfo objectForKey:@"os"],@"os",[deviveANdAppInfo objectForKey:@"deviceVersion"],@"version",[deviveANdAppInfo objectForKey:@"uuid"],@"id",[FileOperation getDeviceToken],@"number", nil];
    
    NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:sign,@"sign",[deviveANdAppInfo objectForKey:@"version"],@"version",method,@"method",param0,@"params",deviceInfoDic,@"deviceInfo", nil];
    
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic0 options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *dataStr =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];
    NSString *encodedValue1 = [formDataRequest encodeURL:dataStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:encodedValue1,@"data", nil];
    
    NSLog(@"dic0 = %@",dic0);
    
    _retryCount = 1;
    //先判断网络连接，如果网络连接失败，直接提示，返回，不进行网络请求
    
    if(![self isConnectionAvailable])
    {
        if (hasActivityIndicator) {
            //菊花停止转动
            if(_indicator.animatCount)
                _indicator.animatCount = 0;
            [_indicator progresshHUDRemoved];
        }
        
        if(self.err)
        {
            if(self.err())
            {
                self.err = nil;
                return ;
            }
        }
        [ProgressHUD showMessage:@"当前网络不可用，请检查你的网络设置。" Width:280 High:10];
        failure(nil,nil);
        return;
    }
    
    if (hasActivityIndicator) {
        //显示菊花
        _indicator = [ActivityIndicator sharedManager];
        AppDelegate *delegateApp = [[UIApplication sharedApplication]delegate];
        //设置计数，为了处理并发请求操作，animatCount ＝ 0的时候才可以显示indicator animatCount ＝ 0了才可以移除indicator，防止indicator显示出现混乱
        if(!_indicator.animatCount)
            [_indicator progressHudShowInView:delegateApp.window];
        _indicator.animatCount++;
    }
    
    [self uploadImageRequestWithUrl:method andImagePaths:paths andDic:dic success:success failure:failure];
}

- (void)uploadImageRequestWithUrl:(NSString *)method andImagePaths:(NSDictionary *)paths andDic:(NSDictionary *)params success:success failure:failure
{
    NSLog(@"imgDic = %@",paths);
    NSLog(@"params = %@",params);
    
    self.suc = [success copy];
    self.fail = [failure copy];
    
    NSLog(@"url = %@",[NSString stringWithFormat:@"%@%@",MYAFHTTP_BASEURL,AFPortStr]);
    
    _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MYAFHTTP_BASEURL,AFPortStr]]];
    [_request setNumberOfTimesToRetryOnTimeout:_retryCount]; //设置重试次数为3次
    [_request setPostFormat:ASIMultipartFormDataPostFormat];
    
    NSArray *imgFile = [paths allKeys];
    for(int i = 0;i<imgFile.count;i++)
    {
        NSString *key = [imgFile objectAtIndex:i];
        NSString *obj = [paths objectForKey:key];
        //        UIImrage *img;
        
        NSLog(@"%@",[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:obj]);
        //        NSString *imagePath = [NSString stringWithFormat:@"%@",[NSHomeDirectory() stringByAppendingPathComponent:obj]];
        NSMutableData *mData;
        
        //如果是图片
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:obj]];
        
        NSData *data = UIImageJPEGRepresentation(img, 1.0f);
        mData = [data mutableCopy];
        if(mData)
        {
            [_request addData:mData withFileName:obj andContentType:@"image/png" forKey:key];
        }
    }
    
    NSArray *keys = [params allKeys];
    for(NSString *key in keys)
    {
        NSString *object = [params objectForKey:key];
        [_request addPostValue:object forKey:key];
    }
    [_request setTimeOutSeconds:60]; //Timout时间设置成5秒
    
    //    [_request setDelegate:self];
    [_request startAsynchronous];//开始。异步
    __weak MyAfHTTPClient *weakSelf0 = self;
    __weak ASIFormDataRequest *weakRequest = _request;
    [_request setCompletionBlock:^{
        //显示菊花
        ActivityIndicator *indicator = [ActivityIndicator sharedManager];
        [indicator progresshHUDRemoved];
        
        NSString *jsonString = [weakRequest responseString];
        
        NSMutableDictionary *dictionary = [jsonString objectFromJSONString];
        
        PostData *responseData = [[PostData alloc]init];
        responseData.code = [[dictionary objectForKey:@"result_code"] integerValue];
        
        if (responseData.code == 200) {
            responseData.succeed = YES;
            if ([dictionary objectForKey:@"msg"] == [NSNull null]) {
                responseData.msg  = @"";
            }else{
                responseData.msg = [NSString stringWithString:[dictionary objectForKey:@"msg"]];
            }
            if ([dictionary objectForKey:@"data"] == [NSNull null]) {
                responseData.result = @"";
            }else
                responseData.result = [dictionary objectForKey:@"data"];
        }else if([[dictionary objectForKey:@"result_code"] integerValue] == 0){
            responseData.succeed = NO;
            BOOL hasMsg = NO;
            for (NSString *key in ((NSDictionary *)dictionary).allKeys) {
                if ([key isEqualToString:@"msg"]) {
                    hasMsg = YES;
                }
            }
            if (([dictionary objectForKey:@"msg"] == [NSNull null])||(hasMsg == NO)) {//msg==nil或msg不存在
                responseData.msg  = @"";
            }else{
                responseData.msg = [NSString stringWithString:[dictionary objectForKey:@"msg"]];
            }
        }
        
        NSLog(@"%@",weakRequest.responseString);
        
        weakSelf0.suc(nil,responseData);
    }];
    __weak MyAfHTTPClient *weakSelf = self;
    [_request setFailedBlock :^{
        ActivityIndicator *indicator = [ActivityIndicator sharedManager];
        [indicator progresshHUDRemoved];
        weakSelf.fail(nil,nil);
    }];
}

/**
 * 修发图片大小
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
    
}

/**
 * 保存图片
 */
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
//    NSData* imageData;
    
//    //判断图片是不是png格式的文件
//    if (UIImagePNGRepresentation(tempImage)) {
//        //返回为png图像。
//        imageData = UIImagePNGRepresentation(tempImage);
//    }else {
//        //返回为JPEG图像。
//        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
//    }
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    
//    NSString* documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
//    
//    NSArray *nameAry=[fullPathToFile componentsSeparatedByString:@"/"];
//    NSLog(@"===fullPathToFile===%@",fullPathToFile);
//    NSLog(@"===FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
//    
//    [imageData writeToFile:fullPathToFile atomically:NO];
//    return fullPathToFile;
    CGSize imgSize = tempImage.size;
    float maxF = imgSize.height > imgSize.width? imgSize.height:imgSize.width;
    if (maxF > 1000) {
        tempImage = [ImageCompress scaleImage:tempImage WithScale:1000.0/maxF];
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/FreeAsk%@.jpg",NSHomeDirectory(),imageName];
    [manager createFileAtPath:filePath contents:UIImageJPEGRepresentation(tempImage, 1.0f) attributes:nil];
    return filePath;
}

/**
 * 生成GUID
 */
+ (NSString *)generateUuidString{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // transfer ownership of the string
    // to the autorelease pool
    //    [uuidString autorelease];
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}



/*
 deng dai
 */


#pragma mark 取消网络请求
- (void)cancelHttpRequest
{
    [self.operationQueue cancelAllOperations];
}
////判断网络连接状态
//-(BOOL) isConnectionAvailable{
//    
//    NSOperationQueue *operationQueue = self.operationQueue;
//  
//    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//            {
//                [operationQueue setSuspended:NO];
////                afd = @"dfgg";
//            }
//                
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//            default:
//                [operationQueue setSuspended:YES];
//                break;
//        }
//    }];
//    
//    [self.reachabilityManager startMonitoring];
//    return NO;
//    
//}

    
    
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


//+(HttpRequest *)sharedNetAccess
//{
//    if(httpRequest == nil)
//    {
//        httpRequest = [[HttpRequest alloc]init];
//    }
//    
//    return httpRequest;
//}



//获取当前app版本
//获取手机当前的时间戳
//当前设备信息
- (void)getDiviceAndAppInfo
{
    NSString *appVersion = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    
//    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *time_stamp = [NSString stringWithFormat:@"%llu",recordTime];
    
    //设备uuid
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    NSString *results = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //版本号
    NSString *deviceVersion = [NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]];
    deviveANdAppInfo = [NSDictionary dictionaryWithObjectsAndKeys:appVersion,@"version",time_stamp,@"time_stamp",@"iOS",@"os",deviceVersion,@"deviceVersion",results,@"uuid",[FileOperation getDeviceToken],@"number", nil];
}

//调整加载视图的frame
- (void) setIndicatorFrameWithFrame:(CGRect) loadingFrame
{
    [_indicator reSetFrame:loadingFrame];
}
//恢复加载视图的frame
- (void) reSetIndicatorFrame
{
    [_indicator reSetFrame:CGRectMake(0, 64, MAIN_SCREEN_WIDTH0, MAIN_SCREEN_HEIGHT0-64)];
}

//当正在加载的过程中，突然返回，隐藏加载界面
- (void) hiddenLoadingView
{
    //菊花停止转动
    if(_indicator.animatCount)
        _indicator.animatCount = 0;
    [_indicator progresshHUDRemovedFast];
}


@end


#import "UIImageView+AFNetworking.h"
@implementation  UIImageView(adimageView)

//广告页面图片路径拼接处理、图片异步加载、本地缓存
- (void)setADImageWithURLStr:(NSString *)oldUrlStr
         placeholderImage:(UIImage *)placeholderImage
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",MYAFHTTP_BASEURL,AFPortStr,oldUrlStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self setImageWithURL:url placeholderImage:placeholderImage];
}


@end

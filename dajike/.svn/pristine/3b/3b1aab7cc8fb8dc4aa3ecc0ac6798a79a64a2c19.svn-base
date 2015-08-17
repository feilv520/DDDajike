//
//  ShouYiBiLiPayObject.m
//  jibaobao
//
//  Created by swb on 15/6/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "ShouYiBiLiPayObject.h"
#import "defines.h"

@implementation ShouYiBiLiPayObject
//支付时的收益比例可抵金额
+ (void)getShouYiBiLiPayJinE:(CallBackDataBlock)callback
{
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Configs.property" parameters:nil ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSMutableDictionary *dic = [responseObject.result mutableCopy];
            callback(dic);
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

@end

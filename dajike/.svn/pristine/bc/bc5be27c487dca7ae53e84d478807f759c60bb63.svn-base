//
//  DOrderOperation.m
//  dajike
//
//  Created by swb on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//


/*
 *******  订单类的操作
 */

#import "DOrderOperation.h"
#import "dDefine.h"

@implementation DOrderOperation
//取消订单
+ (void)cancelOrder:(NSDictionary *)pramas success:(sec)succ
{
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.cancleOrder" parameters:pramas ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        NSLog(@"result = %@",responseObject.result);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            succ();
            
        }else{
            
        }
        showMessage(responseObject.msg);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//删除订单
+ (void)deleteOrder:(NSDictionary *)parama success:(sec)succ
{
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.deleteOrder" parameters:parama ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        NSLog(@"result = %@",responseObject.result);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            succ();
            
        }else{
            
        }
        showMessage(responseObject.msg);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end

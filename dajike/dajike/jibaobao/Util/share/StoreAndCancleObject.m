//
//  StoreAndCancleObject.m
//  jibaobao
//
//  Created by swb on 15/6/26.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "StoreAndCancleObject.h"
#import "defines.h"

@implementation StoreAndCancleObject

+ (void)stroe:(NSString *)userId withObjectId:(NSString *)objectId withType:(NSString *)storeType withBlcok:(CallBackSuccess)success
{
    NSDictionary *parameter = @{@"objectId":objectId,@"type":storeType,@"userId":userId};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyCollectss.collect" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
//            _mView.storeImg.image = [UIImage imageNamed:@"img_asterisk_03"];
            success(666);
            [ProgressHUD showMessage:@"收藏成功" Width:100 High:80];
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"收藏失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

+ (void)cancelStore:(NSString *)userId withObjectId:(NSString *)objectId withType:(NSString *)storeType withBlcok:(CallBackSuccess)success
{
    NSDictionary *parameter = @{@"itemId":objectId,@"type":storeType,@"userId":userId};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyCollectss.delete" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
//            _mView.storeImg.image = [UIImage imageNamed:@"img_asterisk_02"];
            success(666);
            [ProgressHUD showMessage:@"取消收藏成功" Width:100 High:80];
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"取消收藏失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

@end

//
//  StoreAndCancleObject.h
//  jibaobao
//
//  Created by swb on 15/6/26.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 **   收藏  取消收藏
 */

#import <Foundation/Foundation.h>

typedef void (^CallBackSuccess)(int flag);

@interface StoreAndCancleObject : NSObject

//收藏
+ (void)stroe:(NSString *)userId withObjectId:(NSString *)objectId withType:(NSString *)storeType withBlcok:(CallBackSuccess)success;
//取消收藏
+ (void)cancelStore:(NSString *)userId withObjectId:(NSString *)objectId withType:(NSString *)storeType withBlcok:(CallBackSuccess)success;

@end

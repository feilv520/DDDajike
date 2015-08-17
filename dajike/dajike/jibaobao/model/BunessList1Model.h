//
//  BunessList1Model.h
//  jibaobao
//
//  Created by 李江明 on 15/5/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 我的收藏-》商家
 */
@interface BunessList1Model : NSObject

@property (strong ,nonatomic)NSString *region_name;

@property (strong ,nonatomic)NSString *address;

@property (strong ,nonatomic)NSString *avgxingji;

@property (strong ,nonatomic)NSString *tag;

@property (strong ,nonatomic)NSString *distance;

@property (strong ,nonatomic)NSString *item_id;

@property (strong ,nonatomic)NSString *tel;

@property (strong ,nonatomic)NSString *store_logo;

@property (strong ,nonatomic)NSString *couponNum;

@property (strong ,nonatomic)NSString *commentCount;

@property (strong ,nonatomic)NSString *store_name;

@property (strong ,nonatomic)NSString *collectCount;
@property (nonatomic) BOOL isChecked;




@end
/*
 
 
 "region_name": "中国上海上海嘉定区",
 "address": "一二八纪念路",
 "avgxingji": null,
 "tag": "美容美体",
 "item_id": 4039,
 "tel": "1888888888",
 "store_logo": "data/files/2014/0313/40391394680579_store_logo.png",
 "couponNum": 0,
 "commentCount": 0,
 "store_name": "花神艺术养颜连锁机构"
 */
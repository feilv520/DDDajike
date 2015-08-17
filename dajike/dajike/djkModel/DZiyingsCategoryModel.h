//
//  DZiyingsCategoryModel.h
//  dajike
//
//  Created by dajike on 15/7/21.
//  Copyright (c) 2015年 haixia. All rights reserved.
//


//大集客自营 类别
#import <Foundation/Foundation.h>

@interface DZiyingsCategoryModel : NSObject
@property (strong, nonatomic) NSString *cateId;
@property (strong, nonatomic) NSString *storeId;
@property (strong, nonatomic) NSString *cateName;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *ifShow;
@property (strong, nonatomic) NSString *dropState;
@property (strong, nonatomic) NSString *guojiguan;
@property (strong, nonatomic) NSString *changshang;
@property (strong, nonatomic) NSString *dailishang;
@property (strong, nonatomic) NSString *lingshoushang;
@property (strong, nonatomic) NSString *shitidian;
@property (strong, nonatomic) NSString *persistent;
@property (strong, nonatomic) NSString *entityId;

@end

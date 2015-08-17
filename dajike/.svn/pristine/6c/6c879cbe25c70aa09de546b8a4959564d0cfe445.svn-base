//
//  DFileOperation.h
//  dajike
//
//  Created by dajike on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "FileOperation.h"
//最近zhiying城市列表
#define kRecentlyZhiyingCityArr              @"recentlyZhiyingCityArr"
//selectView 当前选择 index
#define kSelectZhiyingIndex              @"selectViewSelectZhiyingIndex"
@interface DFileOperation : FileOperation


//区域直营城市列表
//获取所有的区域直营城市列表
+ (void) getAllQuyuPlaces:(void (^)(BOOL finish))success;
//取出所有的城市
+ (NSArray *) getAllCityPlaces;
//取出当前城市id对应的所有区县
+ (NSArray *)getAllQuyuByCityId:(NSInteger)cityId;

#pragma zhiying
//当前直营城市字典
+ (NSDictionary *)getCurrentZhiyingCityDic;

//存储记录
+ (void)writeCurrentCityWithCityDic:(NSDictionary *)cityDic;
//获取最近zhiying城市记录
+ (NSArray *)getRecentlyZhiyingCitys;

//纪录选择的index
+ (NSInteger) selectCityIndex;

+ (void) writeSelectCityIndex:(NSInteger) index;

@end

//
//  AnalysisData.h
//  jibaobao
//
//  Created by dajike on 15/5/22.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 data数据的解析类
 */
#import <Foundation/Foundation.h>


@interface AnalysisData : NSObject
//针对后台返回的des加密后的字典数据的解析处理
+ (NSDictionary *)decodeAndDecriptWittDESstring:(NSString *)DESStr;

//针对后台返回的des加密后的数组数据的解析处理
+ (NSArray *)decodeAndDecriptWittDESArray:(NSString *)DESStr;

+ (NSString *)decodeToString:(NSString *)str;
@end


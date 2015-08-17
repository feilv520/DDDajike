//
//  JasonStringTransfer.h
//  RuYi
//
//  Created by DLin on 14-10-31.
//  Copyright (c) 2014-2015 DLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonStringTransfer : NSObject
//json字符串转字典，数组
+ (id)jsonStringToDictionary:(NSString *)jsonString;

//字典，数组转json字符串
+ (NSString *)objectToJsonString:(id)object;

//字典转model
+(id)dictionary:(NSDictionary *)dic ToModel:(id)model;

//model转字典
+ (NSDictionary *)modelToDictionary:(NSObject*)model;

//model转jsonString
+ (NSString *)modelToJsonString:(NSObject *)model;

//model转属性数组
+ (NSArray *)modelToArray:(NSObject *)model;
@end

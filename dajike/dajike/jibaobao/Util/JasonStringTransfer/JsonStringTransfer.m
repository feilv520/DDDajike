//
//  JasonStringTransfer.m
//  RuYi
//
//  Created by DLin on 14-10-31.
//  Copyright (c) 2014-2015 DLin. All rights reserved.
//

#import "JsonStringTransfer.h"
#import "JSONKit.h"
#import "MJExtension.h"
@implementation JsonStringTransfer
//json字符串转字典，数组
+ (id)jsonStringToDictionary:(NSString *)jsonString
{
    id ob = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    return ob;
}
//字典，数组转json字符串
+ (NSString *)objectToJsonString:(id)object
{
    NSString *jsonString = [object JSONString1];
    return jsonString;
}
//字典转model
+ (id)dictionary:(NSDictionary *)dic ToModel:(NSObject*)model
{
    //dic中所有value转成string类型
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]init];
    for (NSString * key in dic.allKeys) {
        if ([[dic objectForKey:key] isKindOfClass:[NSArray class]]) {
            [mutableDic setObject:[dic objectForKey:key] forKey:key];
        }
        [mutableDic setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:key]] forKey:key];
        
    }
    model = [[model class] objectWithKeyValues:mutableDic];
    return model;
}
//model转字典
+ (NSDictionary *)modelToDictionary:(NSObject*)model
{
    NSDictionary *dict = model.keyValues;
    return dict;
}
//model转属性数组
+ (NSArray *)modelToArray:(NSObject *)model
{
    NSDictionary *dict = model.keyValues;
    NSArray *arr = [dict allKeys];
    return arr;
}
//model转jsonString
+ (NSString *)modelToJsonString:(NSObject *)model
{
    //先把model转字典，再把字典转jsonstring
    if(model)
    {
        NSDictionary *dict = model.keyValues;
        
        NSString *jsonString = [dict JSONString1];
        return jsonString;
    }
    else
        return nil;
}
@end

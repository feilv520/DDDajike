//
//  AnalysisData.m
//  jibaobao
//
//  Created by dajike on 15/5/22.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "AnalysisData.h"
#import "DES3Util.h"


@implementation AnalysisData
//针对后台返回的des加密后的字典数据的解析处理
+ (NSDictionary *)decodeAndDecriptWittDESstring:(NSString *)DESStr
{
    NSString *sd = [DESStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *sd1 = [DES3Util decrypt:sd];
    NSData *data = [sd1 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tmpDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return tmpDic;
}

//针对后台返回的des加密后的数组数据的解析处理
+ (NSArray *)decodeAndDecriptWittDESArray:(NSString *)DESStr
{
    NSString *sd = [DESStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *sd1 = [DES3Util decrypt:sd];
    NSData *data = [sd1 dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *tmpArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return tmpArr;
}

+ (NSString *)decodeToString:(NSString *)str
{
    NSString *sd = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *sd1 = [DES3Util decrypt:sd];
    return sd1;
}

@end




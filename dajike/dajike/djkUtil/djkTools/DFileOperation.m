//
//  DFileOperation.m
//  dajike
//
//  Created by dajike on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DFileOperation.h"
#import "FMDatabase.h"
#import "DMyAfHTTPClient.h"

@implementation DFileOperation
//区域直营城市列表
//获取所有的区域直营城市列表
+ (void) getAllQuyuPlaces:(void (^)(BOOL finish))success
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyQuyuDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS QUYUCITYS (id integer  primary key,pid integer, name text, pname text)"];
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"QyZhiYings.chooseArea" parameters:nil ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *cityDic = [[NSDictionary alloc]initWithDictionary:responseObject.result];
                for (NSString *key in cityDic.allKeys) {
                    NSMutableArray *quyuArr = [NSMutableArray arrayWithArray:[cityDic objectForKey:key]];
                    if (quyuArr.count > 0) {
                        NSDictionary *dic0 = @{@"id":[NSString stringWithFormat:@"%@",[[quyuArr objectAtIndex:0] objectForKey:@"pid"]],@"name":key,@"pname":@"全城",@"pid":@"0"};
                        [quyuArr insertObject:dic0 atIndex:0];
                        for (NSDictionary *quDic in quyuArr) {
                            NSString * insertSql = [NSString stringWithFormat:
                                                    @"INSERT INTO QUYUCITYS (id, pid, name, pname) VALUES ('%ld','%ld','%@','%@')", (long)[[quDic objectForKey:@"id"] integerValue], (long)[[quDic objectForKey:@"pid"] integerValue], [NSString stringWithFormat:@"%@",[quDic objectForKey:@"name"]], [NSString stringWithFormat:@"%@",[quDic objectForKey:@"pname"]]];
                            [db executeUpdate:insertSql];
                            
                        }
                    }
                }
                [db close];
                
                
            });
        }
        success(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        success(NO);
        [db close];
    }];
}


//取出所有的城市
+ (NSArray *) getAllCityPlaces
{
    NSMutableArray *placeOriArr = [[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyQuyuDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS QUYUCITYS (id integer  primary key,pid integer, name text, pname text)"];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM QUYUCITYS WHERE pid = '0'"];
        NSLog(@"%d",s.columnCount);
        while ([s next]) {
            NSMutableDictionary *placeDic = [[NSMutableDictionary alloc]init];
            [placeDic setObject:[NSString stringWithFormat:@"%d",[s intForColumn:@"id"]] forKey:@"id"];
            [placeDic setObject:[NSString stringWithFormat:@"%d",[s intForColumn:@"pid"]] forKey:@"pid"];
            [placeDic setObject:[NSString stringWithFormat:@"%@",[s stringForColumn:@"name"]] forKey:@"name"];
            [placeDic setObject:[NSString stringWithFormat:@"%@",[s stringForColumn:@"pname"]] forKey:@"pname"];
            [placeOriArr addObject:placeDic];
        }
        [db close];
    }
    
    
    NSLog(@"%@",placeOriArr);

    return placeOriArr;
}

//取出当前城市id对应的所有区县
+ (NSArray *)getAllQuyuByCityId:(NSInteger)cityId
{
    NSMutableArray *placeOriArr = [[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyQuyuDatabase.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS QUYUCITYS (id integer  primary key,pid integer, name text, pname text)"];
    if ([db open]) {
        NSString *sqlStr0 = [NSString stringWithFormat:@"SELECT * FROM QUYUCITYS WHERE id = '%d'",cityId];
        FMResultSet *s0 = [db executeQuery:sqlStr0];
        NSLog(@"%d",s0.columnCount);
        while ([s0 next]) {
            if ([s0 intForColumn:@"pid"] != 0) {//父ID不为0，说明此时id为区id,转换成城市id
                cityId = [s0 intForColumn:@"pid"];
            }
        }
 
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM QUYUCITYS WHERE pid = '%d'",cityId];
        FMResultSet *s = [db executeQuery:sqlStr];
        NSLog(@"%d",s.columnCount);
        while ([s next]) {
            NSMutableDictionary *placeDic = [[NSMutableDictionary alloc]init];
            [placeDic setObject:[NSString stringWithFormat:@"%d",[s intForColumn:@"id"]] forKey:@"id"];
            [placeDic setObject:[NSString stringWithFormat:@"%d",[s intForColumn:@"pid"]] forKey:@"pid"];
            [placeDic setObject:[NSString stringWithFormat:@"%@",[s stringForColumn:@"name"]] forKey:@"name"];
            [placeDic setObject:[NSString stringWithFormat:@"%@",[s stringForColumn:@"pname"]] forKey:@"pname"];
            [placeOriArr addObject:placeDic];
        }
        NSString *sqlStr1 = [NSString stringWithFormat:@"SELECT * FROM QUYUCITYS WHERE id = '%d'",cityId];
        FMResultSet *s1 = [db executeQuery:sqlStr1];
        NSLog(@"%d",s1.columnCount);
        while ([s1 next]) {
            NSMutableDictionary *placeDic = [[NSMutableDictionary alloc]init];
            [placeDic setObject:[NSString stringWithFormat:@"%d",[s1 intForColumn:@"id"]] forKey:@"id"];
            [placeDic setObject:[NSString stringWithFormat:@"%d",[s1 intForColumn:@"pid"]] forKey:@"pid"];
            [placeDic setObject:[NSString stringWithFormat:@"%@",[s1 stringForColumn:@"name"]] forKey:@"name"];
            [placeDic setObject:[NSString stringWithFormat:@"%@",[s1 stringForColumn:@"pname"]] forKey:@"pname"];
            [placeOriArr insertObject:placeDic atIndex:0];
        }

        [db close];
    }
    return placeOriArr;
}

#pragma zhiying

//当前直营城市字典
+ (NSDictionary *)getCurrentZhiyingCityDic
{
    NSMutableArray *marr = [FileOperation getobjectForKey:kRecentlyZhiyingCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
//    if (marr == nil || marr.count == 0) {
////        return @{@"id":@"2704",@"pid":@"321",@"name":@"闸北区",@"pname":@"上海"};
//        return @{@"id":@"321",@"pid":@"0",@"name":@"上海",@"pname":@"全城"};
//    }
    return [marr objectAtIndex:0];
}

//存储记录
+ (void)writeCurrentCityWithCityDic:(NSDictionary *)cityDic
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self getRecentlyZhiyingCitys]];
    
    for (int j = 0; j< arr.count; j++) {
        if ([[[arr objectAtIndex:j] objectForKey:@"id"] integerValue] == [[cityDic objectForKey:@"id"] integerValue]) {
            [arr removeObjectAtIndex:j];
        }
    }
    
    if (arr.count >= 4) {
        for (int i = 0; i < arr.count-4 + 1; i++) {
            [arr removeObjectAtIndex:3+i];
        }
    }
    [arr insertObject:cityDic atIndex:0];
    [self setPlistObject:arr forKey:kRecentlyZhiyingCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
}
//获取最近zhiying城市记录
+ (NSArray *)getRecentlyZhiyingCitys
{
    NSMutableArray *marr = [FileOperation getobjectForKey:kRecentlyZhiyingCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
    //    NSLog(@"marr = %@",marr);
    return marr;
}

//纪录选择的index
+ (NSInteger) selectCityIndex
{
    NSString *str = [self getobjectForKey:kSelectZhiyingIndex ofFilePath:[self creatPlistIfNotExist:SET_PLIST]];
    if (str == nil) {
        str = @"0";
    }
    return [str integerValue];
}

+ (void) writeSelectCityIndex:(NSInteger) index
{
    [self setPlistObject:[NSString stringWithFormat:@"%d",index] forKey:kSelectZhiyingIndex ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
}


@end
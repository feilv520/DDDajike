//
//  FileOperation.h
//  jibaobao
//
//  Created by dajike on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 文件操作类
 */

//plist文件名
#define SET_PLIST  @"set"
#define MESSAGE_PLIST  @"message" //消息


//key value
#define kIsLogin              @"isLogin"

//搜索历史纪录列表
#define kSearchHistoryList              @"searchHistoryList"

////当前所在城市  或定位城市
//#define kCurrentCity              @"currentCity"
////当前所在城市id  或定位城市
//#define kCurrentCityId              @"currentCityId"
//定位城市name
#define kDingweiCityName             @"dingweiCityName"
//定位城市id
#define kDingweiCityId              @"dingweiCityId"
//当前所在城市区县
#define kCurrentCityArr              @"currentCityArr"

//最近城市列表
#define kRecentlyCityArr              @"recentlyCityArr"
//selectView 当前选择 index
#define kSelectIndex              @"selectViewSelectIndex"

//最近浏览过的商品
#define kRecentlyGoodsIdArr         @"recentlyGoodsIdArr"

//deviceToken
#define kDeviceToken              @"deviceToken"
//经度
#define kLatitude              @"latitude"
//纬度
#define kLongitude              @"longitude"


#pragma -------
//未读取消息个数
#define kMessageNumber              @"messageNumber"
//消息列表
#define kMessageList              @"messageList"



#import <Foundation/Foundation.h>

@interface FileOperation : NSObject

//创建plist 文件
+ (NSString *) creatPlistIfNotExist:(NSString *)plistName;
//设置plist文件中的值
+ (void) setPlistObject:(id)object forKey:(NSString *)key ofFilePath:(NSString *)filePath;
//获取plist文件中的值
+ (id) getobjectForKey:(NSString *)key ofFilePath:(NSString *)filePath;
// 读取字典
+ (NSDictionary *)readFileToDictionary:(NSString *)filePath;

//写入
+ (void)writeToPlistFile:(NSString *)plistName withDic:(NSMutableDictionary *)dic;

//是否在登录状态
+(BOOL) isLogin;
//保存用户ID
+(void) saveUserId:(NSString *)userId;
//保存用户密码
+(void) savePassword:(NSString *)password;
//用户ID
+(NSString *)getUserId;
//用户密码
+(NSString *)getPassword;
//退出登录
+ (void)logOffOrlogOut;
//---------------------地区库处理------------------
//获取所有的地区库
+ (void) getAllPlaces:(void (^)(BOOL finish))success;
//取出所有的地区库
+ (NSArray *) getAllPlaces;
//获取所有一级地区
+ (NSArray *) getAllYijiPlaces;
//根据id获取下级地区
+ (NSArray *)getNextPlacesWithRegionId:(NSInteger)regionId;
////地区库添加拼音字段
//+ (void) addPinyinToPlaces:(void (^)(BOOL finish))success;
#pragma mark-------------------
#pragma mark-----------关于搜索历史纪录的处理------------------------
//获取本地存储的搜索历史记录
+ (NSArray *) getHistoryList;

//清除历史记录
+ (void) clearSearchHistory;
//存储历史记录
+ (void) writeSearchHistory:(NSString *)searchKey;
#pragma mark-------------------
#pragma mark-----------关于最近定位城市--------------------------
//根据当前城市id获取下级地区
+ (NSArray *)getNextPlacesByCurrentCityId:(NSString *)regionId;
//获取最近城市记录
+ (NSArray *)getRecentlyCitys;
//当前选择城市名称
+ (NSString *)getCurrentCityName;
//当前选择城市id
+ (NSString *)getCurrentCityId;
//存储记录
+ (void)writeCurrentCityWithCityName:(NSString *)cityName andCityId:(NSString *)cityId;

//获取定位城市
+(NSString *) getDingweiCityId;
+(NSString *) getDingweiCityName;
//存储当前定位城市
+ (void)writeDingweiCityWithCityName:(NSString *)cityName andCityId:(NSString *)cityId;

//纪录选择的index
+ (NSInteger) selectIndex;
+ (void) writeSelectIndex:(NSInteger) index;

#pragma mark ----------- 购物车  猜你喜欢 ----------------
+ (NSMutableArray *)getCurrentGoodsIdsArr;
//获得浏览过的商品Id 长字符串
+(NSString *)getCurrentGoodsIds;
+ (void)addGoodIdToCurrentGoodsIdsArr:(NSString *)goodId;

#pragma mark -----------  清除缓存  --------------------
//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath;
//文件夹大小
+ (float ) folderSizeAtPath:(NSString*) folderPath;
//清除缓存
+(void) clearCacheAtPath:(NSString *)cachePath;
#pragma mark -----------  推送的 deviceToken  --------------------
+(void) writeDeviceToken:(NSString *)deviceToken;
+ (NSString *) getDeviceToken;
#pragma mark -----------  定位的经纬度  --------------------
+(void) writeLatitude:(NSString *)latitude;
+ (NSString *) getLatitude;
+(void) writeLongitude:(NSString *)longitude;
+ (NSString *) getLongitude;
#pragma mark -----------  消息推送  --------------------
//写入一条消息
+(void) writeAMessage:(NSDictionary *)messageInfo;
//读取消息列表
+ (NSArray *) getMessageList;
//写入消息个数
+(void) writeMessageNum:(NSInteger)num;
//读取消息个数
+ (NSInteger) getMessageNum;
//清除消息列表
+ (void) clearMessageList;
@end

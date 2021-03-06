//
//  commonTools.h
//  ProManagInfo
//
//  Created by luhaixia on 14/11/5.
//  Copyright (c) 2014年 luhaixia. All rights reserved.
//

//一些基本的验证等相关封装函数
#import <Foundation/Foundation.h>


@interface commonTools : NSObject
+ (NSString *)getChars;
+(BOOL) isNetworkEnabled;
+ (BOOL) isEmpty:(NSString *) str;
+ (void)dialPhone:(NSString *)number;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isPhoneNum:(NSString *)phoneNum;
+ (BOOL)isValidPassword:(NSString *)pwd;
+ (BOOL)isValidEmail:(NSString *)email;
+ (BOOL)isValidIDCard:(NSString *)IDCard;
+ (BOOL)isValidPassport:(NSString *)Passport;

+ (NSString*)DataTOjsonString:(id)object;
+ (NSDate *)timestampTODate:(NSString *)timestamp;
+ (NSString *)timesToDate:(NSString *)string;
+ (NSString *)secondTimesToDate:(NSString *)string;
+ (NSString *)timeAndDateFromStamp:(NSString *)string;
//金额保留到小数点后两位
+ (NSString *)moneyTolayout:(NSString *)oldMoney;
+ (BOOL)isNull:(id)value;
//是否全为数字
+ (BOOL)isAllNum:(NSString *)string;
+ (BOOL) containsChinese:(NSString *)str;
//银行卡校验
+ (BOOL)isValidBankCardNumber:(NSString *)value;
//汉字姓名校验
+ (BOOL)isValidChanseName:(NSString *)value;
//+ (void)shareButtonClicked:(NSString *)content;
//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string;
//判断是否为浮点形：
//+ (BOOL)isPureFloat:(NSString*)string;  这个方法有点问题

//获取iOS设备的ip地址
//+ (NSString *)getIPAddress:(BOOL)preferIPv4;
//+ (NSDictionary *)getIPAddresses;
//内网ip
+ (void)getLANIPAddressWithCompletion:(void (^)(NSString *IPAddress))completion;
//外网ip
+ (void)getWANIPAddressWithCompletion:(void(^)(NSString *IPAddress))completion;
+ (NSString *) whatismyipdotcom;

//拼接图片的url
+ (NSURL *)getImgURL:(NSString *)urlStr;

// 银行卡检查(马成铭)
+(BOOL) checkCardNo:(NSString*) cardNo;
// 校验邮编
+ (BOOL) isValidZipcode:(NSString*)value;
// 手机号码校验
+ (BOOL) isValidPhone:(NSString*)value;
//+ (void) shareUM:(NSString *)content presentSnsIconSheetView:(UIViewController *)controller delegate:(id <UMSocialUIDelegate>)delegate;
@end

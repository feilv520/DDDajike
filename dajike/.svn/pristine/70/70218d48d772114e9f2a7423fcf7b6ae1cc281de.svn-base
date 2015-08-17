//
//  commonTools.m
//  ProManagInfo
//
//  Created by luhaixia on 14/11/5.
//  Copyright (c) 2014年 luhaixia. All rights reserved.
//

#import "commonTools.h"
#import "FileOperation.h"
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
//#import <ShareSDK/ShareSDK.h>
#import "defines.h"
#import "UIView+MyView.h"

#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"


#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@implementation commonTools


//生成随机字符串
+ (NSString *)getChars
{
    NSArray *changeArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    
    NSMutableString *getStr = [[NSMutableString alloc] initWithCapacity:11];
    NSMutableString *Str = [[NSMutableString alloc] initWithCapacity:11];
    
    NSMutableString  *changeString = [[NSMutableString alloc] initWithCapacity:12];
    NSMutableString *codeString = [[NSMutableString alloc] initWithCapacity:12];
    for(NSInteger i = 0; i < 10; i++)
    {
        NSInteger index = arc4random() % ([changeArray count] - 1);
        getStr = [changeArray objectAtIndex:index];
        char c = [getStr characterAtIndex:0];
        
        if (isupper(c) ) {
            //                    NSLog(@"getStr1 = %@",getStr);
            c = c+'a'-'A';
            Str = [NSMutableString stringWithFormat:@"%c",c];
        }else{
            //                    NSLog(@"getStr2 = %@",getStr);
            Str = [NSMutableString stringWithFormat:@"%c",c];
        }
        
        codeString = (NSMutableString *)[codeString stringByAppendingString:Str];
        changeString = (NSMutableString *)[changeString stringByAppendingString:getStr];
    }
    //    NSLog(@"changeString = %@",changeString);
    
    
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f",a];//转为字符型
    NSString *timeString1 = [timeString substringToIndex:(timeString.length-7)];
    
    NSString *sessionIdStr = [NSString stringWithFormat:@"%@%@",changeString,timeString1];
    return sessionIdStr;
}

//-判断当前网络是否可用
+(BOOL) isNetworkEnabled
{
    BOOL bEnabled = FALSE;
    NSString *url = @"www.baidu.com";
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [url UTF8String]);
    SCNetworkReachabilityFlags flags;
    
    bEnabled = SCNetworkReachabilityGetFlags(ref, &flags);
    
    CFRelease(ref);
    if (bEnabled) {
        //        kSCNetworkReachabilityFlagsReachable：能够连接网络
        //        kSCNetworkReachabilityFlagsConnectionRequired：能够连接网络，但是首先得建立连接过程
        //        kSCNetworkReachabilityFlagsIsWWAN：判断是否通过蜂窝网覆盖的连接，比如EDGE，GPRS或者目前的3G.主要是区别通过WiFi的连接。
        BOOL flagsReachable = ((flags & kSCNetworkFlagsReachable) != 0);
        BOOL connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
        BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
        bEnabled = ((flagsReachable && !connectionRequired) || nonWiFi) ? YES : NO;
    }
    
    return bEnabled;
}

//判断字符串是否为空
+(BOOL) isEmpty:(NSString *) str
{
    if (!str) {
        return YES;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

//打电话
+ (void)dialPhone:(NSString *)number
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]];
    [[UIApplication sharedApplication] openURL:url];
}

//校验手机号的格式是否正确
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if ([regextestMobile evaluateWithObject:mobileNum] == YES){
        return YES;
    }
    else {
        return NO;
    }
}
//电话号码校验
+ (BOOL)isPhoneNum:(NSString *)phoneNum
{
    NSString *phone = @"^(\\d{3,4}-)\\d{7,8}$";
    NSPredicate *regextestPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phone];
    return [regextestPhone evaluateWithObject:phoneNum];
}

//校验密码输入格式
+ (BOOL)isValidPassword:(NSString *)pwd
{
    NSString * regex = @"^[A-Za-z0-9]{6,18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:pwd];
    return isMatch;
}

//校验邮箱格式
+ (BOOL)isValidEmail:(NSString *)email
{
    NSString * regex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:email];
    return isMatch;
}

//身份证
+ (BOOL)isValidIDCard:(NSString *)IDCard
{
    NSString * regex;
    if (IDCard.length == 15) {
        regex = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
    }
    if (IDCard.length == 18) {
        regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{4}$";
    }
    //    NSString * regex = @"[1-9]\\d{7}((0\\d)|(1[0-2]))([0|1|2]\\d|3[0-1])\\d{3}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:IDCard];
    return isMatch;
}

//校验护照格式
+ (BOOL)isValidPassport:(NSString *)Passport
{
    NSString * regex = @"^1[45][0-9]{7}|G[0-9]{8}|P[0-9]{7}|S[0-9]{7,8}|D[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:Passport];
    return isMatch;
}

//data转jsonString
+ (NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = @"";
    
    if (object) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        if (! jsonData) {
//            NSLog(@"Got an error: %@", error);
        } else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    
    return jsonString;
}

//字符串转日期
+ (NSDate *)timestampTODate:(NSString *)string
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:string];
//    NSLog(@"date1:%@",date);
    
    return date;
}

//转日期格式yyyy-MM-dd
+ (NSString *)timesToDate:(NSString *)string
{
    NSDate *orderDate;
    if (string.length >10) {
        orderDate = [NSDate dateWithTimeIntervalSince1970:[string doubleValue]/1000.0];
    }else{
        orderDate = [NSDate dateWithTimeIntervalSince1970:[string longLongValue]];
    }
//      NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:1433135750935/1000.0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:orderDate];
    return dateString;
}

//转时间格式hh:mm:ss
+ (NSString *)secondTimesToDate:(NSString *)string
{
    //    NSString *str = [NSString stringWithFormat:@"%@",[self.orderDetailInfoDic objectForKey:@"time"]];
    NSDate *orderDate;
    if (string.length >10) {
        orderDate = [NSDate dateWithTimeIntervalSince1970:[string longLongValue]/1000.0];
    }else{
        orderDate = [NSDate dateWithTimeIntervalSince1970:[string longLongValue]];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:orderDate];
    return dateString;
}

//转日期+时间 yyyy-MM-dd  hh:mm:ss
+ (NSString *)timeAndDateFromStamp:(NSString *)string
{
    NSDate *orderDate;
    if (string.length >10) {
        orderDate = [NSDate dateWithTimeIntervalSince1970:[string longLongValue]/1000.0];
    }else{
        orderDate = [NSDate dateWithTimeIntervalSince1970:[string longLongValue]];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:orderDate];
    return dateString;
    
}

//金额保留到小数点后两位
+ (NSString *)moneyTolayout:(NSString *)oldMoney
{
    CGFloat oldm = [oldMoney floatValue];
    return [NSString stringWithFormat:@"%.2f",oldm];
}

//判断是否为null,nil,字符串"<null>"类型  这些都是服务器端可能返回的数据类型，判空专用
+ (BOOL)isNull:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return value == nil || [value isEqual:[NSNull null]] || [value isEqualToString:@"<null>"] || [self isEmpty:value] || [value isEqualToString:@"null"];
    }
    return value == nil || [value isEqual:[NSNull null]];
}

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

//+ (BOOL)isPureFloat:(NSString*)string{
//    NSScanner* scan = [NSScanner scannerWithString:string];
//    float val;
//    return[scan scanFloat:&val] && [scan isAtEnd];
//}

//是否包含汉字、数字、字母,判断特殊字符
+ (BOOL) containsChinese:(NSString *)str
{
    for(int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if( (a<0x0030)||(a >= 0x9fff)||(a > 0x0039 && a < 0x0041)||(a > 0x005a && a < 0x0061)||(a > 0x007a && a <= 0x4e00)){
            return FALSE;
        }
    }
    return TRUE;
}

//是否全为数字
+ (BOOL)isAllNum:(NSString *)string
{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}


// 银行卡检查(马成铭)
+(BOOL) checkCardNo:(NSString*) cardNo{
    int sum = 0;
    int len = [cardNo length];
    int i = 0;
    
    while (i < len) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(len - 1 - i, 1)];
        int tmpVal = [tmpString intValue];
        if (i % 2 != 0) {
            tmpVal *= 2;
            if(tmpVal>=10) {
                tmpVal -= 9;
            }
        }
        sum += tmpVal;
        i++;
    }
    
    if((sum % 10) == 0)
        return YES;
    else
        return NO;
}
//银行卡校验
+ (BOOL)isValidBankCardNumber:(NSString *)value
{
    NSString * regex = @"^(998801|998802|622525|622526|435744|435745|483536|528020|526855|622156|622155|356869|531659|622157|627066|627067|627068|627069)\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:value];
    return isMatch;
    
    
//    int oddsum = 0;
//    int evensum = 0;
//    int allsum = 0;
//    
//    for (int i = 0; i< [value length];i++) {
//        NSString *tmpString = [value substringWithRange:NSMakeRange(i, 1)];
//        int tmpVal = [tmpString intValue];
//        if((i % 2) == 0){
//            tmpVal *= 2;
//            if(tmpVal>=10)
//                tmpVal -= 9;
//            evensum += tmpVal;
//        }else{
//            oddsum += tmpVal;
//            
//        }
//    }
//    
//    allsum = oddsum + evensum;
//    
//    if((allsum % 10) == 0)
//        return YES;
//    else
//        return NO;
    
    
    
//    BOOL result = NO;
//    NSInteger length = [value length];
//    if (length >= 13) {
//        result = [WTCreditCard isValidNumber:value];
//        if (result)
//        {
//            NSInteger twoDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 2)] integerValue];
//            //VISA
//            if([WTCreditCard isStartWith:value Str:@"4"]) {
//                if (13 == length||16 == length) {
//                    result = TRUE;
//                }else {
//                    result = NO;
//                }
//            }
//            //MasterCard
//            else if(twoDigitBeginValue >= 51 && twoDigitBeginValue <= 55 && length == 16) {
//                result = TRUE;
//            }
//            //American Express
//            else if(([WTCreditCard isStartWith:value Str:@"34"]||[WTCreditCard isStartWith:value Str:@"37"]) && length == 15){
//                result = TRUE;
//            }
//            //Discover
//            else if([WTCreditCard isStartWith:value Str:@"6011"] && length == 16) {
//                result = TRUE;
//            }else {
//                result = FALSE;
//            }
//        }
//        if (result)
//        {
//            NSInteger digitValue;
//            NSInteger checkSum = 0;
//            NSInteger index = 0;
//            NSInteger leftIndex;
//            //even length, odd index
//            if (0 == length%2) {
//                index = 0;
//                leftIndex = 1;
//            }
//            //odd length, even index
//            else {
//                index = 1;
//                leftIndex = 0;
//            }
//            while (index < length) {
//                digitValue = [[value substringWithRange:NSMakeRange(index, 1)] integerValue];
//                digitValue = digitValue*2;
//                if (digitValue >= 10)
//                {
//                    checkSum += digitValue/10 + digitValue%10;
//                }
//                else
//                {
//                    checkSum += digitValue;
//                }
//                digitValue = [[value substringWithRange:NSMakeRange(leftIndex, 1)] integerValue];
//                checkSum += digitValue;
//                index += 2;
//                leftIndex += 2;
//            }
//            result = (0 == checkSum%10) ? TRUE:FALSE;
//        }
//    }else {
//        result = NO;
//    }
//    return result;

}

//汉字姓名校验
+ (BOOL)isValidChanseName:(NSString *)value
{
    NSString * regex = @"^([\\u4e00-\\u9fa5]+|([a-z]+\\s?)+)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:value];
    return isMatch;
}

//拼接图片Url
+ (NSURL *)getImgURL:(NSString *)urlStr
{
//    NSDictionary *mDic = [FileOperation readFileToDictionary:SET_PLIST];
//    NSString *imgDomainURLstr = [mDic objectForKey:@"image_domain"];
//    NSString *imgURLstr = [NSString stringWithFormat:@"%@/%@",imgDomainURLstr,urlStr];
//    NSURL *imgURL = [NSURL URLWithString:imgURLstr];
    if ([commonTools isNull:urlStr]) {
        return nil;
    }
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *imgURL = [NSURL URLWithString:urlStr];
    return imgURL;
}

//校验邮编 (mc)
+ (BOOL) isValidZipcode:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    unsigned long len = strlen(cvalue);
    if (len != 6) {
        return FALSE;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return FALSE;
        }
    }
    return TRUE;
}

// 手机号码校验 (mc)
+ (BOOL) isValidPhone:(NSString*)value {
    if (value.length != 11) {
        return FALSE;
    }
    if (![commonTools isMobileNumber:value])
    {
        return FALSE;
    }
    NSString *preString = [[NSString stringWithFormat:@"%@",value] substringToIndex:2];
    if ([preString isEqualToString:@"13"] ||
        [preString isEqualToString: @"15"] ||
        [preString isEqualToString: @"18"])
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    return TRUE;
}

/*   ***********************************************************************************
 
                       获取iOS 各种ip地址  参数传YES   [self getIPAddress:YES]
 
*********************************************************************************** */

//+ (NSString *)getIPAddress:(BOOL)preferIPv4
//{
//    NSArray *searchArray = preferIPv4 ?
//    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
//    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
//    
//    NSDictionary *addresses = [self getIPAddresses];
//    NSLog(@"addresses: %@", addresses);
//    
//    __block NSString *address;
//    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
//     {
//         address = addresses[key];
//         if(address) *stop = YES;
//     } ];
//    return address ? address : @"0.0.0.0";
//}
//
//+ (NSDictionary *)getIPAddresses
//{
//    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
//    
//    // retrieve the current interfaces - returns 0 on success
//    struct ifaddrs *interfaces;
//    if(!getifaddrs(&interfaces)) {
//        // Loop through linked list of interfaces
//        struct ifaddrs *interface;
//        for(interface=interfaces; interface; interface=interface->ifa_next) {
//            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
//                continue; // deeply nested code harder to read
//            }
//            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
//            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
//            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
//                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
//                NSString *type;
//                if(addr->sin_family == AF_INET) {
//                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
//                        type = IP_ADDR_IPv4;
//                    }
//                } else {
//                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
//                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
//                        type = IP_ADDR_IPv6;
//                    }
//                }
//                if(type) {
//                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
//                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
//                }
//            }
//        }
//        // Free memory
//        freeifaddrs(interfaces);
//    }
//    return [addresses count] ? addresses : nil;
//}
+ (void)getLANIPAddressWithCompletion:(void (^)(NSString *IPAddress))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *IP = [self getIPAddress];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(IP);
            }
        });
    });
}

+ (void)getWANIPAddressWithCompletion:(void(^)(NSString *IPAddress))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *IP = @"0.0.0.0";
        NSURL *url = [NSURL URLWithString:@"http://ifconfig.me/ip"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:8.0];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"Failed to get WAN IP Address!\n%@", error);
            [[[UIAlertView alloc] initWithTitle:@"获取外网 IP 地址失败" message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            IP = responseStr;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(IP);
        });
    });
}

#pragma mark -
// http://zachwaugh.me/posts/programmatically-retrieving-ip-address-of-iphone/
+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
+ (NSString *) whatismyipdotcom
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://www.whatismyip.com/automation/n09230945.asp"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:1 error:&error];
    return ip ? ip : [error localizedDescription];
}



/*   ***********************************************************************************
                             END
 *********************************************************************************** */


/*
 * 常用信用卡卡号规则
 * Issuer Identifier  Card Number                            Length
 * Diner's Club       300xxx-305xxx, 3095xx, 36xxxx, 38xxxx  14
 * American Express   34xxxx, 37xxxx                         15
 * VISA               4xxxxx                                 13, 16
 * MasterCard         51xxxx-55xxxx                          16
 * JCB                3528xx-358xxx                          16
 * Discover           6011xx                                 16
 * 银联                622126-622925                          16
 *
 * 信用卡号验证基本算法：
 * 偶数位卡号奇数位上数字*2，奇数位卡号偶数位上数字*2。
 * 大于10的位数减9。
 * 全部数字加起来。
 * 结果不是10的倍数的卡号非法。
 * prefrences link:http://www.truevue.org/licai/credit-card-no
 *
 */


//+ (void)shareButtonClicked:(NSString *)content
//{
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
//    
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:content
//                                       defaultContent:@"默认分享内容"
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:@"为为旅游"
//                                                  url:@"http://www.sharesdk.cn"
//                                          description:content
//                                            mediaType:SSPublishContentMediaTypeNews];
//    
//    [ShareSDK showShareActionSheet:nil
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions: nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                if (state == SSResponseStateSuccess)
//                                {
////                                    NSLog(@"分享成功");
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
////                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//                                }
//                            }];
//}


/*
+ (void) shareUM:(NSString *)content presentSnsIconSheetView:(UIViewController *)controller delegate:(id <UMSocialUIDelegate>)delegate
{
    //自定义友盟分享面板
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = Color_bg;
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    UIView *rootView = topController.view;
    backView.frame = rootView.bounds;
    [rootView addSubview:backView];
    [rootView bringSubviewToFront:backView];
    
    UIView *actionView = [[UIView alloc]initWithFrame:CGRectMake(0, rootView.bounds.size.height, rootView.bounds.size.width, 210)];
    actionView.backgroundColor = Color_White;
    
    for (int i = 0; i < 6; i++) {
//        UIImageView *imageV = [[UIImageView alloc]createImageViewWithFrame:CGRectMake(20+(i%3)*100, (i/3)*100, 60, 60) andImageName:[UIImage imageNamed:@"1"]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(18+(i%3)*115, 12+(i/3)*75, 53, 45)];
        [imageView setImage:[UIImage imageNamed:@"1"]];
        
        [actionView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]creatLabelWithFrame:CGRectMake(18+(i%3)*115, 57+(i/3)*75, 53, 30) AndFont:14 AndBackgroundColor:Color_Clear AndText:@"朋友圈" AndTextAlignment:NSTextAlignmentCenter AndTextColor:Color_Black andCornerRadius:0];
        [actionView addSubview:label];
        
        UIButton *btn = [[UIButton alloc]createButtonWithFrame:CGRectMake(18+(i%3)*115, 12+(i/3)*75, 53, 83) andBackImageName:nil andTarget:self andAction:@selector(toShareBtn:) andTitle:nil andTag:i+100];
        [actionView addSubview:btn];
    }
    
    [backView addSubview:actionView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 160, topController.view.bounds.size.width, 1)];
    line.backgroundColor = Color_mainColor;
    [actionView addSubview:line];
    
    UIButton *cancleBtn = [[UIButton alloc]createButtonWithFrame:CGRectMake(0, 161, topController.view.bounds.size.width, 47) andBackImageName:nil andTarget:self andAction:@selector(toCancleBtn:) andTitle:nil andTag:300];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:Color_mainColor forState:UIControlStateNormal];
    [actionView addSubview:cancleBtn];
    
    
    [UIView animateWithDuration:0.8 animations:^{
        CGRect frame = actionView.frame;
        frame.origin.y = actionView.frame.origin.y-210;
        [actionView setFrame:frame];
    }];
    
//    [UIView animateWithDuration:0.2 animations:^{
//        backView.alpha = 1.0f;
//        backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);}
//                     completion:^(BOOL finished) {
//                         
//                         [UIView animateWithDuration:0.12 animations:^{
//                             backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);} completion:^(BOOL finished) {
//                                 
//                                 [UIView animateWithDuration:0.12 animations:^{
//                                     backView.transform = CGAffineTransformIdentity;
//                                 } completion:^(BOOL finished) {
//                                     NSLog(@"hello");
//                                     
//                                 }];
//                             }];
//                     }];
    
    
    
    
//    UMSocialSnsPlatform *sinaPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"UMCOPYLink"];
//    sinaPlatform.bigImageName = @"1";
//    sinaPlatform.displayName = @"微博";
//    sinaPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
//        NSLog(@"点击新浪微博的响应");
//    };
//    
  
    
    
    /*
    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"1"];          //分享内嵌图片
    
    //调用快速分享接口
    NSArray *arr = [NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToEmail,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,@"UMCOPYLink", nil];
//     NSArray *arr = [NSArray arrayWithObjects:@"UMCOPYLink",@"UMCOPYLink1",@"UMCOPYLink2",@"UMCOPYLink3", nil];
    
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:UmengAppkey
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:arr
                                       delegate:delegate];
 

}
- (void)toShareBtn:(id)sender
{
    
}
- (void)toCancleBtn:(id)sender
{
    
}
*/



@end

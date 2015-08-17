//
//  dDefine.h
//  dajike
//
//  Created by dajike on 15/7/7.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#ifndef dajike_dDefine_h
#define dajike_dDefine_h
//用户信息文件名
#define dajikeUser @"userInfo"

#define APP_TYPE(a) a==0? 0:1
//判定系统版本
#define DIOSVersion [[UIDevice currentDevice].systemVersion doubleValue]
#define DIS_IOS6 [[[UIDevice currentDevice] systemVersion] floatValue]<7.0
#define DIS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0

#define DWIDTH_VIEW_DEFAULT   self.frame.size.width
#define DHEIGHT_VIEW_DEFAULT   self.frame.size.height
#define DWIDTH_CONTROLLER_DEFAULT   [[UIScreen mainScreen] applicationFrame].size.width
#define DHEIGHT_CONTROLLER_DEFAULT   ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?[[UIScreen mainScreen] applicationFrame].size.height+20:[[UIScreen mainScreen] applicationFrame].size.height)
//判断是否6plus 键盘高度不一样
#define DiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

//返回按钮
#define DimageNavBack @"img_pub_02"

//高度
#define DHeight_mainBtn_H   30.0   //下一步

//默认 设置
//字体
////*******************细*************
//#define DFont_9 [UIFont fontWithName:@"HiraKakuProN-W3" size:9]
//#define DFont_13 [UIFont fontWithName:@"HiraKakuProN-W3" size:13]
//#define DFont_12 [UIFont fontWithName:@"HiraKakuProN-W3" size:12]
//#define DFont_11 [UIFont fontWithName:@"HiraKakuProN-W3" size:11]
//#define DFont_10 [UIFont fontWithName:@"HiraKakuProN-W3" size:10]
//#define DFont_14 [UIFont fontWithName:@"HiraKakuProN-W3" size:14]
//#define DFont_15 [UIFont fontWithName:@"HiraKakuProN-W3" size:15]
//#define DFont_Nav [UIFont fontWithName:@"HiraKakuProN-W3" size:18] //navBar标题字体
//
////*******************粗*************
//#define DFont_9b [UIFont fontWithName:@"Copperplate-Bold" size:9]
//#define DFont_13b [UIFont fontWithName:@"Copperplate-Bold" size:13]
//#define DFont_12b [UIFont fontWithName:@"Copperplate-Bold" size:12]
//#define DFont_11b [UIFont fontWithName:@"Copperplate-Bold" size:11]
//#define DFont_10b [UIFont fontWithName:@"Copperplate-Bold" size:10]
//#define DFont_14b [UIFont fontWithName:@"Copperplate-Bold" size:14]
//#define DFont_15b [UIFont fontWithName:@"Copperplate-Bold" size:15]
//#define DFont_Navb [UIFont fontWithName:@"Copperplate-Bold" size:18] //navBar标题字体

//*******************细*************
#define DFont_9 [UIFont fontWithName:@"ArialMT" size:9]
#define DFont_13 [UIFont fontWithName:@"ArialMT" size:13]
#define DFont_12 [UIFont fontWithName:@"ArialMT" size:12]
#define DFont_11 [UIFont fontWithName:@"ArialMT" size:11]
#define DFont_10 [UIFont fontWithName:@"ArialMT" size:10]
#define DFont_14 [UIFont fontWithName:@"ArialMT" size:14]
#define DFont_15 [UIFont fontWithName:@"ArialMT" size:15]
#define DFont_Nav [UIFont fontWithName:@"ArialMT" size:18] //navBar标题字体

//*******************粗*************
#define DFont_9b [UIFont fontWithName:@"Arial-BoldMT" size:9]
#define DFont_13b [UIFont fontWithName:@"Arial-BoldMT" size:13]
#define DFont_12b [UIFont fontWithName:@"Arial-BoldMT" size:12]
#define DFont_11b [UIFont fontWithName:@"Arial-BoldMT" size:11]
#define DFont_10b [UIFont fontWithName:@"Arial-BoldMT" size:10]
#define DFont_14b [UIFont fontWithName:@"Arial-BoldMT" size:14]
#define DFont_15b [UIFont fontWithName:@"Arial-BoldMT" size:15]
#define DFont_Navb [UIFont fontWithName:@"Arial-BoldMT" size:18] //navBar标题字体

//状态栏
#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
//tabBar高度
#define TabBarHeight                        49.0f
//导航栏高度
#define NaviBarHeight                       44.0f
#define ViewCtrlTopBarHeight                (DIS_IOS7 ? (NaviBarHeight + StatusBarHeight) : NaviBarHeight)
#define IsUseIOS7SystemSwipeGoBack          (DIS_IOS7 ? YES : NO)


#define DFont_Btn_Nav [UIFont systemFontOfSize:15.0f] //navBar标题字体
//颜色
#define DColor_Black [UIColor blackColor]
#define DColor_White  [UIColor whiteColor]
#define DColor_Clear  [UIColor clearColor]


#define DColor_tabbarTextW [UIColor whiteColor]  //tabbar字体白色
#define DColor_tabbarbg [UIColor blackColor]  //tabbar背景黑色
#define DBackColor_mine [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0]
//大集客主题红色
#define DColor_mainRed [UIColor colorWithRed:196/255.0 green:41/255.0 blue:31/255.0 alpha:1] //c4291f
//蒙板颜色
#define DColor_mengban   [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]//

//
#define DRect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define DSize(w, h)                          CGSizeMake(w, h)
#define DRGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// assert
#ifdef ENABLE_ASSERT_STOP
#define APP_ASSERT_STOP                     {LogRed(@"APP_ASSERT_STOP"); NSAssert1(NO, @" \n\n\n===== APP Assert. =====\n%s\n\n\n", __PRETTY_FUNCTION__);}
#define APP_ASSERT(condition)               {NSAssert(condition, @" ! Assert");}
#else
#define APP_ASSERT_STOP                     do {} while (0);
#define APP_ASSERT(condition)               do {} while (0);
#endif


#define DColor_dadada   [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1]
#define DColor_b9b9b9   [UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1]//b9b9b9
#define DColor_ffffff   [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]//ffffff
#define DColor_808080   [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1]//808080
#define DColor_f3f3f3   [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]//f3f3f3
#define DColor_b2b2b2   [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1]//b2b2b2
#define DColor_a0a0a0   [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1]//a0a0a0  底部蒙板
#define DColor_f69a2b   [UIColor colorWithRed:246/255.0 green:154/255.0 blue:43/255.0 alpha:1]//f69a2b
#define DColor_666666   [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]//666666
#define DColor_000000   [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]//000000
#define DColor_999999   [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]//999999
#define DColor_252525   [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1]//252525
#define DColor_f6f1ef   [UIColor colorWithRed:246/255.0 green:241/255.0 blue:239/255.0 alpha:1]//f6f1ef
#define DColor_cccccc   [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]//cccccc
//#define DColor_kkk999   [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]//kkk999
#define DColor_b2b1b1   [UIColor colorWithRed:178/255.0 green:177/255.0 blue:177/255.0 alpha:1]//b2b1b1
#define DColor_c9c9c9   [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1]//c9c9c9
#define DColor_f7f7f7   [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]//f7f7f7
#define DColor_c4291f   DRGBA(196, 41, 31, 1)
//分割线灰色
#define DColor_line_bg   [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1]

//字体灰色
#define DColor_word_bg   [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1]

//灰色背景
#define DColor_bg   [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]
//主题灰色4
#define DColor_gray4   [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1]
//主题红色
#define DColor_mainColor   [UIColor colorWithRed:203/255.0 green:20/255.0 blue:72/255.0 alpha:1]

//常用方法
#define push(VC)    [self.navigationController pushViewController:VC animated:YES]
#define pop()       [self.navigationController popViewControllerAnimated:YES]
#define showMessage(msg)    [ProgressHUD showMessage:msg Width:100 High:80]
//注册cell
#define registerNib(NibName,identifierCell)   [self.dMainTableView registerNib:[UINib nibWithNibName:NibName bundle:nil] forCellReuseIdentifier:identifierCell]
//获取userId
#define get_userId [FileOperation getUserId]
//#define get_userId @"2"

//默认代替图片
#define DImagePlaceholderImage  @"smallPlaceImage.png"  //1:1
#define DImagePlaceholderImage_Big  @"bigPlaceImage.png" //2:1
#define DImagePlaceholderImage_5_2  @"bigPlaceImage.png"  //5:2
#define DPlaceholderImage  [UIImage imageNamed:@"smallPlaceImage.png"]  //1:1
#define DPlaceholderImage_Big  [UIImage imageNamed:@"bigPlaceImage.png"]  //2:1
#define DPlaceholderImage_5_2  [UIImage imageNamed:@"bigPlaceImage.png"]  //5:2

//******************** 常用头文件 ********************************
//***********************************************************

#import "DBaseNavView.h"//自定义导航条
#import "DImgButton.h"
#import "DBaseNavView.h"
#import "UtilityFunc.h"//工具
#import "commonTools.h"
#import "DTools.h"
#import "DES3Util.h"
#import "UIView+MyView.h"
#import "ProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "DMyAfHTTPClient.h" //网络请求数据
#import "UIImageView+AFNetworking.h" //图片加载
#import "JsonStringTransfer.h" //转换工具
#import "FileOperation.h"           //文件操作类
#import "AnalysisData.h"

#endif

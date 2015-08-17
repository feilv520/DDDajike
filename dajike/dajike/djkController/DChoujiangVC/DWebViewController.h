//
//  DWebViewController.h
//  dajike
//
//  Created by dajike on 15/7/15.
//  Copyright (c) 2015年 haixia. All rights reserved.
//
/*
 帮助中心
 关于我们
 用户协议
 特别声明
 */
#import "DBackNavigationViewController.h"
typedef enum {
    CHOU_SHU_DE,
    IS_NEED_ADD,
}isNeedAddType;

typedef enum {//进入店铺
    SJ,       //默认商家首页
    JIFEN,   //积分首页
}SJ_JF;

@interface DWebViewController : DBackNavigationViewController
@property (assign, nonatomic) NSInteger isHelp;//help_center:1      aboun us:2  大集客用户协议公告:3  特别声明:4  抽奖规则:5 商家详情:6   物流:7
@property (assign, nonatomic) isNeedAddType type;
@property (strong, nonatomic) NSString *urlStr;
@property (strong, nonatomic) NSString *goodId;
@property (assign, nonatomic) SJ_JF sjORjf;

//商品详情分享用
@property (strong, nonatomic) NSString *googsTitle;//title
@property (strong, nonatomic) NSString *imageUrl;//imageUrl
@end

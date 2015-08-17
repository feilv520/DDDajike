//
//  UserInfoModel.h
//  jibaobao
//
//  Created by swb on 15/5/22.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
 ***  会员信息类(MyUserInfos.index)
 */

#import <Foundation/Foundation.h>


@interface UserInfoModel : NSObject

@property (strong, nonatomic) NSString      *userId;        //会员Id

@property (strong, nonatomic) NSString      *userName;      //会员名

@property (strong, nonatomic) NSString      *email;         //会员邮箱

@property (strong, nonatomic) NSString      *emailCode;     //

@property (strong, nonatomic) NSString      *password;      //用户登录密码

@property (strong, nonatomic) NSString      *password2;     //大集客支付密码

@property (strong, nonatomic) NSString      *realName;      //真实姓名

@property (strong, nonatomic) NSString      *gender;        //性别

@property (strong, nonatomic) NSString      *phoneTel;

@property (strong, nonatomic) NSString      *phoneMob;      //手机号

@property (strong, nonatomic) NSString      *imQq;

@property (strong, nonatomic) NSString      *regTime;       //注册时间 时间戳格式

@property (strong, nonatomic) NSString      *lastLogin;     //最后登录时间 时间戳格式

@property (strong, nonatomic) NSString      *lastIp;        //最后登录IP地址

@property (strong, nonatomic) NSString      *portrait;      //会员头像地址

@property (strong, nonatomic) NSString      *memberType;    //类型01:会员,02:服务中心,03服务中心子账号,04采购

@property (strong, nonatomic) NSString      *status;        //会员状态: 0待激活,1待审核,2正常,3冻结

@property (strong, nonatomic) NSString      *dropState;     // 是否删除 0已删除,1未删除

@property (strong, nonatomic) NSString      *emailActiveCode;           //邮箱验证码

@property (strong, nonatomic) NSString      *phoneMobBindStatus;        //手机号是否绑定  0为否 1为是

@property (strong, nonatomic) NSString      *emailBindStatus;           //邮箱是否绑定 0为否 1为是

@property (strong, nonatomic) NSString      *nickName;      //用户昵称

@property (strong, nonatomic) NSString      *spreaderType;  //是否开通集客小店 1为是 0为否

@property (strong, nonatomic) NSString      *shopName;      //集客小店名称

@property (strong, nonatomic) NSString      *bankCount;      //绑定的银行卡总数

@property (strong, nonatomic) NSString      *couponCount;     //优惠券总数

@property (strong, nonatomic) NSString      *collectCount;    //收藏总数

@property (strong, nonatomic) NSString      *goodsCount;      //收藏商品总数

@property (strong, nonatomic) NSString      *storeCount;      //收藏商家总数

@property (strong, nonatomic) NSString      *friendCount;     //我的好友总数

@property (strong, nonatomic) NSString      *cartCount;       //购物车总数

@end

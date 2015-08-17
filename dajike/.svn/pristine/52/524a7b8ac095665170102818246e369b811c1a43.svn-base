//
//  AccountDetailModel.h
//  jibaobao
//
//  Created by dajike on 15/5/27.
//  Copyright (c) 2015年 dajike. All rights reserved.
//
/*
 账户明细model
 */
/*
 收益账户
 "id":160992,
 "userId":2,                                     //用户id
 "jine":20.0000,                                 //变动金额，加为正数，减为负数
 "beizhu":"取消订单 150511202441268501 ，退回已支付的 20.00 元到收益账户_订单类型为mobile！",  //备注
 "createTime":1431954595000,                                                                   //记录创建时间
 "orderSn":"150511202441268501",                                                               //订单编号
 "type":2,                                                                                     //-1未知,0抽奖,1未抽奖平均,2取消订单,3提现,4营业额,5支付,6收益,7充值
 "yueType":1,                                //支付使用的账户(0营业额账户，1收益账户，2充值账户,3营业额结算账户,4收益结算账户, 5抽奖结算账户)
 
 
 充值账户
 "id":160989,
 "yue_type":2,                                                     //支付使用的账户(0营业额账户，1收益账户，2充值账户,3营业额结算账户,4收益结算账户, 5抽奖结算账户)
 "jine":-94.4000,                                                  //变动金额，加为正数，减为负数
 "object_id":"1906",
 "create_time":1431928575000,                                     //记录创建时间
 "order_sn":"150518135615172178",                                 //订单编号
 "beizhu":"充值账户支付订单 150518135615172178 用掉 94.40 元_1！", //备注
 "user_id":2,                                                     //用户ID
 "type":5              //-1未知,0抽奖,1未抽奖平均,2取消订单,21修改订单商品,3提现,31取消提现,4营业额,5支付,6收益,61收益转出,62收益转入,7充值
 
 积分
 "id":2999,
 "userId":2,                                                //用户id
 "jifen":-20,                                               //积分，加为正数，减为负数
 "beizhu":"订单 150518151540366155 支付使用了 20 个积分！", //备注
 "createTime":1431933358000,                                //记录创建时间
 "orderSn":"150518151540366155",                            //订单编号
 "type":5,                              //-1未知,0抽奖,1未抽奖自动分配,2帮人注册送积分,21关注大集客,22阅读推广文章,3取消订单退积分,31修改订单商品,5支付,6收益
 "objectId":"1907",                     //用于联合唯一索引，对应type，-1为null,01为抽奖权id,2,21被推荐人的id,22为fans表ID,35为订单id,6为提成表id
 
 营业额明细
 "id":160995,
 "userId":2,                                                              //用户id
 "jine":-200.0000,                                                        //变动金额，加为正数，减为负数
 "beizhu":"营业额账户提现 200.00 元到 asdfasd 的 中国工商银行 账户！",    //备注
 "createTime":1432543054000,                                              //记录创建时间
 "orderSn":null,                                                          //订单编号
 "type":3,                                                //-1未知,0抽奖,1未抽奖平均,2取消订单,21修改订单商品,3提现,31取消提现,4营业额,5支付,6收益,61收益转出,62收益转入,7充值
 "yueType":0,                                                             //支付使用的账户(0营业额账户，1收益账户，2充值账户,3营业额结算账户,4收益结算账户, 5抽奖结算账户)
 "objectId":"43",         //用于联合唯一索引，对应type，-1为null,01为抽奖权id,2458为order_id,3为提现id,6为提成表id,7为pay_id
 
 奖励受益
 "id":160955,
 "yue_type":4,                                          //支付使用的账户(0营业额账户，1收益账户，2充值账户,3营业额结算账户,4收益结算账户, 5抽奖结算账户)
 "jine":-100.0000,                                      //变动金额，加为正数，减为负数
 "object_id":null,                                     //用于联合唯一索引，对应type，-1为null,01为抽奖权id,2458为order_id,3为提现id,6为提成表id,7为pay_id
 "create_time":1431415601000,                          //创建记录时间
 "order_sn":null,                                      //订单编号
 "beizhu":"用户 seller 的奖励收益 100.0 元转入收益账户！", //备注
 "user_id":2,                                              //用户id
 "type":61                                      //-1未知,0抽奖,1未抽奖平均,2取消订单,21修改订单商品,3提现,31取消提现,4营业额,5支付,6收益,61收益转出,62收益转入,7充值
 
 抽奖收益
 "id":160797,
 "jine":145.58,                     //变动金额，加为正数，减为负数
 "create_time":"2015-03-03 11:12:20", //记录创建时间
 "sum":{"je":245.58,"jf":0},          //金额和积分总和
 "ctype":"yltype",
 "beizhu":"抽奖145.58元",           //备注
 "user_id":2,                       //用户id
 "type":0                          // -1未知,0抽奖,1未抽奖自动分配,2帮人注册送积分,21关注大集客,22阅读推广文章,3取消订单退积分,31修改订单商品,5支付,6收益
 */
#import <Foundation/Foundation.h>

@interface AccountDetailModel : NSObject

@property (retain, nonatomic)NSString *beizhu; //备注
@property (retain, nonatomic)NSString *createTime; //记录创建时间
@property (retain, nonatomic)NSString *data;
@property (retain, nonatomic)NSString *entityId;
@property (retain, nonatomic)NSString *id;
@property (retain, nonatomic)NSString *jine;
@property (retain, nonatomic)NSString *member;
@property (retain, nonatomic)NSString *objectId;
@property (retain, nonatomic)NSString *orderSn;
@property (retain, nonatomic)NSString *persistent;
@property (retain, nonatomic)NSString *type;
@property (retain, nonatomic)NSString *userId; //用户id
@property (retain, nonatomic)NSString *yueType;

@property (retain, nonatomic)NSString *yue_type;
@property (retain, nonatomic)NSString *object_id;
@property (retain, nonatomic)NSString *create_time;
@property (retain, nonatomic)NSString *order_sn;
@property (retain, nonatomic)NSString *user_id;

@property (retain, nonatomic)NSString *jifen;
@property (retain, nonatomic)NSString *addTime;
@property (retain, nonatomic)NSString *orderAmount;
@property (retain, nonatomic)NSString *je;
@property (retain, nonatomic)NSString *jf;
@property (retain, nonatomic)NSString *ctype;


//@property (retain, nonatomic)NSString *id;
//@property (retain, nonatomic)NSString *userId;
//@property (retain, nonatomic)NSString *jine;
//@property (retain, nonatomic)NSString *beizhu;
//@property (retain, nonatomic)NSString *createTime;
//@property (retain, nonatomic)NSString *orderSn;
//@property (retain, nonatomic)NSString *type;
//@property (retain, nonatomic)NSString *yueType;
//
//@property (retain, nonatomic)NSString *yue_type;
//@property (retain, nonatomic)NSString *object_id;
//@property (retain, nonatomic)NSString *create_time;
//@property (retain, nonatomic)NSString *order_sn;
//@property (retain, nonatomic)NSString *user_id;
//
////积分
//@property (retain, nonatomic)NSString *jifen;
//@property (retain, nonatomic)NSString *objectId;
//
////奖励受益
//@property (retain, nonatomic)NSString *je;
//@property (retain, nonatomic)NSString *jf;
//@property (retain, nonatomic)NSString *ctype;
//@property (retain, nonatomic)NSString *order_amount;

@end

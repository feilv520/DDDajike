//
//  DConfirmOrderViewController.h
//  dajike
//
//  Created by swb on 15/7/22.
//  Copyright (c) 2015年 haixia. All rights reserved.
//




//  确认订单 &  购物车确认订单

#import "DBackNavigationViewController.h"
#import "DGoodsDetailModel.h"

typedef enum {
    CHOU_SHU,//凑数专用
    LI_JI_GOU_MAI,
    GOU_WU_CHE,
    LI_JI_DUI_HUAN,
}QueRenType;

@interface DConfirmOrderViewController : DBackNavigationViewController

@property (assign, nonatomic) QueRenType type;
@property (strong, nonatomic) DGoodsDetailModel *model;
@property (strong, nonatomic) NSMutableDictionary *mDic;
@property (strong, nonatomic) NSString *shifukuan;
@property (strong, nonatomic) NSMutableArray *xiaoJiArr;
@property (strong, nonatomic) NSMutableArray *deleteArr;

@end

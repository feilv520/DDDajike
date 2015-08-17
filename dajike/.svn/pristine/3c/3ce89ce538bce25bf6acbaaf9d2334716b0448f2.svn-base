//
//  FoodViewController.h
//  jibaobao
//
//  Created by dajike on 15/4/27.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "BackNavigationViewController.h"
#import "JSDropDownMenu.h"
#import "ShouyeBannerModel.h"
typedef enum {
    SEARCH,//搜索
    MEISHI,//美食
    XIUXIAN_YULE,//休闲娱乐
    LIREN,//丽人
    LVSE_TECHAN,//绿色特产
    GOUWU,//购物
    JIAJU_JIAWANG,//家居家纺
    SHNEGHUO_FUWU,//生活服务
    NEARBY,//附近
    DEFAULT_LIST,//DEFAULT
} StoreListTYpe;
@interface FoodViewController : BackNavigationViewController<BarButtonDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate>
{
    //undo
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    NSInteger _currentData1SelectedIndex;
    NSInteger _currentData2SelectedIndex;
    //    JSDropDownMenu *menu;
}
@property (retain, nonatomic) JSDropDownMenu *menu;

@property (strong, nonatomic) NSString       *flagStr;
//标题
@property (strong, nonatomic) NSString       *navTitle;
@property (assign, nonatomic) StoreListTYpe  StoreListType;
@property (retain, nonatomic) ShouyeBannerModel *bannerModel;
//- (void) ishasMenu:(BOOL)hanMenu;
@end

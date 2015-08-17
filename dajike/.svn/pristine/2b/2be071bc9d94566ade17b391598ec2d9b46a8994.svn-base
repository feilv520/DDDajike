//
//  NearViewController.h
//  jibaobao
//
//  Created by swb on 15/5/19.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationViewController.h"
#import "JSDropDownMenu.h"
typedef enum {
    SEARCH,//搜索
    MEISHI,//美食
    GOUWU,//购物
    NEARBY,//附近
    TEST,
} StoreListTYpe;
@interface NearViewController : NavigationViewController<JSDropDownMenuDataSource,JSDropDownMenuDelegate>
{
    //分类的三个字典
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
@property (strong, nonatomic) NSString       *navTitle;
@property (assign, nonatomic) StoreListTYpe  StoreListType;

@end

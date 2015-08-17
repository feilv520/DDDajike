//
//  BackNavigationViewController.h
//  jibaobao
//
//  Created by dajike on 15/4/24.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
//#import "RequestNoDataView.h"

//左：          中：标题      右：0个选项
//左：返回       中：标题      右：1个选项
//左：返回       中：标题      右：2个选项
//左：1个选项       中：标题      右：1个选项


//左：返回       中：标题      右：0个选项
//左：返回       中：标题      右：0个选项
//左：返回       中：标题      右：0个选项
//左：返回       中：标题      右：0个选项
//左：返回       中：标题      右：0个选项

typedef enum {
    DEFAULT,
    SEARCH_BUTTON,
    SHAREANGSHOUCANG_BUTTON,
    MINE_BUTTON,
    WORD_TYPE
} NavType;

@protocol BarButtonDelegate <NSObject>

@optional
//左边返回按钮
- (void) navLeftButtonTapped:(id)sender;
- (void)right0ButtonClicked:(id)sender;
- (void)right1ButtonClicked:(id)sender;
- (void)leftButtonClicked:(id)sender;
- (void)wordBtnClicked:(id)sender;


@end
@interface BackNavigationViewController : UIViewController
{
    UILabel *titleLabel;
    BOOL isEnd;
}
@property (nonatomic, weak) id<BarButtonDelegate> delegate;
@property (retain, nonatomic) UITableView *mainTabview;
@property (retain, nonatomic) UIImageView *noDataView;
@property (retain, nonatomic) MJRefreshGifHeader *header;
@property (retain, nonatomic) MJRefreshBackNormalFooter *footer;

//@property (assign, nonatomic) BOOL hasMenu;


//左边返回按钮
- (void) navLeftButtonTapped:(id)sender;
////右边按钮事件
//- (void) navLeftButtonTapped:(id)sender;
//对navgationBar上特殊元素的定制
- (void)setNavType:(NavType)navType action:(NSString *)actionName;
- (void)setNavType:(NavType)navType;
//返回按钮隐藏
- (void)setBackBtnHidden:(BOOL)hidden;
//搜索按钮隐藏
- (void)setSearchBtnHidden:(BOOL)hidden;
//分享按钮隐藏
- (void)setShearBtnHidden:(BOOL)hidden;
//消息按钮隐藏
- (void)setMessageBtnHidden:(BOOL)hidden;
//设置按钮隐藏
- (void)setSetBtnHidden:(BOOL)hidden;
//收藏按钮隐藏
- (void)setStoreBtnHidden:(BOOL)hidden;
//滚回顶部按钮隐藏
- (void)setScrollBtnHidden:(BOOL)hidden;
//列表Style
- (void)addTableView:(UITableViewStyle)style;
//加载下拉刷新和上拉加载
- (void) addHeaderAndFooter;

@end

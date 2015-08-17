//
//  NavigationViewController.h
//  jibaobao
//
//  Created by dajike on 15/4/24.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "JShouyeNavButton.h"
//左：       中：      右：
//左：下拉          中：textField      右：1个选项
//左：1个选项       中：标题      右：1个选项


//左：返回       中：标题      右：2个选项
//左：1个选项       中：标题      右：1个选项


//左：返回       中：标题      右：0个选项
//左：返回       中：标题      右：0个选项
//左：返回       中：标题      右：0个选项
//左：返回       中：标题      右：0个选项
//左：返回       中：标题      右：0个选项

typedef enum {
    DEFAULT_NAV,
    SHOUYE_NAV,
    MINE_NAV,
    CHOUJIANG_NAV
} NavMainType;
@protocol MineBarButtonDelegate <NSObject>

@optional
- (void)left0ButtonClicked:(id)sender;
- (void)left1ButtonClicked:(id)sender;
- (void)rightButtonClicked:(id)sender;
@end

@interface NavigationViewController : UIViewController
{
    BOOL isEnd;
}
@property (nonatomic, weak) id<MineBarButtonDelegate> delegate;
@property (retain, nonatomic) UITableView *mainTabview;
@property (retain, nonatomic) MJRefreshGifHeader *header;
@property (retain, nonatomic) MJRefreshBackNormalFooter *footer;
@property (retain, nonatomic) JShouyeNavButton *navButton;


//对Bar上特殊元素的定制
- (void)setNavType:(NavMainType)navType action:(NSString *)actionName;
- (void)setNavType:(NavMainType)navType;
- (void)addHeaderAndFooter;

/*
 **  首页定位城市  重新设置frame
 */

- (void) setNavButtonFrameByTitle:(NSString *)title andCityId:(NSString *)cityId;
@end

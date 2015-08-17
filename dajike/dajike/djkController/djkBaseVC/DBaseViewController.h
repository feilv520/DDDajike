//
//  DBaseViewController.h
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DImgButton.h"
#import "MJRefresh.h"
@interface DBaseViewController : UIViewController
{
    BOOL isEnd;
}
@property (nonatomic, strong) UITableView *dMainTableView;
@property (retain, nonatomic) UIImageView *noDataView;

@property (retain, nonatomic) MJRefreshGifHeader *header;
@property (retain, nonatomic) MJRefreshBackNormalFooter *footer;
- (void)bringNaviBarToTopmost;
- (void)hideNaviBar:(BOOL)bIsHide;
- (void)setNaviBarTitle:(NSString *)strTitle;
- (void)setNaviBarLeftBtn:(DImgButton *)btn;
- (void)setNaviBarRightBtn:(DImgButton *)btn;
- (void)changeNavImg:(NSString *)imgName;

- (void)naviBarAddCoverView:(UIView *)view;
- (void)naviBarAddCoverViewOnTitleView:(UIView *)view;
- (void)naviBarRemoveCoverView:(UIView *)view;

- (void)addTableView:(BOOL)isNeedRefresh;

//加载下拉刷新和上拉加载
- (void) addHeaderAndFooter;

@end

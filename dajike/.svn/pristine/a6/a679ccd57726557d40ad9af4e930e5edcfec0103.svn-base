//
//  DBackNavigationViewController.h
//  dajike
//
//  Created by dajike on 15/7/7.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

/*
 */
#import <UIKit/UIKit.h>
#import "DImgButton.h"
#import "MJRefresh.h"
@interface DBackNavigationViewController : UIViewController
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
- (void) changeNavTitleColor:(UIColor *)color;
- (void)setNaviBarLeftBtn:(DImgButton *)btn;
- (void)setNaviBarRightBtn:(DImgButton *)btn;
// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)bCanDragBack;

- (void)naviBarAddCoverView:(UIView *)view;
- (void)naviBarAddCoverViewOnTitleView:(UIView *)view;
- (void)naviBarRemoveCoverView:(UIView *)view;

- (void)addTableView:(BOOL)isNeedRefresh;

- (void)changeNavImg:(NSString *)imgName;

@end

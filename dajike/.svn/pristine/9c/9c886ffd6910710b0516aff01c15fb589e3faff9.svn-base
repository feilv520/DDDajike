//
//  DBaseNavSearchController.h
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBaseViewController;
@class DBaseNavSearchController;
@protocol CustomNaviBarSearchControllerDelegate <NSObject>

- (void)naviBarSearchCtrl:(DBaseNavSearchController *)ctrl searchKeyword:(NSString *)strKeyword;
- (void)naviBarSearchCtrlCancel:(DBaseNavSearchController *)ctrl;

@optional
- (void)naviBarSearchCtrlClearKeywordRecord:(DBaseNavSearchController *)ctrl;

@end

@interface DBaseNavSearchController : NSObject

@property (unsafe_unretained) id<CustomNaviBarSearchControllerDelegate> delegate;

- (id)initWithParentViewCtrl:(DBaseViewController *)viewCtrl;

- (void)resetPlaceHolder:(NSString *)strMsg;

// 导航条上的关键字输入框分两种
// 1、由按钮触发，点击按钮后显示输入框，结束后销毁输入框现实按钮。
- (void)showTempSearchCtrl;

// 2、导航条一直显示输入框。
- (void)showFixationSearchCtrl;
- (void)showFixationSearchCtrlOnTitleView;

- (void)startSearch;
- (void)removeSearchCtrl;

- (void)setRecentKeyword:(NSArray *)arrRecentKeyword;
- (void)setKeyword:(NSString *)strKeyword;

@end

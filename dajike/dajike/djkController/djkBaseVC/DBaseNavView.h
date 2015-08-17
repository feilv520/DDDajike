//
//  DBaseNavView.h
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//



//自定义导航栏
#import <UIKit/UIKit.h>
#import "DImgButton.h"

@interface DBaseNavView : UIView

@property (nonatomic, weak) UIViewController *m_viewCtrlParentVC;

+ (CGRect)rightBtnFrame;
+ (CGSize)barBtnSize;
+ (CGSize)barSize;
+ (CGRect)titleViewFrame;

//创建一个导航条按钮,不带背景图片
+ (DImgButton *)createNavBtnWithTitle:(NSString *)btnTitle target:(id)target action:(SEL)action;
//创建一个导航条按钮,带背景图片
+ (DImgButton *)createNavBtnWithImgNormal:(NSString *)imgNormal imgHighlight:(NSString *)imgHighlight imgSelected:(NSString *)imgSelected target:(id)target action:(SEL)action;


// 用自定义的按钮和标题替换默认内容
- (void)setNavLeftBtn:(DImgButton *)btn;
- (void)setNavRightBtn:(DImgButton *)btn;
//设置导航条题头
- (void)setNavTitle:(NSString *)navTitle;
- (void) setNavTitleColor:(UIColor *)color;
- (void)changeNavImg:(NSString *)imgName;

// 在导航条上覆盖一层自定义视图。比如：输入搜索关键字时，覆盖一个输入框在上面。
- (void)showCoverView:(UIView *)view;
- (void)showCoverView:(UIView *)view animation:(BOOL)bIsAnimation;
- (void)showCoverViewOnTitleView:(UIView *)view;
- (void)hideCoverView:(UIView *)view;

@end

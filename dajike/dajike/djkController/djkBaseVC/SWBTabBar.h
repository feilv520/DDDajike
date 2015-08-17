//
//  SWBTabBar.h
//  自定义选项卡
//
//  Created by swb on 15/7/6.
//  Copyright (c) 2015年 swb. All rights reserved.
//




//自定义tabBar
#import <UIKit/UIKit.h>
@class DTabView;

@class SWBTabBar;

@protocol SWBTabBarDelegate <NSObject>

/**
 *  工具栏按钮被选中, 记录从哪里跳转到哪里. (方便以后做相应特效)
 */
- (void) tabBar:(SWBTabBar *)tabBar selectedFrom:(NSInteger) from to:(NSInteger)to;

@end

@interface SWBTabBar : UIView
//@property (nonatomic, weak) DTabView *selectView;
@property(nonatomic,weak) id<SWBTabBarDelegate> delegate;

/**
 *  使用特定图片来创建按钮, 这样做的好处就是可扩展性. 拿到别的项目里面去也能换图片直接用
 *
 *  @param image         普通状态下的图片
 *  @param selectedImage 选中状态下的图片
 */
-(void)addButtonWithImage:(UIImage *)image selectedImage:(UIImage *) selectedImage;

/**
 *  使用特定图片来创建按钮, 这样做的好处就是可扩展性. 拿到别的项目里面去也能换图片直接用
 *
 *  @param image         普通状态下的图片
 *  @param selectedImage 选中状态下的图片
 */
//- (void)addViewWithFrame:(CGRect)rect;
- (void)swipe:(int)btnTag;

@end

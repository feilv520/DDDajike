//
//  SWBTabBarController.h
//  自定义选项卡
//
//  Created by swb on 15/7/6.
//  Copyright (c) 2015年 swb. All rights reserved.
//


//自定义tabBarController

#import <UIKit/UIKit.h>
@class SWBTabBar;

@interface SWBTabBarController : UITabBarController

+ (SWBTabBarController *)sharedManager;

@property (strong, nonatomic) SWBTabBar *myView;

@end

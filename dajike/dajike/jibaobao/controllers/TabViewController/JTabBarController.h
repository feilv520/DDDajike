//
//  JTabBarController.h
//  jibaobao
//
//  Created by dajike on 15/4/23.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTabBarController : UITabBarController


 //下面的tabbar
@property (nonatomic,retain) UIView *tabBarView;


#pragma mark 单例模式
+(JTabBarController *)sharedManager;
//选中
- (void) selectAtIndex:(NSInteger) selectIndex;
@end

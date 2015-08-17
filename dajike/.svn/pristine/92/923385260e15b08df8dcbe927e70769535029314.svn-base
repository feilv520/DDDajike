//
//  ActivityIndicator.h
//  RuYi
//
//  Created by DLin on 14-10-31.
//  Copyright (c) 2014-2015 DLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface ActivityIndicator : NSObject
@property (retain, nonatomic)UIControl *control;
- (void)progressHudShowInView:(UIView *)view;

- (void)progresshHUDRemoved;
//立即消失
- (void)progresshHUDRemovedFast;

+ (id)sharedManager;

- (BOOL)isAnimating;
//设置Frame
- (void) reSetFrame:(CGRect)frame;

@property (nonatomic,assign)int animatCount;
@end

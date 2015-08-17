//
//  DSJShouYeViewController.h
//  dajike
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBaseViewController.h"

typedef void (^CallBackDWebViewController)();

@interface DSJShouYeViewController : DBaseViewController
@property(retain, nonatomic) NSString * storeId;
@property (strong, nonatomic) CallBackDWebViewController block;
- (void)callback:(CallBackDWebViewController)block;
@end

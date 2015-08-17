//
//  PayView.h
//  jibaobao
//
//  Created by swb on 15/6/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

//网络请求成功，回掉的块
typedef void (^success111)(id ret);

@interface PayView : UIView<UIWebViewDelegate>

@property (nonatomic, strong)success111 suc;

- (void)payRequestWithParam:(NSDictionary *)params ifAddActivityIndicator:(BOOL)hasActivityIndicator success:(success111)success;

/**
 *  判断网络链接
 */
-(BOOL) isConnectionAvailable;

@end

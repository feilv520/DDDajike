//
//  MyClickLb.h
//  jibaobao
//
//  Created by swb on 15/6/13.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 *****  带有点击事件的Lb
 */

#import <UIKit/UIKit.h>

@interface MyClickLb : UILabel

typedef void (^ClickLabelBlock)(MyClickLb *clickLb);

@property (strong, nonatomic) ClickLabelBlock  block;

- (void)callbackClickedLb:(ClickLabelBlock)block;

@end

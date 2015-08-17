//
//  ImgScrollView.h
//  jibaobao
//
//  Created by swb on 15/7/3.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgScrollView : UIScrollView

typedef void (^CallBackImgScollView)(ImgScrollView *imgScrollView);

- (void)setContentWithFrame:(CGRect)rect;
- (void)setImg:(UIImage *)img;
- (void)setAnimationRect;
- (void)rechangeInitRect;

@property (strong, nonatomic) CallBackImgScollView block;

- (void)callBackImgScrollView:(CallBackImgScollView)block;


@end

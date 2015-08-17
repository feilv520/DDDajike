//
//  DrawHeaderView.h
//  jibaobao
//
//  Created by dajike on 15/6/10.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawHeaderView : UIView
//@property (retain ,nonatomic) UIImageView *headImageView;
@property (retain ,nonatomic) UIButton *headImageBtn;
@property (retain ,nonatomic) UILabel *nameBtn;
@property (retain ,nonatomic) UIButton *xianjinBtn;
@property (retain ,nonatomic) UIButton *jifenBtn;
@property (assign, nonatomic) CGFloat myAlpha;
@property (assign, nonatomic) CGFloat angle0;
@property (assign, nonatomic) CGFloat angle2;

@property (retain ,nonatomic) UIImageView *dengguang0;
@property (retain ,nonatomic) UIImageView *dengguang1;
@property (retain ,nonatomic) UIImageView *dengguang2;
- (void)startAnimation0;
- (void)startAnimation1;
@end

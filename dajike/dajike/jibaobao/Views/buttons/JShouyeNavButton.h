//
//  JShouyeNavButton.h
//  jibaobao
//
//  Created by dajike on 15/4/27.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JShouyeNavButton : UIButton
@property UILabel *cityTitleLabel;
- (void)setupWithTitle:(NSString *)string;
- (void)setdownWithTitle:(NSString *)string;

@end
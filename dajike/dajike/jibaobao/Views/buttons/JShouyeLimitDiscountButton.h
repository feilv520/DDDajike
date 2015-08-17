//
//  JShouyeLimitDiscountButton.h
//  jibaobao
//
//  Created by dajike on 15/4/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShouyeBannerModel.h"

@interface JShouyeLimitDiscountButton : UIButton
@property (retain, nonatomic) ShouyeBannerModel *timeLimitModel;

- (void)setImageStr:(NSString *)imageStr andTitle:(NSString *)title andNewPrice:(CGFloat)newPrice andOldPrice:(CGFloat)oldPrice;
@end

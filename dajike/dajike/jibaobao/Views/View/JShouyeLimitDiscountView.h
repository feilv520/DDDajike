//
//  JShouyeLimitDiscountView.h
//  jibaobao
//
//  Created by dajike on 15/4/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JShouyeLimitDiscountViewDelegate <NSObject>

@optional
- (void)ShouyeLimitDiscounButtonClicked:(id)sender;
@end

@interface JShouyeLimitDiscountView : UIView
@property (nonatomic, weak) id<JShouyeLimitDiscountViewDelegate> delegate;
- (void)setImageWithArray:(NSArray *)imageArray andtitles:(NSArray *)titleArr andNewPrices:(NSArray *)newPriceArr andOldPriceArray:(NSArray *)oldPriceArr;
@end

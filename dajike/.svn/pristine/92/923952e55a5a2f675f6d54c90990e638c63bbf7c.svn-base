//
//  SwbBuyView.h
//  jibaobao
//
//  Created by swb on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLabel.h"

typedef void (^BuyBtnClickedBlock)();

@interface SwbBuyView : UIView

@property (strong, nonatomic) UILabel       *priceLb;
@property (strong, nonatomic) LPLabel       *notPriceLb;
@property (strong, nonatomic) UILabel       *lotteryLb;

@property (strong, nonatomic) UIButton      *buyBtn;

@property (strong, nonatomic) BuyBtnClickedBlock    block;

//- (void)layoutMyView;

- (void)CallBackBuyBtnClicked:(BuyBtnClickedBlock)block;

@end

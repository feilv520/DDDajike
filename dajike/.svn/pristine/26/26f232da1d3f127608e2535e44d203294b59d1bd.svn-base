//
//  GouWuCheClickView.h
//  dajike
//
//  Created by swb on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//


//购物车下面的猜你喜欢
#import <UIKit/UIKit.h>

@interface GouWuCheClickView : UIView

typedef void (^CallBackClickedBlock)(GouWuCheClickView *gouWuCheClickView);

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel   *nameLb;
@property (strong, nonatomic) UILabel   *priceLb;

@property (strong, nonatomic) CallBackClickedBlock mBlock;

- (void)callBackClicked:(CallBackClickedBlock)block;

@end

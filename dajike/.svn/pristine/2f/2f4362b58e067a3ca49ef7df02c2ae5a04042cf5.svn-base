//
//  SwbBuyView.m
//  jibaobao
//
//  Created by swb on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SwbBuyView.h"
#import "UIView+MyView.h"
#import "defines.h"

@implementation SwbBuyView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutMyView];
    }
    return self;
}

- (void)layoutMyView
{
    UIView *lineView1 = [self createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 1) andBackgroundColor:Color_bg];
    [self addSubview:lineView1];
    self.priceLb = [self creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(lineView1.frame)+5, 100, 20) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_mainColor andCornerRadius:0.0f];
    
    [self addSubview:self.priceLb];
//    self.notPriceLb = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(self.priceLb.frame)+10, CGRectGetMaxY(lineView1.frame)+10, 80, 10) AndFont:12.0f AndBackgroundColor:[UIColor clearColor] AndText:notPrice AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor lightGrayColor] andCornerRadius:0.0f];
    self.notPriceLb = [[LPLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLb.frame)+10, CGRectGetMaxY(lineView1.frame)+10, 80, 10)];
    self.notPriceLb.text = nil;
    self.notPriceLb.font = [UIFont systemFontOfSize:14.0f];
    self.notPriceLb.backgroundColor = [UIColor clearColor];
    self.notPriceLb.textColor = [UIColor lightGrayColor];
    self.notPriceLb.strikeThroughColor = [UIColor lightGrayColor];
    self.notPriceLb.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.notPriceLb];
    self.lotteryLb = [self creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(self.priceLb.frame)+1, 150, 15) AndFont:12.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_mainColor andCornerRadius:0.0f];
    [self addSubview:self.lotteryLb];
    
    self.buyBtn = [self createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-90, 7, 80, 30) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:@"立即购买" andTag:11];
    self.buyBtn.layer.cornerRadius = 3.0f;
    self.buyBtn.layer.masksToBounds = YES;
    self.buyBtn.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:135.0/255.0 blue:34.0/255.0 alpha:1.0f];
    [self addSubview:self.buyBtn];
    
    UIView *lineView2 = [self createViewWithFrame:CGRectMake(0, self.frame.size.height-0.5, WIDTH_CONTROLLER_DEFAULT, 0.5) andBackgroundColor:Color_line_bg];
    [self addSubview:lineView2];
}

- (void)btnClickedAction:(id)sender
{
    self.block();
}

- (void)CallBackBuyBtnClicked:(BuyBtnClickedBlock)block
{
    self.block = block;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

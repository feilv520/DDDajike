//
//  TypeAndNumView.m
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "TypeAndNumView.h"
#import "UIView+MyView.h"
#import "defines.h"

@implementation TypeAndNumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self layOutMyViews];
    }
    return self;
}

- (void)layOutMyViews
{
    _typeLb = [self creatLabelWithFrame:CGRectMake(10, 7, 100, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"D07#白黑M" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    [self addSubview:_typeLb];
    
    _numLb = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(_typeLb.frame)+10, 0, 85, 44) AndFont:13.0f AndBackgroundColor:[UIColor clearColor] AndText:@"(剩余499单)" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
    _numLb.numberOfLines = 0;
    [self addSubview:_numLb];
    
    UIView *ivBg = [self createViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-112, 7, 92, 30) andBackgroundColor:Color_bg];
    [self addSubview:ivBg];
    
//    _jianBtn = [self createButtonWithFrame:CGRectMake(0.5, 0.5, 30, 29) andBackImageName:@"img_jian" andTarget:self andAction:@selector(btnClickedAction:) andTitle:nil andTag:898];
    _jianBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5, 0.5, 30, 29)];
    [_jianBtn setBackgroundImage:[UIImage imageNamed:@"img_jian"] forState:UIControlStateNormal];
    [_jianBtn addTarget:self action:@selector(btnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [ivBg addSubview:_jianBtn];
    
    _numTf = [self createTextFieldWithFrame:CGRectMake(CGRectGetMaxX(_jianBtn.frame)+0.5, 0.5, 30, 29) andPlaceholder:nil andPassWord:NO andLeftImageView:nil andRightImageView:nil andFont:15.0f];
    _numTf.backgroundColor = [UIColor whiteColor];
    _numTf.textAlignment = NSTextAlignmentCenter;
    _numTf.text = @"1";
    _numTf.enabled = NO;
    [ivBg addSubview:_numTf];
    
//    _jiaBtn = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(_numTf.frame)+0.5, 0.5, 30, 29) andBackImageName:@"img_jia" andTarget:self andAction:@selector(btnClickedAction:) andTitle:nil andTag:899];
    _jiaBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numTf.frame)+0.5, 0.5, 30, 29)];
    [_jiaBtn setBackgroundImage:[UIImage imageNamed:@"img_jia"] forState:UIControlStateNormal];
    [_jiaBtn addTarget:self action:@selector(btnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [ivBg addSubview:_jiaBtn];
}

- (void)btnClickedAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.block(btn);
}

- (void)callBackBtnClicked:(BtnClickedBlock)block
{
    self.block = [block copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

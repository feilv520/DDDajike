//
//  GouWuCheClickView.m
//  dajike
//
//  Created by swb on 15/7/9.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "GouWuCheClickView.h"
#import "dDefine.h"

#define imgHeight 80

@implementation GouWuCheClickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.imgView = [self createImageViewWithFrame:DRect(5, 5, imgHeight, imgHeight) andImageName:DImagePlaceholderImage];
    [self addSubview:self.imgView];
    
    self.nameLb = [self creatLabelWithFrame:DRect(0, CGRectGetMaxY(self.imgView.frame)+5, self.frame.size.width, 27) AndFont:11.0f AndBackgroundColor:DColor_Clear AndText:@"送快递就发生的开发上了对方" AndTextAlignment:NSTextAlignmentCenter AndTextColor:DColor_808080 andCornerRadius:0.0f];
    self.nameLb.numberOfLines = 0;
    [self addSubview:self.nameLb];
    
    self.priceLb = [self creatLabelWithFrame:DRect(0, CGRectGetMaxY(self.nameLb.frame)+2, self.frame.size.width, 13) AndFont:11.0f AndBackgroundColor:DColor_Clear AndText:@"¥33.00" AndTextAlignment:NSTextAlignmentCenter AndTextColor:DColor_c4291f andCornerRadius:0.0f];
    [self addSubview:self.priceLb];
    
    UIButton *btn = [self createButtonWithFrame:DRect(0, 0, self.frame.size.width, self.frame.size.height) andBackImageName:nil andTarget:self andAction:@selector(btnClicked) andTitle:nil andTag:0];
    [self addSubview:btn];
}
- (void)btnClicked
{
    self.mBlock(self);
}

- (void)callBackClicked:(CallBackClickedBlock)block
{
    self.mBlock = [block copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

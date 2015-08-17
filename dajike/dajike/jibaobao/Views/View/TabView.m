//
//  TabView.m
//  jibaobao
//
//  Created by swb on 15/5/21.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "TabView.h"
#import "defines.h"
#import "UIView+MyView.h"

@implementation TabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self setMainView];
    }
    return self;
}

- (void)callBackTabViewClicked:(TabViewClickedBlock)block
{
    self.block = [block copy];
}

- (void)setMainView
{
    CGFloat x = self.frame.size.width/2-10;
    CGFloat y = 5;
    self.tabImgView = [self createImageViewWithFrame:CGRectMake(x, y, 20, 23) andImageName:nil];
    self.tabImgView.contentMode =  UIViewContentModeScaleAspectFit;
    self.tabImgView.clipsToBounds  = YES;
    [self addSubview:self.tabImgView];
    
    self.tabLb = [self creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabImgView.frame)+2, self.frame.size.width, 20) AndFont:12.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentCenter AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [self addSubview:self.tabLb];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.block(self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

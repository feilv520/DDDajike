//
//  SwbCommentView.m
//  jibaobao
//
//  Created by swb on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SwbCommentView.h"
#import "UIView+MyView.h"
#import "defines.h"

@implementation SwbCommentView

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
    UIView *lineView = [self createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 1) andBackgroundColor:Color_line_bg];
    [self addSubview:lineView];
    
    UIImageView *img = [self createImageViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/2-50, 10, 24, 22) andImageName:@"img_write"];
    [self addSubview:img];
    
    UILabel *lb = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+5, 7, 63, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"我要评价" AndTextAlignment:NSTextAlignmentCenter AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [self addSubview:lb];
    
    UIButton *commentBtn = [self createButtonWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 44) andBackImageName:nil andTarget:self andAction:@selector(commentAction:) andTitle:nil andTag:10];
    [self addSubview:commentBtn];
}

- (void)commentAction:(id)sender
{
    self.block();
}

- (void)callbackBtnClicked:(CommentBtnCallBackBlock)block
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

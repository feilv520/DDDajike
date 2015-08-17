//
//  RequestNoDataView.m
//  jibaobao
//
//  Created by swb on 15/5/25.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "RequestNoDataView.h"
#import "defines.h"
#import "SwbClickImageView.h"

@implementation RequestNoDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color_tableV;
        self.userInteractionEnabled = YES;
        [self LayOutView];
    }
    return self;
}

- (void)LayOutView
{
    UIView *viewBg = [self createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT) andBackgroundColor:Color_tableV];
    [self addSubview:viewBg];
    
    SwbClickImageView *imgView = [[SwbClickImageView alloc]initWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/2-50, HEIGHT_CONTROLLER_DEFAULT/2-130, 100, 100)];
    imgView.image = [UIImage imageNamed:@"img_jiazai"];
    __weak RequestNoDataView *weakSelf = self;
    [imgView callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
        weakSelf.block();
    }];
    [viewBg addSubview:imgView];
    
    UILabel *lb = [self creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(imgView.frame)+5, WIDTH_CONTROLLER_DEFAULT-20, 20) AndFont:16.0f AndBackgroundColor:Color_Clear AndText:@"使劲戳我，重新加载" AndTextAlignment:NSTextAlignmentCenter AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [viewBg addSubview:lb];
    
}

- (void)callBackRequestNoData:(CallbackRequestNoData)block
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

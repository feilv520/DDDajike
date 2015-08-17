//
//  MyHeaderView.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/8.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "MyHeaderView.h"
#import "UIView+MyView.h"
#import "defines.h"

@implementation MyHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.alpha = 0.5f;
        [self layoutMyView];
    }
    return self;
}

- (void)layoutMyView
{
    self.iv = [self createImageViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, WIDTH_CONTROLLER_DEFAULT/2) andImageName:imagePlaceholderImage];
    [self addSubview:self.iv];
    
    UIView *view1 = [self createViewWithFrame:CGRectMake(0, self.iv.frame.size.height-50, WIDTH_CONTROLLER_DEFAULT, 50) andBackgroundColor:Color_Black];
    view1.alpha = 0.4f;
    [self addSubview:view1];
    
    self.shopNameLb = [self creatLabelWithFrame:CGRectMake(10, CGRectGetMinY(view1.frame), WIDTH_CONTROLLER_DEFAULT-120, 25) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"宝山店" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor whiteColor] andCornerRadius:0.0f];
    [self addSubview:self.shopNameLb];
    
    self.xingjiLb = [self creatLabelWithFrame:CGRectMake(110, CGRectGetMaxY(self.shopNameLb.frame), 40, 25) AndFont:13.0f AndBackgroundColor:[UIColor clearColor] AndText:@"0.0分" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor colorWithRed:241.0/255.0 green:135.0/255.0 blue:34.0/255.0 alpha:1.0f] andCornerRadius:0.0f];
    [self addSubview:self.xingjiLb];
    
    self.commentNumLb = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(self.xingjiLb.frame), CGRectGetMaxY(self.shopNameLb.frame), 80, 25) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"555人评价" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor whiteColor] andCornerRadius:0.0f];
    [self addSubview:self.commentNumLb];
    
    UIView *vv = [self createViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.iv.frame), WIDTH_CONTROLLER_DEFAULT, 5) andBackgroundColor:Color_tableV];
    [self addSubview:vv];
    
    UIView *lineView1 = [self createViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.iv.frame)+5, WIDTH_CONTROLLER_DEFAULT, 1) andBackgroundColor:Color_line_bg];
    [self addSubview:lineView1];
    
    UIImageView *adressIv = [self createImageViewWithFrame:CGRectMake(10, CGRectGetMaxY(lineView1.frame)+5, 15, 20) andImageName:@"img_add_h"];
    [self addSubview:adressIv];
    
    self.adressLb = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(adressIv.frame)+5, CGRectGetMaxY(lineView1.frame)+5, WIDTH_CONTROLLER_DEFAULT-50, 20) AndFont:13.0f AndBackgroundColor:[UIColor clearColor] AndText:@"万达广场3楼" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [self addSubview:self.adressLb];
    
    UIView *lineView2 = [self createViewWithFrame:CGRectMake(0, CGRectGetMaxY(adressIv.frame)+5, WIDTH_CONTROLLER_DEFAULT, 1) andBackgroundColor:Color_line_bg];
    [self addSubview:lineView2];
    
    UIImageView *phoneIv = [self createImageViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/4-30, CGRectGetMaxY(lineView2.frame)+5, 20, 20) andImageName:@"img_phone"];
    [self addSubview:phoneIv];
    
    UILabel *phoneLb = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(phoneIv.frame), CGRectGetMaxY(lineView2.frame), 50, 30) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"电话" AndTextAlignment:NSTextAlignmentCenter AndTextColor:Color_word_bg andCornerRadius:0.0];
    [self addSubview:phoneLb];
    
    UIView *lineView3 = [self createViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/2, CGRectGetMaxY(lineView2.frame)+5, 1, 20) andBackgroundColor:Color_line_bg];
    [self addSubview:lineView3];
    
    self.storeImg = [self createImageViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/4*3-30, CGRectGetMaxY(lineView2.frame)+5, 20, 20) andImageName:@"img_asterisk_02"];
    [self addSubview:self.storeImg];
    
    UILabel *storeLb = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(self.storeImg.frame), CGRectGetMaxY(lineView2.frame), 50, 30) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:@"收藏" AndTextAlignment:NSTextAlignmentCenter AndTextColor:Color_word_bg andCornerRadius:0.0];
    [self addSubview:storeLb];
    
    UIView *lineView4 = [self createViewWithFrame:CGRectMake(0, CGRectGetMaxY(storeLb.frame)+2, WIDTH_CONTROLLER_DEFAULT, 1) andBackgroundColor:Color_line_bg];
    [self addSubview:lineView4];
    [self addBtnClick];
}

//添加button  Tag ==  2.地址button  3.电话button  4.收藏button  5.相册
- (void)addBtnClick
{
    UIButton *addressBtn = [self createButtonWithFrame:CGRectMake(0, CGRectGetMinY(self.adressLb.frame), WIDTH_CONTROLLER_DEFAULT, 30) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:nil andTag:2];
    [self addSubview:addressBtn];
    
    UIButton *phoneBtn = [self createButtonWithFrame:CGRectMake(0, CGRectGetMaxY(addressBtn.frame)-5, WIDTH_CONTROLLER_DEFAULT/2, 35) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:nil andTag:3];
    [self addSubview:phoneBtn];
    
    UIButton *storeBtn = [self createButtonWithFrame:CGRectMake(CGRectGetMaxX(phoneBtn.frame), CGRectGetMinY(phoneBtn.frame), WIDTH_CONTROLLER_DEFAULT/2, 35) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:nil andTag:4];
    [self addSubview:storeBtn];
}

- (void)btnClickedAction:(id)sender
{
    UIButton *mBtn = (UIButton *)sender;
    self.btnCallBackBlock(mBtn.tag);
}

- (void)addShopPhotosBtn
{
    UIView *viewBG = [self createViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-97, CGRectGetMaxY(self.iv.frame)-78, 80, 80) andBackgroundColor:Color_Black];
    viewBG.alpha = 0.7f;
    viewBG.layer.borderColor = Color_White.CGColor;
    viewBG.layer.borderWidth = 1.0f;
    [self addSubview:viewBG];
    self.shopPhotoImg = [self createImageViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-100, CGRectGetMaxY(self.iv.frame)-75, 80, 80) andImageName:imagePlaceholderImage];
    self.shopPhotoImg.layer.borderColor = Color_White.CGColor;
    self.shopPhotoImg.layer.borderWidth = 1.0f;
    
    [self addSubview:self.shopPhotoImg];
    self.shopPhotosBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-100, CGRectGetMaxY(self.iv.frame)-75, 80, 80)];
    self.shopPhotosBtn.tag = 5;
    self.shopPhotosBtn.backgroundColor = [UIColor clearColor];
    [self.shopPhotosBtn addTarget:self action:@selector(btnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.shopPhotosBtn];
    
    UIView *vv = [self createViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-90, CGRectGetMaxY(self.shopPhotosBtn.frame)-20, 40, 15) andBackgroundColor:Color_Black];
    vv.layer.cornerRadius = 8.0f;
    vv.layer.masksToBounds = YES;
    vv.alpha = 0.7f;
    [self addSubview:vv];
    
    self.photoNumLb = [self creatLabelWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-90, CGRectGetMaxY(self.shopPhotosBtn.frame)-20, 40, 15) AndFont:12.0f AndBackgroundColor:[UIColor clearColor] AndText:@"13张" AndTextAlignment:NSTextAlignmentCenter AndTextColor:[UIColor whiteColor] andCornerRadius:0.0f];
    [self addSubview:self.photoNumLb];
}

- (void)btnClickedCallBackAction:(ClickBtnBlock)block
{
    self.btnCallBackBlock = block;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

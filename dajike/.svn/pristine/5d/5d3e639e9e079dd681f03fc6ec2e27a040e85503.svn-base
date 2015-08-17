//
//  DBaseNavView.m
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBaseNavView.h"
#import "dDefine.h"

@interface DBaseNavView()

@property (nonatomic, readonly) DImgButton *m_btnBack;
@property (nonatomic, readonly) UILabel *m_labelTitle;
@property (nonatomic, readonly) UIImageView *m_imgViewBg;
@property (nonatomic, readonly) DImgButton *m_btnLeft;
@property (nonatomic, readonly) DImgButton *m_btnRight;

@end

@implementation DBaseNavView

@synthesize m_btnBack = _btnBack;
@synthesize m_labelTitle = _labelTitle;
@synthesize m_imgViewBg = _imgViewBg;
@synthesize m_btnLeft = _btnLeft;
@synthesize m_btnRight = _btnRight;


+ (CGRect)rightBtnFrame
{
    return DRect(DWIDTH_CONTROLLER_DEFAULT-60, 22.0f, [[self class] barBtnSize].width, [[self class] barBtnSize].height);
}

+ (CGSize)barBtnSize
{
    return DSize(60.0f, 40.0f);
}

+ (CGSize)barSize
{
    return DSize(DWIDTH_CONTROLLER_DEFAULT, 64.0f);
}

+ (CGRect)titleViewFrame
{
    return DRect(DWIDTH_CONTROLLER_DEFAULT/2-95, 22.0f, 190.0f, 40.0f);
}
//创建一个导航条按钮,不带背景图片
+ (DImgButton *)createNavBtnWithTitle:(NSString *)btnTitle target:(id)target action:(SEL)action
{
    DImgButton *btn = [[self class] createNavBtnWithImgNormal:nil imgHighlight:nil imgSelected:nil target:target action:action];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitleColor:DColor_White forState:UIControlStateNormal];
    btn.titleLabel.font = DFont_Btn_Nav;
    return btn;
}
//创建一个导航条按钮,带背景图片
+ (DImgButton *)createNavBtnWithImgNormal:(NSString *)imgNormal imgHighlight:(NSString *)imgHighlight imgSelected:(NSString *)imgSelected target:(id)target action:(SEL)action
{
    UIImage *imgNavBtnNormal = [UIImage imageNamed:imgNormal];
    
    DImgButton *btn = [DImgButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:imgNavBtnNormal forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:(imgHighlight ? imgHighlight : imgNormal)] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:(imgSelected ? imgSelected : imgNormal)] forState:UIControlStateSelected];
    CGFloat fDeltaWidth = ([[self class] barBtnSize].width - imgNavBtnNormal.size.width)/2.0f;
    CGFloat fDeltaHeight = ([[self class] barBtnSize].height - imgNavBtnNormal.size.height)/2.0f;
    fDeltaWidth = (fDeltaWidth >= 2.0f) ? fDeltaWidth/2.0f : 0.0f;
    fDeltaHeight = (fDeltaHeight >= 2.0f) ? fDeltaHeight/2.0f : 0.0f;
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(fDeltaHeight, fDeltaWidth, fDeltaHeight, fDeltaWidth)];
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(fDeltaHeight, -imgNavBtnNormal.size.width, fDeltaHeight, fDeltaWidth)];
    return btn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    
    // 默认左侧显示返回按钮
    _btnBack = [[self class] createNavBtnWithImgNormal:DimageNavBack imgHighlight:DimageNavBack imgSelected:DimageNavBack target:self action:@selector(btnBack:)];
//    _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btnBack setImage:[UIImage imageNamed:DimageNavBack] forState:UIControlStateNormal];
//    [_btnBack setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 10, 35)];
//    [_btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelTitle.backgroundColor = [UIColor clearColor];
    _labelTitle.textColor = DColor_White;
    _labelTitle.font = DFont_Navb;
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    
    _imgViewBg = [[UIImageView alloc] initWithFrame:self.bounds];
    _imgViewBg.image = [[UIImage imageNamed:@"a"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    _imgViewBg.alpha = 1.0f;
    
//    if (_bIsBlur)
//    {// iOS7可设置是否需要现实磨砂玻璃效果
//        _imgViewBg.alpha = 0.0f;
//        UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:self.bounds];
//        [self addSubview:naviBar];
//    }else{}
    
    _labelTitle.frame = [[self class] titleViewFrame];
    _imgViewBg.frame = self.bounds;
    
    [self addSubview:_imgViewBg];
    [self addSubview:_labelTitle];
    
    [self setNavLeftBtn:_btnBack];
}

- (void)changeNavImg:(NSString *)imgName
{
    if (_imgViewBg) {
        _imgViewBg.image = [UIImage imageNamed:imgName];
    }
}
- (void)setNavTitle:(NSString *)strTitle
{
    [_labelTitle setText:strTitle];
}
- (void) setNavTitleColor:(UIColor *)color
{
    [_labelTitle setTextColor:color];
}

- (void)setNavLeftBtn:(DImgButton *)btn
{
    if (_btnLeft)
    {
        [_btnLeft removeFromSuperview];
        _btnLeft = nil;
    }else{}
    
    _btnLeft = btn;
    if (_btnLeft)
    {
        _btnLeft.frame = DRect(2.0f, 22.0f, [[self class] barBtnSize].width, [[self class] barBtnSize].height);
        [self addSubview:_btnLeft];
    }else{}
}

- (void)setNavRightBtn:(DImgButton *)btn
{
    if (_btnRight)
    {
        [_btnRight removeFromSuperview];
        _btnRight = nil;
    }else{}
    
    _btnRight = btn;
    if (_btnRight)
    {
        _btnRight.frame = [[self class] rightBtnFrame];
        [self addSubview:_btnRight];
    }else{}
}

- (void)btnBack:(id)sender
{
    if (self.m_viewCtrlParentVC)
    {
        [self.m_viewCtrlParentVC.navigationController popViewControllerAnimated:YES];
    }else{APP_ASSERT_STOP}
}


- (void)showCoverView:(UIView *)view
{
    [self showCoverView:view animation:NO];
}
- (void)showCoverView:(UIView *)view animation:(BOOL)bIsAnimation
{
    if (view)
    {
        [self hideOriginalBarItem:YES];
        
        [view removeFromSuperview];
        
        view.alpha = 0.4f;
        [self addSubview:view];
        if (bIsAnimation)
        {
            [UIView animateWithDuration:0.2f animations:^()
             {
                 view.alpha = 1.0f;
             }completion:^(BOOL f){}];
        }
        else
        {
            view.alpha = 1.0f;
        }
    }else{APP_ASSERT_STOP}
}

- (void)showCoverViewOnTitleView:(UIView *)view
{
    if (view)
    {
        if (_labelTitle)
        {
            _labelTitle.hidden = YES;
        }else{}
        
        [view removeFromSuperview];
        view.frame = _labelTitle.frame;
        
        [self addSubview:view];
    }else{APP_ASSERT_STOP}
}

- (void)hideCoverView:(UIView *)view
{
    [self hideOriginalBarItem:NO];
    if (view && (view.superview == self))
    {
        [view removeFromSuperview];
    }else{}
}

#pragma mark -
- (void)hideOriginalBarItem:(BOOL)bIsHide
{
    if (_btnLeft)
    {
        _btnLeft.hidden = bIsHide;
    }else{}
    if (_btnBack)
    {
        _btnBack.hidden = bIsHide;
    }else{}
    if (_btnRight)
    {
        _btnRight.hidden = bIsHide;
    }else{}
    if (_labelTitle)
    {
        _labelTitle.hidden = bIsHide;
    }else{}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

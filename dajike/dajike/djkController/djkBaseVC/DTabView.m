//
//  DTabView.m
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DTabView.h"
#import "dDefine.h"
#import "defines.h"
#import "UIView+MyView.h"

@implementation DTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DColor_252525;
//        self.userInteractionEnabled = YES;
        self.imgArr = @[@"djk_index_01",@"djk_index_03",@"djk_index_05",@"djk_index_09"];
        self.selectImgArr = @[@"djk_index_02",@"djk_index_04",@"djk_index_06",@"djk_index_10"];
        self.titleArr = @[@"首页",@"分类",@"购物车",@"我的"];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeGouWuCheNum:) name:@"changeGouWuCheNum" object:nil];
//        [self setMainView];
    }
    return self;
}

- (void)callBackTabViewClicked:(DTabViewClickedBlock)block
{
    self.block = [block copy];
}

- (void)setMainView:(NSInteger)selectIndex
{
    CGFloat x = self.frame.size.width/4;
    CGFloat y = 5;
    for (int i = 0; i<4; i++) {
        self.tabImgView = [self createImageViewWithFrame:CGRectMake(x/2-10+self.frame.size.width/4*i, y, 20, 20) andImageName:[self.imgArr objectAtIndex:i]];
        self.tabImgView.contentMode =  UIViewContentModeScaleAspectFit;
        self.tabImgView.clipsToBounds  = YES;
        
        [self addSubview:self.tabImgView];
        
        self.tabLb = [self creatLabelWithFrame:CGRectMake(0+self.frame.size.width/4*i, CGRectGetMaxY(self.tabImgView.frame)+3, self.frame.size.width/4, 15) AndFont:12.0f AndBackgroundColor:[UIColor clearColor] AndText:[self.titleArr objectAtIndex:i] AndTextAlignment:NSTextAlignmentCenter AndTextColor:DColor_tabbarTextW andCornerRadius:0.0f];
        self.tabLb.font = DFont_12b;
        [self addSubview:self.tabLb];
        if (i == selectIndex) {
            self.tabImgView.image = [UIImage imageNamed:[self.selectImgArr objectAtIndex:i]];
            self.tabLb.textColor = DColor_c4291f;
        }
    }
    [self setGouWuCheXiaoJiaoBiao];
}

- (void)changeGouWuCheNum:(NSNotification *)notify
{
    NSLog(@"%@",notify.object);
    NSMutableDictionary *dic = [[FileOperation readFileToDictionary:jibaobaoUser]mutableCopy];
    _numLb.text = [dic objectForKey:@"cartCount"];
    if ([_numLb.text intValue]>0) {
        [_numLb setHidden:NO];
        _numLb.text = [NSString stringWithFormat:@"%@",_numLb.text];
    }else
        [_numLb setHidden:YES];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeGouWuCheNum" object:nil];
}

//设置购物车小角标
- (void)setGouWuCheXiaoJiaoBiao
{
    _numLb = [[UILabel alloc]initWithFrame:DRect(DWIDTH_CONTROLLER_DEFAULT/4*3-DWIDTH_CONTROLLER_DEFAULT/8+7, 5, 15, 15)];
    _numLb.hidden = YES;
    _numLb.backgroundColor = DColor_White;
    _numLb.layer.cornerRadius = _numLb.frame.size.width/2;
    _numLb.layer.masksToBounds = YES;
    _numLb.text = @"0";
    _numLb.font = [UIFont systemFontOfSize:9.0f];
    _numLb.textColor = DColor_c4291f;
    _numLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_numLb];
    [self bringSubviewToFront:_numLb];
    [self changeGouWuCheNum:nil];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    self.block(self);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

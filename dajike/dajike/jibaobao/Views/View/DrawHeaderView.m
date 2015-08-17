//
//  DrawHeaderView.m
//  jibaobao
//
//  Created by dajike on 15/6/10.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "DrawHeaderView.h"

#define LENGTH_BILI_H   self.frame.size.height/(320.0/416*250)
#define LENGTH_BILI_W   self.frame.size.width/320.0
@interface DrawHeaderView()

@end

@implementation DrawHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawViews];
        
    }
    return self;
}

- (void) drawViews
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_tp_03.png"]];
    [imageView setFrame:self.frame];
    [imageView setUserInteractionEnabled:YES];
    [self addSubview:imageView];
    
    _dengguang0 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_dengguang2.png"]];
    [_dengguang0 setFrame:CGRectMake(LENGTH_BILI_W*(-35), LENGTH_BILI_W*18, LENGTH_BILI_W*150, LENGTH_BILI_W*200)];
    [_dengguang0 setUserInteractionEnabled:YES];
    [imageView addSubview:_dengguang0];
    
    _dengguang1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_dengguang2.png"]];
    [_dengguang1 setFrame:CGRectMake(LENGTH_BILI_W*87, LENGTH_BILI_W*14, LENGTH_BILI_W*150, LENGTH_BILI_W*180)];
    [_dengguang1 setUserInteractionEnabled:YES];
    [imageView addSubview:_dengguang1];
    
    _dengguang2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_dengguang2.png"]];
    [_dengguang2 setFrame:CGRectMake(LENGTH_BILI_W*210, LENGTH_BILI_W*15, LENGTH_BILI_W*150, LENGTH_BILI_W*200)];
    [_dengguang2 setUserInteractionEnabled:YES];
    [imageView addSubview:_dengguang2];
    
    
    _headImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(LENGTH_BILI_W*135, LENGTH_BILI_W*50, LENGTH_BILI_W*50, LENGTH_BILI_W*50)];
    [_headImageBtn setBackgroundImage:[UIImage imageNamed:@"nan.png"] forState:UIControlStateNormal];
//    _headImageBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_touxiang"]];
    [_headImageBtn.layer setMasksToBounds:YES];
    _headImageBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    _headImageBtn.layer.borderWidth = 2.0;
    _headImageBtn.layer.cornerRadius = 25;
    [_headImageBtn setEnabled:YES];
    [imageView addSubview:_headImageBtn];
    
    _nameBtn = [[UILabel alloc]initWithFrame:CGRectMake(LENGTH_BILI_W*130, LENGTH_BILI_W*90, LENGTH_BILI_W*60, LENGTH_BILI_W*35)];
    [_nameBtn setBackgroundColor:[UIColor clearColor]];
    _nameBtn.text = @"";
    [_nameBtn setTextColor:[UIColor whiteColor]];
    [_nameBtn setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
    [_nameBtn setNumberOfLines:3];
    [_nameBtn setTextAlignment:NSTextAlignmentCenter];
    [imageView addSubview:_nameBtn];
    
    
    _xianjinBtn = [[UIButton alloc]initWithFrame:CGRectMake(LENGTH_BILI_W*70, LENGTH_BILI_W*80, LENGTH_BILI_W*60, LENGTH_BILI_W*60.0/50*58)];
    [_xianjinBtn setBackgroundImage:[UIImage imageNamed:@"img_d_xj.png"] forState:UIControlStateNormal];
    _xianjinBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    _xianjinBtn.layer.borderWidth = 0.5;
    _xianjinBtn.layer.cornerRadius = 2.0;
    [imageView addSubview:_xianjinBtn];
    
    _jifenBtn = [[UIButton alloc]initWithFrame:CGRectMake(LENGTH_BILI_W*185, LENGTH_BILI_W*80, LENGTH_BILI_W*60, LENGTH_BILI_W*60.0/50*58)];
    [_jifenBtn setBackgroundImage:[UIImage imageNamed:@"img_d_inte.png"] forState:UIControlStateNormal];
    _jifenBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    _jifenBtn.layer.borderWidth = 0.5;
    _jifenBtn.layer.cornerRadius = 2.0;
    [imageView addSubview:_jifenBtn];
    
    [self startAnimation0];

}

//- (void) kaichangDonghua
//{
//    dengguang0.layer.anchorPoint = CGPointMake(0, 0.5) ;
//    dengguang0.layer.transform = CATransform3DMakeRotation((M_PI*0.2)/180,0,0,1);
////    CGAffineTransform endAngle = CGAffineTransformMakeRotation(0.2 * (M_PI / 180.0f));
////    
////    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
////        dengguang0.transform = endAngle;
////    } completion:^(BOOL finished) {
////        angle += 10;
////        [self kaichangDonghua];
////    }];
//}

- (void)startAnimation0
{
    [_dengguang0 setHidden:NO];
    [_dengguang2 setHidden:NO];
    
    CGAffineTransform endAngle0 = CGAffineTransformMakeRotation(_angle0 * (M_PI / 180.0f));
    CGAffineTransform endAngle2 = CGAffineTransformMakeRotation(_angle2 * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _dengguang0.layer.anchorPoint = CGPointMake(0.5f,0.0f);//围绕点
//        _dengguang0.layer.position = CGPointMake(285, 15);//位置</span>
        _dengguang0.layer.position = CGPointMake(LENGTH_BILI_W*40, LENGTH_BILI_W*18);//位置</span>

        _dengguang0.transform = endAngle0;
        
        _dengguang2.layer.anchorPoint = CGPointMake(0.5f,0.0f);//围绕点
        _dengguang2.layer.position = CGPointMake(LENGTH_BILI_W*285, LENGTH_BILI_W*15);//位置</span>
        //        dengguang0.layer.position = CGPointMake(40, 18);//位置</span>
        
        _dengguang2.transform = endAngle2;
        
        _dengguang0.alpha = _myAlpha;
        _dengguang2.alpha = _myAlpha;
        
    } completion:^(BOOL finished) {
        _angle0 -= 10;
        _angle2 += 10;
        _myAlpha += 0.06;
        if (_angle2 <= 30) {
            [self startAnimation0];
        }
        
    }];
}

- (void)startAnimation1
{
    
    [_dengguang1 setHidden:NO];
    _dengguang1.alpha = 0.0f;
    [UIView animateWithDuration:0.2 animations:^{
        _dengguang1.alpha = 1.0f;
        _dengguang1.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.0);}
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.12 animations:^{
                             _dengguang1.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);} completion:^(BOOL finished) {
                                 
                                 [UIView animateWithDuration:0.12 animations:^{
                                     _dengguang1.transform = CGAffineTransformIdentity;
                                 } completion:^(BOOL finished) {
                                     NSLog(@"hello");
                                     
                                 }];
                             }];
                     }];
    
}


@end

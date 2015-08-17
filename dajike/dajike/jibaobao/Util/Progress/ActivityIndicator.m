//
//  ActivityIndicator.m
//  RuYi
//
//  Created by DLin on 14-10-31.
//  Copyright (c) 2014-2015 DLin. All rights reserved.
//
//获取屏幕宽高
#define MAIN_SCREEN_WIDTH   [[UIScreen mainScreen] applicationFrame].size.width
#define MAIN_SCREEN_HEIGHT ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?[[UIScreen mainScreen] applicationFrame].size.height+20:[[UIScreen mainScreen] applicationFrame].size.height)
#import "ActivityIndicator.h"

static ActivityIndicator *_indicator;
@implementation ActivityIndicator
{
    MBProgressHUD *_HUD;
    
    NSTimer *timer;
    
    BOOL _isAnimating;
    
    //    UIControl *_control;
    //如医icon
    UIImageView *_ruyiImageView;
    //转圈实体
//    UIImageView *_circleImageView;
    
    // 定时器
    NSTimer *_timer;
    
}
- (id)init
{
    self = [super init];
    if(self)
    {
        _control = [[UIControl alloc]init];
        _control.frame = CGRectMake(0, 64, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-64);
        _ruyiImageView = [[UIImageView alloc]init];
        _ruyiImageView.image = [UIImage imageNamed:@"loading01.jpg"];
        _ruyiImageView.frame = CGRectMake(0, 0, _control.frame.size.width, _control.frame.size.height);
        [_control addSubview:_ruyiImageView];
        
        //        _circleImageView = [[UIImageView alloc]init];
        //        _circleImageView.frame = CGRectMake((MAIN_SCREEN_WIDTH-80)/2, (MAIN_SCREEN_HEIGHT-80-64)/2, 80, 80);
        //        _circleImageView.image = [UIImage imageNamed:@"img_touxiang"];
        //        [_control addSubview:_circleImageView];
        //        _control.backgroundColor = [UIColor redColor];
    }
    return self;
}
- (void)progressHudShowInView:(UIView *)view
{
    //    _HUD = [[MBProgressHUD alloc] initWithView:view];
    //    [view addSubview:_HUD];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        [view addSubview:_control];
        //    [self chrysanthemumAnimation];
        //定时器，设定时间过1.5秒，
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(chrysanthemumAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _isAnimating = YES;
        //    [_HUD show:YES];
    });

}
// 转动菊花
-(void)chrysanthemumAnimation{
    //    [self btnClickWithBlock:^{
    //        _circleImageView.transform = CGAffineTransformRotate(_circleImageView.transform, M_PI_2);
    //    }];
    if ([_ruyiImageView.image isEqual:[UIImage imageNamed:@"loading01.jpg"]]) {
        _ruyiImageView.image = [UIImage imageNamed:@"loading02.jpg"];
    }else if ([_ruyiImageView.image isEqual:[UIImage imageNamed:@"loading02.jpg"]]){
        _ruyiImageView.image = [UIImage imageNamed:@"loading021.jpg"];
    }else if ([_ruyiImageView.image isEqual:[UIImage imageNamed:@"loading021.jpg"]]){
        _ruyiImageView.image = [UIImage imageNamed:@"loading02.jpg"];
    }
    
    
}
- (void)btnClickWithBlock:(void (^)())block
{
    // 0.动画（头部-开始动画）
    [UIView beginAnimations:nil context:nil];
    // 设置动画的执行时间
    [UIView setAnimationDuration:0.4];
    
    block();
    
    // 1.动画（尾部-提交动画-执行动画）
    [UIView commitAnimations];
}

- (void)progresshHUDRemoved
{
    _ruyiImageView.image = [UIImage imageNamed:@"loading02.jpg"];
    [self performSelector:@selector(do1) withObject:self afterDelay:0.3];
    
    //    [_HUD hide:YES];
    //    [_HUD removeFromSuperview];
}
-(void)do1
{
    _ruyiImageView.image = [UIImage imageNamed:@"loading03.jpg"];
    [self performSelector:@selector(do2) withObject:self afterDelay:0.3];
}
-(void)do2
{
    _ruyiImageView.image = [UIImage imageNamed:@"loading04.jpg"];
    [self performSelector:@selector(do3) withObject:self afterDelay:0.4];
}
- (void) do3
{
    _ruyiImageView.image = [UIImage imageNamed:@"loading01.jpg"];
    _isAnimating = NO;
    [_timer invalidate];
    [_control removeFromSuperview];
}
- (void)progresshHUDRemovedFast
{
    _ruyiImageView.image = [UIImage imageNamed:@"loading01.jpg"];
    _isAnimating = NO;
    [_timer invalidate];
    [_control removeFromSuperview];
}
- (BOOL)isAnimating
{
    return _isAnimating;
}
+ (id)sharedManager
{
    if(!_indicator)
    {
        _indicator = [[ActivityIndicator alloc]init];
    }
    return _indicator;
}

//设置Frame
- (void) reSetFrame:(CGRect)frame
{
    _control.frame = frame;
    _ruyiImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//    _ruyiImageView.frame = frame;
    //    _circleImageView.frame = CGRectMake((frame.size.width-80)/2, (frame.size.height-80)/2, 80, 80);
}
@end

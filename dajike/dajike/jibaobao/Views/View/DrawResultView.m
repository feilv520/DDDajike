//
//  DrawResultView.m
//  jibaobao
//
//  Created by dajike on 15/6/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "DrawResultView.h"
@interface DrawResultView()
{
    //存放抽奖结果图片
    NSMutableArray *_choujingImageArr;
    UIView *tanChuangV;
    UIScrollView *scrollV;
}
@end

@implementation DrawResultView
////单例
//static DrawResultView * _sharedDrawsult = nil;
//+ (DrawResultView *) sharedDrawResultView
//{
//    if (_sharedDrawsult == nil)
//    {
//        _sharedDrawsult = [[self alloc] initWithFrame:CGRectMake(10, 100, 300, 150)];
//    }
//    return _sharedDrawsult;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tanChuangV = [[UIView alloc]initWithFrame:self.frame];
        tanChuangV.layer.masksToBounds = YES;
        tanChuangV.layer.cornerRadius = 6.0;
        tanChuangV.backgroundColor = [UIColor whiteColor];
        [tanChuangV setUserInteractionEnabled:YES];
        [self addSubview:tanChuangV];
        
        _closeButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-45, 5, 20, 20)];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"img_cha.png"] forState:UIControlStateNormal];
//        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [tanChuangV addSubview:_closeButton];
        
        scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, tanChuangV.frame.size.width, tanChuangV.frame.size.height-30)];
        [scrollV setScrollEnabled:YES];
        [tanChuangV addSubview:scrollV];
        
        
    }
    return self;
}
- (void) setResultWithArr:(NSArray *)resultArr
{
    if (_choujingImageArr != nil) {
        [_choujingImageArr removeAllObjects];
        _choujingImageArr = nil;
    }
    _choujingImageArr = [[NSMutableArray alloc]init];
    
    for (NSString * objc in resultArr) {
        NSInteger jingInt = [objc integerValue];
        if (jingInt < 10) {//现金奖
            switch (jingInt) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    [_choujingImageArr addObject:@"img_y_09.png"];
                }
                    break;
                case 2:
                {
                    [_choujingImageArr addObject:@"img_y_11.png"];
                }
                    break;
                case 3:
                {
                    [_choujingImageArr addObject:@"img_y_10.png"];
                }
                    break;
                case 4:
                {
                    [_choujingImageArr addObject:@"img_y_08.png"];
                }
                    break;
                case 5:
                {
                    [_choujingImageArr addObject:@"img_y_07.png"];
                }
                    break;
                    
                default:
                    break;
            }
        }else{//积分奖
            switch (jingInt) {
                case 11:
                {
                    [_choujingImageArr addObject:@"img_y_04.png"];
                }
                    break;
                case 12:
                {
                    [_choujingImageArr addObject:@"img_y_06.png"];
                }
                    break;
                case 13:
                {
                    [_choujingImageArr addObject:@"img_y_05.png"];
                }
                    break;
                case 14:
                {
                    [_choujingImageArr addObject:@"img_y_03.png"];
                    
                }
                    break;
                case 15:
                {
                    [_choujingImageArr addObject:@"img_y_02.png"];
                }
                    break;
                    
                default:
                    break;
            }

        }
    }
    
    if (_choujingImageArr.count == 0) {
        //谢谢参与
        [_choujingImageArr addObject:@"img_y_xiexie.png"];
    }
    
    //按规则摆放
//    if (_choujingImageArr.count > 0) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:0]]];
//        [imageV setFrame:CGRectMake(128, 81, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 1) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:1]]];
//        [imageV setFrame:CGRectMake(79, 81, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 2) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:2]]];
//        [imageV setFrame:CGRectMake(172, 81, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 3) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:3]]];
//        [imageV setFrame:CGRectMake(60, 24, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 4) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:4]]];
//        [imageV setFrame:CGRectMake(105, 24, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 5) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:5]]];
//        [imageV setFrame:CGRectMake(148, 24, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 6) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:6]]];
//        [imageV setFrame:CGRectMake(193, 24, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 7) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:7]]];
//        [imageV setFrame:CGRectMake(60, 130, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 8) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:8]]];
//        [imageV setFrame:CGRectMake(105, 130, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 9) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:9]]];
//        [imageV setFrame:CGRectMake(148, 130, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 10) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:10]]];
//        [imageV setFrame:CGRectMake(193, 130, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
    
    
    
    
    
    //按规则摆放
    for (int i = 0; i < _choujingImageArr.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:0]]];
        [imageV setFrame:CGRectMake(25+(i%5)*50, (i/5)*57, 50, 46)];
        [imageV setContentMode:UIViewContentModeScaleAspectFit];
        [scrollV addSubview:imageV];
    }
    if (_choujingImageArr.count > 15) {
        scrollV.contentSize = CGSizeMake(scrollV.frame.size.width, 46+(_choujingImageArr.count/5 + (_choujingImageArr.count%5>0?1:0))*46);
    }
//    if (_choujingImageArr.count > 0) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:0]]];
//        [imageV setFrame:CGRectMake(60, 24, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 1) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:1]]];
//        [imageV setFrame:CGRectMake(105, 24, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 2) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:2]]];
//        [imageV setFrame:CGRectMake(148, 24, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 3) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:3]]];
//        [imageV setFrame:CGRectMake(193, 24, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 4) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:4]]];
//        [imageV setFrame:CGRectMake(128, 81, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 5) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:5]]];
//        [imageV setFrame:CGRectMake(79, 81, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 6) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:6]]];
//        [imageV setFrame:CGRectMake(172, 81, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 7) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:7]]];
//        [imageV setFrame:CGRectMake(60, 130, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 8) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:8]]];
//        [imageV setFrame:CGRectMake(105, 130, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 9) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:9]]];
//        [imageV setFrame:CGRectMake(148, 130, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }
//    if (_choujingImageArr.count > 10) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_choujingImageArr objectAtIndex:10]]];
//        [imageV setFrame:CGRectMake(193, 130, 37, 46)];
//        [tanChuangV addSubview:imageV];
//    }else{
//        return;
//    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (void) show
//{
//    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    
//    while (topController.presentedViewController) {
//        topController = topController.presentedViewController;
//    }
//    UIView *rootView = topController.view;
////    CGRect frame;
////    frame.size.height = 100;
////    frame.size.width = rootView.bounds.size.width-40;
////    self.frame = frame;
//    
////    self.frame = rootView.bounds;
//
//    [self setFrame:CGRectMake(0, 0, rootView.bounds.size.width-40, 150)];
////    self.center = rootView.center;
//    [rootView addSubview:self];
//    [rootView bringSubviewToFront:self];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        self.alpha = 1.0f;
//        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);}
//                     completion:^(BOOL finished) {
//                         
//                         [UIView animateWithDuration:0.12 animations:^{
//                             self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);} completion:^(BOOL finished) {
//                                 
//                                 [UIView animateWithDuration:0.12 animations:^{
//                                     self.transform = CGAffineTransformIdentity;
//                                 } completion:^(BOOL finished) {
//                                     NSLog(@"hello");
//                                     
//                                 }];
//                             }];
//                     }];
//}
//
//- (void) close
//{
//   
//    [self removeFromSuperview];
//    //    CGRect frame;
//    //    frame.size.height = 100;
//    //    frame.size.width = rootView.bounds.size.width-40;
//    //    self.frame = frame;
//    
//    //    self.frame = rootView.bounds;
//    
//    
//}
//


@end

//
//  BrowserViewBg.m
//  jibaobao
//
//  Created by swb on 15/7/3.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "BrowserViewBg.h"
#import "defines.h"
#import "SwbClickImageView.h"
#import "ImgScrollView.h"

@implementation BrowserViewBg
{
    UIView *markView;
    UIScrollView *myScrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color_Clear;
        self.alpha = 0;
        [self initPhotoBrowse];
    }
    return self;
}

- (void)initPhotoBrowse
{
    markView = [[UIView alloc] initWithFrame:self.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [self addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    [self addSubview:myScrollView];
}

- (void)show:(id)myView
{
//    [self.view bringSubviewToFront:scrollPanel];
    self.alpha = 1.0;
    
    SwbClickImageView *tmpView = myView;
    
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = self.currentIndex*WIDTH_CONTROLLER_DEFAULT;
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgView];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImg:tmpView.image];
    [tmpImgScrollView callBackImgScrollView:^(ImgScrollView *imgScrollView) {
        ImgScrollView *tmpImgView = imgScrollView;
        
        [UIView animateWithDuration:0.5 animations:^{
            markView.alpha = 0;
            [tmpImgView rechangeInitRect];
        } completion:^(BOOL finished) {
            self.alpha = 0;
        }];
    }];
    [myScrollView addSubview:tmpImgScrollView];
    
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark - custom method
- (void) addSubImgView
{
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.bounds.size.height;
    contentSize.width = WIDTH_CONTROLLER_DEFAULT * self.imgArr.count;
    myScrollView.contentSize = contentSize;
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < self.imgArr.count; i ++)
    {
        if (i == self.currentIndex)
        {
            continue;
        }
        
        SwbClickImageView *tmpView = (SwbClickImageView *)[self.imgViewSuperView viewWithTag:10+i];
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:[UIApplication sharedApplication].keyWindow];
        
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImg:tmpView.image];
        [myScrollView addSubview:tmpImgScrollView];
        [tmpImgScrollView callBackImgScrollView:^(ImgScrollView *imgScrollView) {
            ImgScrollView *tmpImgView = imgScrollView;
            
            [UIView animateWithDuration:0.5 animations:^{
                markView.alpha = 0;
                [tmpImgView rechangeInitRect];
            } completion:^(BOOL finished) {
                self.alpha = 0;
            }];
        }];
        [tmpImgScrollView setAnimationRect];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

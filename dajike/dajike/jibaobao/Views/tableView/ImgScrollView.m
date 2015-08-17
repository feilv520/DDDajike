//
//  ImgScrollView.m
//  jibaobao
//
//  Created by swb on 15/7/3.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "ImgScrollView.h"

@interface ImgScrollView()<UIScrollViewDelegate>
{
    UIImageView *imgView;
    //记录自己的位置
    CGRect scaleOriginRect;
    //图片的大小
    CGSize imgSize;
    //缩放前大小
    CGRect initRect;
}

@end

@implementation ImgScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        self.bouncesZoom = YES;//设置scrollview的bouncesZoom属性可以确保view的放缩比例超出设置比例范围时自动进行反弹。
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0f;
        
        imgView = [[UIImageView alloc]init];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imgView];
    }
    return self;
}

- (void)setContentWithFrame:(CGRect)rect
{
    imgView.frame = rect;
    initRect = rect;
}

- (void)setAnimationRect
{
    imgView.frame = scaleOriginRect;
}

- (void)rechangeInitRect
{
    self.zoomScale = 1.0f;
    imgView.frame = initRect;
}

- (void)setImg:(UIImage *)img
{
    if (img) {
        imgView.image = img;
        imgSize = img.size;
        
        //首先判断缩放的值
        float scaleX = self.frame.size.width/imgSize.width;
        float scaleY = self.frame.size.height/imgSize.height;
        
        //倍数小的先到边缘
        if (scaleX > scaleY) {
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
            self.maximumZoomScale = self.frame.size.width/imgViewWidth;
            
            scaleOriginRect = (CGRect){
                self.frame.size.height/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height
            };
        }else {
            //X方向先到边缘
            float imgViewHeight = imgSize.height*scaleX;
            self.maximumZoomScale = self.frame.size.height/imgViewHeight;
            
            scaleOriginRect = (CGRect){
                0,(self.frame.size.height-imgViewHeight)/2,self.frame.size.width,imgViewHeight
            };
        }
    }
}
#pragma mark - scroll delegate
/*
 1.实现UIScrollView的缩放，必须使maximumZoomScale（默认1.0）和minimumZoomScale（默认1.0）不同 ，并且需要在delegate中的viewForZoomingInScrollView: 方法中返回需要所放的view。实现以上即可进行缩放。
 
 */

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //如果想要scrollview 实现缩放 则需要给scrollview.delegate 对一个UIScrollViewDelegate 对象
    //且 此对象需要覆写viewForZoomingInScrollView 方法。
    //总结:只有 scrollview的delegate复写了viewForZoomingInScrollView scrollview才会缩放。
    return imgView;
}
//注意：
//viewForZoomingInScrollView方法返回的view是scrollview确定contentsize的view。contentsize的大小与该view的frame.size相同；在放缩的同时scrollview会自动设定zoomscale属性的大小，与每次放缩结束的scrollViewDidEndZooming:withView:atScale 中的scale相同。每次放缩过程中，所放缩的view的bound不会改变而frame会改变（这同修改view的transform属性的效果相同）放缩会改变frame，改变view在父视图的位置，而不会改变bound大小。推测放缩也是通过affinetransform进行改变。所以对需要固定位置的view，需要在每次scrollViewDidZoom中修改view的位置
//例如如下代码实现固定ImageView始终在整个content的居中位置：
/*
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ?
    
    scrollView.contentSize.width/2 : xcenter;
    
    //同上，此处修改y值
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?
    
    scrollView.contentSize.height/2 : ycenter;
    
    [[scrollView viewWithTag:imageview] setCenter:CGPointMake(xcenter, ycenter)];
    
}
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = imgView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    //固定imgView始终在整个content的居中位置
    if (imgFrame.size.width <= boundsSize.width) {
        centerPoint.x = boundsSize.width/2;
    }
    if (imgFrame.size.height <= boundsSize.height) {
        centerPoint.y = boundsSize.height/2;
    }
    imgView.center = centerPoint;
}
- (void)callBackImgScrollView:(CallBackImgScollView)block
{
    self.block = block;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.block(self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
 
 scroll view 原理
 
 在滚动过程当中，其实是在修改原点坐标。当手指触摸后, scroll view会暂时拦截触摸事件,使用一个计时器。假如在计时器到点后没有发生手指移动事件，那么 scroll view 发送tracking events 到被点击的 subview。假如在计时器到点前发生了移动事件，那么scroll view 取消 tracking 自己发生滚动。
 
 子类可以重载
 
 touchesShouldBegin:withEvent:inContentView: 决定自己是否接收 touch 事件
 pagingEnabled：当值是 YES 会自动滚动到 subview 的边界，默认是NO
 touchesShouldCancelInContentView: 开始发送 tracking messages 消息给subview 的时候调用这个方法，决定是否发送 tracking messages 消息到subview。假如返回NO，发送。YES 则不发送。
 假如canCancelContentTouches属性是NO，则不调用这个方法来影响如何处理滚动手势。
 
 scroll view 还处理缩放和平移手势，要实现缩放和平移，必须实现委托viewForZoomingInScrollView:、scrollViewDidEndZooming:withView:atScale:
 两个方法。另外maximumZoomScale和minimumZoomScale 两个属性要不一样。
 
 几个属性介绍
 
 tracking
 当 touch 后还没有拖动的时候值是YES，否则NO
 
 zoomBouncing
 当内容放大到最大或者最小的时候值是 YES，否则NO
 
 zooming
 当正在缩放的时候值是 YES，否则 NO
 
 decelerating
 当滚动后，手指放开但是还在继续滚动中。这个时候是 YES，其它时候是 NO
 
 decelerationRate
 设置手指放开后的减速率
 
 maximumZoomScale
 一个浮点数，表示能放最大的倍数
 
 minimumZoomScale
 一个浮点数，表示能缩最小的倍数
 
 pagingEnabled
 当值是 YES 会自动滚的那个到 subview 的边界。默认是NO
 
 scrollEnabled
 决定是否可以滚动
 
 delaysContentTouches
 是个布尔值，当值是 YES 的时候，用户触碰开始，scroll view要延迟一会，看看是否用户有意图滚动。假如滚动了，那么捕捉 touch-down 事件，否则就不捕捉。假如值是NO，当用户触碰， scroll view会立即触发touchesShouldBegin:withEvent:inContentView:，默认是 YES
 
 canCancelContentTouches
 当值是 YES 的时候，用户触碰后，然后在一定时间内没有移动，scrollView 发送 tracking events，然后用户移动手指足够长度触发滚动事件，这个时候，scrollView 发送了 touchesCancelled:withEvent:到 subview，然后 scroView 开始滚动。假如值是 NO，scrollView 发送tracking events 后，就算用户移动手指，scrollView 也不会滚动。
 
 contentSize
 里面内容的大小，也就是可以滚动的大小，默认是0，没有滚动效果。
 
 showsHorizontalScrollIndicator
 滚动时是否显示水平滚动条
 
 showsVerticalScrollIndicator
 滚动时是否显示垂直滚动条
 
 bounces
 默认是 yes，就是滚动超过边界会反弹有反弹回来的效果。假如是NO，那么滚动到达边界会立刻停止。
 
 bouncesZoom
 和 bounces 类似,区别在于：这个效果反映在缩放上面，假如缩放超过最大缩放，那么会反弹效果；假如是NO，则到达最大或者最小的时候立即停止。
 
 directionalLockEnabled
 默认是 NO，可以在垂直和水平方向同时运动。当值是YES 时，假如一开始是垂直或者是水平运动，那么接下来会锁定另外一个方向的滚动。 假如一开始是对角方向滚动，则不会禁止某个方向
 
 indicatorStyle
 滚动条的样式，基本只是设置颜色。总共3个颜色：默认、黑、白
 
 scrollIndicatorInsets
 设置滚动条的位置
*/

@end

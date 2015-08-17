//
//  ViewController.m
//  jibaobao
//
//  Created by dajike on 15/4/23.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "ViewController.h"
#import "SWBTabBarController.h"
#import "AppDelegate.h"
#import "defines.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scrollerView;
    UIPageControl *pageControl;
    NSArray *images;
    BOOL isloaded;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([FileOperation getobjectForKey:isFirstOpen ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]] == NO) {
        //首次打开
        NSLog(@"dddddww = %@",[FileOperation creatPlistIfNotExist:SET_PLIST]);
        NSLog(@"ddddd = %@",[FileOperation getobjectForKey:isFirstOpen ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]]);
        [self addScrollAndPageController];
        //isFirstOpen 设为1
        [FileOperation setPlistObject:@"1" forKey:isFirstOpen ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
    }else{
        //不显示引导页面
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [self addTabBarViews];
    }
}

- (void) addTabBarViews
{
    SWBTabBarController *tabbarVC = [SWBTabBarController sharedManager];
    
    [self setRootVC:tabbarVC];
    
}



- (void)setRootVC:(id)sender
{
    //获取当前的应用程序
    UIApplication *app = [UIApplication sharedApplication];
    //委托
    AppDelegate *del = app.delegate;
    //设置根视图
    del.window.rootViewController = sender;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//欢迎界面
#pragma mark-----
#pragma mark-------Start  First---------
- (void) addScrollAndPageController
{
    scrollerView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(80, self.view.frame.size.height-130, 160, 80)];
    images = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"djksy02.jpg"],[UIImage imageNamed:@"djksy03.jpg"], [UIImage imageNamed:@"djksy04.jpg"],nil];
    [self.view addSubview:scrollerView];
    [self.view addSubview:pageControl];
    [pageControl setHidden:NO];
    [pageControl setCurrentPageIndicatorTintColor:Color_mainColor];
    [pageControl setPageIndicatorTintColor:Color_pageRed];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpPage];
}


#pragma mark--------setUpPage-----------
- (void)setUpPage
{
    scrollerView.delegate = self;
    scrollerView.backgroundColor = [UIColor blackColor];
    scrollerView.bounces = YES;
    scrollerView.canCancelContentTouches =  NO;
    scrollerView.indicatorStyle = UIActivityIndicatorViewStyleWhite;
    scrollerView.clipsToBounds = YES;
    scrollerView.scrollEnabled = YES;//允许缩放
    scrollerView.pagingEnabled = YES;//允许画面切换
    scrollerView.directionalLockEnabled = NO;//设置在拖拽的时候锁定其在水平或者垂直的方向
    scrollerView.alwaysBounceHorizontal = NO;
    scrollerView.alwaysBounceVertical = NO;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.showsVerticalScrollIndicator = NO;
    
    NSUInteger pages = 0;//用来记录页数
    int originx = 0;//用来纪录scrollView的x坐标
    
    for (UIImage *image in images)
    {   //创建一个视图
        UIImageView *pImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        //设置视图的背景色
        pImageView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        //设置imageView的背景图
        [pImageView setImage:image];
        
        //给imageView设置区域
        CGRect rect = scrollerView.frame;
        rect.origin.x = originx;
        rect.origin.y = 0;
        rect.size.width = scrollerView.frame.size.width;
        rect.size.height = scrollerView.frame.size.height;
        pImageView.frame = rect;
        
        //设置图片内容的显示模式(自适应模式)
        //        pImageView.contentMode = UIViewContentModeScaleAspectFill;
        pImageView.contentMode = UIViewContentModeScaleToFill;
        [scrollerView addSubview:pImageView];
        //下一张视图的x坐标:offset为:self.scrollView.frame.size.width.
        originx += scrollerView.frame.size.width;
        //记录scrollView内imageView的个数
        pages++;
    }
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    //设置总页数
    pageControl.numberOfPages = pages;
    //默认当前页为第一页
    pageControl.currentPage = 0;
    pageControl.tag = 110;
    [scrollerView setContentSize:CGSizeMake(originx, scrollerView.bounds.size.height)];
}

#pragma mark  ------changePage:-------
- (void)changePage:(id)sender
{
    CGRect rect = scrollerView.frame;
    rect.origin.y = 0;
    [scrollerView scrollRectToVisible:rect animated:YES];
}

#pragma mark------scrollViewDidEndDecelerating:-------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollerView.frame.size.width;
    int page = floor((scrollerView.contentOffset.x -pageWidth/2)/pageWidth) + 1;
    pageControl.currentPage = page;
    
    //设置背景字幕
    if (pageControl.currentPage == 2)
    {
        UIButton *btn;
        btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/2.0-110, HEIGHT_CONTROLLER_DEFAULT-120, 220, 100)];
        
//                btn.backgroundColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.8 alpha:1];
        btn.backgroundColor = [UIColor clearColor];
        //        [btn setTitle:@"进入应用" forState:UIControlStateNormal];
        //允许显示高亮
        btn.showsTouchWhenHighlighted = YES;
//        [btn setBackgroundColor:[UIColor blueColor]];
        [btn addTarget:self action:@selector(inToApplication) forControlEvents:UIControlEventTouchDown];
        
        [self.view addSubview:btn];
    }else{
        for (UIView *vi in self.view.subviews) {
            if ([vi isKindOfClass:[UIButton class]]) {
                [vi setHidden:YES];
            }
            
        }
    }
}

//加载应用
- (void) inToApplication
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self addTabBarViews];
    
}


@end
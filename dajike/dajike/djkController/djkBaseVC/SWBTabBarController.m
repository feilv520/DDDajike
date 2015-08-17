//
//  SWBTabBarController.m
//  自定义选项卡
//
//  Created by swb on 15/7/6.
//  Copyright (c) 2015年 swb. All rights reserved.
//

#import "SWBTabBarController.h"
#import "TabView.h"
#import "SWBTabBar.h"
#import "dDefine.h"

#import "DMainViewController.h"
#import "DClassificationViewController.h"
#import "GouWuCheViewController.h"
//#import "DSearchViewController.h"
#import "DShouYeViewController.h"
#import "DBaseNavigationController.h"
#import "DMyCenterViewController.h"

static SWBTabBarController *mainTabBarController;

@interface SWBTabBarController ()<SWBTabBarDelegate>
//{
//    SWBTabBar *myView;
//}

@end

@implementation SWBTabBarController
@synthesize myView;

+ (SWBTabBarController *)sharedManager
{
    @synchronized(self){
        if (mainTabBarController == nil) {
            mainTabBarController = [[self alloc]init];
        }
    }
    return mainTabBarController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTabBarAndVCs];
    //删除现有的tabBar
//    CGRect rect = self.tabBar.bounds; //这里要用bounds来加, 否则会加到下面去.看不见
//    LogFrame(self.tabBar);
    //[self.tabBar removeFromSuperview];  //移除TabBarController自带的下部的条
    
    //测试添加自己的视图
    myView = [[SWBTabBar alloc] initWithFrame:DRect(0, DHEIGHT_CONTROLLER_DEFAULT-49, DWIDTH_CONTROLLER_DEFAULT, 49)]; //设置代理必须改掉前面的类型,不能用UIView
    myView.delegate = self; //设置代理
//    myView.frame = rect;
//    myView.backgroundColor = DColor_252525;
    myView.backgroundColor = DColor_Clear;
    [self.view addSubview:myView];
//    [self.tabBar addSubview:myView]; //添加到系统自带的tabBar上, 这样可以用的的事件方法. 而不必自己去写
    NSLog(@"%@",self.tabBar.subviews);
    self.tabBar.hidden = YES;
    //为控制器添加按钮
    for (int i=0; i<self.viewControllers.count; i++) { //根据有多少个子视图控制器来进行添加按钮
        
//        NSString *imageName = [NSString stringWithFormat:@"2_03"];
//        NSString *imageNameSel = [NSString stringWithFormat:@"img_cha"];
//        
//        UIImage *image = [UIImage imageNamed:imageName];
//        UIImage *imageSel = [UIImage imageNamed:imageNameSel];
        
//        [myView addButtonWithImage:image selectedImage:imageSel];
        [myView addButtonWithImage:nil selectedImage:nil];
//        [myView addViewWithFrame:CGRectMake(i*(self.tabBar.bounds.size.width/self.viewControllers.count), 0, self.tabBar.bounds.size.width/self.viewControllers.count, 49)];
    }
    
    NSLog(@"%@",myView.subviews);
    
}
/**永远别忘记设置代理*/
- (void)tabBar:(SWBTabBar *)tabBar selectedFrom:(NSInteger)from to:(NSInteger)to {
    self.selectedIndex = to;
}

- (void) addTabBarAndVCs
{
    //-------------首页----------------
    
    DShouYeViewController *vc1 = [[DShouYeViewController alloc]init];
    DBaseNavigationController *nav0VC = [[DBaseNavigationController alloc]initWithRootViewController:vc1];
    UITabBarItem *item0 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
    vc1.tabBarItem = item0;
    
    //-------------分类----------------
    DClassificationViewController *vc2 = [[DClassificationViewController alloc]initWithNibName:nil bundle:nil];
    DBaseNavigationController *nav1VC = [[DBaseNavigationController alloc]initWithRootViewController:vc2];
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
    vc2.tabBarItem = item1;
    //-------------购物车----------------
    GouWuCheViewController *vc3 = [[GouWuCheViewController alloc]init];
    DBaseNavigationController *nav2VC = [[DBaseNavigationController alloc]initWithRootViewController:vc3];
    //    _VC2 = [[DrawMainViewController alloc]initWithNibName:nil bundle:nil];
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:3];
    vc3.tabBarItem = item2;
    //-------------搜索----------------
//    DSearchViewController *vc4 = [[DSearchViewController alloc]init];
//    DBaseNavigationController *nav3VC = [[DBaseNavigationController alloc]initWithRootViewController:vc4];
//    //    nav3VC.navigationItem.title = @"个人中心";
//    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:4];
//    vc4.tabBarItem = item3;
    //--------------我的 ----------------------
    DMyCenterViewController *vc5 = [[DMyCenterViewController alloc]init];
    DBaseNavigationController *nav4VC = [[DBaseNavigationController alloc]initWithRootViewController:vc5];
    //    nav3VC.navigationItem.title = @"个人中心";
    UITabBarItem *item4 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:4];
    vc5.tabBarItem = item4;
    
    [self setViewControllers:[NSArray arrayWithObjects:nav0VC,nav1VC,nav2VC,nav4VC, nil] animated:YES];
//    self.tabBar.hidden = YES;
    
    //------ 手势 --------------
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGR:)];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGR:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
}

- (void)swipeGR:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"往左滑");
        if (self.selectedIndex != self.viewControllers.count-1) {
            [myView swipe:(int)self.selectedIndex+1];
        }else
            return;
        
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"往右滑");
        if (self.selectedIndex != 0) {
            [myView swipe:(int)self.selectedIndex-1];
        }else
            return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

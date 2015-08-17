//
//  JTabBarController.m
//  jibaobao
//
//  Created by dajike on 15/4/23.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "JTabBarController.h"
#import "BackNavigationViewController.h"
#import "NavigationViewController.h"
#import "JMineViewController.h"
#import "defines.h"


#import "JShouyeMainViewController.h"

//#import "NearViewController.h"
#import "NearViewController.h"
#import "TabView.h"
#import "DrawMainViewController.h"


// 单例全局变量
static JTabBarController *mainFrameView;

@interface JTabBarController ()

@end

@implementation JTabBarController
{
//    //下面的tabbar
//    UIView *_tabBarView;
    
    //模块
    JShouyeMainViewController *_VC0;
    NearViewController *_VC1;
    DrawMainViewController *_VC2;
    JMineViewController *_VC3;
    
    NSMutableArray      *_imgArr;
    NSMutableArray      *_selectImgArr;
    NSMutableArray      *_titleArr;
}

//--------------------------------------
//   ------   主框架单例   -------
//--------------------------------------
#pragma mark 单例模式
+(JTabBarController *)sharedManager
{
    @synchronized(self) {
        if (mainFrameView == nil) {
            mainFrameView = [[self alloc] init];
        }
    }
    return mainFrameView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imgArr = [[NSMutableArray alloc]initWithObjects:@"img_home_h",@"img_add_h",@"img_lottery_h",@"img_my_h", nil];
    _selectImgArr = [[NSMutableArray alloc]initWithObjects:@"img_home_c",@"img_add_c",@"img_lottery_c",@"img_my_c", nil];
    _titleArr = [[NSMutableArray alloc]initWithObjects:@"首页",@"附近",@"抽奖",@"我的", nil];
    self.selectedIndex = 0;
    
    //----tabbar----
    [self addTabBarAndVCs];
}

- (void) addTabBarAndVCs
{
    //-------------大集客自营----------------
    
    _VC0 = [[JShouyeMainViewController alloc]init];
    UINavigationController *nav0VC = [[UINavigationController alloc]initWithRootViewController:_VC0];
    UITabBarItem *item0 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
    _VC0.tabBarItem = item0;
    
    //-------------区域直营----------------
    _VC1 = [[NearViewController alloc]initWithNibName:nil bundle:nil];
    _VC1.StoreListType = NEARBY;
    UINavigationController *nav1VC = [[UINavigationController alloc]initWithRootViewController:_VC1];
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
    _VC1.tabBarItem = item1;
    //-------------抽奖----------------
    _VC2 = [[DrawMainViewController alloc]init];
    UINavigationController *nav2VC = [[UINavigationController alloc]initWithRootViewController:_VC2];
//    _VC2 = [[DrawMainViewController alloc]initWithNibName:nil bundle:nil];
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:3];
    _VC2.tabBarItem = item2;
    //-------------我的----------------
    _VC3 = [[JMineViewController alloc]init];
    UINavigationController *nav3VC = [[UINavigationController alloc]initWithRootViewController:_VC3];
//    nav3VC.navigationItem.title = @"个人中心";
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:4];
    _VC3.tabBarItem = item3;
    
    //------------backColor---------
    _VC0.view.backgroundColor = Color_White;
    _VC1.view.backgroundColor = Color_White;
    _VC2.view.backgroundColor = Color_White;
    _VC3.view.backgroundColor = Color_White;
    
    //------------下边的tabbar的定制----------------
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [self setViewControllers:[NSArray arrayWithObjects:nav0VC,nav1VC,nav2VC,nav3VC, nil] animated:YES];
    //初始化定义tabbar背景
    self.tabBar.hidden = YES;
    _tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_CONTROLLER_DEFAULT-50, WIDTH_CONTROLLER_DEFAULT, 50)];
    _tabBarView.userInteractionEnabled = YES;
    _tabBarView.backgroundColor = [UIColor grayColor];
    _tabBarView.window.windowLevel = UIWindowLevelStatusBar;
//    NSLog(@"%f",UIWindowLevelAlert);
//    NSLog(@"%f",UIWindowLevelNormal);
//    NSLog(@"%f",UIWindowLevelStatusBar);
    [self.view addSubview:_tabBarView];
    
    // 最后通过设置按钮，添加到tabbar上，这里设置了5个TabBarItem,可以选择边测试边调节item的位置  49.0/2-10
    // 初始化定义tabbarItem
    float coordinax = self.view.frame.size.width/4;
    for (int index = 0; index < 4; index++) {
        TabView *tab = [[TabView alloc]initWithFrame:CGRectMake(index*coordinax, 0.5, coordinax, 49.5)];
        tab.tag = index+1;
        [tab.tabImgView setImage:[UIImage imageNamed:[_imgArr objectAtIndex:index]]];
        tab.tabLb.text = [_titleArr objectAtIndex:index];
        if (index == 0) {
            tab.tabImgView.image = [UIImage imageNamed:[_selectImgArr objectAtIndex:index]];
            tab.tabLb.textColor = Color_mainColor;
        }
        [tab callBackTabViewClicked:^(TabView *tabView) {
            NSLog(@"啊好看啥地方开始%@---%ld",_tabBarView.subviews,self.selectedIndex+1);
            TabView *tmpView = (TabView *)[_tabBarView viewWithTag:self.selectedIndex+1];
            tmpView.tabImgView.image = [UIImage imageNamed:[_imgArr objectAtIndex:self.selectedIndex]];
            tmpView.tabLb.textColor = Color_word_bg;
            self.selectedIndex = tabView.tag-1;
            
            tabView.tabImgView.image = [UIImage imageNamed:[_selectImgArr objectAtIndex:index]];
            tabView.tabLb.textColor = Color_mainColor;
        }];
        [_tabBarView addSubview:tab];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        
//        button.tag = index;
//        button.frame = CGRectMake(index*coordinax, 0.5, coordinax-0.6, 43.5);
//        
//        NSString *imageName;
//        switch (index) {
//            case 0:
//                imageName = @"首页";
//                break;
//                
//            case 1:
//                imageName = @"附近";
//                break;
//
//            case 2:
//                imageName = @"抽奖";
//                break;
//
//            case 3:
//                imageName = @"我的";
//                break;
//
//                
//            default:
//                break;
//        }
//        
//        
//        [button setTitle:imageName forState:UIControlStateNormal];
//        [button setTintColor:[UIColor grayColor]];
//        [button setBackgroundColor:[UIColor whiteColor]];
////        if (index == 0) {
////            [button setBackgroundColor:[UIColor whiteColor]];
////        }else{
////            [button setBackgroundColor:[UIColor blackColor]];
////        }
//        self.selectedIndex = 0;
//        
////        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
//        [_tabBarView addSubview:button];
        
//        [_tabBarView setHidden:YES];
//        [self.tabBar setBackgroundColor:[UIColor whiteColor]];
//        [self.tabBar setBarTintColor:[UIColor whiteColor]];
//        [self.tabBar setBackgroundColor:[UIColor redColor]];
//        [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"img_add_c.png"]];
    }

}
- (void) selectAtIndex:(NSInteger) selectIndex
{
    TabView *tmpView = (TabView *)[_tabBarView viewWithTag:self.selectedIndex+1];
    tmpView.tabImgView.image = [UIImage imageNamed:[_imgArr objectAtIndex:self.selectedIndex]];
    tmpView.tabLb.textColor = Color_word_bg;
    self.selectedIndex = selectIndex;
    
    TabView *tabView = (TabView *)[_tabBarView viewWithTag:self.selectedIndex+1];
    tabView.tabImgView.image = [UIImage imageNamed:[_selectImgArr objectAtIndex:self.selectedIndex]];
    tabView.tabLb.textColor = Color_mainColor;
}
#pragma mark 最后把按钮触发的控制器链接起来，用selectedIndex属性
-(void)changeViewController:(id) sender
{
    NSLog(@"dfdgf");
    for(UIButton *btn in _tabBarView.subviews){
    btn.backgroundColor = [UIColor blackColor];
    }
    
    
    UIButton *button   = (UIButton *) sender;
    self.selectedIndex = button.tag;
    button.backgroundColor = [UIColor redColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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

//
//  BackNavigationViewController.m
//  jibaobao
//
//  Created by dajike on 15/4/24.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "BackNavigationViewController.h"

#import "defines.h"

#import "JTabBarController.h"
#import "UIView+MyView.h"
//#import "UIView+NUI.h"

@interface BackNavigationViewController ()<UITableViewDelegate>


@end

@implementation BackNavigationViewController
{
    UIButton    *_searchBtn;        //搜索按钮
    UIButton    *_shearBtn;         //分享按钮
    UIButton    *_setBtn;           //设置按钮
    UIButton    *_messageBtn;       //消息按钮
    UIButton    *_storeBtn;         //收藏按钮
    UIButton    *_backBtn;          //返回按钮
    
    UIButton    *_scrollToTopBtn;   //列表滚回顶部按钮
}
//- (id)init
//{
//   if (self = [super initWithNibName:@"MainView" bundle:nil]) {
//        [self setModalPresentationStyle:UIModalPresentationFormSheet];
//        [self setModalInPopover:NO];
//        
//        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
//    
//    return self;
//}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setFont:Font_Nav];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
//        titleLabel.text = @"我的账户";
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置底层背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [backgroundImageView setImage:[UIImage imageNamed:@"bg_main.png"]];
    [self.view insertSubview:backgroundImageView atIndex:0];
    
//    [self addHeaderAndFooter];
    
    [self addScrollBtn];
}

//列表滚回顶部按钮
- (void)addScrollBtn
{
    _scrollToTopBtn = [self.view createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-50, HEIGHT_CONTROLLER_DEFAULT-150, 30, 30) andBackImageName:@"img_top" andTarget:self andAction:@selector(right1Cliped:) andTitle:nil andTag:55];
    [self.view addSubview:_scrollToTopBtn];
//    [self.view bringSubviewToFront:_scrollToTopBtn];
}

- (void)addTableView:(UITableViewStyle)style
{
    self.mainTabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64) style:style];
    self.mainTabview.delegate = self;
    [self.view addSubview:self.mainTabview];
    
    //添加无数据时的显示界面，正常情况下隐藏
    self.noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading_no_s"]];
    self.noDataView.contentMode = UIViewContentModeScaleAspectFit;
    [self.noDataView setFrame:CGRectMake(0, 0, self.mainTabview.frame.size.width, self.mainTabview.frame.size.height)];
    [self.mainTabview addSubview:self.noDataView];
    [self.noDataView setHidden:YES];
    
    //  列表 cell 从头开始显示  需要实现一个代理方法
    if ([self.mainTabview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTabview setSeparatorInset:UIEdgeInsetsZero];
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self.mainTabview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTabview setLayoutMargins:UIEdgeInsetsZero];
    }
#endif
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //底部tabBar隐藏
    JTabBarController *jTabBarVC = [JTabBarController sharedManager];
    [jTabBarVC.tabBarView setHidden:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //底部tabBar显现
    JTabBarController *jTabBarVC = [JTabBarController sharedManager];
    [jTabBarVC.tabBarView setHidden:NO];
    
    //视图退出后 凡是有键盘的  键盘退出
    for (UIView *View in self.view.subviews) {
        [View endEditing:YES];
    }

}



//左边返回按钮
- (void) addLeftBack
{
    //left barbutton
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setFrame:CGRectMake(0, 2, 15, 20)];
    [_backBtn setBackgroundImage:[UIImage imageNamed:imageNavBack] forState:UIControlStateNormal];
    [_backBtn.titleLabel setFont:Font_Default];
//    navLeftBtn.nuiClass = @"NavBackButton";
    [_backBtn addTarget:self action:@selector(navLeftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barLeftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem = barLeftButtonItem;
}
//右边按钮
- (UIButton *) addRightButtonOtemWithName:(NSString *)nameString andImageName:(NSString*)imageName
{
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navRightBtn setFrame:CGRectMake(0, 0, 34, 44)];
    [navRightBtn setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *messageImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 9, 25, 25)];
    [messageImage setImage:[UIImage imageNamed:imageName]];
    [messageImage setContentMode:UIViewContentModeScaleAspectFit];
    [navRightBtn addSubview:messageImage];
    
//    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 21, 34, 16)];
//    messageLabel.text = nameString;
////    messageLabel.nuiClass = @"ShouyeNavMessageLabel";
//    [messageLabel setFont:Font_Default];
//    messageLabel.numberOfLines = 1;
//    [messageLabel setTextAlignment:NSTextAlignmentCenter];
//    [navRightBtn addSubview:messageLabel];
    
//    [navRightBtn addTarget:self action:@selector(navRightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barRightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
//    barRightButtonItem.nuiClass = @"NavBarButtonItem";
//    [self.navigationItem setRightBarButtonItem:barRightButtonItem];
    return navRightBtn;
}
- (void)setNavType:(NavType)navType action:(NSString *)actionName
{
    //设置navigationBar
    if (self.navigationController) {
        if (navType == SEARCH_BUTTON) {
            [self addLeftBack];
            _searchBtn = [self addRightButtonOtemWithName:@"搜索" andImageName:imageSearch];
            [_searchBtn addTarget:self action:@selector(right1Cliped:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barRightButtonItem0 = [[UIBarButtonItem alloc] initWithCustomView:_searchBtn];
//            barRightButtonItem0.nuiClass = @"NavBarButtonItem";
            [self.navigationItem setRightBarButtonItem:barRightButtonItem0];
        }else if (navType == SHAREANGSHOUCANG_BUTTON) {
            [self addLeftBack];
            _shearBtn = [self addRightButtonOtemWithName:@"分享" andImageName:imageShare];
            [_shearBtn addTarget:self.delegate action:@selector(right1Cliped:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barRightButtonItem0 = [[UIBarButtonItem alloc] initWithCustomView:_shearBtn];
//            barRightButtonItem0.nuiClass = @"NavBarButtonItem";
            
            _storeBtn = [self addRightButtonOtemWithName:@"收藏" andImageName:imageStore];
            [_storeBtn addTarget:self.delegate action:@selector(right2Cliped:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barRightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:_storeBtn];
//            barRightButtonItem1.nuiClass = @"NavBarButtonItem";
            NSArray *arr = [NSArray arrayWithObjects:barRightButtonItem0,barRightButtonItem1, nil];
            [self.navigationItem setRightBarButtonItems:arr];
        }else if (navType == MINE_BUTTON) {
            _setBtn = [self addRightButtonOtemWithName:@"设置" andImageName:imageSet];
            [_setBtn addTarget:self.delegate action:@selector(left1Cliped:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barRightButtonItem0 = [[UIBarButtonItem alloc] initWithCustomView:_setBtn];
//            barRightButtonItem0.nuiClass = @"NavBarButtonItem";
            
            _messageBtn = [self addRightButtonOtemWithName:@"消息" andImageName:imageMessage];
            [_messageBtn addTarget:self.delegate action:@selector(right1Cliped:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barRightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:_messageBtn];
//            barRightButtonItem1.nuiClass = @"NavBarButtonItem";
            [self.navigationItem setLeftBarButtonItem:barRightButtonItem0];
            [self.navigationItem setRightBarButtonItem:barRightButtonItem1];
        }else if (navType == WORD_TYPE) {
            [self addLeftBack];
            UIButton *btn = [self.view createButtonWithFrame:CGRectMake(0, 0, 44, 44) andBackImageName:nil andTarget:self andAction:@selector(wordBtnCliped:) andTitle:actionName andTag:65];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIBarButtonItem *barRightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
            [self.navigationItem setRightBarButtonItem:barRightButtonItem1];
        }
    }

}
//返回按钮隐藏
- (void)setBackBtnHidden:(BOOL)hidden
{
    _backBtn.hidden = hidden;
}


//设置搜索按钮隐藏
- (void)setSearchBtnHidden:(BOOL)hidden
{
    if(hidden)
        _searchBtn.hidden = YES;
    else
        _searchBtn.hidden = NO;
}
//设置分享按钮隐藏
- (void)setShearBtnHidden:(BOOL)hidden
{
    if(hidden)
        _shearBtn.hidden = YES;
    else
        _shearBtn.hidden = NO;
}
//消息按钮隐藏
- (void)setMessageBtnHidden:(BOOL)hidden
{
    if(hidden)
        _messageBtn.hidden = YES;
    else
        _messageBtn.hidden = NO;
}
//设置按钮隐藏
- (void)setSetBtnHidden:(BOOL)hidden
{
    if(hidden)
        _setBtn.hidden = YES;
    else
        _setBtn.hidden = NO;
}
//收藏按钮隐藏
- (void)setStoreBtnHidden:(BOOL)hidden
{
    if(hidden)
        _storeBtn.hidden = YES;
    else
        _storeBtn.hidden = NO;
}

//滚回顶部按钮隐藏
- (void)setScrollBtnHidden:(BOOL)hidden
{
    if(hidden)
        _scrollToTopBtn.hidden = YES;
    else {
        _scrollToTopBtn.hidden = NO;
        [self.view bringSubviewToFront:_scrollToTopBtn];
    }
}

//- (void)setNavType:(NavType)navType action:(NSString *)actionName
//{
//    //设置navigationBar
//    if (self.navigationController) {
//        if (navType == SEARCH_BUTTON) {
//            [self addLeftBack];
//            UIButton *btn0 = [self addRightButtonOtemWithName:@"搜索" andImageName:imageSearch];
//            [btn0 addTarget:self action:@selector(right1Cliped:) forControlEvents:UIControlEventTouchUpInside];
//            UIBarButtonItem *barRightButtonItem0 = [[UIBarButtonItem alloc] initWithCustomView:btn0];
//            //            barRightButtonItem0.nuiClass = @"NavBarButtonItem";
//            [self.navigationItem setRightBarButtonItem:barRightButtonItem0];
//        }else if (navType == SHAREANGSHOUCANG_BUTTON) {
//            [self addLeftBack];
//            UIButton *btn0 = [self addRightButtonOtemWithName:@"分享" andImageName:imageShare];
//            [btn0 addTarget:self.delegate action:@selector(right1Cliped:) forControlEvents:UIControlEventTouchUpInside];
//            UIBarButtonItem *barRightButtonItem0 = [[UIBarButtonItem alloc] initWithCustomView:btn0];
//            //            barRightButtonItem0.nuiClass = @"NavBarButtonItem";
//            
//            UIButton *btn1 = [self addRightButtonOtemWithName:@"收藏" andImageName:imageStore];
//            [btn1 addTarget:self.delegate action:@selector(right2Cliped:) forControlEvents:UIControlEventTouchUpInside];
//            UIBarButtonItem *barRightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
//            //            barRightButtonItem1.nuiClass = @"NavBarButtonItem";
//            NSArray *arr = [NSArray arrayWithObjects:barRightButtonItem0,barRightButtonItem1, nil];
//            [self.navigationItem setRightBarButtonItems:arr];
//        }else if (navType == MINE_BUTTON) {
//            UIButton *btn0 = [self addRightButtonOtemWithName:@"设置" andImageName:imageSet];
//            [btn0 addTarget:self.delegate action:@selector(left1Cliped:) forControlEvents:UIControlEventTouchUpInside];
//            UIBarButtonItem *barRightButtonItem0 = [[UIBarButtonItem alloc] initWithCustomView:btn0];
//            //            barRightButtonItem0.nuiClass = @"NavBarButtonItem";
//            
//            UIButton *btn1 = [self addRightButtonOtemWithName:@"消息" andImageName:imageMessage];
//            [btn1 addTarget:self.delegate action:@selector(right1Cliped:) forControlEvents:UIControlEventTouchUpInside];
//            UIBarButtonItem *barRightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
//            //            barRightButtonItem1.nuiClass = @"NavBarButtonItem";
//            [self.navigationItem setLeftBarButtonItem:barRightButtonItem0];
//            [self.navigationItem setRightBarButtonItem:barRightButtonItem1];
//        }
//    }
//    
//}

- (void)setNavType:(NavType)navType
{
    [self setNavType:navType action:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//左边返回按钮
- (void) navLeftButtonTapped:(id)sender
{
    [[MyAfHTTPClient sharedClient] hiddenLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}
//左一
- (void)left1Cliped:(id)sender
{
    if (self.delegate) {
        [self.delegate leftButtonClicked:sender];
    }
}
//右一
- (void)right1Cliped:(id)sender
{
    if (self.delegate) {
        [self.delegate right0ButtonClicked:sender];
    }
}
//右二
- (void)right2Cliped:(id)sender
{
    if (self.delegate) {
        [self.delegate right1ButtonClicked:sender];
    }
}
//wordBtn
- (void)wordBtnCliped:(id)sender
{

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:TRUE];
}

#pragma mark-----
#pragma mark---------MJRefresh---------

//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    //    [self otherFourList:0 :^(BOOL finish) {
    //        success(finish);
    //    }];
    success(YES);
}

//刷新数据
- (void) refreshData:(void (^)(BOOL finish))success
{
    //重新加载数据。一切都重新初始化
    [self.footer resetNoMoreData];
    
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}

//加载下拉刷新和上拉加载
- (void) addHeaderAndFooter
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshData:^(BOOL finish) {
            [self.header endRefreshing];
        }];
    }];
    //设置图片
    [self.header prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:@"1.png"];
    [idleImages addObject:image];
    UIImage *image1 = [UIImage imageNamed:@"2.png"];
    [idleImages addObject:image1];
    [self.header setImages:idleImages forState:MJRefreshStateIdle];
    
    [self.header setImages:idleImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self.header setImages:idleImages forState:MJRefreshStateRefreshing];
    
    // 隐藏时间
    self.header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    self.header.stateLabel.hidden = YES;
    
    self.mainTabview.header = self.header;
    [self.header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData:^(BOOL finish) {
            [self.footer endRefreshing];
            if (isEnd == YES) {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [self.mainTabview.footer noticeNoMoreData];
                //                [self.footer setState:MJRefreshStateLoadIngEnd];
                //                self.footer.statusLabel.text = @"内容全部加载完毕";
            }
        }];
    }];
    // 设置文字
    [self.footer setTitle:@"下拉加载刷新" forState:MJRefreshStateIdle];
    [self.footer setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [self.footer setTitle:@"全部加载完毕" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    self.footer.stateLabel.font = [UIFont systemFontOfSize:17];
    
    // 设置颜色
    self.footer.stateLabel.textColor = [UIColor blueColor];
    
    self.mainTabview.footer = self.footer;
    [self.footer beginRefreshing];

}


/*
   **  列表 cell 从头显示
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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

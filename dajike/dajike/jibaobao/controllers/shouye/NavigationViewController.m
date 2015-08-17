//
//  NavigationViewController.m
//  jibaobao
//
//  Created by dajike on 15/4/24.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "NavigationViewController.h"

#import "defines.h"
#import "JNaveButton.h"


@interface NavigationViewController ()<UITableViewDelegate>
{
    JNaveButton *navRightBtnShouye;
    JNaveButton *btn1Mine;
}

@end

@implementation NavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置底层背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [backgroundImageView setImage:[UIImage imageNamed:@"img_jiazai.png"]];
    [self.view insertSubview:backgroundImageView atIndex:0];

    self.mainTabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64-51) style:UITableViewStyleGrouped];
    self.mainTabview.delegate = self;
    [self.view addSubview:self.mainTabview];
    
    //  列表 cell 从头开始显示  需要实现一个代理方法
    if ([self.mainTabview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTabview setSeparatorInset:UIEdgeInsetsZero];
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self.mainTabview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTabview setLayoutMargins:UIEdgeInsetsZero];
    }
#endif
//    [self addHeaderAndFooter];
   }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
//        [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg1.png"] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.layer.shadowOpacity = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//         [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
//        UITextField *navTitleView = [[UITextField alloc]initWithFrame:CGRectMake(0, 12, 250, 27)];
//        navTitleView.backgroundColor = [UIColor whiteColor];
//        navTitleView.layer.borderColor = [[UIColor grayColor] CGColor];
//        navTitleView.layer.borderWidth = 1;
//        [navTitleView setFont:Font_Default];
////        navTitleView.nuiClass = @"ShouyeNavTitleViewTextField";
//        [navTitleView setPlaceholder:@"请输入商家、品类、地点"];
//        [navTitleView setFont:[UIFont systemFontOfSize:10]];
//        [navTitleView setKeyboardType:UIKeyboardTypeDefault];
//        self.navigationItem.titleView = navTitleView;
//        
//        
//        // bind left user button
//        JShouyeNavButton *navLeftBtn = [[JShouyeNavButton alloc]initWithFrame:CGRectMake(0, 2, 65, 21)];;
//        //        navLeftBtn.nuiClass = @"NavLeftButton";
//        //        //[navLeftBtn setFrame:CGRectMake(0, 0, 55, 55)];
//        //        //[navLeftBtn setImage:[UIImage imageNamed:@"nav_user"] forState:UIControlStateNormal];
//        [navLeftBtn addTarget:self action:@selector(navLeftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *barLeftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navLeftBtn];
//        //barLeftButtonItem.nuiClass = @"NavBarButtonItem";
//        [self.navigationItem setLeftBarButtonItem:barLeftButtonItem];
//        
//        // bind right settings button
//        UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [navRightBtn setFrame:CGRectMake(0, 0, 34, 44)];
//        [navRightBtn setBackgroundColor:[UIColor clearColor]];
//        
//        UIImageView *messageImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 20, 20)];
//        [messageImage setImage:[UIImage imageNamed:imageMessage]];
//        [navRightBtn addSubview:messageImage];
//        
//        UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 21, 34, 16)];
//        messageLabel.text = @"消息";
////        messageLabel.nuiClass = @"ShouyeNavMessageLabel";
//        [messageLabel setFont:Font_Default];
//        messageLabel.numberOfLines = 1;
//        [messageLabel setTextAlignment:NSTextAlignmentCenter];
//        [navRightBtn addSubview:messageLabel];
//        
//        [navRightBtn addTarget:self action:@selector(navRightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *barRightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
////        barRightButtonItem.nuiClass = @"NavBarButtonItem";
//        [self.navigationItem setRightBarButtonItem:barRightButtonItem];
        if (navRightBtnShouye) {
            [navRightBtnShouye setButtonImage:[UIImage imageNamed:@"img_bell.png"] andButtonNumber:[FileOperation getMessageNum]];
        }
        if (btn1Mine) {
            [btn1Mine setButtonImage:[UIImage imageNamed:@"img_bell.png"] andButtonNumber:[FileOperation getMessageNum]];
        }
    }

}

//右边按钮
- (UIButton *) addRightButtonOtemWithName:(NSString *)nameString andImageName:(NSString*)imageName
{
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navRightBtn setFrame:CGRectMake(0, 0, 34, 44)];
    [navRightBtn setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *messageImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 20, 20)];
    [messageImage setImage:[UIImage imageNamed:imageName]];
    [navRightBtn addSubview:messageImage];
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 21, 34, 16)];
    messageLabel.text = nameString;
    //    messageLabel.nuiClass = @"ShouyeNavMessageLabel";
    [messageLabel setFont:Font_Default];
    messageLabel.numberOfLines = 1;
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [navRightBtn addSubview:messageLabel];
    
    //    [navRightBtn addTarget:self action:@selector(navRightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *barRightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    //    barRightButtonItem.nuiClass = @"NavBarButtonItem";
    //    [self.navigationItem setRightBarButtonItem:barRightButtonItem];
    return navRightBtn;
}
- (void)setNavType:(NavMainType)navType action:(NSString *)actionName
{
    //设置navigationBar
    if (self.navigationController) {
        if (navType == SHOUYE_NAV) {
//            UITextField *navTitleView = [[UITextField alloc]initWithFrame:CGRectMake(0, 12, 250, 27)];
//            navTitleView.backgroundColor = [UIColor whiteColor];
//            navTitleView.layer.borderColor = [[UIColor grayColor] CGColor];
//            navTitleView.layer.borderWidth = 1;
//            [navTitleView setFont:Font_Default];
//            //        navTitleView.nuiClass = @"ShouyeNavTitleViewTextField";
//            [navTitleView setPlaceholder:@"请输入商家、品类、地点"];
//            [navTitleView setFont:[UIFont systemFontOfSize:10]];
//            [navTitleView setKeyboardType:UIKeyboardTypeDefault];
//            self.navigationItem.titleView = navTitleView;
            
            
            // bind left user button
            _navButton = [[JShouyeNavButton alloc]initWithFrame:CGRectMake(0, 2, 65, 21)];;
            //        navLeftBtn.nuiClass = @"NavLeftButton";
            //        //[navLeftBtn setFrame:CGRectMake(0, 0, 55, 55)];
            //        //[navLeftBtn setImage:[UIImage imageNamed:@"nav_user"] forState:UIControlStateNormal];
            //获取定位城市
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Regions.locationCity" parameters:@{@"latitude":@"",@"longitude":@""} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"responseObject.result = %@",[responseObject.result objectForKey:@"regionName"]);
                    //                    //定位成功，显示当前定位城市
                    [self setNavButtonFrameByTitle:[responseObject.result objectForKey:@"regionName"] andCityId:[responseObject.result objectForKey:@"regionId"]];
                                        [_navButton setupWithTitle:[responseObject.result objectForKey:@"regionName"]];
                    ////                    //存储当前定位的城市
                    //                    [FileOperation setPlistObject:[responseObject.result objectForKey:@"regionName"] forKey:kCurrentCity ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
                    //                    [FileOperation setPlistObject:[responseObject.result objectForKey:@"regionId"] forKey:kCurrentCityId ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
                    //
                NSMutableArray *citysArr = [[NSMutableArray alloc]init];
                NSDictionary *cityDic = @{@"regionName":@"全城",@"regionId":[responseObject.result objectForKey:@"regionId"]};
                [citysArr addObject:cityDic];
                for (NSArray *arr in [responseObject.result objectForKey:@"subRegions"]) {
                    NSDictionary *dic = @{@"regionName":[arr objectAtIndex:1],@"regionId":[arr objectAtIndex:0]};
                    [citysArr addObject:dic];
                }

                [FileOperation setPlistObject:citysArr forKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
                //存储定位城市
                    [FileOperation writeDingweiCityWithCityName:[responseObject.result objectForKey:@"regionName"] andCityId:[NSString stringWithFormat:@"%@",[responseObject.result objectForKey:@"regionId"]]];

                    [FileOperation writeCurrentCityWithCityName:[responseObject.result objectForKey:@"regionName"] andCityId:[NSString stringWithFormat:@"%@",[responseObject.result objectForKey:@"regionId"]]];
                }else{
                    //定位失败，获取上次选择城市id
                    if ([FileOperation getCurrentCityName]!=nil) {
                        [self setNavButtonFrameByTitle:[FileOperation getCurrentCityName] andCityId:[FileOperation getCurrentCityId]];
                        [_navButton setupWithTitle:[FileOperation getCurrentCityName]];
                        if ([FileOperation getNextPlacesByCurrentCityId:[FileOperation getCurrentCityId]].count > 1) {
                            [FileOperation setPlistObject:[FileOperation getNextPlacesByCurrentCityId:[FileOperation getCurrentCityId]] forKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
                        }
                    }
                    else{
                        [self setNavButtonFrameByTitle:@"上海" andCityId:@"321"];
                        [_navButton setupWithTitle:@"上海"];
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
                //定位失败，显示以前定位城市
                if ([FileOperation getCurrentCityName]!=nil) {
                    [self setNavButtonFrameByTitle:[FileOperation getCurrentCityName] andCityId:[FileOperation getCurrentCityId]];
                    [_navButton setupWithTitle:[FileOperation getCurrentCityName]];
                    if ([FileOperation getNextPlacesByCurrentCityId:[FileOperation getCurrentCityId]].count > 1) {
                        [FileOperation setPlistObject:[FileOperation getNextPlacesByCurrentCityId:[FileOperation getCurrentCityId]] forKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
                    }  
                }else{
                    [self setNavButtonFrameByTitle:@"上海" andCityId:@"321"];
                    [_navButton setupWithTitle:@"上海"];
                }
            }];


            [_navButton addTarget:self action:@selector(navLeftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barLeftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navButton];
            //barLeftButtonItem.nuiClass = @"NavBarButtonItem";
            [self.navigationItem setLeftBarButtonItem:barLeftButtonItem];
            
            // bind right settings button
            navRightBtnShouye = [JNaveButton buttonWithType:UIButtonTypeCustom];
            [navRightBtnShouye setFrame:CGRectMake(0, 0, 20, 28)];
            [navRightBtnShouye setBackgroundColor:[UIColor clearColor]];
//            UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [navRightBtn setFrame:CGRectMake(0, 0, 34, 44)];
//            [navRightBtn setBackgroundColor:[UIColor clearColor]];
            [navRightBtnShouye setButtonImage:[UIImage imageNamed:@"img_bell.png"] andButtonNumber:[FileOperation getMessageNum]];
            
//            UIImageView *messageImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 20, 20)];
//            [messageImage setImage:[UIImage imageNamed:imageMessage]];
//            [navRightBtn addSubview:messageImage];
//            
//            UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 21, 34, 16)];
//            messageLabel.text = @"消息";
//            //        messageLabel.nuiClass = @"ShouyeNavMessageLabel";
//            [messageLabel setFont:Font_Default];
//            messageLabel.numberOfLines = 1;
//            [messageLabel setTextAlignment:NSTextAlignmentCenter];
//            [navRightBtn addSubview:messageLabel];
            
            [navRightBtnShouye addTarget:self action:@selector(navRightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barRightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtnShouye];
            //        barRightButtonItem.nuiClass = @"NavBarButtonItem";
            [self.navigationItem setRightBarButtonItem:barRightButtonItem];
        }else if (navType == MINE_NAV) {
//            self.navigationItem.title = @"我的";
            UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 44)];
            navTitleLabel.backgroundColor = [UIColor whiteColor];
            [navTitleLabel setTextAlignment:NSTextAlignmentCenter];
//            navTitleLabel.layer.borderColor = [[UIColor grayColor] CGColor];
//            navTitleLabel.layer.borderWidth = 1;
//            [navTitleLabel setFont:Font_Default];
            //        navTitleView.nuiClass = @"ShouyeNavTitleViewTextField";
//            [navTitleLabel setPlaceholder:@"请输入商家、品类、地点"];
            navTitleLabel.text = @"个人中心";
            [navTitleLabel setFont:[UIFont systemFontOfSize:20]];
//            [navTitleLabel setKeyboardType:UIKeyboardTypeDefault];
            self.navigationItem.titleView = navTitleLabel;
            
//            UIButton *btn0 = [self addRightButtonOtemWithName:@"设置" andImageName:imageSet];
            JNaveButton *btn0 = [JNaveButton buttonWithType:UIButtonTypeCustom];
            [btn0 setFrame:CGRectMake(0, 0, 25, 23)];
            [btn0 setBackgroundColor:[UIColor clearColor]];
            //            UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            [navRightBtn setFrame:CGRectMake(0, 0, 34, 44)];
            //            [navRightBtn setBackgroundColor:[UIColor clearColor]];
            [btn0 setButtonImage:[UIImage imageNamed:@"img_icon6.png"] andButtonNumber:0];
            [btn0 addTarget:self action:@selector(left1Cliped:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barRightButtonItem0 = [[UIBarButtonItem alloc] initWithCustomView:btn0];
            //            barRightButtonItem0.nuiClass = @"NavBarButtonItem";
            
//            UIButton *btn1 = [self addRightButtonOtemWithName:@"消息" andImageName:imageMessage];
            btn1Mine = [JNaveButton buttonWithType:UIButtonTypeCustom];
            [btn1Mine setFrame:CGRectMake(0, 0, 20, 28)];
            [btn1Mine setBackgroundColor:[UIColor clearColor]];
            //            UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            [navRightBtn setFrame:CGRectMake(0, 0, 34, 44)];
            //            [navRightBtn setBackgroundColor:[UIColor clearColor]];
            [btn1Mine setButtonImage:[UIImage imageNamed:@"img_bell.png"] andButtonNumber:[FileOperation getMessageNum]];
            [btn1Mine addTarget:self action:@selector(right1Cliped:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barRightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btn1Mine];
            //            barRightButtonItem1.nuiClass = @"NavBarButtonItem";
            [self.navigationItem setLeftBarButtonItem:barRightButtonItem0];
            [self.navigationItem setRightBarButtonItem:barRightButtonItem1];
        }else if (navType == CHOUJIANG_NAV) {
            //            self.navigationItem.title = @"我的";
            UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 44)];
            navTitleLabel.backgroundColor = [UIColor whiteColor];
            [navTitleLabel setTextAlignment:NSTextAlignmentCenter];
            //            navTitleLabel.layer.borderColor = [[UIColor grayColor] CGColor];
            //            navTitleLabel.layer.borderWidth = 1;
            //            [navTitleLabel setFont:Font_Default];
            //        navTitleView.nuiClass = @"ShouyeNavTitleViewTextField";
            //            [navTitleLabel setPlaceholder:@"请输入商家、品类、地点"];
            navTitleLabel.text = @"我要抽奖";
            [navTitleLabel setFont:[UIFont systemFontOfSize:20]];
            //            [navTitleLabel setKeyboardType:UIKeyboardTypeDefault];
            self.navigationItem.titleView = navTitleLabel;
            
            //            UIButton *btn0 = [self addRightButtonOtemWithName:@"设置" andImageName:imageSet];
            UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn0 setFrame:CGRectMake(0, 0, 60, 30)];
            [btn0 setBackgroundColor:[UIColor clearColor]];
            //            UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            [navRightBtn setFrame:CGRectMake(0, 0, 34, 44)];
            //            [navRightBtn setBackgroundColor:[UIColor clearColor]];
            [btn0 setTitleColor:Color_mainColor forState:UIControlStateNormal];
            [btn0 setTitle:@"抽奖规则" forState:UIControlStateNormal];
            [btn0.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn0 addTarget:self action:@selector(left1Cliped:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barRightButtonItem0 = [[UIBarButtonItem alloc] initWithCustomView:btn0];
            //            barRightButtonItem0.nuiClass = @"NavBarButtonItem";
            
            //            UIButton *btn1 = [self addRightButtonOtemWithName:@"消息" andImageName:imageMessage];
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn1 setFrame:CGRectMake(0, 0, 60, 30)];
            [btn1 setBackgroundColor:[UIColor clearColor]];
            //            UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            [navRightBtn setFrame:CGRectMake(0, 0, 34, 44)];
            //            [navRightBtn setBackgroundColor:[UIColor clearColor]];
            [btn1 setTitleColor:Color_mainColor forState:UIControlStateNormal];
            [btn1 setTitle:@"奖金查询" forState:UIControlStateNormal];
            [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
           [btn1 addTarget:self action:@selector(right1Cliped:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barRightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
            //            barRightButtonItem1.nuiClass = @"NavBarButtonItem";
            [self.navigationItem setLeftBarButtonItem:barRightButtonItem0];
            [self.navigationItem setRightBarButtonItem:barRightButtonItem1];
        }
    }
    
}

- (void)setNavType:(NavMainType)navType
{
    [self setNavType:navType action:nil];
}

//左一
- (void)left1Cliped:(id)sender
{
    if (self.delegate) {
        [self.delegate left1ButtonClicked:sender];
    }
}
//右一
- (void)right1Cliped:(id)sender
{
    if (self.delegate) {
        [self.delegate rightButtonClicked:sender];
    }
}
//右二
- (void)left2Cliped:(id)sender
{
    if (self.delegate) {
        [self.delegate left1ButtonClicked:sender];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navLeftButtonTapped:(id)sender
{
//    [[SlideNavigationController sharedInstance] toggleLeftMenu];
    NSLog(@"%s",__func__);
}

- (void)navRightButtonTapped:(id)sender
{
//    [[SlideNavigationController sharedInstance] toggleRightMenu];
     NSLog(@"%s",__func__);
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
 **  首页定位城市  重新设置frame
 */

- (void) setNavButtonFrameByTitle:(NSString *)title andCityId:(NSString *)cityId
{
    /*
    //如果为区县  显示上级市名
    NSString *parentName;
//    NSInteger cityId;
    NSArray *allPlaceArr = [FileOperation getAllPlaces];
    NSString *resultTitle;
    
    
//    for (NSDictionary *cityDic in allPlaceArr) {
//        if ([[cityDic objectForKey:@"regionName"] isEqualToString:title]) {
//            cityId = [[cityDic objectForKey:@"parentId"] integerValue];
//        }
//    }
    if ([[FileOperation getNextPlacesWithRegionId:[NSString stringWithFormat:@"%@",cityId]] count] == 0) {
        NSInteger parentId = 0;
        for (NSDictionary *cityDic in allPlaceArr) {
            if ([[cityDic objectForKey:@"regionId"] integerValue] == [cityId integerValue]) {
                parentId = [[cityDic objectForKey:@"parentId"] integerValue];
            }
        }
        for (NSDictionary *cityDic in allPlaceArr) {
            if ([[cityDic objectForKey:@"regionId"] integerValue] == parentId) {
                parentName = [NSString stringWithFormat:@"%@",[cityDic objectForKey:@"regionName"]];
            }
        }
    }
    //修改plist文件里的内容
    if (parentName == nil) {
        //如果
        resultTitle = [NSString stringWithFormat:@"%@",title];
    }else{
       resultTitle = [NSString stringWithFormat:@"%@ %@",parentName,title];
    }
    
    */

    CGRect frame = [self.navButton contentAdaptionLabel:title withSize:CGSizeMake(100, 21) withTextFont:13];
    CGRect frame1 = self.navButton.frame;
    frame1.size.width = frame.size.width +20;
    [self.navButton setFrame:frame1];
    
    self.navButton.cityTitleLabel.text = title;
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

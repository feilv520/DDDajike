//
//  DBaseViewController.m
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DBaseViewController.h"
#import "DBaseNavView.h"
#import "SWBTabBarController.h"
#import "SWBTabBar.h"
#import "dDefine.h"
#import "defines.h"
#import "MJRefresh.h"

@interface DBaseViewController ()<UITableViewDelegate>
{
//    UILabel *_numLb;
}
@property (nonatomic, readonly) DBaseNavView *m_viewNaviBar;

@end

@implementation DBaseViewController
@synthesize m_viewNaviBar = _viewNaviBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DColor_White;
    _viewNaviBar = [[DBaseNavView alloc] initWithFrame:DRect(0.0f, 0.0f, [DBaseNavView barSize].width, [DBaseNavView barSize].height)];
    _viewNaviBar.m_viewCtrlParentVC = self;
    [self.view addSubview:_viewNaviBar];
    [self setNaviBarLeftBtn:nil];
    //改变导航栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置购物车小角标
//    [self setGouWuCheXiaoJiaoBiao];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeGouWuCheNum:) name:@"changeGouWuCheNum" object:nil];
}
//- (void)changeGouWuCheNum:(NSNotification *)notify
//{
//    NSLog(@"%@",notify.object);
//    NSMutableDictionary *dic = [[FileOperation readFileToDictionary:jibaobaoUser]mutableCopy];
//    _numLb.text = [dic objectForKey:@"cartCount"];
//    if ([_numLb.text intValue]>0) {
//        [_numLb setHidden:NO];
//        _numLb.text = [NSString stringWithFormat:@"%@",_numLb.text];
//    }else
//        [_numLb setHidden:YES];
//}
////设置购物车小角标
//- (void)setGouWuCheXiaoJiaoBiao
//{
//    _numLb = [[UILabel alloc]initWithFrame:DRect(DWIDTH_CONTROLLER_DEFAULT/4*3-DWIDTH_CONTROLLER_DEFAULT/8+7, 5, 15, 15)];
//    _numLb.hidden = YES;
//    _numLb.backgroundColor = DColor_White;
//    _numLb.layer.cornerRadius = _numLb.frame.size.width/2;
//    _numLb.layer.masksToBounds = YES;
//    _numLb.text = @"0";
//    _numLb.font = [UIFont systemFontOfSize:9.0f];
//    _numLb.textColor = DColor_c4291f;
//    _numLb.textAlignment = NSTextAlignmentCenter;
//    SWBTabBarController *tabBarVC = [SWBTabBarController sharedManager];
////    [tabBarVC.myView addSubview:_numLb];
//    [self.view bringSubviewToFront:_numLb];
//    [self changeGouWuCheNum:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------- 添加基类tableview ---------------
- (void)addTableView:(BOOL)isNeedRefresh
{
    self.dMainTableView = [[UITableView alloc]initWithFrame:DRect(0, 64, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT-64-50) style:UITableViewStyleGrouped];
    self.dMainTableView.delegate = self;
    [self.view addSubview:self.dMainTableView];
    
    //添加无数据时的显示界面，正常情况下隐藏
    self.noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading_no_s"]];
    self.noDataView.contentMode = UIViewContentModeScaleAspectFit;
    [self.noDataView setFrame:CGRectMake(0, 0, self.dMainTableView.frame.size.width, self.dMainTableView.frame.size.height)];
    [self.dMainTableView addSubview:self.noDataView];
    [self.noDataView setHidden:YES];
    
    //  列表 cell 从头开始显示  需要实现一个代理方法
    if ([self.dMainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.dMainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self.dMainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.dMainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
#endif
    
    if (isNeedRefresh) {
        [self addHeaderAndFooter];
    }
    
}

#pragma mark -
/**--------------------------------------------------------------------------------------
 *  集成刷新控件
 */
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
    
    self.dMainTableView.header = self.header;
//    [self.header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData:^(BOOL finish) {
            [self.footer endRefreshing];
            if (isEnd == YES) {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [self.dMainTableView.footer noticeNoMoreData];
//                                [self.footer setState:MJRefreshStateLoadIngEnd];
//                                self.footer.statusLabel.text = @"内容全部加载完毕";
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
    self.footer.stateLabel.textColor = [UIColor grayColor];
    
    self.dMainTableView.footer = self.footer;
//    [self.footer beginRefreshing];
    
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

#pragma mark --------- 头部导航栏配置 ------------

- (void)bringNaviBarToTopmost
{
    if (_viewNaviBar)
    {
        [self.view bringSubviewToFront:_viewNaviBar];
    }else{}
}

- (void)hideNaviBar:(BOOL)bIsHide
{
    _viewNaviBar.hidden = bIsHide;
}

- (void)setNaviBarTitle:(NSString *)strTitle
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setNavTitle:strTitle];
    }else{APP_ASSERT_STOP}
}

- (void)setNaviBarLeftBtn:(DImgButton *)btn
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setNavLeftBtn:btn];
    }else{APP_ASSERT_STOP}
}

- (void)setNaviBarRightBtn:(DImgButton *)btn
{
    if (_viewNaviBar)
    {
        [_viewNaviBar setNavRightBtn:btn];
    }else{APP_ASSERT_STOP}
}
- (void)changeNavImg:(NSString *)imgName
{
    if (_viewNaviBar) {
        [_viewNaviBar changeNavImg:imgName];
    }else{APP_ASSERT_STOP}
}

- (void)naviBarAddCoverView:(UIView *)view
{
    if (_viewNaviBar && view)
    {
        [_viewNaviBar showCoverView:view animation:YES];
    }else{}
}

- (void)naviBarAddCoverViewOnTitleView:(UIView *)view
{
    if (_viewNaviBar && view)
    {
        [_viewNaviBar showCoverViewOnTitleView:view];
    }else{}
}

- (void)naviBarRemoveCoverView:(UIView *)view
{
    if (_viewNaviBar)
    {
        [_viewNaviBar hideCoverView:view];
    }else{}
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

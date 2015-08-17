//
//  JShouyeMainViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/6.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "JShouyeMainViewController.h"
#import "JShouyeoneCell.h"
#import "JShouyeTwoCell.h"
#import "DiscountCouponCell.h"
#import "JShouyeaButton.h"
#import "defines.h"
#import "MJRefresh.h"
#import "FoodViewController.h"
#import "ShoppingViewController.h"
#import "SelectCityViewController.h"
#import "SearchViewController.h"
#import "MessageListViewController.h"
#import "SelectCityView.h"
#import "MyAfHTTPClient.h"
#import "AFNetworking.h"
#import "TimeLimitModel.h"
#import "NearPrivilegeModel.h"
#import "ShouyeBannerModel.h"
#import "GeneralHongBaoViewController.h"
#import "JTabBarController.h"
#import "SwbClickImageView.h"

#import "FoodShopDetailViewController.h"
#import "ProductDetailViewController.h"
#import "ProductListViewController.h"
#import "CashCouponDetailViewController.h"
#import "LoginViewController.h"

#import "AppDelegate.h"
#import "SWBTabBarController.h"

@interface JShouyeMainViewController ()<JShouyeoneCellDelegate,UITextFieldDelegate,SelectCityViewDelegate>
{
    UIScrollView *imageScrollView;
    UIPageControl *pageControl;
    
    BOOL pageControlBeingUsed;
    NSTimer *myTimer;//定时器
    NSMutableArray *imageArray;
    
    SelectCityView *_SelectCityView;
    
    NSMutableArray *nearbyYouhuiArr;//附近｀优惠｀数组
    NSMutableArray *limitYouhuiArr;//限时优惠数组
    NSDictionary *choujiangDic;//抽奖
    NSMutableArray *adArr;//广告数组
    
    //经纬度
    NSString *_latitude;
    NSString *_longitude;
    
    NSInteger page;
    //首页广告
//    NSMutableArray *modelArr;
    
    //selectView 蒙板
    UIView *_selectVMengbanView;
}
- (void)bindAds:(NSArray *)items;
@end

@implementation JShouyeMainViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITextField *navTitleView = [[UITextField alloc]initWithFrame:CGRectMake(-5, 17, 250+5, 25)];
        navTitleView.backgroundColor = [UIColor whiteColor];
        navTitleView.layer.borderColor = [Color_bg CGColor];
        navTitleView.layer.borderWidth = 1;
        [navTitleView setFont:Font_Default];
        //        navTitleView.nuiClass = @"ShouyeNavTitleViewTextField";
        [navTitleView setPlaceholder:@"  请输入商家、品类、地点"];
        [navTitleView setFont:[UIFont systemFontOfSize:10]];
        [navTitleView setKeyboardType:UIKeyboardTypeDefault];
        navTitleView.delegate = self;
        self.navigationItem.titleView = navTitleView;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //显示当前定位城市
    [self setNavButtonFrameByTitle:[[[FileOperation getRecentlyCitys]objectAtIndex:0] objectForKey:@"regionName"] andCityId:[[[FileOperation getRecentlyCitys]objectAtIndex:0] objectForKey:@"regionId"]];
    [self.navButton setupWithTitle:[[[FileOperation getRecentlyCitys]objectAtIndex:0] objectForKey:@"regionName"]];
    _SelectCityView.selectCityTag = [FileOperation selectIndex];
    
//    if (limitYouhuiArr.count == 0) {
//        [self refreshData:^(BOOL finish) {
//        }];
//    }
    //询问开启定位操作
#if TARGET_IPHONE_SIMULATOR
    //写入plist
    [FileOperation writeLatitude:@"31.326362"];
    [FileOperation writeLongitude:@"121.442765"];
#elif TARGET_OS_IPHONE
    //当前经纬度
    [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        //写入plist
        [FileOperation writeLatitude:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude]];
        [FileOperation writeLongitude:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude]];
    }];
#endif
    
    [self.mainTabview setFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64-51+40)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self setNavType:SHOUYE_NAV action:nil];
    page = 0;
    [self addsubViews];
    [self addHeaderAndFooter];
    
}
- (void) addsubViews
{
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2)];
    imageScrollView.backgroundColor = Color_gray1;
    [imageScrollView setPagingEnabled:YES];
    //设置滚动条类型
    imageScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    //是否自动裁切超出部分
    imageScrollView.clipsToBounds = YES;
    //设置是否可以缩放
    imageScrollView.scrollEnabled = YES;
    imageScrollView.showsHorizontalScrollIndicator = FALSE;//水平滚动条是否显示
    imageScrollView.showsVerticalScrollIndicator = FALSE;//垂直滚动条是否显示
    self.mainTabview.tableHeaderView = imageScrollView;
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-35, self.view.frame.size.width/2-25, 70, 30)];
    [pageControl setCurrentPageIndicatorTintColor:Color_mainColor];
    [pageControl setPageIndicatorTintColor:Color_gray4];
    
    _selectVMengbanView = [[UIView alloc]initWithFrame:self.view.frame];
    _selectVMengbanView.backgroundColor = Color_mengban;
    [self.view addSubview:_selectVMengbanView];
    [self.view bringSubviewToFront:_selectVMengbanView];
    //单击
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [_selectVMengbanView addGestureRecognizer:singleRecognizer];
    [_selectVMengbanView setHidden:YES];

    _SelectCityView = [[SelectCityView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 210)];
    _SelectCityView.myDelegate = self;
    [_selectVMengbanView addSubview:_SelectCityView];
    [_SelectCityView setHidden:YES];
    
    [self httprequest];
}
//多线程网络请求
- (void)httprequest
{
     [self forADImage];
    //限时优惠请求数据
    nearbyYouhuiArr = [[NSMutableArray alloc]init];
    
    
    
    [self timeLimitPrivilege];
    [self FirstPageChoujiang];
//    // 延迟2秒执行：
//    double delayInSeconds = 1.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        // code to be executed on the main queue after delay
//            });
    
    [self nearbyYouhui:^(BOOL finish) {
        NSLog(@"sdsfsf");
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-----
#pragma mark---------UITableviewDelegate  UITableViewDatasource---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4+nearbyYouhuiArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        return 138;
    }else if(row == 1){
        return 113+10+10+15+30;
    }else if(row == 2){
        return (self.view.frame.size.width/2);
    }else if(row == 3){
        return 26;
    }else{
        return 80;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        JShouyeoneCell *cell1 = [[JShouyeoneCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"one"];
        [cell1 addimageAndTitle];
        cell1.delegate = self;
        return cell1;
        
    }else if(row == 1){
        JShouyeTwoCell *cell2 = [[JShouyeTwoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"two"];
        if (limitYouhuiArr.count > 0) {
            for (int i = 0; i<limitYouhuiArr.count; i++) {
                switch (i) {
                    case 0:
                    {
                        cell2.btn1.timeLimitModel = [limitYouhuiArr objectAtIndex:0];
                    }
                        break;
                    case 1:
                    {
                        cell2.btn2.timeLimitModel = [limitYouhuiArr objectAtIndex:1];
                    }
                        break;
                    case 2:
                    {
                        cell2.btn3.timeLimitModel = [limitYouhuiArr objectAtIndex:2];
                    }
                        break;
                        
                    default:
                        break;
                }
                    [cell2.btn1 addTarget:self action:@selector(toXianshiBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [cell2.btn2 addTarget:self action:@selector(toXianshiBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [cell2.btn3 addTarget:self action:@selector(toXianshiBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        return cell2;
    }else if(row == 2){
        UITableViewCell *cell3 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"three"];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:cell3.frame];
        imageV.backgroundColor = Color_bg00;
//        imageV.contentMode = UIViewContentModeScaleAspectFit;
        if (choujiangDic != nil) {
            [imageV setImageWithURL:[commonTools getImgURL:[choujiangDic objectForKey:@"img"]] placeholderImage:PlaceholderImage_Big];
        }else{
            [imageV setImage:PlaceholderImage_Big];
        }
        cell3.backgroundView = imageV;
        return cell3;
    }else if(row == 3){
        UITableViewCell *cell4 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"4"];
        [cell4.textLabel setFont:Font_Default];
        cell4.textLabel.text = @"您附近的优惠";
        return cell4;
    }else{
        static NSString *nibName = @"DiscountCouponCell";
        DiscountCouponCell *pcell = [tableView dequeueReusableCellWithIdentifier:nibName];
        if (nil == pcell) {
            [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
            pcell = [tableView dequeueReusableCellWithIdentifier:nibName];
        }
        if (nearbyYouhuiArr.count > 0) {
            pcell.nearbyYouhuiModel = [nearbyYouhuiArr objectAtIndex:row-4];
        }
        
        return pcell;
    }
        return nil;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"%s",__func__);
    NSInteger row = indexPath.row;
    if (row == 0) {
//        return 138;
    }else if(row == 1){
//        return 113;
    }else if(row == 2){
//        [[JTabBarController sharedManager] selectAtIndex:2];
        [self addTabBarViews];
        
    }else if(row == 3){
//        return 26;
    }else{
        CashCouponDetailViewController *couponVC2 = [[CashCouponDetailViewController alloc]init];
        couponVC2.navigationItem.title = @"代金券详情";
        NearPrivilegeModel *model = [nearbyYouhuiArr objectAtIndex:indexPath.row-4];
        couponVC2.goodsId = model.goods_id;
        [self.navigationController pushViewController:couponVC2 animated:YES];
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

#pragma mark-----
#pragma mark---------JShouyeoneCellDelegate---------
- (void)JShouyeoneCellButtonCliped:(id)sender
{
    JShouyeaButton *btn =(JShouyeaButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            FoodViewController *foodVC = [[FoodViewController alloc]init];
            foodVC.navTitle = @"美食";
            foodVC.StoreListType = MEISHI;
            [self.navigationController pushViewController:foodVC animated:YES];
        }
            break;
        case 1:
        {
            ShoppingViewController *foodVC = [[ShoppingViewController alloc]init];
            foodVC.navTitle = @"购物";
            [self.navigationController pushViewController:foodVC animated:YES];
        }
            break;
        case 2:
        {
            FoodViewController *foodVC = [[FoodViewController alloc]init];
            foodVC.navTitle = @"休闲娱乐";
            foodVC.StoreListType = XIUXIAN_YULE;
            [self.navigationController pushViewController:foodVC animated:YES];
        }
            break;
        case 3:
        {
            FoodViewController *foodVC = [[FoodViewController alloc]init];
            foodVC.navTitle = @"丽人";
            foodVC.StoreListType = LIREN;
            [self.navigationController pushViewController:foodVC animated:YES];
        }
            break;
        case 4:
        {
            FoodViewController *foodVC = [[FoodViewController alloc]init];
            foodVC.navTitle = @"绿色特产";
            foodVC.StoreListType = LVSE_TECHAN;
            [self.navigationController pushViewController:foodVC animated:YES];
        }
            break;
        case 5:
        {
            FoodViewController *foodVC = [[FoodViewController alloc]init];
            foodVC.navTitle = @"家居家纺";
            foodVC.StoreListType = JIAJU_JIAWANG;
            [self.navigationController pushViewController:foodVC animated:YES];
        }
            break;
        case 6:
        {
            FoodViewController *foodVC = [[FoodViewController alloc]init];
            foodVC.navTitle = @"生活服务";
            foodVC.StoreListType = SHNEGHUO_FUWU;
            [self.navigationController pushViewController:foodVC animated:YES];
        }
            break;
        case 7:
        {
            if ([FileOperation isLogin]) {
                GeneralHongBaoViewController *vc = [[GeneralHongBaoViewController alloc]init];
                vc.userId = [FileOperation getUserId];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                //跳转到登录
                LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:loginVC animated:YES];
//                [ProgressHUD showMessage:@"您还未登录，请先登录！" Width:280 High:10];
            }
            
        }
            break;
        default:
            break;
    }
    NSLog(@"%s",__func__);
}
#pragma mark-----
#pragma mark---------限时优惠  点击事件---------
- (void) toXianshiBtn:(id) sender
{
    JShouyeLimitDiscountButton *button = (JShouyeLimitDiscountButton *)sender;
    NSInteger index = button.tag;
    ShouyeBannerModel *item = [limitYouhuiArr objectAtIndex:index];
    //代金券详情
    if ([item.linkType isEqualToString:@"goods_detail_coupon"]) {
        CashCouponDetailViewController *CashCouponDetailVC = [[CashCouponDetailViewController alloc]init];
        CashCouponDetailVC.goodsId = item.goodsId;
        [self.navigationController pushViewController:CashCouponDetailVC animated:YES];
    }
    if ([item.linkType isEqualToString:@"store_detail"]) {//商家详情
        FoodShopDetailViewController *shopVC = [[FoodShopDetailViewController alloc]init];
        shopVC.storeId = item.storeId;
        [shopVC callBackFoodVC:^{
            NSLog(@"评论成功");
        }];
        [self.navigationController pushViewController:shopVC animated:YES];
    }
    if ([item.linkType isEqualToString:@"store_list"]) {//商家列表
        FoodViewController *foodVC = [[FoodViewController alloc]init];
        foodVC.navTitle = item.title;
        foodVC.StoreListType = DEFAULT_LIST;
        foodVC.bannerModel = item;
        [self.navigationController pushViewController:foodVC animated:YES];
    }
    if ([item.linkType isEqualToString:@"goods_detail"]) {//商品详情
        ProductDetailViewController *vc = [[ProductDetailViewController alloc]init];
        vc.goodId = [NSString stringWithFormat:@"%d",[item.goodsId intValue]];
        vc.goodsImageStr = [NSString stringWithFormat:@"%@",item.img];
        NSLog(@"%@",vc.goodId);
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([item.linkType isEqualToString:@"goods_list"]) {//商品列表
        ProductListViewController *vc = [[ProductListViewController alloc]init];
        vc.bannerModel = item;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
#pragma mark-----
#pragma mark---------MJRefresh---------
//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        [ProgressHUD showMessage:@"加载完成" Width:280 High:10];
        success (YES);
    }else{
        [self nearbyYouhui:^(BOOL finish) {
            success(finish);
        }];
    }
    
}

//刷新数据
- (void) refreshData:(void (^)(BOOL finish))success
{
    //重新加载数据。一切都重新初始化
    [self.footer resetNoMoreData];
    [nearbyYouhuiArr removeAllObjects];
    nearbyYouhuiArr = nil;
    nearbyYouhuiArr = [[NSMutableArray alloc]init];
    isEnd = NO;
    page = 0;
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}
#pragma mark-----
#pragma mark---------imageScrollViews---------
//广告nanner
- (void)forADImage
{
//    NSMutableArray *adImageArr = [[NSMutableArray alloc]init];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"jbb_index_banner",@"code", nil];
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.show" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"%@",responseObject.result);
            NSArray *resultArr = [NSArray arrayWithArray:responseObject.result];
            NSMutableArray * modelArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in resultArr) {
                NSMutableDictionary *dic0 = [[NSMutableDictionary alloc]init];
                for (NSString *key in [dic allKeys]) {
                    if ([[dic objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic1 = [NSDictionary dictionaryWithDictionary:[dic objectForKey:key]];
                        for ( NSString *key1 in [dic1 allKeys]) {
                            [dic0 setObject:[dic1 objectForKey:key1] forKey:key1];
                        }
                    }else{
                        [dic0 setObject:[dic objectForKey:key] forKey:key];
                    }
                }
                ShouyeBannerModel *shouyeBannerItem = [[ShouyeBannerModel alloc]init];
                shouyeBannerItem = [JsonStringTransfer dictionary:dic0 ToModel:shouyeBannerItem];
                [modelArr addObject:shouyeBannerItem];
            }
                 [self bindAds:modelArr];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];   
}

- (void)bindAds:(NSArray *)items
{
    if (items == nil || items.count == 0) {
        return;
    }
    
    
    // ad view
    int count = items.count;
    
    imageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < count; i ++) {
        
        ShouyeBannerModel *item = [items objectAtIndex:i];
//        NSURL *url = [NSURL URLWithString:[item objectForKey:@"img"]];
         NSURL *url = [commonTools getImgURL:item.img];
        NSLog(@"url = %@",url);
//        [imageArray addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
        [imageArray addObject:url];
    }
    
    imageScrollView.delegate=self;
//    UIImageView *firstView=[[UIImageView alloc] initWithImage:[imageArray lastObject]];
    CGFloat Width=imageScrollView.frame.size.width;
    CGFloat Height=imageScrollView.frame.size.height;
    SwbClickImageView *firstView=[[SwbClickImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    firstView.backgroundColor = Color_bg00;
//    firstView.contentMode = UIViewContentModeScaleAspectFit;
    [firstView setImageWithURL:[imageArray lastObject] placeholderImage:PlaceholderImage_Big];
    [imageScrollView addSubview:firstView];
    //点击图片事件
    [firstView callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
        NSLog(@"firstView cliped");
    }];
//    panRecognizer.delegate = self;
    //set the last as the first
    
    for (int i=0; i<[imageArray count]; i++) {
//        UIImageView *subViews=[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:i]];
        SwbClickImageView *subViews=[[SwbClickImageView alloc] initWithFrame:CGRectMake(Width*(i+1), 0, Width, Height)];
        subViews.backgroundColor = Color_bg00;
//        subViews.contentMode = UIViewContentModeScaleAspectFit;
        [subViews setImageWithURL:[imageArray objectAtIndex:i] placeholderImage:PlaceholderImage_Big];
        [imageScrollView addSubview: subViews];
        //点击图片事件
        [subViews callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
           NSLog(@"subViews cliped");
            ShouyeBannerModel *item = [items objectAtIndex:i];
            if ([item.linkType isEqualToString:@"store_detail"]) {//商家详情
                FoodShopDetailViewController *shopVC = [[FoodShopDetailViewController alloc]init];
                shopVC.storeId = item.storeId;
                [self.navigationController pushViewController:shopVC animated:YES];
            }
            if ([item.linkType isEqualToString:@"store_list"]) {//商家列表
                FoodViewController *foodVC = [[FoodViewController alloc]init];
                foodVC.navTitle = item.title;
                foodVC.StoreListType = DEFAULT_LIST;
                foodVC.bannerModel = item;
                [self.navigationController pushViewController:foodVC animated:YES];
            }
            if ([item.linkType isEqualToString:@"goods_detail"]) {//商品详情
                ProductDetailViewController *vc = [[ProductDetailViewController alloc]init];
                vc.goodId = [NSString stringWithFormat:@"%d",[item.goodsId intValue]];
                vc.goodsImageStr = [NSString stringWithFormat:@"%@",item.img];
                NSLog(@"%@",vc.goodId);
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([item.linkType isEqualToString:@"goods_list"]) {//商品列表
                ProductListViewController *vc = [[ProductListViewController alloc]init];
                vc.bannerModel = item;
                [self.navigationController pushViewController:vc animated:YES];
            }
            //代金券详情
            if ([item.linkType isEqualToString:@"goods_detail_coupon"]) {
                CashCouponDetailViewController *CashCouponDetailVC = [[CashCouponDetailViewController alloc]init];
                CashCouponDetailVC.goodsId = item.goodsId;
                [self.navigationController pushViewController:CashCouponDetailVC animated:YES];
            }

        }];
    }
    
//    UIImageView *lastView=[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:0]];
    SwbClickImageView *lastView=[[SwbClickImageView alloc] initWithFrame:CGRectMake(Width*(imageArray.count+1), 0, Width, Height)];
    lastView.backgroundColor = Color_bg00;
//    lastView.contentMode = UIViewContentModeScaleAspectFit;
    [lastView setImageWithURL:[imageArray objectAtIndex:0] placeholderImage:PlaceholderImage_Big];
    [imageScrollView addSubview:lastView];
    //点击图片事件
    [lastView callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
        NSLog(@"lastView cliped");
    }];
    //set the first as the last
    
//    //添加单击手势
//    UITapGestureRecognizer *panRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom0:)];
//    panRecognizer.numberOfTapsRequired = 1;
//    [imageScrollView addGestureRecognizer:panRecognizer];
    
    [imageScrollView setContentSize:CGSizeMake(Width*(imageArray.count+2), Height)];
    //    [self.view addSubview:self.scrollView];
    [imageScrollView scrollRectToVisible:CGRectMake(Width, 0, Width, Height) animated:NO];
    
    pageControl.numberOfPages=imageArray.count;
    //    self.pageControl.backgroundColor=[UIColor blueColor];//背景
    pageControl.currentPage=0;
    pageControl.enabled=YES;
    [self.mainTabview addSubview:pageControl];
    [pageControl addTarget:self action:@selector(pageTurn:)forControlEvents:UIControlEventValueChanged];
    
    myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    
}
-(void)scrollToNextPage:(id)sender
{
    int pageNum=pageControl.currentPage;
    CGSize viewSize=imageScrollView.frame.size;
    CGRect rect=CGRectMake((pageNum+2)*viewSize.width, 0, viewSize.width, viewSize.height);
    [imageScrollView scrollRectToVisible:rect animated:NO];
    pageNum++;
    if (pageNum==imageArray.count) {
        CGRect newRect=CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
        [imageScrollView scrollRectToVisible:newRect animated:NO];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth=imageScrollView.frame.size.width;
    int currentPage=floor((imageScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    if (currentPage==0) {
        pageControl.currentPage=imageArray.count-1;
    }else if(currentPage==imageArray.count+1){
        pageControl.currentPage=0;
    }
    pageControl.currentPage=currentPage-1;
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [myTimer invalidate];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth=imageScrollView.frame.size.width;
    CGFloat pageHeigth=imageScrollView.frame.size.height;
    int currentPage=floor((imageScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    NSLog(@"the current offset==%f",imageScrollView.contentOffset.x);
    NSLog(@"the current page==%d",currentPage);
    
    if (currentPage==0) {
        [imageScrollView scrollRectToVisible:CGRectMake(pageWidth*imageArray.count, 0, pageWidth, pageHeigth) animated:NO];
        pageControl.currentPage=imageArray.count-1;
        NSLog(@"pageControl currentPage==%d",pageControl.currentPage);
        NSLog(@"the last image");
        return;
    }else  if(currentPage==[imageArray count]+1){
        [imageScrollView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
        pageControl.currentPage=0;
        NSLog(@"pageControl currentPage==%d",pageControl.currentPage);
        NSLog(@"the first image");
        return;
    }
    pageControl.currentPage=currentPage-1;
    NSLog(@"pageControl currentPage==%d",pageControl.currentPage);
//    [self pageTurn:pageControl];
    
}

-(void)pageTurn:(UIPageControl *)sender
{
    int pageNum=pageControl.currentPage;
    CGSize viewSize=imageScrollView.frame.size;
    [imageScrollView setContentOffset:CGPointMake((pageNum+1)*viewSize.width, 0)];
    NSLog(@"myscrollView.contentOffSet.x==%f",imageScrollView.contentOffset.x);
    NSLog(@"pageControl currentPage==%d",pageControl.currentPage);
    [myTimer invalidate];
}
////单击事件处理
//- (void) handlePanFrom0:(UITapGestureRecognizer *)recognizer
//{
//    CGFloat tagX = [recognizer locationInView:imageScrollView].x;
//    CGFloat ViewWidth = self.view.frame.size.width;
//    NSInteger tagIndex = tagX/ViewWidth;
//    NSLog(@"fgfgfgdfg%f->%f",[recognizer locationInView:imageScrollView].x,[recognizer locationInView:imageScrollView].y);
//}



//#pragma mark-----
//#pragma mark---------UIScrollViewDelegate---------
//- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    [self pageTurn:pageControl];
//}

#pragma mark-----
#pragma mark---------UITableviewDelegate  UITableViewDatasource---------
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark------
#pragma mark------UITextFieldDelegate---------

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    SearchViewController *searchVC = [[SearchViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:searchVC animated:NO];
    [textField endEditing:YES];
}

- (void)navRightButtonTapped:(id)sender
{
    //    [[SlideNavigationController sharedInstance] toggleRightMenu];
    NSLog(@"%s",__func__);
    MessageListViewController *messageVC = [[MessageListViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)navLeftButtonTapped:(id)sender
{
    //    [[SlideNavigationController sharedInstance] toggleLeftMenu];
    NSLog(@"%s",__func__);
    
    

    
    if (_SelectCityView.isHidden == YES) {
        [_SelectCityView setHidden:NO];
        [_selectVMengbanView setHidden:NO];
        if ([FileOperation getCurrentCityName]!=nil) {
//            [_SelectCityView addSubViewsWithCity:[FileOperation getobjectForKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]]];
            [self setNavButtonFrameByTitle:[FileOperation getCurrentCityName] andCityId:[FileOperation getCurrentCityId]];
            [self.navButton setdownWithTitle:[FileOperation getCurrentCityName]];
            [_SelectCityView addSubViewsWithCity:[FileOperation getCurrentCityName]];
        }else{
            [_SelectCityView addSubViewsWithCity:@"上海"];
            [self setNavButtonFrameByTitle:@"上海" andCityId:@"321"];
            [self.navButton setdownWithTitle:@"上海"];
        }
        
        
    }else{
        [_SelectCityView setHidden:YES];
        [_selectVMengbanView setHidden:YES];
        [self setNavButtonFrameByTitle:[FileOperation getCurrentCityName] andCityId:[FileOperation getCurrentCityId]];
        [self.navButton setupWithTitle:[FileOperation getCurrentCityName]];

    }
    
//    
//    - (void)setup
//    {
//        [self.updownImageView setImage:[UIImage imageNamed:imageUp]];
//    }
//    //收起
//    - (void)setdownWithTitle:(NSString *)string
}

#pragma mark------
#pragma mark------SelectCityViewDelegate---------
- (void) changeCity
{
    [_SelectCityView setHidden:YES];
    [_selectVMengbanView setHidden:YES];
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:selectCityVC animated:YES];
}

- (void) selectView:(SelectCityView *)mSelectView selectedIndex:(int)index
{
    //当前选择index存入plist文件
    [FileOperation writeSelectIndex:index];
    [_SelectCityView setHidden:YES];
    [_selectVMengbanView setHidden:YES];
    //获取当前定位城市的所有区县
    NSArray *cityArr = [FileOperation getobjectForKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
    //得到当前选择区县的数据 并写进plist文件
    [FileOperation writeCurrentCityWithCityName:[[cityArr objectAtIndex:index]objectForKey:@"regionName"] andCityId:[[cityArr objectAtIndex:index]objectForKey:@"regionId"]];
    if ([FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",[[cityArr objectAtIndex:index]objectForKey:@"regionId"]]].count > 1) {
        [FileOperation setPlistObject:[FileOperation getNextPlacesByCurrentCityId:[NSString stringWithFormat:@"%@",[[cityArr objectAtIndex:index]objectForKey:@"regionId"]]] forKey:kCurrentCityArr ofFilePath:[FileOperation creatPlistIfNotExist:SET_PLIST]];
    }

    [_SelectCityView addSubViewsWithCity:[FileOperation getCurrentCityName]];
    [self setNavButtonFrameByTitle:[[cityArr objectAtIndex:index]objectForKey:@"regionName"] andCityId:[[cityArr objectAtIndex:index]objectForKey:@"regionId"]];
    [self.navButton setupWithTitle:[[cityArr objectAtIndex:index]objectForKey:@"regionName"]]; 
}

#pragma mark------
#pragma mark------数据请求---------
//限时优惠
- (void) timeLimitPrivilege
{ 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"jbb_index_xianshi",@"code", nil];
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.show" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
//            if (responseObject.succeed) {
//                NSLog(@"%@",responseObject.result);
//                if (limitYouhuiArr != nil) {
//                    [limitYouhuiArr removeAllObjects];
//                    limitYouhuiArr = nil;
//                }
//                limitYouhuiArr = [[NSMutableArray alloc]init];
//                for (NSDictionary *dic in responseObject.result) {
//                    TimeLimitModel *timeLinmitItem = [[TimeLimitModel alloc]init];
//                    timeLinmitItem = [JsonStringTransfer dictionary:dic ToModel:timeLinmitItem];
//                    [limitYouhuiArr addObject:timeLinmitItem];
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.mainTabview reloadData];
//                });
//            }
            if (responseObject.succeed) {
                NSLog(@"%@",responseObject.result);
                NSArray *resultArr = [NSArray arrayWithArray:responseObject.result];
                if (limitYouhuiArr != nil) {
                    [limitYouhuiArr removeAllObjects];
                    limitYouhuiArr = nil;
                }
                limitYouhuiArr = [[NSMutableArray alloc]init];
                
                for (NSDictionary *dic in resultArr) {
                    NSMutableDictionary *dic0 = [[NSMutableDictionary alloc]init];
                    for (NSString *key in [dic allKeys]) {
                        if ([[dic objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dic1 = [NSDictionary dictionaryWithDictionary:[dic objectForKey:key]];
                            for ( NSString *key1 in [dic1 allKeys]) {
                                [dic0 setObject:[dic1 objectForKey:key1] forKey:key1];
                            }
                        }else{
                            [dic0 setObject:[dic objectForKey:key] forKey:key];
                        }
                    }
                    ShouyeBannerModel *shouyeBannerItem = [[ShouyeBannerModel alloc]init];
                    shouyeBannerItem = [JsonStringTransfer dictionary:dic0 ToModel:shouyeBannerItem];
                    [limitYouhuiArr addObject:shouyeBannerItem];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainTabview reloadData];
                });
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    });
    
}

//附近优惠
- (void) nearbyYouhui:(void (^)(BOOL finish))success
{
    NSLog(@"locationCorrrdinate.latitude = %@",_latitude);
    _latitude = [NSString stringWithFormat:@"%@",[FileOperation getLatitude]];
    _longitude = [NSString stringWithFormat:@"%@",[FileOperation getLongitude]];
    //[NSString stringWithFormat:@"%@",[FileOperation getCurrentCityId]]
    //参数字典
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_latitude,@"latitude",_longitude,@"longitude",[NSString stringWithFormat:@"%ld",page+1],@"page",@"4",@"pageSize",[FileOperation getCurrentCityId],@"regionId",@"",@"categoryId",@"eg.add_time",@"orderBy",@"desc",@"ascDesc", nil];
    //post请求
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.fujinyouhui" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed ) {
            NSLog(@"%@",responseObject.result);
            
            NSArray *dataArr =[NSArray arrayWithArray:[responseObject.result objectForKey:@"data"]];
            //每次加载10条数据，若本次请求得到数据条数少于10条，说明内容全部加载完成
            page = [[responseObject.result objectForKey:@"page"] integerValue];
            if (dataArr.count < 4) {
                isEnd = YES;
            }
            for (int i=0; i<dataArr.count; i++) {
                NearPrivilegeModel *nearbyItem = [[NearPrivilegeModel alloc]init];
                nearbyItem = [JsonStringTransfer dictionary:[NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:i]] ToModel:nearbyItem];
                [nearbyYouhuiArr addObject:nearbyItem];
            }
            NSLog(@"reload data  locationCorrrdinate.latitude = %@",_latitude);
            //                    dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTabview reloadData];
            //                    });
        }
        success(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        success(NO);
    }];

    /*
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //区分模拟器和真机
#if TARGET_IPHONE_SIMULATOR
        //参数字典
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",31.324698],@"latitude",[NSString stringWithFormat:@"%f",121.447377],@"longitude",[NSString stringWithFormat:@"%d",page+1],@"page",@"4",@"pageSize",@"",@"categoryId",@"eg.add_time",@"orderBy",@"desc",@"ascDesc",@"3416",@"regionId", nil];
        _latitude = @"31.326362";
        _longitude = @"121.442765";
        //post请求
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.fujinyouhui" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed ) {
                NSLog(@"%@",responseObject.result);
                NSArray *dataArr =[NSArray arrayWithArray:[responseObject.result objectForKey:@"data"]];
                
                for (int i=0; i<dataArr.count; i++) {
                    NearPrivilegeModel *nearbyItem = [[NearPrivilegeModel alloc]init];
                    nearbyItem = [JsonStringTransfer dictionary:[NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:i]] ToModel:nearbyItem];
                    [nearbyYouhuiArr addObject:nearbyItem];
                }
                //每次加载10条数据，若本次请求得到数据条数少于10条，说明内容全部加载完成
                page = [[responseObject.result objectForKey:@"page"] integerValue];
                if (page >= [[responseObject.result objectForKey:@"totalPage"] integerValue]) {
                    isEnd = YES;
                }
                
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTabview reloadData];
//            });
            success(YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            success(NO);
        }];
        
#elif TARGET_OS_IPHONE
        //当前经纬度
        NSLog(@"dd locationCorrrdinate.latitude = %@",_latitude);
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        _latitude = [NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
        _longitude = [NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
        NSLog(@"locationCorrrdinate.latitude = %@",_latitude);
        
        //[NSString stringWithFormat:@"%@",[FileOperation getCurrentCityId]]
        //参数字典
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude],@"latitude",[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude],@"longitude",[NSString stringWithFormat:@"%d",page+1],@"page",@"4",@"pageSize",@"3416",@"regionId",@"",@"categoryId",@"eg.add_time",@"orderBy",@"desc",@"ascDesc", nil];
        //post请求
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.fujinyouhui" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed ) {
                NSLog(@"%@",responseObject.result);
                
                NSArray *dataArr =[NSArray arrayWithArray:[responseObject.result objectForKey:@"data"]];
                //每次加载10条数据，若本次请求得到数据条数少于10条，说明内容全部加载完成
                page = [[responseObject.result objectForKey:@"page"] integerValue];
                if (dataArr.count < 4) {
                    isEnd = YES;
                }
                for (int i=0; i<dataArr.count; i++) {
                    NearPrivilegeModel *nearbyItem = [[NearPrivilegeModel alloc]init];
                    nearbyItem = [JsonStringTransfer dictionary:[NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:i]] ToModel:nearbyItem];
                    [nearbyYouhuiArr addObject:nearbyItem];
                }
                NSLog(@"reload data  locationCorrrdinate.latitude = %@",_latitude);
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTabview reloadData];
                //                    });
            }
            success(YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            success(NO);
        }];

    } andLocationErrer:^(NSString *errorString) {
        _latitude = @"31.326362";
        _longitude = @"121.442765";
        NSLog(@"locationCorrrdinate.latitude = %@",_latitude);
        
        //[NSString stringWithFormat:@"%@",[FileOperation getCurrentCityId]]
        //参数字典
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",_latitude],@"latitude",[NSString stringWithFormat:@"%f",_longitude],@"longitude",[NSString stringWithFormat:@"%d",page+1],@"page",@"4",@"pageSize",@"3416",@"regionId",@"",@"categoryId",@"eg.add_time",@"orderBy",@"desc",@"ascDesc", nil];
        //post请求
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.fujinyouhui" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed ) {
                NSLog(@"%@",responseObject.result);
                
                NSArray *dataArr =[NSArray arrayWithArray:[responseObject.result objectForKey:@"data"]];
                //每次加载10条数据，若本次请求得到数据条数少于10条，说明内容全部加载完成
                page = [[responseObject.result objectForKey:@"page"] integerValue];
                if (dataArr.count < 4) {
                    isEnd = YES;
                }
                for (int i=0; i<dataArr.count; i++) {
                    NearPrivilegeModel *nearbyItem = [[NearPrivilegeModel alloc]init];
                    nearbyItem = [JsonStringTransfer dictionary:[NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:i]] ToModel:nearbyItem];
                    [nearbyYouhuiArr addObject:nearbyItem];
                }
                NSLog(@"reload data  locationCorrrdinate.latitude = %@",_latitude);
                //                    dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTabview reloadData];
                //                    });
            }
            success(YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            success(NO);
        }];

    }];
//        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
////            
//        }];
    
#endif

//    });
     
     */
    
}
//首页｀抽奖
- (void) FirstPageChoujiang
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"jbb_index_choujiang",@"code", nil];
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.show" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"%@",responseObject.result);
                choujiangDic = [NSDictionary dictionaryWithDictionary:[responseObject.result objectAtIndex:0]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainTabview reloadData];
                });
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    });
    
}
#pragma mark------
#pragma mark------单击萌版---------
- (void)handleSingleTapFrom
{
    [_SelectCityView setHidden:YES];
    [_selectVMengbanView setHidden:YES];
    [self setNavButtonFrameByTitle:[FileOperation getCurrentCityName] andCityId:[FileOperation getCurrentCityId]];
    [self.navButton setupWithTitle:[FileOperation getCurrentCityName]];
}
//#pragma mark------
//#pragma mark------SelectCityViewDelegate---------
//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation
//{
//    if ((newLocation.coordinate.latitude-[_latitude floatValue] > 1)||(newLocation.coordinate.longitude-[_longitude floatValue] > 1)) {
//        _latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
//        _longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
//        [self nearbyYouhui:^(BOOL finish) {
//            
//        }];
//    }
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

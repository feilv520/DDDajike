//
//  DShouYeViewController.m
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DShouYeViewController.h"
#import "dDefine.h"
#import "DShouye01Cell.h"
#import "DRexiaoGoodsCell.h"
#import "DTodayNewGoodsCell.h"
#import "DZhutijie02Cell.h"
#import "DZhutijieCell.h"
#import "SwbClickImageView.h"
#import "UIImageView+AFNetworking.h"
#import "DImgButton.h"
#import "DTools.h"
#import "DTabView.h"
#import "DDrawMainViewController.h"

#import "DTodayNewMOdel.h"
#import "DRexiaoGoodsCell.h"

#import "ShouyeBannerModel.h"

#import "DShouyeZIyingViewController.h"
#import "DShouyeZhiyingController.h"

#import "DSearchViewController.h"

#import "DZiyingsCategoryModel.h"

#import "DWebViewController.h"

#import "DGoodsListViewController.h"
#import "DSJShouYeViewController.h"
#import "DMessageListViewController.h"

@interface DShouYeViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,DShouye01CellDelegate>
{
    UIScrollView *imageScrollView;
    UIPageControl *pageControl;
    
    BOOL pageControlBeingUsed;
    NSTimer *myTimer;//定时器
    NSMutableArray *imageArray;
    
//    NSMutableArray *imageArrayDemo;
    
    NSArray *fenleiArr;
    
    UICollectionView *collectionView01;
    UICollectionView *collectionView02;
    
    
    //今日新品
    NSMutableArray *todayNewGoogsArr;
    
    //热销商品列表
    NSMutableArray *hostGoodsArr;
    NSInteger page;
    
    //主题街列表
    NSMutableArray *zhutijieList;
    
    
    //大集客自营大分类数组
    NSMutableArray *ziyingList;
    
}

@end

@implementation DShouYeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self dajikeZiyingArr];
    if (imageArray.count > 0) {
        if (myTimer) {
            [myTimer invalidate];
        }
        myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    }
    
    //及时刷新热销商品，以便在个人中心删除收藏后，在首页收藏状态不变化
    if (hostGoodsArr.count > 0) {
        [self getHostGoods];
    }
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (myTimer) {
        [myTimer invalidate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //数据的初始化
    [self initdatas];
    
    [self addTableView:YES];
//    [self.dMainTableView setFrame:CGRectMake(0, 64, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT-64-49)];
    [self.dMainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    [self getData:^(BOOL finish) {
        
    }];
    [self addSubViews];
   
    DTabView *tabView = [[DTabView alloc]initWithFrame:DRect(0, DHEIGHT_CONTROLLER_DEFAULT-49, DWIDTH_CONTROLLER_DEFAULT, 49)];
    [tabView setMainView:0];
    [self.view addSubview:tabView];
    
    
}
//数据的初始化
- (void) initdatas
{
    isEnd = NO;
    page = 0;
    todayNewGoogsArr = [[NSMutableArray alloc]init];
    hostGoodsArr = [[NSMutableArray alloc]init];
}

- (void) addSubViews
{
    //添加nav title
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(-15, 0, 250+5, 44)];
    UITextField *navTitleView = [[UITextField alloc]initWithFrame:CGRectMake(-12, 6, 250-35, 28)];
    [navTitleView setBorderStyle:UITextBorderStyleRoundedRect];
    navTitleView.backgroundColor = [UIColor whiteColor];
    navTitleView.layer.borderColor = [DColor_mainRed CGColor];
    navTitleView.layer.borderWidth = 1;
    navTitleView.layer.contentsScale = 3.0;
    [navTitleView setFont:DFont_11];
    //        navTitleView.nuiClass = @"ShouyeNavTitleViewTextField";
    [navTitleView setPlaceholder:@"  搜索商品、店铺"];
    [navTitleView setFont:DFont_11];
    [navTitleView setKeyboardType:UIKeyboardTypeDefault];
    navTitleView.delegate = self;
    [headV addSubview:navTitleView];
    [self naviBarAddCoverViewOnTitleView:headV];
    
    //左边按钮
    DImgButton *leftBtn = [[DImgButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"djk_shouye_img_01"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(toLeftNavButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 25, 25)];
    leftImageV.layer.cornerRadius = 2.0;
    leftImageV.layer.masksToBounds = YES;
    [leftImageV setImage:[UIImage imageNamed:@"djk_index_11"]];
    leftImageV.contentMode = UIViewContentModeScaleAspectFit;
    [leftBtn addSubview:leftImageV];
    [self setNaviBarLeftBtn:leftBtn];
    
    //右边按钮
    DImgButton *rightBtn = [[DImgButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"djk_shouye_img_02"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(toRightNavButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImageV = [[UIImageView alloc]initWithFrame:CGRectMake(24, 8, 25, 25)];
    [rightImageV setImage:[UIImage imageNamed:@"djk_index_12"]];
    rightImageV.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addSubview:rightImageV];

    [self setNaviBarRightBtn:rightBtn];
    
    imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, DWIDTH_CONTROLLER_DEFAULT/2.0)];
    imageScrollView.backgroundColor = DColor_bg;
    [imageScrollView setPagingEnabled:YES];
    //设置滚动条类型
    imageScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    //是否自动裁切超出部分
    imageScrollView.clipsToBounds = YES;
    //设置是否可以缩放
    imageScrollView.scrollEnabled = YES;
    imageScrollView.showsHorizontalScrollIndicator = FALSE;//水平滚动条是否显示
    imageScrollView.showsVerticalScrollIndicator = FALSE;//垂直滚动条是否显示
    self.dMainTableView.tableHeaderView = imageScrollView;
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-35, self.view.frame.size.width/2-25, 70, 30)];
    [pageControl setCurrentPageIndicatorTintColor:DColor_mainRed];
    [pageControl setPageIndicatorTintColor:DColor_ffffff];
    
    [self forADImage];
}

- (void) getData:(void (^)(BOOL finish))success
{
    //banner
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.show" parameters:@{@"code":@"djk_index_banner"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self bindAds:modelArr];
                    });
                }
                
            }
            success(YES);
            NSLog(@"operation = %@",operation);
            NSLog(@"responseObject = %@",responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"operation = %@",operation);
            NSLog(@"error = %@",error);
            success(YES);
        }];
    });
   
    //主题街
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.show" parameters:@{@"code":@"djk_index_theme_street"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                if (zhutijieList != nil) {
                    [zhutijieList removeAllObjects];
                    zhutijieList = nil;
                }
                zhutijieList = [[NSMutableArray alloc]init];
                NSLog(@"%@",responseObject.result);
                NSArray *resultArr = [NSArray arrayWithArray:responseObject.result];
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
                    [zhutijieList addObject:shouyeBannerItem];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.dMainTableView reloadData];
                });
            }
            NSLog(@"operation = %@",operation);
            NSLog(@"responseObject = %@",responseObject);
            success(YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"operation = %@",operation);
            NSLog(@"error = %@",error);
            success(YES);
        }];

    });
    
    //今日新品
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.indexRecommend" parameters:@{@"recomId":@"62",@"page":@"1",@"pageSize":@"100"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                if (todayNewGoogsArr != nil) {
                    [todayNewGoogsArr removeAllObjects];
                    todayNewGoogsArr = nil;
                }
                todayNewGoogsArr = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in [responseObject.result objectForKey:@"data"]) {
                    DTodayNewMOdel *itemModel = [[DTodayNewMOdel alloc]init];
                    itemModel = [JsonStringTransfer dictionary:dic ToModel:itemModel];
                    [todayNewGoogsArr addObject:itemModel];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dMainTableView reloadData];
            });
            NSLog(@"operation = %@",operation);
            NSLog(@"responseObject = %@",responseObject);
            success(YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"operation = %@",operation);
            NSLog(@"error = %@",error);
            success(YES);
        }];
    });
    
    
   
}
 //热销商品请求数据
- (void) getHostGoods:(void (^)(BOOL finish))success
{
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.indexRecommend" parameters:@{@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10",@"userId":[FileOperation getUserId],@"recomId":@"61"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            if ([responseObject.result objectForKey:@"data"] == [NSNull null]) {
                isEnd = YES;
                [self.dMainTableView reloadData];
                success(YES);
                return ;
            }
            NSArray *arr = [NSArray arrayWithArray:[responseObject.result objectForKey:@"data"]];
            for (NSDictionary *dic in arr) {
                DReXiaoGoodsModel *rexiaoModel = [[DReXiaoGoodsModel alloc]init];
                rexiaoModel = [JsonStringTransfer dictionary:dic ToModel:rexiaoModel];
                [hostGoodsArr addObject:rexiaoModel];
            }
            page++;
            if (arr.count < 10) {
                isEnd = YES;
            }
            [self.dMainTableView reloadData];
        }
        success(YES);
        NSLog(@"operation = %@",operation);
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation = %@",operation);
        NSLog(@"error = %@",error);
        success(YES);
    }];
}

//为了热销商品收藏状态保持最新，每次进入页面需要重新加载数据
- (void) getHostGoods
{
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.indexRecommend" parameters:@{@"page":[NSString stringWithFormat:@"%d",1],@"pageSize":[NSString stringWithFormat:@"%d",hostGoodsArr.count],@"userId":[FileOperation getUserId],@"recomId":@"61"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            if ([responseObject.result objectForKey:@"data"] == [NSNull null]) {
                isEnd = YES;
                [self.dMainTableView reloadData];
                return ;
            }
            NSArray *arr = [NSArray arrayWithArray:[responseObject.result objectForKey:@"data"]];
            if (hostGoodsArr != nil) {
                [hostGoodsArr removeAllObjects];
                hostGoodsArr = nil;
            }
            hostGoodsArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in arr) {
                DReXiaoGoodsModel *rexiaoModel = [[DReXiaoGoodsModel alloc]init];
                rexiaoModel = [JsonStringTransfer dictionary:dic ToModel:rexiaoModel];
                [hostGoodsArr addObject:rexiaoModel];
            }
            [self.dMainTableView reloadData];
        }
        NSLog(@"operation = %@",operation);
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation = %@",operation);
        NSLog(@"error = %@",error);
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-----
#pragma mark---------load data---------
//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        showMessage(@"加载完成");
        success (YES);
    }else{
        if (hostGoodsArr == nil) {
            [self.footer resetNoMoreData];
            page = 0;
            isEnd = NO;
        }
        [self getHostGoods:^(BOOL finish) {
            success(finish);
        }];
    }
}

//刷新数据
- (void) refreshData:(void (^)(BOOL finish))success
{
    //重新加载数据。一切都重新初始化
    [self.footer resetNoMoreData];
    //重新加载数据。一切都重新初始化
    isEnd = NO;
    page = 0;
    [hostGoodsArr removeAllObjects];
    hostGoodsArr = nil;
    hostGoodsArr = [[NSMutableArray alloc]init];
    
    [self getData:^(BOOL finish) {
        success(finish);
    }];
}


#pragma mark------
#pragma mark------UITextFieldDelegate---------

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField endEditing:YES];
    DSearchViewController *searchVC = [[DSearchViewController alloc]init];
    push(searchVC);
}

#pragma mark------
#pragma mark------UITableViewDataSource  UITableViewDelegate---------
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 55.0;
    }
    return 6.0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (row == 0) {
            return DWIDTH_CONTROLLER_DEFAULT*(87.0/320);
        }
    }else if(section == 1){
        if (row == 0) {
            return 32.0;
        }else{
            if (todayNewGoogsArr.count > 0) {
                return DWIDTH_CONTROLLER_DEFAULT*(93.0/320);
            }
            return 0.5;
        }
    }else if(section == 2){
        if (row == 0) {
            return 32.0;
        }else{
            return DWIDTH_CONTROLLER_DEFAULT*(100.0/320);
        }
    }
    else if(section == 3){
        if (row == 0) {
            if (hostGoodsArr.count > 0) {
                return (DWIDTH_CONTROLLER_DEFAULT*(249.0 + 10)/320)*(hostGoodsArr.count/2+(hostGoodsArr.count%2 > 0?1:0));
            }
            return 5;
        }
    }
    return 0;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return zhutijieList.count+1;
    }
    else if(section == 3){
        return 1;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 55)];
        v.backgroundColor = [UIColor whiteColor];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 27, DWIDTH_CONTROLLER_DEFAULT/2 - 35, 1.0)];
        line1.backgroundColor = DColor_666666;
        [v addSubview:line1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT/2 + 35, 27, DWIDTH_CONTROLLER_DEFAULT/2 - 35, 1)];
        line2.backgroundColor = DColor_666666;
        [v addSubview:line2];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT/2 - 35, 0, 70, 55)];
        [label setFont:DFont_11];
        [label setTextColor:DColor_666666];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.text = @"热销商品";
        [v addSubview:label];
        
        return v;
    }
    return nil;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (row == 0) {
            DShouye01Cell *cell00 = [self loadDShouye01Cell:self.dMainTableView];
            cell00.delegate = self;
            return cell00;
        }
    }else if(section == 1){
        if (row == 0) {
            static NSString *identifer = @"cell10";
            UITableViewCell *cell10 = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell10 == nil) {
                cell10 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 32)];
                label.backgroundColor = [UIColor clearColor];
                [label setFont:DFont_13];
                [label setTextColor:DColor_mainRed];
                label.text = @"今日新品";
                [cell10 addSubview:label];
            }
//            cell10.backgroundColor = [UIColor greenColor];
            return cell10;
        }else{
            static NSString *identifer = @"cell11";
//            UITableViewCell *cell11 = [tableView dequeueReusableCellWithIdentifier:identifer];
//            if (cell11 == nil) {
//                
//            }
            
            UITableViewCell *cell11 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
            //    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            //    flowlayout.headerReferenceSize = CGSizeMake(100, 100);
            //    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowlayout];
            if (todayNewGoogsArr.count > 0) {
                collectionView01 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, DWIDTH_CONTROLLER_DEFAULT*(93.0/320)) collectionViewLayout:flowlayout];
            }else{
                collectionView01 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 0.5) collectionViewLayout:flowlayout];
            }
            
            [collectionView01 registerClass:[DTodayNewGoodsCell class] forCellWithReuseIdentifier:@"collectionView01Cell"];
            collectionView01.delegate = self;
            collectionView01.dataSource = self;
            collectionView01.backgroundColor = [UIColor whiteColor];
            [cell11 addSubview:collectionView01];
            return cell11;
        }
    }else if(section == 2){
        if (row == 0) {
            static NSString *identifer = @"cell20";
            UITableViewCell *cell20 = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell20 == nil) {
                cell20 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 32)];
                label.backgroundColor = [UIColor clearColor];
                [label setFont:DFont_13];
                [label setTextColor:DColor_mainRed];
                label.text = @"主题街";
                [cell20 addSubview:label];
            }
            return cell20;
        }else if(row < (zhutijieList.count/2+(zhutijieList.count%2?1:0) + 1)){
            DZhutijieCell *cell21 = [self loadDZhutijieCell:self.dMainTableView];
            if (zhutijieList.count > indexPath.row-1) {
                cell21.zhutijiemodel = [zhutijieList objectAtIndex:row-1];
            }
            if (row%2 == 0) {
                cell21.backgroundColor = [UIColor colorWithRed:(220+row*10)/255.0 green:(239+10*row)/255.0 blue:(227-row*10)/255.0 alpha:1];
            }else{
                cell21.backgroundColor = [UIColor colorWithRed:(190-(row- (zhutijieList.count/2+(zhutijieList.count%2?1:0) + 1))*10)/255.0 green:(239+10*(row- (zhutijieList.count/2+(zhutijieList.count%2?1:0) + 1)))/255.0 blue:(247-(row- (zhutijieList.count/2+(zhutijieList.count%2?1:0) + 1))*10)/255.0 alpha:1];
            }
            
//            cell21.backgroundColor = [UIColor colorWithRed:(220+row*10)/255.0 green:(239)/255.0 blue:(247-row*10)/255.0 alpha:1];
            return cell21;
        }else{
//            DZhutijie02Cell *cell22 = [self loadDZhutijie02Cell:self.dMainTableView];
            DZhutijie02Cell *cell22 = [DTools loadTableViewCell:self.dMainTableView cellClass:[DZhutijie02Cell class]];
            if (zhutijieList.count > indexPath.row-1) {
                cell22.zhutijiemodel = [zhutijieList objectAtIndex:row-1];
            }
            if (row%2 == 0) {
                cell22.backgroundColor = [UIColor colorWithRed:(220+row*10)/255.0 green:(239+10*row)/255.0 blue:(247-row*10)/255.0 alpha:1];
            }else{
                cell22.backgroundColor = [UIColor colorWithRed:(200-(row- (zhutijieList.count/2+(zhutijieList.count%2?1:0) + 1))*10)/255.0 green:(239+10*(row- (zhutijieList.count/2+(zhutijieList.count%2?1:0) + 1)))/255.0 blue:(247-(row- (zhutijieList.count/2+(zhutijieList.count%2?1:0) + 1))*10)/255.0 alpha:1];
            }

            return cell22;
        }
    }
    else if(section == 3){
        if (row == 0) {
            UITableViewCell *cell30 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell30"];
            UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
            [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            if (hostGoodsArr.count > 0) {
                collectionView02 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, DWIDTH_CONTROLLER_DEFAULT*((249.0 + 10)/320.0)*(hostGoodsArr.count/2+(hostGoodsArr.count%2 > 0?1:0))) collectionViewLayout:flowlayout];
            }else{
                collectionView02 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT/320.0, DWIDTH_CONTROLLER_DEFAULT/320.0/5) collectionViewLayout:flowlayout];
            }
            [collectionView02 registerClass:[DRexiaoGoodsCell class] forCellWithReuseIdentifier:@"collectionView02Cell"];
            [collectionView02 setScrollEnabled:NO];
            collectionView02.delegate = self;
            collectionView02.dataSource = self;
            collectionView02.backgroundColor = [UIColor whiteColor];
            [cell30 addSubview:collectionView02];
            return cell30;

        }
    }

    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ((indexPath.section == 2)&&(indexPath.row > 0)) {
        ShouyeBannerModel *model = (ShouyeBannerModel *)[zhutijieList objectAtIndex:indexPath.row-1];
        NSString *linkType = [NSString stringWithFormat:@"%@",model.linkType];
        if ([linkType isEqualToString:@"goods_detail"]) {//商品详情
            DWebViewController *vc = [[DWebViewController alloc]init];
            if ([FileOperation isLogin]) {
                vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",model.goodsId,get_userId];
            }else{
                vc.urlStr = [NSString stringWithFormat:@"goodsId=%@",model.goodsId];
            }
            vc.type = IS_NEED_ADD;
            vc.goodId = [NSString stringWithFormat:@"%@",model.goodsId];
            vc.imageUrl = [NSString stringWithFormat:@"%@",model.img];
            vc.googsTitle = [NSString stringWithFormat:@"%@",model.title];
            vc.isHelp = 6;
            push(vc);

        }
        if ([linkType isEqualToString:@"store_detail"]) {//商家详情
            DSJShouYeViewController *sjVC = [[DSJShouYeViewController alloc]init];
            sjVC.storeId = model.storeId;
            push(sjVC);
        }
        if ([linkType isEqualToString:@"store_list"]) {//商家列表
            
        }
        if ([linkType isEqualToString:@"goods_list"]) {//商品列表
            DGoodsListViewController *goodsListVC = [[DGoodsListViewController alloc] init];
            goodsListVC.cateId = [NSString stringWithFormat:@"%@",model.cateId];
            push(goodsListVC);
        }
        
    }
}
#pragma mark------
#pragma mark------UICollectionViewDataSource  UICollectionViewDelegate---------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:collectionView01]) {
        if (todayNewGoogsArr.count > 0) {
            return todayNewGoogsArr.count;
        }else{
            return 0;
        }
    }
    if (hostGoodsArr.count > 0) {
        return hostGoodsArr.count;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:collectionView01]) {
        DTodayNewGoodsCell *cell0 = [self loadDTodayNewGoodsCell:collectionView01 atIndexPath:indexPath];
        if (todayNewGoogsArr.count > indexPath.row) {
            cell0.todayNewModel = [todayNewGoogsArr objectAtIndex:indexPath.row];
        }
        return cell0;
    }else{
        DRexiaoGoodsCell *cell02 = [self loadDRexiaoGoodsCell:collectionView02 atIndexPath:indexPath];
        if (hostGoodsArr.count > indexPath.row) {
            cell02.rexiaoModel = [hostGoodsArr objectAtIndex:indexPath.row];
            [cell02.shoucangLabel setTag:300+indexPath.row];
            [cell02.shoucangLabel addTarget:self action:@selector(shoucangGoods:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell02;
    }
//    static NSString * CellIdentifier = @"GradientCell";
//    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    //    if (cell == nil) {
//    //        cell = [UICollectionViewCell alloc]init
//    //    }
//    
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
//    return cell;
    
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([collectionView isEqual:collectionView01]) {
        return 1;
    }else{
        return 1;
    }
    return 1;
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:collectionView01]) {
        return CGSizeMake(DWIDTH_CONTROLLER_DEFAULT*(82.0/320), DWIDTH_CONTROLLER_DEFAULT*(93.0/320));
    }else{
//        return CGSizeMake(155.0+30, 249.0+30);
        return CGSizeMake(DWIDTH_CONTROLLER_DEFAULT*(155.0/320), DWIDTH_CONTROLLER_DEFAULT*(249.0/320));
    }
    return CGSizeMake(0, 0);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:collectionView01]) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
//        CGFloat top, CGFloat left, CGFloat bottom, CGFloat right
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//每个cell之间的间距
- (CGFloat)minimumInteritemSpacing {
    return 0.0;
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if ([collectionView isEqual:collectionView01]) {
        DWebViewController *vc = [[DWebViewController alloc]init];
        DTodayNewMOdel *goodsListModel = (DTodayNewMOdel *)[todayNewGoogsArr objectAtIndex:indexPath.row];
        vc.type = IS_NEED_ADD;
        vc.goodId = [NSString stringWithFormat:@"%@",goodsListModel.goods_id];
        vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",goodsListModel.goods_id,get_userId];
        vc.imageUrl = [NSString stringWithFormat:@"%@",goodsListModel.default_image];
        vc.googsTitle = [NSString stringWithFormat:@"%@",goodsListModel.goods_name];
        vc.isHelp = 6;
        push(vc);
        
    }else{
        if (hostGoodsArr.count > row) {
            DReXiaoGoodsModel *model = (DReXiaoGoodsModel *)[hostGoodsArr objectAtIndex:row];
            DWebViewController *vc = [[DWebViewController alloc]init];
            vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",model.goods_id,get_userId];
            vc.type = IS_NEED_ADD;
            vc.goodId = [NSString stringWithFormat:@"%@",model.goods_id];
            vc.imageUrl = [NSString stringWithFormat:@"%@",model.default_image];
            vc.googsTitle = [NSString stringWithFormat:@"%@",model.goods_name];
            vc.isHelp = 6;
            push(vc);
        }
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:collectionView01]) {
        
    }else{
        
    }
    return YES;
}

#pragma mark------
#pragma mark------loadTableView--------
- (DShouye01Cell *)loadDShouye01Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"DShouye01Cell";
    
    DShouye01Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (DZhutijieCell *)loadDZhutijieCell:(UITableView *)tableView
{
    NSString * const nibName  = @"DZhutijieCell";
    
    DZhutijieCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (DZhutijie02Cell *)loadDZhutijie02Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"DZhutijie02Cell";
    
    DZhutijie02Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

//- (id) loadTableViewCell:(UITableView *)tableView cellClass:(Class)classname
//{
//    NSString *  nibName  = [NSString stringWithFormat:@"%s",object_getClassName(classname)];
//    
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
//    
//    if (cell == nil) {
//        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
//        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
//    }
//    
//    return cell;
//}
#pragma mark------
#pragma mark------loadCollectionView--------
- (DRexiaoGoodsCell *)loadDRexiaoGoodsCell:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath
{
    NSString * const nibName  = @"DRexiaoGoodsCell";
    
    [collectionView registerNib:[UINib nibWithNibName:nibName
                                               bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectionView02Cell"];
    DRexiaoGoodsCell *cell = [[DRexiaoGoodsCell alloc]init];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView02Cell" forIndexPath:indexPath];
    cell.layer.borderColor = [DColor_f7f7f7 CGColor];
    cell.layer.borderWidth = 0.5;
    return cell;

}

- (DTodayNewGoodsCell *)loadDTodayNewGoodsCell:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath
{
    NSString * const nibName  = @"DTodayNewGoodsCell";

    [collectionView registerNib:[UINib nibWithNibName:nibName
                                               bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectionView01Cell"];
    DTodayNewGoodsCell *cell = [[DTodayNewGoodsCell alloc]init];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView01Cell" forIndexPath:indexPath];
    return cell;
}
#pragma mark-----
#pragma mark---------imageScrollViews---------
//广告nanner
- (void)forADImage
{
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.show" parameters:@{@"code":@"djk_index_banner"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
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
  
        }
        NSLog(@"operation = %@",operation);
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation = %@",operation);
        NSLog(@"error = %@",error);
    }];
//    NSArray *arr = @[@"http://img01.dajike.com/data/files/2015/0626/1435318300475.jpg",
//                     @"http://img01.dajike.com/data/files/2015/0626/1435318703168.jpg",
//                     @"http://img01.dajike.com/data/files/2015/0627/1435376040191.jpg",
//                     @"http://img01.dajike.com/data/files/2015/0626/1435318947856.jpg",
//                     ];
//    imageArrayDemo = [NSMutableArray arrayWithArray:arr];
//    [self bindAds:imageArrayDemo];
}

- (void)bindAds:(NSArray *)items
{
    if (items == nil || items.count == 0) {
        return;
    }
    
    
    // ad view
    int count = items.count;
    if (imageArray != nil) {
        [imageArray removeAllObjects];
        imageArray = nil;
    }
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
    firstView.backgroundColor = DColor_a0a0a0;
    //    firstView.contentMode = UIViewContentModeScaleAspectFit;
    [firstView setImageWithURL:[imageArray lastObject] placeholderImage:DPlaceholderImage_Big];
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
        subViews.backgroundColor = DColor_a0a0a0;
        //        subViews.contentMode = UIViewContentModeScaleAspectFit;
        [subViews setImageWithURL:[imageArray objectAtIndex:i] placeholderImage:DPlaceholderImage_Big];
        [imageScrollView addSubview: subViews];
        //点击图片事件
        [subViews callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
            NSLog(@"subViews cliped");
            ShouyeBannerModel *item = [items objectAtIndex:i];
            if ([item.linkType isEqualToString:@"store_detail"]) {//商家详情
                showMessage(@"商家详情");
                DSJShouYeViewController *sjVC = [[DSJShouYeViewController alloc]init];
                sjVC.storeId = item.storeId;
                push(sjVC);            }
            if ([item.linkType isEqualToString:@"store_list"]) {//商家列表
                showMessage(@"商家列表");
            }
            if ([item.linkType isEqualToString:@"goods_detail"]) {//商品详情
                showMessage(@"商品详情");
                DWebViewController *vc = [[DWebViewController alloc]init];
                if ([FileOperation isLogin]) {
                    vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",item.goodsId,get_userId];
                }else{
                    vc.urlStr = [NSString stringWithFormat:@"goodsId=%@",item.goodsId];
                }
                vc.type = IS_NEED_ADD;
                vc.goodId = [NSString stringWithFormat:@"%@",item.goodsId];
                vc.imageUrl = [NSString stringWithFormat:@"%@",item.img];
                vc.googsTitle = [NSString stringWithFormat:@"%@",item.title];
                vc.isHelp = 6;
                push(vc);


            }
            if ([item.linkType isEqualToString:@"goods_list"]) {//商品列表
                showMessage(@"商品列表");
                DGoodsListViewController *goodsListVC = [[DGoodsListViewController alloc] init];
                goodsListVC.cateId = [NSString stringWithFormat:@"%@",item.cateId];
                push(goodsListVC);
            }
            //代金券详情
            if ([item.linkType isEqualToString:@"goods_detail_coupon"]) {
                showMessage(@"代金券详情");
            }
            
        }];
    }
    

    SwbClickImageView *lastView=[[SwbClickImageView alloc] initWithFrame:CGRectMake(Width*(imageArray.count+1), 0, Width, Height)];
    lastView.backgroundColor = DColor_a0a0a0;
    [lastView setImageWithURL:[imageArray objectAtIndex:0] placeholderImage:DPlaceholderImage_Big];
    [imageScrollView addSubview:lastView];
    //点击图片事件
    [lastView callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
        NSLog(@"lastView cliped");
    }];
    
    [imageScrollView setContentSize:CGSizeMake(Width*(imageArray.count+2), Height)];
    //    [self.view addSubview:self.scrollView];
    [imageScrollView scrollRectToVisible:CGRectMake(Width, 0, Width, Height) animated:NO];
    
    pageControl.numberOfPages=imageArray.count;
    //    self.pageControl.backgroundColor=[UIColor blueColor];//背景
    pageControl.currentPage=0;
    pageControl.enabled=YES;
    [self.dMainTableView addSubview:pageControl];
    [pageControl addTarget:self action:@selector(pageTurn:)forControlEvents:UIControlEventValueChanged];
    
    if (myTimer) {
        [myTimer invalidate];
    }
    myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}
-(void)scrollToNextPage:(id)sender
{
//    NSLog(@"scrollToNextPage = %s=%d",__func__,pageControl.currentPage);
    NSInteger pageNum=pageControl.currentPage;
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
    if ([scrollView isEqual:imageScrollView]) {
//        NSLog(@"scrollViewDidScroll = %s=%d",__func__,pageControl.currentPage);
        CGFloat pageWidth=imageScrollView.frame.size.width;
        int currentPage=floor((imageScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
        if (currentPage==0) {
            pageControl.currentPage=imageArray.count-1;
        }else if(currentPage==imageArray.count+1){
            pageControl.currentPage=0;
        }
        pageControl.currentPage=currentPage-1;
//        NSLog(@"ss scrollViewDidScroll = %s=%d",__func__,pageControl.currentPage);
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:imageScrollView]) {
        [myTimer invalidate];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"scrollViewDidEndDragging = %s",__func__);
    if ([scrollView isEqual:imageScrollView]) {
        if (myTimer) {
            [myTimer invalidate];
        }
        myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:imageScrollView]) {
        CGFloat pageWidth=imageScrollView.frame.size.width;
        CGFloat pageHeigth=imageScrollView.frame.size.height;
        int currentPage=floor((imageScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
        NSLog(@"the current offset==%f",imageScrollView.contentOffset.x);
        NSLog(@"the current page==%d",currentPage);
        
        if (currentPage==0) {
            [imageScrollView scrollRectToVisible:CGRectMake(pageWidth*imageArray.count, 0, pageWidth, pageHeigth) animated:NO];
            pageControl.currentPage=imageArray.count-1;
            NSLog(@"pageControl currentPage==%ld",(long)pageControl.currentPage);
            NSLog(@"the last image");
            return;
        }else  if(currentPage==[imageArray count]+1){
            [imageScrollView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
            pageControl.currentPage=0;
            NSLog(@"pageControl currentPage==%ld",(long)pageControl.currentPage);
            NSLog(@"the first image");
            return;
        }
        pageControl.currentPage=currentPage-1;
        NSLog(@"pageControl currentPage==%ld",(long)pageControl.currentPage);
        //    [self pageTurn:pageControl];
    }
}

-(void)pageTurn:(UIPageControl *)sender
{
    int pageNum=pageControl.currentPage;
    CGSize viewSize=imageScrollView.frame.size;
    [imageScrollView setContentOffset:CGPointMake((pageNum+1)*viewSize.width, 0)];
    NSLog(@"myscrollView.contentOffSet.x==%f",imageScrollView.contentOffset.x);
    NSLog(@"pageControl currentPage==%ld",(long)pageControl.currentPage);
    [myTimer invalidate];
}

#pragma mark-----
#pragma mark---------DShouye01CellDelegate---------
- (void) shouyeButtonClipAtIndex:(NSInteger)index
{
    NSLog(@"%s",__func__);
    switch (index) {
        case 0://大集客自营
        {
            NSLog(@"ziyingLIst = %@",ziyingList);
            if (ziyingList.count > 0) {
                DShouyeZIyingViewController *ziyingVC = [[DShouyeZIyingViewController alloc]init];
                ziyingVC.ziyingLIst = [NSArray arrayWithArray:ziyingList];
                push(ziyingVC);
            }else{
                [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"ZiYings.category" parameters:nil ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                    if (responseObject.succeed) {
                        ziyingList = [[NSMutableArray alloc]init];
                        for (NSDictionary * dic in responseObject.result) {
                            DZiyingsCategoryModel *ziyingCaModel = [[DZiyingsCategoryModel alloc]init];
                            ziyingCaModel = [JsonStringTransfer dictionary:dic ToModel:ziyingCaModel];
                            [ziyingList addObject:ziyingCaModel];
                        }
                        DShouyeZIyingViewController *ziyingVC = [[DShouyeZIyingViewController alloc]init];
                        ziyingVC.ziyingLIst = [NSArray arrayWithArray:ziyingList];;
                        push(ziyingVC);
                        
                    }else{
                        showMessage(@"请求失败");
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    showMessage(@"请求失败");
                }];
            }
            
        }
            break;
        case 1://集宝宝
        {
            
        }
            break;
        case 2://区域自营
        {
            DShouyeZhiyingController *zhiyingVC = [[DShouyeZhiyingController alloc]init];
            push(zhiyingVC);
        }
            break;
        case 3://我要抽奖
        {
            DDrawMainViewController *VC = [[DDrawMainViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark-----
#pragma mark---------NavBUtton Clip---------
//左边按钮
- (void) toLeftNavButton:(id) sender
{
    NSLog(@"%s",__func__);
}
//右边按钮
- (void) toRightNavButton:(id) sender
{
//    NSLog(@"%s",__func__);
    DMessageListViewController *messageListVC = [[DMessageListViewController alloc]init];
    [self.navigationController pushViewController:messageListVC animated:YES];
}
//收藏商品
- (void) shoucangGoods:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger row = btn.tag-300;
    DReXiaoGoodsModel *model = (DReXiaoGoodsModel *)[hostGoodsArr objectAtIndex:row];
    NSString *goodsId = [NSString stringWithFormat:@"%@",model.goods_id];
    NSString *userId;
    if ([FileOperation isLogin]) {
        userId = [NSString stringWithFormat:@"%@",[FileOperation getUserId]];
    }else{
        userId = @"";
        showMessage(@"请先登录！");
        return;
    }
    if ([model.collect isEqualToString:@"1"]) {
        //取消收藏
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyCollectss.delete" parameters:@{@"userId":userId,@"type":@"goods",@"itemId":goodsId} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                showMessage(responseObject.msg);
                //收藏状态改变了
                model.collect = @"0";
                [hostGoodsArr replaceObjectAtIndex:row withObject:model];
                [self.dMainTableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"operation = %@",operation);
            NSLog(@"error = %@",error);
        }];

    }else{
        //收藏
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyCollectss.collect" parameters:@{@"userId":[FileOperation getUserId],@"type":@"1",@"objectId":goodsId} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                showMessage(responseObject.msg);
                //收藏状态改变了
                model.collect = @"1";
                [hostGoodsArr replaceObjectAtIndex:row withObject:model];               [self.dMainTableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"operation = %@",operation);
            NSLog(@"error = %@",error);
        }];

    }
    
}

//大集客自营
- (void) dajikeZiyingArr
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"ZiYings.category" parameters:nil ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                ziyingList = [[NSMutableArray alloc]init];
                for (NSDictionary * dic in responseObject.result) {
                    DZiyingsCategoryModel *ziyingCaModel = [[DZiyingsCategoryModel alloc]init];
                    ziyingCaModel = [JsonStringTransfer dictionary:dic ToModel:ziyingCaModel];
                    [ziyingList addObject:ziyingCaModel];
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    });
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
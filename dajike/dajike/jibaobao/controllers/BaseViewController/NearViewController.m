//
//  NearViewController.m
//  jibaobao
//
//  Created by swb on 15/5/19.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "NearViewController.h"
#import "BunessList1Cell.h"
#import "CashCouponCell.h"
#import "FoodShopDetailViewController.h"
#import "CashCouponDetailViewController.h"
#import "defines.h"
#import "FoodShopDetailViewController.h"

static NSString *cell1 = @"cell111";
static NSString *cell2 = @"cell222";

@interface NearViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *titleLabel;
    NSMutableArray  *_dataSource;
    
    NSMutableArray  *_couponArr;
    //当前页码
    NSInteger page;
    
    //搜索界面 头title
    UISearchBar *_searchBar;
    
    //分类搜索
    NSString *regionId;
    NSString *cateId;
    NSString *orderBy;
    NSString *key;
    //距离
    NSString *distance;
}
@property (retain, nonatomic) UIImageView *noDataView;
@end

@implementation NearViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setFont:Font_Nav];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        titleLabel.text = @"附近";
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    regionId =  [NSString stringWithFormat:@"%@",[FileOperation getCurrentCityId]];
    if (_data2 != nil) {
        [self getquancheng];
    }
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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainTabview setFrame:CGRectMake(0, 44, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64-45-50)];
    //添加无数据时的显示界面，正常情况下隐藏
    self.noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading_no_s"]];
    self.noDataView.contentMode = UIViewContentModeScaleAspectFit;
    [self.noDataView setFrame:CGRectMake(0, 0, self.mainTabview.frame.size.width, self.mainTabview.frame.size.height)];
    [self.mainTabview addSubview:self.noDataView];
    CGRect frame = self.mainTabview.frame;
    frame.size.height += 1;
    self.mainTabview.frame = frame;
    [self.noDataView setHidden:YES];
    // Do any additional setup after loading the view.
    //    if ([self.flagStr intValue] == 0) {
    //        titleLabel.text = @"美食";
    //    }
    //    if ([self.flagStr intValue] == 2) {
    //        titleLabel.text = @"休闲娱乐";
    //    }
    //    if ([self.flagStr intValue] == 5) {
    //        titleLabel.text = @"购物";
    //    }
    self.StoreListType = NEARBY;
    titleLabel.text = @"附近";
    _dataSource = [[NSMutableArray alloc]init];
    _couponArr = [[NSMutableArray alloc]init];
    
    //    [self addTableView:UITableViewStyleGrouped];
    //    [self.mainTabview setFrame:CGRectMake(0, 45, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64-45)];
    
    //    self.delegate = self;
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    //    [self setNavType:SEARCH_BUTTON action:nil];
    [self addHeaderAndFooter];
    
    
//    [self addMenuView];
    //    [self ishasMenu:YES];
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"BunessList1Cell" bundle:nil] forCellReuseIdentifier:cell1];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"CashCouponCell" bundle:nil] forCellReuseIdentifier:cell2];
    
    //    [self ishasMenu:YES];
    
    //添加头
    //    [self addHead];
    regionId = [NSString stringWithFormat:@"%@",[FileOperation getCurrentCityId]];
    cateId = @"";
    if (self.StoreListType == NEARBY) {
        orderBy = @"distance_asc";//距离最近
    }else{
//        orderBy = @"add_time_desc";//智能排序
        orderBy = @"distance_asc";//距离最近
    }
    
    distance = @"";//距离  默认全城，距离传空
    key = @"";
    [self getFenleiList];
    [self getDataIsFirst:NO isSuccess:^(BOOL finish) {
        
    }];
    
}
- (void)getDataIsFirst:(BOOL)isFirst isSuccess:(void(^)(BOOL finish))success
{
    //参数字典
    NSDictionary *dic = @{@"key":key,@"latitude":[NSString stringWithFormat:@"%@",[FileOperation getLatitude]],@"longitude":[NSString stringWithFormat:@"%@",[FileOperation getLongitude]],@"regionId":regionId,@"cateId":cateId,@"orderBy":orderBy,@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10",@"distance":distance};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Stores.list" parameters:dic ifAddActivityIndicator:isFirst success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSMutableArray *arr = [[responseObject.result objectForKey:@"data"]mutableCopy];
            for (int i=0; i<arr.count; i++) {
                
                NSMutableArray *tmpArr = [[[arr objectAtIndex:i]objectForKey:@"coupons"]mutableCopy];
                if (tmpArr.count == 0) {
                    [_couponArr addObject:@"我也是来凑数的"];
                }
                else
                {
                    for (int j=0; j<tmpArr.count; j++) {
                        CashCouponModel *cashModel = [[CashCouponModel alloc]init];
                        cashModel = [JsonStringTransfer dictionary:[tmpArr objectAtIndex:j] ToModel:cashModel];
                        [tmpArr replaceObjectAtIndex:j withObject:cashModel];
                    }
                    [_couponArr addObject:tmpArr];
                }
                
                
                ShopListModel *model = [[ShopListModel alloc]init];
                model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
                [arr replaceObjectAtIndex:i withObject:model];
                
            }
            [_dataSource addObjectsFromArray:arr];
            NSLog(@"%@---%@",_dataSource,_couponArr);
            //每次请求10条，如果这次请求的总条数小于10条，说明数据全部请求完毕
            page = [[responseObject.result objectForKey:@"page"] integerValue];
            if (arr.count < 10) {
                isEnd = YES;
            }
            [self.mainTabview reloadData];
        }
        success(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
        success(NO);
    }];

    
    
    /*
    //区分模拟器和真机
#if TARGET_IPHONE_SIMULATOR
    //参数字典
    NSDictionary *dic = @{@"key":key,@"latitude":@"32.398896",@"longitude":@"120.489934",@"regionId":regionId,@"cateId":cateId,@"orderBy":orderBy,@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10",@"distance":distance};
    //post请求
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Stores.list" parameters:dic ifAddActivityIndicator:isFirst success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            NSMutableArray *arr = [[responseObject.result objectForKey:@"data"]mutableCopy];
            for (int i=0; i<arr.count; i++) {
                
                NSMutableArray *tmpArr = [[[arr objectAtIndex:i]objectForKey:@"coupons"]mutableCopy];
                if (tmpArr.count == 0) {
                    [_couponArr addObject:@"我也是来凑数的"];
                }
                else
                {
                    for (int j=0; j<tmpArr.count; j++) {
                        CashCouponModel *cashModel = [[CashCouponModel alloc]init];
                        cashModel = [JsonStringTransfer dictionary:[tmpArr objectAtIndex:j] ToModel:cashModel];
                        [tmpArr replaceObjectAtIndex:j withObject:cashModel];
                    }
                    [_couponArr addObject:tmpArr];
                }
                
                
                ShopListModel *model = [[ShopListModel alloc]init];
                model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
                [arr replaceObjectAtIndex:i withObject:model];
                
            }
            [_dataSource addObjectsFromArray:arr];
            NSLog(@"%@---%@",_dataSource,_couponArr);
            //每次请求10条，如果这次请求的总条数小于10条，说明数据全部请求完毕
            page = [[responseObject.result objectForKey:@"page"] integerValue];
            if (arr.count < 10) {
                isEnd = YES;
            }
            [self.mainTabview reloadData];
        }
        success(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
        success(NO);
    }];
    
#elif TARGET_OS_IPHONE
    //当前经纬度
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        NSLog(@"latitude. = %f",locationCorrrdinate.latitude);
        NSLog(@"longitude. = %f",locationCorrrdinate.longitude);
        //参数字典
         NSDictionary *dic = @{@"key":key,@"latitude":[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude],@"longitude":[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude],@"regionId":regionId,@"cateId":cateId,@"orderBy":orderBy,@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10",@"distance":distance};
        
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Stores.list" parameters:dic ifAddActivityIndicator:isFirst success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSMutableArray *arr = [[responseObject.result objectForKey:@"data"]mutableCopy];
                for (int i=0; i<arr.count; i++) {
                    
                    NSMutableArray *tmpArr = [[[arr objectAtIndex:i]objectForKey:@"coupons"]mutableCopy];
                    if (tmpArr.count == 0) {
                        [_couponArr addObject:@"我也是来凑数的"];
                    }
                    else
                    {
                        for (int j=0; j<tmpArr.count; j++) {
                            CashCouponModel *cashModel = [[CashCouponModel alloc]init];
                            cashModel = [JsonStringTransfer dictionary:[tmpArr objectAtIndex:j] ToModel:cashModel];
                            [tmpArr replaceObjectAtIndex:j withObject:cashModel];
                        }
                        [_couponArr addObject:tmpArr];
                    }
                    
                    
                    ShopListModel *model = [[ShopListModel alloc]init];
                    model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
                    [arr replaceObjectAtIndex:i withObject:model];
                    
                }
                [_dataSource addObjectsFromArray:arr];
                NSLog(@"%@---%@",_dataSource,_couponArr);
                //每次请求10条，如果这次请求的总条数小于10条，说明数据全部请求完毕
                page = [[responseObject.result objectForKey:@"page"] integerValue];
                if (arr.count < 10) {
                    isEnd = YES;
                }
                [self.mainTabview reloadData];
            }
            success(YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            NSLog(@"operation6 = %@",operation);
            success(NO);
        }];
        
    }];
    
#endif
*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)right0ButtonClicked:(id)sender
{
    NSLog(@"%s",__func__);
}
- (void)right1ButtonClicked:(id)sender
{
    NSLog(@"%s",__func__);
}
//添加头
//- (void) addHead
//{
//    SegmentControlView *segmentView = [[SegmentControlView alloc] init];
//    segmentView.parentViewController = self;
//    segmentView.delegate = self;
//    [segmentView.segment1Button setTitle:@"美食" forState:UIControlStateNormal];
//    [segmentView.segment2Button setTitle:@"全城" forState:UIControlStateNormal];
//    [segmentView.segment3Button setTitle:@"智能排序" forState:UIControlStateNormal];
//    [self.segmentView addSubview:segmentView];
//}
#pragma mark------
#pragma mark------tableViewCell-----------------
- (CashCouponCell *)loadBusinessListItemCell:(UITableView *)tableView
{
    CashCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cell2];
    
    return cell;
}
- (BunessList1Cell *)loadBunessList1ItemCell:(UITableView *)tableView
{
    BunessList1Cell *cell = [tableView dequeueReusableCellWithIdentifier:cell1];
    
    return cell;
}
#pragma mark-----
#pragma mark---------UITableviewDelegate  UITableViewDatasource---------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataSource.count == 0) {
        [self.noDataView setHidden:NO];
    }else{
        [self.noDataView setHidden:YES];
    }
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[_couponArr objectAtIndex:section]isKindOfClass:[NSString class]]) {
        return 1;
    }else
        return 1+[[_couponArr objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 60;
    }
    return 0;
    
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        BunessList1Cell *pcell = [self loadBunessList1ItemCell:tableView];
        if (_dataSource.count > 0) {
            pcell.model = [_dataSource objectAtIndex:indexPath.section];
        }
        
        return pcell;
    }else{
        CashCouponCell * pCell = [self loadBusinessListItemCell:tableView];
        if (_couponArr.count > 0) {
            pCell.model = [[_couponArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1];
        }
        
        return pCell;
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行",indexPath.row);
    //    RecommendFoodViewController *shopDetailVC = [[RecommendFoodViewController alloc]init];
    //    [self.navigationController pushViewController:shopDetailVC animated:YES];
    if (indexPath.row == 0) {
        FoodShopDetailViewController *shopVC = [[FoodShopDetailViewController alloc]init];
        shopVC.flagStr = self.flagStr;
        ShopListModel *model = [_dataSource objectAtIndex:indexPath.section];
        shopVC.storeId = model.store_id;
        [shopVC callBackFoodVC:^{
            //重新加载数据。一切都重新初始化
            isEnd = NO;
            page = 0;
            [_dataSource removeAllObjects];
            _dataSource = nil;
            _dataSource = [[NSMutableArray alloc]init];
            
            [_couponArr removeAllObjects];
            _couponArr = nil;
            _couponArr = [[NSMutableArray alloc]init];
            [self getDataIsFirst:NO isSuccess:^(BOOL finish) {
                
            }];
        }];
        [self.navigationController pushViewController:shopVC animated:YES];
    }else {
        CashCouponDetailViewController *shopDetailVC = [[CashCouponDetailViewController alloc]init];
        shopDetailVC.flagStr = self.flagStr;
        CashCouponModel *mm = [[_couponArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1];
        NSLog(@"_____%@",mm.goods_id);
        shopDetailVC.goodsId = mm.goods_id;
        NSLog(@"%@",_dataSource);
        ShopListModel *model = [_dataSource objectAtIndex:indexPath.section];
        NSLog(@"%@",model.store_id);
        shopDetailVC.storeId = model.store_id;
        [self.navigationController pushViewController:shopDetailVC animated:YES];
    }
    
}

#pragma mark-----
#pragma mark---------JSDropDownMenu---------
//- (void) ishasMenu:(BOOL)hanMenu
//{
//    if (!hanMenu) {
//        [self.menu setHidden:YES];
//    }else{
//        [self.menu setHidden:NO];
//        CGRect frame = self.mainTabview.frame;
//        frame.origin.y = self.mainTabview.frame.origin.y+45;
//        frame.size.height = self.mainTabview.frame.size.height-45;
//        [self.mainTabview setFrame:frame];
//    }
//}
- (void) addMenuView{
    _currentData1Index = 0;
     _currentData2Index = 0;
    if (self.StoreListType == NEARBY) {
        _currentData3Index = 4;
    }else{
        _currentData3Index = 0;
    }
    
    _currentData1SelectedIndex = 0;
    
    
//    _data1 = [NSMutableArray arrayWithObjects:@{@"title":@"美食", @"data":food}, @{@"title":@"旅游", @"data":travel}, nil];
//    _data2 = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];
//    _data3 = [NSMutableArray arrayWithObjects:@"不限人数", @"单人餐", @"双人餐", @"3~4人餐", nil];
    self.menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
    self.menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    self.menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    self.menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
//    self.menu.dataSource = self;
    self.menu.delegate = self;
    
    [self.view addSubview:self.menu];
}
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
//    if (column==2) {
//        
//        return YES;
//    }
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if ((column==0)||(column==1)) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if ((column==0)||(column==1)) {
        return 0.5;
    }
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    if (column==2) {
        
        return _currentData3Index;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        if (leftOrRight==0) {
            
            return _data1.count;
        } else{
            
            if (_data1.count == 1) {
                leftRow = 0;
            }
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==1){
        
        if (leftOrRight==0) {
            
            return _data2.count;
        } else{
            
            
            NSDictionary *menuDic = [_data2 objectAtIndex:leftRow];
            if ([[menuDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                return [[menuDic objectForKey:@"data"] count];
            }else{
                return 0;
            }
            
        }
        
    } else if (column==2){
        
        return _data3.count;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0:
            if (_currentData1Index == 0) {
                return @"全部分类";
            }else{
                return [[[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex] objectForKey:@"cate_name"];
            }
            
            break;
        case 1: return [[[_data2[_currentData2Index] objectForKey:@"data"] objectAtIndex:_currentData2SelectedIndex] objectForKey:@"region_name"];
            break;
        case 2: return [_data3[_currentData3Index] objectForKey:@"data"];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            if (_data1.count == 1) {
                leftRow = 0;
            }
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"cate_name"];
        }
    } else if (indexPath.column==1) {
        
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data2 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data2 objectAtIndex:leftRow];
            return [[[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"region_name"];
        }
        
    } else {
        
        return [_data3[indexPath.row] objectForKey:@"data"];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if(indexPath.leftOrRight==0){
            
            _currentData1Index = indexPath.row;
            if (indexPath.row == 0) {
                cateId = [_data1[_currentData1Index] objectForKey:@"cate_id"];
                key = @"";
                [menu confiMenuWithSelectRow:indexPath.row leftOrRight:0];
                self.navTitle = @"全部分类";
                titleLabel.text = self.navTitle;
            }else{
                key = [NSString stringWithFormat:@"%@",[[[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"cate_id"]];
                return;
            }
        }else{
            _currentData1SelectedIndex = indexPath.row;
            if (indexPath.row == 0) {
                key = [NSString stringWithFormat:@"%@",[[[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex] objectForKey:@"cate_id"]];
                cateId = @"";
                self.navTitle = [_data1[_currentData1Index] objectForKey:@"title"];
            }else{
                cateId = [NSString stringWithFormat:@"%@",[[[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex] objectForKey:@"cate_id"]];
//                key = @"";
                self.navTitle = [_data1[_currentData1Index] objectForKey:@"title"];
            }
            titleLabel.text = self.navTitle;
        }
        
        
    } else if(indexPath.column == 1){
        
        if(indexPath.leftOrRight==0){
            
            _currentData2Index = indexPath.row;
            if (indexPath.row > 0) {
                regionId = [_data2[_currentData2Index] objectForKey:@"data"];
                [menu confiMenuWithSelectRow:indexPath.row leftOrRight:0];
            }else{
                return;
            }
            
        }else{
            _currentData2SelectedIndex = indexPath.row;;
            distance = [NSString stringWithFormat:@"%d",([[[[_data2[_currentData2Index] objectForKey:@"data"] objectAtIndex:_currentData2SelectedIndex] objectForKey:@"region_id"] integerValue]*1000)];
            regionId = [NSString stringWithFormat:@"%@",[[[_data2[0] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"region_id"]];
        }
    } else{
        
        _currentData3Index = indexPath.row;
        orderBy = [NSString stringWithFormat:@"%@",[[_data3  objectAtIndex:indexPath.row]objectForKey:@"title"]];
    }
//    self.StoreListType = TEST;
//    if (orderBy == nil) {
//        orderBy = @"";
//    }
//    if (regionId == nil) {
//        regionId = @"";
//    }
//    if (cateId ==  nil) {
//        cateId = @"";
//    }
    [self refreshData:^(BOOL finish) {
        
    }];
}
- (BOOL)menu:(JSDropDownMenu *)menu ifHasImageForRowAtIndexPath:(JSIndexPath *)indexPath
{
    if ((indexPath.column == 0)&&(indexPath.leftOrRight==0)) {
        return YES;
    }
    return NO;
}
//标题前图片
- (UIImage *)menu:(JSDropDownMenu *)menu imageForRowAtIndexPath:(JSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        return [UIImage imageNamed:@"img_msi_01.png"];
    }
    if (row == 1) {
        return [UIImage imageNamed:@"img_msi_02.png"];
    }
    if (row == 2) {
        return [UIImage imageNamed:@"img_msi_04.png"];
    }
    if (row == 3) {
        return [UIImage imageNamed:@"img_msi_05.png"];
    }
    if (row == 4) {
        return [UIImage imageNamed:@"img_msi_06.png"];
    }
    if (row == 5) {
        return [UIImage imageNamed:@"img_msi_07.png"];
    }
    if (row == 6) {
        return [UIImage imageNamed:@"img_msi_09.png"];
    }
    if (row == 7) {
        return [UIImage imageNamed:@"img_msi_08.png"];
    }
    return [UIImage imageNamed:@"img_msi_01.png"];
    
}

#pragma  mark--------MJREfresh---------
//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        [ProgressHUD showMessage:@"加载完成" Width:280 High:10];
        success (YES);
    }else{
        [self getDataIsFirst:NO isSuccess:^(BOOL finish) {
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
    [_dataSource removeAllObjects];
    _dataSource = nil;
    _dataSource = [[NSMutableArray alloc]init];
    
    [_couponArr removeAllObjects];
    _couponArr = nil;
    _couponArr = [[NSMutableArray alloc]init];
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}

//获取分类列表
#pragma  mark--------fenlei  list---------
- (void) getFenleiList
{
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程一
        NSLog(@"并行执行的线程一1");
        
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Stores.allCategoryLists" parameters:nil ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"%@",responseObject.result);
                [_data1 removeAllObjects];
                _data1 = nil;
                _data1 = [[NSMutableArray alloc]init];
                 [_data1 addObject:@{@"cate_id":@"",@"title":@"全部分类"}];
                for (NSDictionary *dic in responseObject.result) {
                    NSMutableArray *dataArr = [NSMutableArray  arrayWithArray:[dic objectForKey:@"childs"]];
                    
                    NSDictionary *dic0 = @{@"cate_id":[NSString stringWithFormat:@"%@",[dic objectForKey:@"key"]],@"cate_name":@"全部"};
                    [dataArr insertObject:dic0 atIndex:0];
                    [_data1 addObject:@{@"data":dataArr,@"title":[NSString stringWithFormat:@"%@",[dic objectForKey:@"cate_name"]]}];
                }
                 NSLog(@"并行执行的线程一111");
                self.menu.dataSource = self;

               
            }
            NSLog(@"并行执行的线程一11");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
        }];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程二
        NSLog(@"并行执行的线程二2");
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Regions.findCityByRegionId" parameters:@{@"regionId":regionId} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {

                NSLog(@"%@",responseObject.result);
                [_data2 removeAllObjects];
                _data2 = nil;
                _data2 = [[NSMutableArray alloc]init];
                for (NSArray *arr in [responseObject.result objectForKey:@"subRegions"]) {
                    NSDictionary *dic = @{@"data":[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]],@"title":[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]]};
                    [_data2 addObject:dic];
                }
                NSDictionary *nearDic = @{@"data":@[@{@"region_name":@"全城",@"region_id":[responseObject.result objectForKey:@"regionId"]},@{@"region_name":@"1km",@"region_id":@"1"},@{@"region_name":@"2km",@"region_id":@"2"},@{@"region_name":@"5km",@"region_id":@"5"},@{@"region_name":@"10km",@"region_id":@"10"}],@"title":@"附近"};
                [_data2 insertObject:nearDic atIndex:0];
                 NSLog(@"并行执行的线程一222");
                self.menu.dataSource = self;
            }
            NSLog(@"并行执行的线程二22");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
        }];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        // 并行执行的线程三
        NSLog(@"并行执行的线程三3");
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Configs.sortFields" parameters:@{@"type":@"store"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"%@",responseObject.result);

                [_data3 removeAllObjects];
                _data3 = nil;
                _data3 = [[NSMutableArray alloc]init];
                NSMutableArray *keyArr = [[NSMutableArray alloc]initWithArray:[responseObject.result allKeys]];
                for (int i = 0; i < [responseObject.result allKeys].count; i++) {
                    NSString *key01 = [[responseObject.result allKeys] objectAtIndex:i];
//                    if ([key01 isEqualToString:@"type"]) {
//                        [keyArr removeObjectAtIndex:i];
//                    }
                    if ([key01 isEqualToString:@"add_time_desc"]) {//智能排序
                        [keyArr removeObjectAtIndex:i];
                        [keyArr insertObject:key01 atIndex:0];
                    }
                    if ([key01 isEqualToString:@"distance_asc"]) {//距离最近
                        [keyArr removeObjectAtIndex:i];
                        [keyArr insertObject:key01 atIndex:4];
                    }
                }

                for (int i = 0; i < keyArr.count; i++) {
                    NSString *key0 = [keyArr objectAtIndex:i];
                    if (![key0 isEqualToString:@"type"]) {
                        [_data3 addObject:@{@"data":[responseObject.result objectForKey:key0],@"title":key0}];
                    }
                }                 NSLog(@"并行执行的线程一333");
                self.menu.dataSource = self;
                [self refreshData:^(BOOL finish) {
                    
                }];
            }
            NSLog(@"并行执行的线程三33");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
        }];
        
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
        // 汇总结果
        NSLog(@"并行执行的线程汇总结果44");
        [self addMenuView];
        
    });

   
}

- (void) getquancheng
{
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Regions.findCityByRegionId" parameters:@{@"regionId":regionId} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSMutableArray *data2 = [[NSMutableArray alloc]init];
            for (NSArray *arr in [responseObject.result objectForKey:@"subRegions"]) {
                NSDictionary *dic = @{@"data":[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]],@"title":[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]]};
                [data2 addObject:dic];
            }
            NSDictionary *nearDic = @{@"data":@[@{@"region_name":@"全城",@"region_id":[responseObject.result objectForKey:@"regionId"]},@{@"region_name":@"1km",@"region_id":@"1"},@{@"region_name":@"2km",@"region_id":@"2"},@{@"region_name":@"5km",@"region_id":@"5"},@{@"region_name":@"10km",@"region_id":@"10"}],@"title":@"附近"};
            [data2 insertObject:nearDic atIndex:0];
            NSLog(@"并行执行的线程一222");
            //城市变更了
            if (![data2 isEqual:_data2]) {
                [_data2 removeAllObjects];
                _data2 = nil;
                _data2 = [[NSMutableArray alloc]init];
                [_data2 addObjectsFromArray:data2];
                self.menu.dataSource = self;
                [self refreshData:^(BOOL finish) {
                    
                }];
            }
        }
        NSLog(@"并行执行的线程二22");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];

}







//#pragma mark------
//#pragma mark------SegmentDelegate-----------------
//- (void)segment:(int)actionIndex diction:(NSDictionary *)dict
//{
//    NSLog(@"%s",__func__);
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

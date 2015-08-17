//
//  SearchViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "DSearchViewController.h"
#import "defines.h"
#import "UIView+MyView.h"
#import "FoodViewController.h"
#import "dDefine.h"
#import "DMyAfHTTPClient.h"
#import "DReXiaoGoodsModel.h"
#import "DGoodsListViewController.h"


@interface DSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UISearchBar *_searchBar;
    NSMutableArray *titleArr;
}
@property(nonatomic, retain) UITableView *tableView;

@end

@implementation DSearchViewController
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
    [super viewWillAppear:animated];
    
    if (_tableView) {
        [_tableView reloadData];
    }
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableView];
    [self addnavItems];
    [self addHeadView];
}

- (void) addnavItems
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width-120, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width-120, 24)];
    [_searchBar setSearchBarStyle:UISearchBarStyleDefault];
    [_searchBar setBarTintColor:[UIColor whiteColor]];
    _searchBar.placeholder = @"请输入商品／店铺";
    _searchBar.delegate = self;
    
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    [_searchBar setTintColor:[UIColor whiteColor]];
    [_searchBar.layer setMasksToBounds:YES];
    _searchBar.layer.borderColor = [DColor_ffffff CGColor];
    _searchBar.layer.borderWidth = 1.0;
    _searchBar.layer.contentsScale = 5.0;
    
    [view addSubview:_searchBar];
    [self naviBarAddCoverViewOnTitleView:view];
    
    DImgButton *rightNavButton = [[DImgButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
    [rightNavButton setTitleColor:DColor_ffffff forState:UIControlStateNormal];
    [rightNavButton setTitle:@"取消" forState:UIControlStateNormal];
    rightNavButton.backgroundColor = [UIColor clearColor];
    [rightNavButton.titleLabel setFont:DFont_13];
    [rightNavButton addTarget:self action:@selector(cancleBUttonClip:) forControlEvents:UIControlEventTouchUpInside];
    [self setNaviBarRightBtn:rightNavButton];
}

- (void) addTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT-64) style:UITableViewStyleGrouped];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DColor_bg;
    [self.view addSubview:self.tableView];
}
- (void) addHeadView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    backView.backgroundColor = DColor_bg;
    
    UILabel *label = [[UILabel alloc] creatLabelWithFrame:CGRectMake(10, 0, 120, 15) AndFont:12 AndBackgroundColor:Color_Clear AndText:@"热门搜索：" AndTextAlignment:NSTextAlignmentLeft AndTextColor:DColor_808080 andCornerRadius:0];
    [backView addSubview:label];
    
    
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.indexRecommend" parameters:@{@"page":@"1",@"pageSize":@"100",@"recomId":@"65"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            titleArr = [[NSMutableArray alloc]init];
            NSMutableArray *btnTitleArr = [[NSMutableArray alloc]init];
            
            for (NSDictionary *dic in [responseObject.result objectForKey:@"data"]) {
                NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_name"]];
                [btnTitleArr addObject:str];
                
                
                DReXiaoGoodsModel *model = [[DReXiaoGoodsModel alloc]init];
                model = [JsonStringTransfer dictionary:dic ToModel:model];
                [titleArr addObject:model];
            }
            for (int i = 0; i < btnTitleArr.count; i++) {
                UIButton *btn = [[UIButton alloc] createButtonWithFrame:CGRectMake((i%3)*90+12*((i%3)+1), (i/3)*40+30, 90, 30) andBackImageName:nil andTarget:self andAction:@selector(hostSearchBUttonClip:) andTitle:[btnTitleArr objectAtIndex:i] andTag:i+100];
                [btn setTitleColor:DColor_808080 forState:UIControlStateNormal];
                [btn setBackgroundColor:Color_White];
                [btn.titleLabel setFont:DFont_12];
                btn.layer.cornerRadius = 3;
                [backView addSubview:btn];
            }
            self.tableView.tableHeaderView = backView;
//            NSArray *arr = [NSArray arrayWithArray:[responseObject.result objectForKey:@"data"]];
//            for (NSDictionary *dic in arr) {
//                DReXiaoGoodsModel *rexiaoModel = [[DReXiaoGoodsModel alloc]init];
//                rexiaoModel = [JsonStringTransfer dictionary:dic ToModel:rexiaoModel];
//                [hostGoodsArr addObject:rexiaoModel];
//            }
//            page++;
//            if (arr.count < 10) {
//                isEnd = YES;
//            }
//            [self.dMainTableView reloadData];
        }
//        success(YES);
        NSLog(@"operation = %@",operation);
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation = %@",operation);
        NSLog(@"error = %@",error);
//        success(YES);
    }];

    
//    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.show" parameters:@{@"code":@"jbb_index_hotSearch"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
//        if (responseObject.succeed) {
//            titleArr = [[NSMutableArray alloc]init];
//            for (NSDictionary *dic in responseObject.result) {
//                NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cateName"]];
//                [titleArr addObject:str];
//            }
//            for (int i = 0; i < titleArr.count; i++) {
//                UIButton *btn = [[UIButton alloc] createButtonWithFrame:CGRectMake((i%3)*90+12*((i%3)+1), (i/3)*40+30, 90, 30) andBackImageName:nil andTarget:self andAction:@selector(hostSearchBUttonClip:) andTitle:[titleArr objectAtIndex:i] andTag:i+100];
//                [btn setTitleColor:Color_gray4 forState:UIControlStateNormal];
//                [btn setBackgroundColor:Color_White];
//                btn.layer.cornerRadius = 3;
//                [backView addSubview:btn];
//            }
//            self.tableView.tableHeaderView = backView;
//            
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error = %@",error);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//取消
- (void) cancleBUttonClip:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//9个热门搜索对应事件
- (void) hostSearchBUttonClip:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag= btn.tag-100;
    //搜索
//    FoodViewController *searchVC = [[FoodViewController alloc]init];
//    searchVC.StoreListType = SEARCH;
//    searchVC.navTitle = [titleArr objectAtIndex:tag];
//    //这里必须先取值，再写入   因为每次搜索都将最新的搜索值插入数组最前端
//    [FileOperation writeSearchHistory:[titleArr objectAtIndex:tag]];
//    [self.navigationController pushViewController:searchVC animated:YES];
    
    
    DGoodsListViewController *goodsListVC = [[DGoodsListViewController alloc] init];
    goodsListVC.cateId = [NSString stringWithFormat:@"%@",((DReXiaoGoodsModel *)[titleArr objectAtIndex:tag]).cate_id];
    goodsListVC.keyWords = [NSString stringWithFormat:@"%@",((DReXiaoGoodsModel *)[titleArr objectAtIndex:tag]).goods_name];
    //这里必须先取值，再写入   因为每次搜索都将最新的搜索值插入数组最前端
    [FileOperation writeSearchHistory:[NSString stringWithFormat:@"%@",((DReXiaoGoodsModel *)[titleArr objectAtIndex:tag]).goods_name]];
    [self.navigationController pushViewController:goodsListVC animated:YES];
    
}


#pragma mark------
#pragma mark------uitableViewDelegate uitableViewDatasource--------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [FileOperation getHistoryList].count+1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    static NSString *identifer = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.backgroundColor = Color_Clear;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 30)];
    backView.backgroundColor = Color_White;
    [cell addSubview:backView];
    
    if (row == [FileOperation getHistoryList].count) {
        UILabel *label = [[UILabel alloc] creatLabelWithFrame:CGRectMake(0, 5, 300, 20) AndFont:12 AndBackgroundColor:Color_Clear AndText:@"清除历史记录" AndTextAlignment:NSTextAlignmentCenter AndTextColor:DColor_808080 andCornerRadius:0];
        [backView addSubview:label];
    }else{
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
        [imageV setImage:[UIImage imageNamed:@"img_re_03"]];
        [backView addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] creatLabelWithFrame:CGRectMake(30, 5, 270, 20) AndFont:12 AndBackgroundColor:Color_Clear AndText:[[FileOperation getHistoryList]objectAtIndex:row] AndTextAlignment:NSTextAlignmentLeft AndTextColor:DColor_999999 andCornerRadius:0];
        [backView addSubview:label];
        
        UIView *line = [[UIView alloc] createViewWithFrame:CGRectMake(0, 29, 300, 0.5) andBackgroundColor:DColor_bg];
        [backView addSubview:line];
    }
    
    //    backView.layer.cornerRadius = 1.0;
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    if (row == [FileOperation getHistoryList].count) {
        [FileOperation clearSearchHistory];
        [tableView reloadData];
    }else{
        //搜索
//        FoodViewController *searchVC = [[FoodViewController alloc]init];
//        searchVC.StoreListType = SEARCH;
//        searchVC.navTitle = [[FileOperation getHistoryList]objectAtIndex:row];
//        //这里必须先取值，再写入   因为每次搜索都将最新的搜索值插入数组最前端
//        [FileOperation writeSearchHistory:[[FileOperation getHistoryList]objectAtIndex:row]];
//        [self.navigationController pushViewController:searchVC animated:YES];
        DGoodsListViewController *goodsListVC = [[DGoodsListViewController alloc] init];
        goodsListVC.keyWords = [[FileOperation getHistoryList]objectAtIndex:row];
//        goodsListVC.cateId = [NSString stringWithFormat:@"%@",((DReXiaoGoodsModel *)[titleArr objectAtIndex:tag]).cate_id];
        //这里必须先取值，再写入   因为每次搜索都将最新的搜索值插入数组最前端
        [FileOperation writeSearchHistory:[[FileOperation getHistoryList]objectAtIndex:row]];
        [self.navigationController pushViewController:goodsListVC animated:YES];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar endEditing:YES];
}

#pragma mark------
#pragma mark------uiSearchViewDelegate --------
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //搜索
    [FileOperation writeSearchHistory:_searchBar.text];
//    FoodViewController *searchVC = [[FoodViewController alloc]init];
//    searchVC.StoreListType = SEARCH;
//    searchVC.navTitle = _searchBar.text;
//    [self.navigationController pushViewController:searchVC animated:YES];
    
    DGoodsListViewController *goodsListVC = [[DGoodsListViewController alloc] init];
    //        goodsListVC.cateId = [NSString stringWithFormat:@"%@",((DReXiaoGoodsModel *)[titleArr objectAtIndex:tag]).cate_id];
    goodsListVC.keyWords = searchBar.text;
    //这里必须先取值，再写入   因为每次搜索都将最新的搜索值插入数组最前端
    [self.navigationController pushViewController:goodsListVC animated:YES];
    
    //键盘推出
    [_searchBar resignFirstResponder];
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

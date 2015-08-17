//
//  ProductListViewController.m
//  jibaobao
//
//  Created by swb on 15/5/16.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 **   购物--》商品列表
 */

#import "ProductListViewController.h"
#import "defines.h"
#import "UIView+MyView.h"
#import "DiscountCouponCell.h"
//#import "CashCouponDetailViewController.h"
#import "ProductDetailViewController.h"
#import "FilterViewController.h"
#import "ProductSortViewController.h"
#import "FoodViewController.h"
#import "SwbClickImageView.h"

#import "GoodsListModel.h"

static NSString *swbCell1 = @"swbCell111";

@interface ProductListViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate>

@end

@implementation ProductListViewController
{
    int             _currentData1SelectedIndex;
    
    NSMutableDictionary *_data1;
    NSMutableArray *_sortArr;
    
    
    UIImageView     *_imgView1;
    UIImageView     *_imgView2;
    
    UITableView     *_sortTableView;
    UIView          *_viewBG;
    UIButton        *_sortBtn;
    UIButton        *_filterBtn;
    
    UISearchBar     *_seachBar;
    
    NSMutableArray  *_dataSource;
    //当前页码
    NSInteger page;
    NSString        *_orderBy;
    
    NSString        *_cateId;
    
    NSString        *_minPrice;
    NSString        *_maxPrice;
    
    NSString        *_storeId;
    NSString        *_recommended;
    
    UILabel         *_descLb;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _data1 = [[NSMutableDictionary alloc]init];
    _sortArr = [[NSMutableArray alloc]initWithObjects:@"我是凑数的", nil];
    _currentData1SelectedIndex = 0;
    _cateId  = @"";
    _storeId = @"";
    _minPrice = @"";
    _maxPrice = @"";
    _orderBy = @"";
    _recommended = @"";
    
//    if (self.storeIdstr) {
//        _storeId = self.storeIdstr;
//    }else
//        _storeId = @"";
//    if (self.orderstr) {
//        _orderBy = self.orderstr;
//    }else
//        _orderBy = @"";
//    if (self.cateIdstr) {
//        _cateId = self.cateIdstr;
//    }else
//        _cateId  = @"";
    
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    UIButton *btn = [self.view createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-50, 12, 25, 22) andBackImageName:@"img_list" andTarget:self andAction:@selector(listBtnAction:) andTitle:nil andTag:1];
    UIBarButtonItem *rigbtBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rigbtBtn;
//    [self addTableView:UITableViewStyleGrouped];
//    [self.mainTabview setFrame:CGRectMake(0, 37, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64-37)];
//    [self.mainTabview registerNib:[UINib nibWithNibName:@"DiscountCouponCell" bundle:nil] forCellReuseIdentifier:swbCell1];
//    
//    self.mainTabview.delegate = self;
//    self.mainTabview.dataSource = self;
    
    [self setSelectView];
    
    [self setSearchView];
    
    [self setScrollBtnHidden:YES];
    [self setTabelView];
    
    //重新加载数据。一切都重新初始化
    isEnd = NO;
    page = 0;
    _dataSource = [[NSMutableArray alloc]init];
    if (self.bannerModel != nil) {
        if ((![commonTools isEmpty:self.bannerModel.cateId])&&(![self.bannerModel.cateId isEqualToString:@""])) {
            _cateId = self.bannerModel.cateId;
        }
        if ((![commonTools isEmpty:self.bannerModel.storeId])&&(![self.bannerModel.storeId isEqualToString:@""])) {
            _storeId = self.bannerModel.storeId;
        }
        if ((![commonTools isEmpty:self.bannerModel.recommended])&&(![self.bannerModel.recommended isEqualToString:@""])) {
            _recommended = self.bannerModel.recommended;
        }
        if ((![commonTools isEmpty:self.bannerModel.minPrice])&&(![self.bannerModel.minPrice isEqualToString:@""])) {
            _minPrice = self.bannerModel.minPrice;
        }
        if ((![commonTools isEmpty:self.bannerModel.maxPrice])&&(![self.bannerModel.maxPrice isEqualToString:@""])) {
            _maxPrice = self.bannerModel.maxPrice;
        }
        if ((![commonTools isEmpty:self.bannerModel.order])&&(![self.bannerModel.order isEqualToString:@""])) {
            _orderBy = self.bannerModel.order;
        }
    }
    [self getGoodsListIsFirst:YES andIsSuccess:^(BOOL finish) {
        
    }];
    [self initSelectList];
    
    [self getSortData];
}

// ---------------- 分割线 ------------------------------------
- (void)setTabelView
{
    [self addTableView:UITableViewStyleGrouped];
    [self.mainTabview setFrame:CGRectMake(0, 35, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64-37)];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"DiscountCouponCell" bundle:nil] forCellReuseIdentifier:swbCell1];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    [self addHeaderAndFooter];
    [self.mainTabview setHidden:YES];
}

//获取排序字段
- (void)getSortData
{
    NSDictionary *parameter = @{@"type":@"good"};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Configs.sortFields" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            _data1 = [responseObject.result mutableCopy];
            
            NSMutableArray *keyArr = [[_data1 allKeys]mutableCopy];
            
            for (NSString *keyStr in keyArr) {
                if (![keyStr isEqualToString:@"type"]) {
                    if ([keyStr isEqualToString:@"add_time_desc"]) {
                        [_sortArr replaceObjectAtIndex:0 withObject:keyStr];
                    }else
                        [_sortArr addObject:keyStr];
                }
                
                    
            }
            NSLog(@"--------%@",_sortArr);
            _descLb.text = [_data1 objectForKey:[_sortArr objectAtIndex:0]];
            CGRect rect = [self.view contentAdaptionLabel:_descLb.text withSize:CGSizeMake(500, 30) withTextFont:15.0f];
            _descLb.frame = CGRectMake(10, 3, rect.size.width+5, 30);
            _imgView1.frame = CGRectMake(CGRectGetMaxX(_descLb.frame)+1, 16, 10, 8);
            [_sortTableView reloadData];
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

#pragma mark  获取商品列表
//获取商品列表
- (void)getGoodsListIsFirst:(BOOL)isFirst andIsSuccess:(void (^)(BOOL finish))success
{
     NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_cateId],@"cateId",[NSString stringWithFormat:@"%@",_orderBy],@"order",[NSString stringWithFormat:@"%@",_minPrice],@"minPrice",[NSString stringWithFormat:@"%@",_maxPrice],@"maxPrice",[NSString stringWithFormat:@"%d",page+1],@"page",@"10",@"pageSize",[NSString stringWithFormat:@"%@",_storeId],@"storeId",[NSString stringWithFormat:@"%@",_recommended],@"recommended",@"material",@"type", nil];
    //请求数据 巨大，界面卡顿
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.list" parameters:parameter ifAddActivityIndicator:isFirst success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            NSLog(@"operation6 = %@",operation);
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                NSMutableArray *tmpArr = [[responseObject.result objectForKey:@"data"]mutableCopy];
                if ([tmpArr count] <= 0) {
                    // 更新界面
                    [self.mainTabview setHidden:NO];
                    [self.mainTabview reloadData];
                }else {
                    for (int i=0; i<tmpArr.count; i++) {
                        GoodsListModel *goodsListModel = [[GoodsListModel alloc]init];
                        goodsListModel = [JsonStringTransfer dictionary:[tmpArr objectAtIndex:i] ToModel:goodsListModel];
                        [tmpArr replaceObjectAtIndex:i withObject:goodsListModel];
                    }
                    [_dataSource addObjectsFromArray:tmpArr];
                    page = [[responseObject.result objectForKey:@"page"] integerValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 更新界面
                        [self.mainTabview setHidden:NO];
                        [self.mainTabview reloadData];
                        
                    });
                }
                if (tmpArr.count < 10) {
                    isEnd = YES;
                }
                success(YES);
            }
            success(NO);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            NSLog(@"operation6 = %@",operation);
            success(NO);
        }];
        
    });

}

//导航栏上面的搜索框  初始化
- (void)setSearchView
{
    UIView *viewBg = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT-120, 30) andBackgroundColor:Color_Clear];
    viewBg.layer.cornerRadius = 5.0f;
    viewBg.layer.masksToBounds = YES;
    
    _seachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT-120, 30)];
    _seachBar.placeholder = @"请输入商家、品类、地点";
    _seachBar.layer.borderWidth = 0.6f;
    _seachBar.layer.borderColor = Color_line_bg.CGColor;
    _seachBar.delegate = self;
    [viewBg addSubview:_seachBar];
    
    self.navigationItem.titleView = viewBg;
    
}

#pragma mark --- searchBar Delegate
//搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_seachBar resignFirstResponder];
    NSLog(@"搜索");
    FoodViewController *vc = [[FoodViewController alloc]init];
    vc.navTitle = _seachBar.text;
    vc.StoreListType = SEARCH;
    [self.navigationController pushViewController:vc animated:YES];

}

//导航栏下面的三段选择菜单
- (void)setSelectView
{
    UIView *viewBg = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 36) andBackgroundColor:Color_White];
    [self.view addSubview:viewBg];
    
    UIView *lineView1 = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 1) andBackgroundColor:Color_line_bg];
    [viewBg addSubview:lineView1];
    
    _descLb = [self.view creatLabelWithFrame:CGRectMake(10, 3, 80, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"综合排序" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [viewBg addSubview:_descLb];
    
    _imgView1 = [self.view createImageViewWithFrame:CGRectMake(CGRectGetMaxX(_descLb.frame)+5, 16, 10, 8) andImageName:@"img_arrow_03_down"];
    [viewBg addSubview:_imgView1];
    
    UILabel *lb2 = [self.view creatLabelWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/2-20, 3, 40, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"新品" AndTextAlignment:NSTextAlignmentCenter AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [viewBg addSubview:lb2];
    
    UILabel *lb3 = [self.view creatLabelWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-70, 3, 32, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"筛选" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [viewBg addSubview:lb3];
    
    _imgView2 = [self.view createImageViewWithFrame:CGRectMake(CGRectGetMaxX(lb3.frame)+5, 13, 8, 10) andImageName:@"img_arrow_03_right"];
    [viewBg addSubview:_imgView2];
    
    UIView *lineView2 = [self.view createViewWithFrame:CGRectMake(0, viewBg.frame.size.height-1, WIDTH_CONTROLLER_DEFAULT, 1) andBackgroundColor:Color_line_bg];
    [viewBg addSubview:lineView2];
    
    _sortBtn = [self.view createButtonWithFrame:CGRectMake(0, 0, 90, 36) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAntion:) andTitle:nil andTag:333];
    [viewBg addSubview:_sortBtn];
    
    _filterBtn = [self.view createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-80, 0, 80, 36) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAntion:) andTitle:nil andTag:444];
    [viewBg addSubview:_filterBtn];
}


//3段选择 第一个 选择列表的初始化
- (void)initSelectList
{
    _viewBG = [self.view createViewWithFrame:CGRectMake(0, 36, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64-36) andBackgroundColor:[UIColor clearColor]];
    [_viewBG setAlpha:0.0f];
    _viewBG.hidden = YES;
    [self.view addSubview:_viewBG];
    
    UIView *viewBG = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, _viewBG.frame.size.height) andBackgroundColor:[UIColor blackColor]];
    viewBG.alpha = 0.5f;
    [_viewBG addSubview:viewBG];
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
    mTap.delegate = self;
    [_viewBG addGestureRecognizer:mTap];
    
    _sortTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 0) style:UITableViewStylePlain];
    _sortTableView.delegate = self;
    _sortTableView.dataSource = self;
    [_viewBG addSubview:_sortTableView];
    
    
}


//3段选择 点击事件
- (void)btnClickedAntion:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == 333) {
        NSLog(@"综合排序");
        if (_viewBG.hidden) {
            _imgView1.image = [UIImage imageNamed:@"img_arrow_02_up"];
            [_filterBtn setTitleColor:Color_mainColor forState:UIControlStateNormal];
            [UIView animateWithDuration:0.3f animations:^{
                //            [_viewBG setHidden:NO];
                _viewBG.hidden = !_viewBG.hidden;
                _viewBG.alpha = 1.0f;
                [_sortTableView setFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 220)];
            } completion:^(BOOL finished) {
                
            }];
        }
        else {
            _imgView1.image = [UIImage imageNamed:@"img_arrow_02_down"];
            [_filterBtn setTitleColor:Color_word_bg forState:UIControlStateNormal];
            [UIView animateWithDuration:0.3f animations:^{
                //            [_viewBG setHidden:NO];
                
                [_sortTableView setFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 0)];
            } completion:^(BOOL finished) {
                _viewBG.alpha = 1.0f;
                _viewBG.hidden = !_viewBG.hidden;
            }];
        }
        
    }
    if (btn.tag == 444) {
        NSLog(@"筛选");
        FilterViewController *vc = [[FilterViewController alloc]init];
        __weak ProductListViewController *weakSelf = self;
        [vc callBackFilter:^(NSString *minPrice, NSString *maxPrice) {
            _minPrice = minPrice;
            _maxPrice = maxPrice;
            isEnd = NO;
            page = 0;
            [_dataSource removeAllObjects];
            _dataSource = nil;
            _dataSource = [[NSMutableArray alloc]init];
            [weakSelf getGoodsListIsFirst:YES andIsSuccess:^(BOOL finish) {
                
            }];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//点击屏幕收回选择列表
- (void)tapClicked:(UITapGestureRecognizer *)tap
{
    _imgView1.image = [UIImage imageNamed:@"img_arrow_02_down"];
    [_filterBtn setTitleColor:Color_word_bg forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3f animations:^{
        //            [_viewBG setHidden:NO];
        _viewBG.alpha = 1.0f;
        [_sortTableView setFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 0)];
    } completion:^(BOOL finished) {
//        _viewBG.alpha = 1.0f;
        _viewBG.hidden = !_viewBG.hidden;
    }];
}


//分类 按钮 事件
- (void)listBtnAction:(id)sender
{
    ProductSortViewController *vc = [[ProductSortViewController alloc]init];
    __weak ProductListViewController *weakSelf = self;
    [vc callBackProduct:^(NSString *cateId,NSString *titleStr) {
        _cateId = cateId;
        isEnd = NO;
        page = 0;
        [_dataSource removeAllObjects];
        _dataSource = nil;
        _dataSource = [[NSMutableArray alloc]init];
        _seachBar.text = titleStr;
        [weakSelf getGoodsListIsFirst:YES andIsSuccess:^(BOOL finish) {
            
        }];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


//返回按钮
- (void)navLeftButtonTapped:(id)sender
{
    [_seachBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


// tableView 代理方法
#pragma mark ---  Tableview   Delegate  &  Datasource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataSource.count == 0) {
        [self.noDataView setHidden:NO];
    }else{
        [self.noDataView setHidden:YES];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTabview) {
        if (_dataSource.count == 0) {
            [self.noDataView setHidden:NO];
        }else{
            [self.noDataView setHidden:YES];
        }
        return [_dataSource count];
    }else {
        if (_sortArr.count == 0) {
            [self.noDataView setHidden:NO];
        }else{
            [self.noDataView setHidden:YES];
        }
        return _sortArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTabview) {
        return 80;
    }else
        return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell1 = @"cell111";
    if (tableView == self.mainTabview) {
        DiscountCouponCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell1];
        
        if (_dataSource.count > 0) {
            myCell.model = [_dataSource objectAtIndex:indexPath.row];
        }
        return myCell;
    }else {
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (!myCell) {
            myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
        }
        UILabel *lb = (UILabel *)[myCell.contentView viewWithTag:88];
        if (!lb) {
            lb = [self.view creatLabelWithFrame:CGRectMake(10, 7, 100, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
            lb.tag = 88;
            [myCell.contentView addSubview:lb];
        }
        lb.text = [_data1 objectForKey:[_sortArr objectAtIndex:indexPath.row]];
        lb.textColor = Color_word_bg;
        if (indexPath.row == _currentData1SelectedIndex) {
            lb.textColor = Color_mainColor;
        }
        SwbClickImageView *iv = (SwbClickImageView *)[myCell.contentView viewWithTag:99*indexPath.row+1];
        if (!iv) {
            iv = [[SwbClickImageView alloc]initWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-50, 12, 20, 20)];
            iv.tag = 99*indexPath.row+1;
            [myCell.contentView addSubview:iv];
        }
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [iv callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
            [self sortSelect:indexPath.row];
        }];
        iv.image = [UIImage imageNamed:@"img_box_01"];
        if (indexPath.row == _currentData1SelectedIndex) {
            iv.image = [UIImage imageNamed:@"img_box_02"];
        }
        return myCell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.mainTabview) {
        ProductDetailViewController *vc = [[ProductDetailViewController alloc]init];
        GoodsListModel *model = [_dataSource objectAtIndex:indexPath.row];
        vc.goodId = [NSString stringWithFormat:@"%d",[model.goods_id intValue]];
        vc.goodsImageStr = [NSString stringWithFormat:@"%@",model.default_image];
        NSLog(@"%@",vc.goodId);
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self sortSelect:indexPath.row];
    }
}
//排序
- (void)sortSelect:(NSInteger)index
{
    _currentData1SelectedIndex = (int)index;
    _orderBy = [_sortArr objectAtIndex:index];
    _descLb.text = [_data1 objectForKey:_orderBy];
    CGRect rect = [self.view contentAdaptionLabel:_descLb.text withSize:CGSizeMake(500, 30) withTextFont:15.0f];
    _descLb.frame = CGRectMake(10, 3, rect.size.width+5, 30);
    _imgView1.frame = CGRectMake(CGRectGetMaxX(_descLb.frame)+1, 16, 10, 8);
    [_sortTableView reloadData];
    
    isEnd = NO;
    page = 0;
    [_dataSource removeAllObjects];
    _dataSource = nil;
    _dataSource = [[NSMutableArray alloc]init];
    
    [self getGoodsListIsFirst:YES andIsSuccess:^(BOOL finish) {
        
    }];
    
    _imgView1.image = [UIImage imageNamed:@"img_arrow_02_down"];
    [_filterBtn setTitleColor:Color_word_bg forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3f animations:^{
        _viewBG.alpha = 1.0f;
        [_sortTableView setFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 0)];
    } completion:^(BOOL finished) {
        _viewBG.hidden = !_viewBG.hidden;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_seachBar resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"SwbClickImageView"]) {
        return NO;
    }
    return  YES;
}


#pragma  mark--------MJREfresh---------
//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        [ProgressHUD showMessage:@"加载完成" Width:280 High:10];
        success (YES);
    }else{
        [self getGoodsListIsFirst:NO andIsSuccess:^(BOOL finish) {
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
    
//    [_couponArr removeAllObjects];
//    _couponArr = nil;
//    _couponArr = [[NSMutableArray alloc]init];
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
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

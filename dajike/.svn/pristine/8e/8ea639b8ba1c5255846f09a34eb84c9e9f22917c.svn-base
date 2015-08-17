//
//  ShopInfoViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/9.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


//  类 ：  商家详情   图片

#import "ShopInfoViewController.h"
#import "defines.h"
#import "UIView+MyView.h"
#import "EnvironmentViewController.h"       //环境
#import "FamousProductViewController.h"     //名品
#import "PriceListViewController.h"         //价目表
#import "AllShopViewController.h"           //全部

@interface ShopInfoViewController ()
{
    FamousProductViewController         *_famousProVC;
    PriceListViewController             *_priceListVC;
    AllShopViewController               *_allShopVC;
}

@end

@implementation ShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.delegate = self;
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    titleLabel.text = @"商家相册";
    
    NSUInteger numberOfPages = 1;
    _viewControllerArray = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    for (NSUInteger k = 0; k < numberOfPages; ++k) {
        [_viewControllerArray addObject:[NSNull null]];
    }
    _mySelectView = [[MySelectView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 30)];
    _mySelectView.nItemWidth = WIDTH_CONTROLLER_DEFAULT/4;
    NSMutableArray *titleArr = [[NSMutableArray alloc]initWithObjects:@"环境",@"名品",@"价目表",@"全部", nil];
    [_mySelectView setTitle:titleArr];
    _mySelectView.myDelegate = self;
    [self.view addSubview:_mySelectView];
    [_mySelectView setHidden:YES];

//    _lazyScrollView = [[DMLazyScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mySelectView.frame)+1, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-CGRectGetHeight(_mySelectView.frame)-1)];
    _lazyScrollView = [[DMLazyScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT)];
    [_lazyScrollView setEnableCircularScroll:NO];
    [_lazyScrollView setAutoPlay:NO];
    __weak __typeof(&*self)weakSelf = self;
    _lazyScrollView.dataSource = ^(NSUInteger index) {
        return [weakSelf controllerAtIndex:index];
    };
    _lazyScrollView.numberOfPages = numberOfPages;
    _lazyScrollView.controlDelegate = self;
    [self.view addSubview:_lazyScrollView];
    
//    [self setScrollBtnHidden:NO];
}

// ------------------------ 分割线 -----------------------------

- (UIViewController *) controllerAtIndex:(NSInteger) index {
    if (index > _viewControllerArray.count || index < 0) return nil;
    id res = [_viewControllerArray objectAtIndex:index];
    if (res == [NSNull null])
    {
        if (index == 0)
        {
            EnvironmentViewController *contr = [[EnvironmentViewController alloc]init];
            contr.fatherVC = self;
            contr.stroeId = self.storeId;
            [_viewControllerArray replaceObjectAtIndex:index withObject:contr];
            return contr;
        }
        if (index == 1)
        {
//            _famousProVC = [[FamousProductViewController alloc] init];
//            _famousProVC.fatherVC = self;
//            [_viewControllerArray replaceObjectAtIndex:index withObject:_famousProVC];
//            return _famousProVC;
        }
        if (index == 2) {
//            _priceListVC = [[PriceListViewController alloc]init];
//            _priceListVC.fatherVC = self;
//            [_viewControllerArray replaceObjectAtIndex:index withObject:_priceListVC];
//            return _priceListVC;
        }
        if (index == 3) {
//            _allShopVC = [[AllShopViewController alloc]init];
//            _allShopVC.fatherVC = self;
//            [_viewControllerArray replaceObjectAtIndex:index withObject:_allShopVC];
//            return _allShopVC;
        }
    }
    return res;
}

#pragma ProductSelViewDelegate
- (void)selectView:(MySelectView *)mSelectView selectedIndex:(int)index
{
    //[_lazyScrollView setPage:index animated:YES];
    int i = (int)[_lazyScrollView currentPage];
    [_lazyScrollView moveByPages:index-i animated:YES];
}
#pragma mark - DMLazyScrollViewDelegate
- (void)lazyScrollViewDidEndDecelerating:(DMLazyScrollView *)pagingView atPageIndex:(NSInteger)pageIndex
{
    [_mySelectView setSelectedIndex:(int)pageIndex];
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

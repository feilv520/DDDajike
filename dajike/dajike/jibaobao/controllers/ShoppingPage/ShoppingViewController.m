//
//  ShoppingViewController.m
//  jibaobao
//
//  Created by swb on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 ***   购物 首页
 */

#import "ShoppingViewController.h"
#import "UIView+MyView.h"
#import "defines.h"
#import "SwbClickImageView.h"
#import "DiscountCouponCell.h"
#import "FoodShopDetailViewController.h"
#import "FoodViewController.h"
#import "ProductListViewController.h"

#import "ShoppingImgModel.h"
#import "NearPrivilegeModel.h"
#import "SearchViewController.h"
#import "ProductDetailViewController.h"
#import "CashCouponDetailViewController.h"

static NSString *swbCell1 = @"swbCell111";

@interface ShoppingViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,BarButtonDelegate>
{
    UIScrollView *imageScrollView;
    UIPageControl *pageControl;
    
    BOOL pageControlBeingUsed;
    NSTimer *myTimer;//定时器
    NSMutableArray *imageArray;
    NSMutableArray *_bannarArr;
    
    NSMutableArray *_newYouHuiArr;
    
    NSMutableArray *_recImgArr;
    
    NSMutableArray *_nearArr;
    
    NSMutableArray *_zuixinyouhuiArr;
}
- (void)bindAds:(NSArray *)items;
@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    [self initTableView];
    [self getData];
}
// ------------------------- 分割线 ----------------------------
//初始化
- (void)initData
{
    _recImgArr = [[NSMutableArray alloc]init];
    _newYouHuiArr = [[NSMutableArray alloc]init];
    _nearArr    = [[NSMutableArray alloc]initWithObjects:@"我是来凑数的", nil];
    imageArray = [[NSMutableArray alloc]init];
    _zuixinyouhuiArr = [[NSMutableArray alloc]init];
    _bannarArr = [[NSMutableArray alloc]init];
    
    titleLabel.text = self.navTitle;
    [self setNavType:SEARCH_BUTTON];
    [self setStoreBtnHidden:YES];
    [self setScrollBtnHidden:YES];
}
//初始化列表
- (void)initTableView
{
    [self addTableView:UITableViewStylePlain];
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    [self.mainTabview registerNib:[UINib nibWithNibName:@"DiscountCouponCell" bundle:nil] forCellReuseIdentifier:swbCell1];
    self.delegate = self;
    [self setHeaderView];
}

- (void)getData
{
    dispatch_queue_t queue1 = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue2 = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group  = dispatch_group_create();
    
    dispatch_group_async(group, queue1, ^{
        [self getShouYeData];
    });
    
    dispatch_group_async(group, queue2, ^{
        [self getYouHuiShangPin];
    });
    
}
//处理数据
- (void)handleData:(NSMutableArray *)arr withType:(int)type
{
    for (int i=0; i<arr.count; i++) {
        if (type == 1) {
            NSMutableDictionary *dic = [[[arr objectAtIndex:i]objectForKey:@"info"]mutableCopy];
            [_zuixinyouhuiArr addObject:dic];
        }
        ShouyeBannerModel *model = [[ShouyeBannerModel alloc]init];
        model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
        [arr replaceObjectAtIndex:i withObject:model];
        if (type == 2) {
            [imageArray addObject:model.img];
        }
    }
    if (type == 1) {
        [_newYouHuiArr addObjectsFromArray:arr];
    }
    if (type == 2) {
        [_bannarArr addObjectsFromArray:arr];
    }
    
}
//获取首页信息
- (void)getShouYeData
{
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Shoppings.index" parameters:nil ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            //最新优惠
            NSMutableArray *arr1 = [[responseObject.result objectForKey:@"jbb_shopping_index_zuixinyouhui"]mutableCopy];
            
            [self handleData:arr1 withType:1];
            //首页幻灯片
            NSMutableArray *arr2 = [[responseObject.result objectForKey:@"jbb_shopping_index_banner"]mutableCopy];
            
            [self handleData:arr2 withType:2];
            
            [self bindAds:imageArray];
            
            _recImgArr = [[responseObject.result objectForKey:@"jbb_shopping_index_tuijianpinpai"]mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTabview reloadData];
            });
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
//底部的优惠商品
- (void)getYouHuiShangPin
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"page",@"4",@"pageSize",@"material",@"type", nil];
    // 耗时的操作
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.list" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSMutableArray *tmpArr = [[responseObject.result objectForKey:@"data"]mutableCopy];
            if ([tmpArr count] <= 0) {
                
            }else {
                for (int i=0; i<tmpArr.count; i++) {
                    GoodsListModel *goodsListModel = [[GoodsListModel alloc]init];
                    goodsListModel = [JsonStringTransfer dictionary:[tmpArr objectAtIndex:i] ToModel:goodsListModel];
                    [tmpArr replaceObjectAtIndex:i withObject:goodsListModel];
                }
                [_nearArr addObjectsFromArray:tmpArr];
//                page = [[responseObject.result objectForKey:@"page"] integerValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    [self.mainTabview reloadData];
                    
                });
            }
//            if (tmpArr.count < 10) {
//                isEnd = YES;
//            }
//            success(YES);
        }
//        success(NO);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
//        success(NO);
    }];
}

- (void)setHeaderView
{
    imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, WIDTH_CONTROLLER_DEFAULT/2)];
    imageScrollView.backgroundColor = [UIColor clearColor];
    [imageScrollView setPagingEnabled:YES];
    [imageScrollView setScrollEnabled:YES];
    imageScrollView.showsHorizontalScrollIndicator = NO;
    self.mainTabview.tableHeaderView = imageScrollView;
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-75, CGRectGetHeight(imageScrollView.frame)-30, 150, 30)];
    [pageControl setCurrentPageIndicatorTintColor:Color_mainColor];
    [pageControl setPageIndicatorTintColor:Color_gray4];
    
//    [self forADImage];
}
#pragma mark-----
#pragma mark---------imageScrollViews---------
- (void)bindAds:(NSArray *)items
{
    if (items == nil || items.count == 0) {
        return;
    }
    
    
    // ad view
//    int count = (int)items.count;
//    
//    imageArray = [[NSMutableArray alloc]initWithCapacity:count];
//    for (int i = 0; i < count; i ++) {
//        
//        NSDictionary *item = [items objectAtIndex:i];
//        NSURL *url = [NSURL URLWithString:[item objectForKey:@"img_src"]];
//        NSLog(@"url = %@",url);
//        [imageArray addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
//    }
    
    imageScrollView.delegate=self;
//    UIImageView *firstView=[[UIImageView alloc] initWithImage:[imageArray lastObject]];
    
    
//    firstView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat Width=imageScrollView.frame.size.width;
    CGFloat Height=imageScrollView.frame.size.height;
    SwbClickImageView *firstView=[[SwbClickImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    [firstView setImageWithURL:[commonTools getImgURL:[imageArray lastObject]] placeholderImage:PlaceholderImage_Big];
//    firstView.frame=CGRectMake(0, 0, Width, Height);
    [imageScrollView addSubview:firstView];
    //set the last as the first
    
    for (int i=0; i<[imageArray count]; i++) {
//        UIImageView *subViews=[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:i]];
        SwbClickImageView *subViews=[[SwbClickImageView alloc] initWithFrame:CGRectMake(Width*(i+1), 0, Width, Height)];
        [subViews setImageWithURL:[commonTools getImgURL:[imageArray objectAtIndex:i]] placeholderImage:PlaceholderImage_Big];
//        subViews.contentMode = UIViewContentModeScaleAspectFit;
//        subViews.frame=CGRectMake(Width*(i+1), 0, Width, Height);
        [imageScrollView addSubview: subViews];
        //点击图片事件
        [subViews callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
            NSLog(@"subViews cliped");
            ShouyeBannerModel *item = [_bannarArr objectAtIndex:i];
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
            if ([item.linkType isEqualToString:@"goods_detail_coupon"]) {//商品详情
                CashCouponDetailViewController *vc = [[CashCouponDetailViewController alloc]init];
                vc.goodsId = [NSString stringWithFormat:@"%d",[item.goodsId intValue]];
//                vc.goodsImageStr = [NSString stringWithFormat:@"%@",item.img];
                NSLog(@"%@",vc.goodsId);
                [self.navigationController pushViewController:vc animated:YES];
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
            
        }];

    }
    
//    UIImageView *lastView=[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:0]];
    SwbClickImageView *lastView=[[SwbClickImageView alloc] initWithFrame:CGRectMake(Width*(imageArray.count+1), 0, Width, Height)];
    [lastView setImageWithURL:[commonTools getImgURL:[imageArray objectAtIndex:0]] placeholderImage:PlaceholderImage_Big];
//    lastView.contentMode = UIViewContentModeScaleAspectFit;
//    lastView.frame=CGRectMake(Width*(imageArray.count+1), 0, Width, Height);
    [imageScrollView addSubview:lastView];
    //set the first as the last
    
    [imageScrollView setContentSize:CGSizeMake(Width*(imageArray.count+2), Height)];
    //    [self.view addSubview:self.scrollView];
    [imageScrollView scrollRectToVisible:CGRectMake(Width, 0, Width, Height) animated:NO];
    
    pageControl.numberOfPages=imageArray.count;
    pageControl.currentPage=0;
    pageControl.enabled=YES;
    [self.mainTabview addSubview:pageControl];
    [pageControl addTarget:self action:@selector(pageTurn:)forControlEvents:UIControlEventValueChanged];
    
    myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    
}
-(void)scrollToNextPage:(id)sender
{
    int pageNum=(int)pageControl.currentPage;
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

-(void)pageTurn:(UIPageControl *)sender
{
    int pageNum=(int)pageControl.currentPage;
    CGSize viewSize=imageScrollView.frame.size;
    [imageScrollView setContentOffset:CGPointMake((pageNum+1)*viewSize.width, 0)];
    NSLog(@"myscrollView.contentOffSet.x==%f",imageScrollView.contentOffset.x);
    NSLog(@"pageControl currentPage==%ld",(long)pageControl.currentPage);
    [myTimer invalidate];
}

#pragma mark Tableview  Delegate  &  Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4+_nearArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 60;
    }
    if (indexPath.row == 3) {
        
        return _newYouHuiArr.count*WIDTH_CONTROLLER_DEFAULT/2+_newYouHuiArr.count*5;
    }
    if (indexPath.row > 4) {
        return 80;
    }
    return 36;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 4) {
        DiscountCouponCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell1];
        if (_nearArr.count>1) {
            myCell.model = [_nearArr objectAtIndex:indexPath.row-4];
        }
        return myCell;
    }
    static NSString *cell1 = @"cell111";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell1];
    if (!myCell) {
        myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
    }
    myCell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
        UIScrollView *recommendScorllView = (UIScrollView *)[myCell.contentView viewWithTag:777];
        if (recommendScorllView) {
            recommendScorllView.hidden = YES;
        }
        UIView *vv = (UIView *)[myCell.contentView viewWithTag:888];
        if (vv) {
            vv.hidden = YES;
        }
        UILabel *lb = (UILabel *)[myCell.contentView viewWithTag:666];
        if (!lb) {
            lb = [self.view creatLabelWithFrame:CGRectMake(10, 3, 160, 30) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
            lb.tag = 666;
            [myCell.contentView addSubview:lb];
        }
        lb.hidden = NO;
        if (indexPath.row == 0) {
            lb.text = @"推荐品牌";
        }
        if (indexPath.row == 2) {
            lb.text = @"附近的优惠商家";
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 4) {
            lb.text = @"优惠商品";
        }
    }
    if (indexPath.row == 1) {
        UILabel *lb = (UILabel *)[myCell.contentView viewWithTag:666];
        if (lb) {
            lb.hidden = YES;
        }
        UIView *vv = (UIView *)[myCell.contentView viewWithTag:888];
        if (vv) {
            vv.hidden = YES;
        }
        UIScrollView *recommendScorllView = (UIScrollView *)[myCell.contentView viewWithTag:777];
        if (!recommendScorllView) {
            recommendScorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 60)];
            recommendScorllView.tag = 777;
            recommendScorllView.showsHorizontalScrollIndicator = NO;
            [myCell.contentView addSubview:recommendScorllView];
        }
        recommendScorllView.hidden = NO;
        for (int i=0; i<_recImgArr.count; i++) {
            SwbClickImageView * mImgView = (SwbClickImageView *)[recommendScorllView viewWithTag:i+1];
            if (!mImgView) {
                mImgView = [[SwbClickImageView alloc]initWithFrame:CGRectMake(i*70+5, 10, 60, 40)];
                mImgView.tag = i+1;
                [recommendScorllView addSubview:mImgView];
            }
            [mImgView setImageWithURL:[commonTools getImgURL:[[_recImgArr objectAtIndex:i]objectForKey:@"img"]] placeholderImage:PlaceholderImage];
//            mImgView.image = PlaceholderImage;
            __weak ShoppingViewController *weakSelf = self;
            [mImgView callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
                NSLog(@"推荐%ld",clickImgView.tag);
                ProductDetailViewController *vc = [[ProductDetailViewController alloc]init];
                vc.goodId = [[_recImgArr objectAtIndex:i]objectForKey:@"goodsId"];
                vc.goodsImageStr = [[_recImgArr objectAtIndex:i]objectForKey:@"img"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            if (i<_recImgArr.count-1) {
                UIView *lineview = (UIView *)[recommendScorllView viewWithTag:i*10+51];
                if (!lineview) {
                    lineview = [self.view createViewWithFrame:CGRectMake((i+1)*70, 10, 1, 40) andBackgroundColor:Color_line_bg];
                    lineview.tag = i*10+51;
                    [recommendScorllView addSubview:lineview];
                }
            }
        }
        [recommendScorllView setContentSize:CGSizeMake(_recImgArr.count*70, 0)];
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 3) {
//        for (UIView *tmpVIew in myCell.contentView.subviews) {
//            [tmpVIew removeFromSuperview];
//        }
        UILabel *lb = (UILabel *)[myCell.contentView viewWithTag:666];
        if (lb) {
            lb.hidden = YES;
        }
        UIScrollView *recommendScorllView = (UIScrollView *)[myCell.contentView viewWithTag:777];
        if (recommendScorllView) {
            recommendScorllView.hidden = YES;
        }
        UIView *viewBg = (UIView *)[myCell.contentView viewWithTag:888];
        if (!viewBg) {
            viewBg = [self.view createViewWithFrame:CGRectMake(0, 5, WIDTH_CONTROLLER_DEFAULT, _newYouHuiArr.count*WIDTH_CONTROLLER_DEFAULT/2+_newYouHuiArr.count*5) andBackgroundColor:[UIColor clearColor]];
            viewBg.tag = 888;
            [myCell.contentView addSubview:viewBg];
        }
        viewBg.hidden = NO;
        viewBg.frame = CGRectMake(0, 5, WIDTH_CONTROLLER_DEFAULT, _newYouHuiArr.count*WIDTH_CONTROLLER_DEFAULT/2+_newYouHuiArr.count*5);
        viewBg.backgroundColor = [UIColor clearColor];
        for (int i=0; i<_newYouHuiArr.count; i++) {
            SwbClickImageView * imgView = (SwbClickImageView *)[viewBg viewWithTag:i*1000+1000];
            if (!imgView) {
                imgView = [[SwbClickImageView alloc]initWithFrame:CGRectMake(0, i*WIDTH_CONTROLLER_DEFAULT/2+5*i, WIDTH_CONTROLLER_DEFAULT, WIDTH_CONTROLLER_DEFAULT/2)];
                imgView.tag = i*1000+1000;
                [viewBg addSubview:imgView];
            }
            UIImageView *tagImg = (UIImageView *)[viewBg viewWithTag:i*1000+500];
            UILabel *label = (UILabel *)[viewBg viewWithTag:i*1000+100];
            if (!tagImg) {
                tagImg = [[UIImageView alloc]init];
                tagImg.tag = i*1000+500;
                tagImg.image = [UIImage imageNamed:@"img_small_h"];
                [viewBg addSubview:tagImg];
                
                label = [[UILabel alloc]init];
                label.tag = i*1000+100;
                [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
                [label setTextColor:[UIColor whiteColor]];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextAlignment:NSTextAlignmentCenter];
                [viewBg addSubview:label];
            }
            tagImg.frame = CGRectMake(0, i*WIDTH_CONTROLLER_DEFAULT/2+5*i, 80, 23);
            label.frame = CGRectMake(0, i*WIDTH_CONTROLLER_DEFAULT/2+5*i, 70, 23);
            label.text = [NSString stringWithFormat:@"%@",[[_zuixinyouhuiArr objectAtIndex:i]objectForKey:@"tag"]];
//            if ([[[_zuixinyouhuiArr objectAtIndex:i]objectForKey:@"tag"]isEqualToString:@"爆款"]) {
//                tagImg.image = [UIImage imageNamed:@"img_exp"];
//            }
//            if ([[[_zuixinyouhuiArr objectAtIndex:i]objectForKey:@"tag"]isEqualToString:@"甩卖"]) {
//                tagImg.image = [UIImage imageNamed:@"img_bargain"];
//            }
//            if ([[[_zuixinyouhuiArr objectAtIndex:i]objectForKey:@"tag"]isEqualToString:@"特卖"]) {
//                tagImg.image = [UIImage imageNamed:@"img_temai"];
//            }
//            if ([[[_zuixinyouhuiArr objectAtIndex:i]objectForKey:@"tag"]isEqualToString:@"夏季新品"]) {
//                tagImg.image = [UIImage imageNamed:@"img_summer"];
//                tagImg.frame = CGRectMake(0, i*WIDTH_CONTROLLER_DEFAULT/2+5*i, 80, 23);
//            }
            
            ShouyeBannerModel *model = [_newYouHuiArr objectAtIndex:i];
            NSLog(@"%@",[commonTools getImgURL:model.img]);
            [imgView setImageWithURL:[commonTools getImgURL:model.img] placeholderImage:PlaceholderImage_Big];
//            imgView.contentMode = UIViewContentModeScaleAspectFit;
            __weak ShoppingViewController *weakSelf = self;
            [imgView callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
                NSLog(@"优惠打折%ld",clickImgView.tag);
                if ([model.linkType isEqualToString:@"goods_detail_coupon"]) {
                    CashCouponDetailViewController *vc = [[CashCouponDetailViewController alloc]init];
                    vc.goodsId = model.goodsId;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                if ([model.linkType isEqualToString:@"goods_list"]) {
                    ProductListViewController *vc = [[ProductListViewController alloc]init];
                    vc.bannerModel = model;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    }
    return myCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        FoodViewController *vc = [[FoodViewController alloc]init];
        vc.navTitle = @"购物";
        vc.StoreListType = GOUWU;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row > 4) {
        ProductDetailViewController *vc = [[ProductDetailViewController alloc]init];
        GoodsListModel *model = [_nearArr objectAtIndex:indexPath.row-4];
        vc.goodId = [NSString stringWithFormat:@"%d",[model.goods_id intValue]];
        vc.goodsImageStr = [NSString stringWithFormat:@"%@",model.default_image];
        [self.navigationController pushViewController:vc animated:YES];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//右边按钮事件
#pragma  mark--------BarButtonDelegate---------
- (void)right0ButtonClicked:(id)sender
{
    NSLog(@"%s",__func__);
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
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

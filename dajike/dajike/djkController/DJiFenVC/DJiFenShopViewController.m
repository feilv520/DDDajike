//
//  DJiFenShopViewController.m
//  dajike
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

/*
 
 *  积分商城首页
 
 */


#import "DJiFenShopViewController.h"
#import "dDefine.h"
#import "DGoodsListTableViewCell.h"
#import "DGoodsListBlurView.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "DGoodsListCollectionViewCell.h"
#import "DGoodsListModel.h"
#import "SWBTabBarController.h"
#import "DGoodsListSelectTableViewCell.h"
#import "NoneLoginCell.h"
#import "UserInfoModel.h"
#import "AnalysisData.h"
#import "AccountOverViewModel.h"
#import "mineMainCell2.h"
#import "DJiFenTableViewCell.h"
#import "DMyJiFenTableViewCell.h"
#import "DJiFenShopTableViewCell.h"
#import "ShouyeBannerModel.h"
#import "SwbClickImageView.h"
#import "DClassModel.h"
#import "DJFenModel.h"
#import "DJFenShopModel.h"
#import "DWebViewController.h"
#import "SWBTabBar.h"

@interface DJiFenShopViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SKSTableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>{
    BOOL twoFlag;
    BOOL threeFlag;
    BOOL fourFlag;
    BOOL fiveFlag;
    
    BOOL selectFlag;
    
    UIScrollView *imageScrollView;
    UIPageControl *pageControl;
    
    BOOL pageControlBeingUsed;
    NSTimer *myTimer;//定时器
    NSMutableArray *imageArray;
    
    NSMutableArray *imageArrayDemo;
    
    NSMutableArray *headArray;
    NSMutableArray *secondArray;
    
    NSMutableDictionary     *_userInfoDic;
    UserInfoModel           *_userModel;
    AccountOverViewModel    *_accountModel;
    
    NSInteger page;
    NSString *tempString;
    
    NSString *sortString;
    NSString *sortTypeString;
    
    NSInteger fNowOpen;
    
    NSString *cateId;
    
    NSString *iscollect;
    
    NSString *collectionString;
}


@property (nonatomic, strong) DImgButton *oneBtn;
@property (nonatomic, strong) DImgButton *twoBtn;
@property (nonatomic, strong) DImgButton *threeBtn;
@property (nonatomic, strong) DImgButton *fourBtn;
@property (nonatomic, strong) DImgButton *fiveBtn;

@property (nonatomic, strong) DImgButton *cancelBtn;
@property (nonatomic, strong) DImgButton *successBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *twoImageV;
@property (nonatomic, strong) UIImageView *threeImageV;
@property (nonatomic, strong) UIImageView *fourImageV;
@property (nonatomic, strong) UIImageView *fiveImageV;

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIView *mView;

@property (nonatomic, strong) DGoodsListBlurView *blurView;

@property (nonatomic, strong) UITableView *selectTableView;

@property (nonatomic, strong) NSMutableArray *contents;

@property (nonatomic, strong) UITableView *headTableView;

@property (nonatomic, strong) NSMutableArray *jiFenShopListArray;

@property (nonatomic, strong) UICollectionView *goodsListCollectionView;

@property (nonatomic, strong) NSString *selectString;

@property (nonatomic, strong) NSString *goodsIDString;

@property (nonatomic, strong) NSMutableArray *oneArray;

@property (nonatomic, strong) NSString *keywords;

@property (nonatomic, strong) NSDictionary *storeDic;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DJiFenShopViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    if ([FileOperation isLogin]) {
        _userInfoDic = [[FileOperation readFileToDictionary:dajikeUser]mutableCopy];
        _userModel = [[UserInfoModel alloc]init];
        _userModel = [JsonStringTransfer dictionary:_userInfoDic ToModel:_userModel];
        [self getMyAccountInfo];
    }
    [self.dMainTableView reloadData];
}

- (void) getMyAccountInfo{
    if ([FileOperation getUserId] == nil) {
        return;
    }
    NSDictionary *parameter = @{@"userId":[FileOperation getUserId]};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation:%@\n result:%@",operation,responseObject.result);
        if (responseObject.succeed) {
            NSDictionary *dic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
            NSLog(@"111111111111111111111111111%@",dic);
            _accountModel = [[AccountOverViewModel alloc] init];
            _accountModel = [JsonStringTransfer dictionary:dic ToModel:_accountModel];
            [self.headTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadingStoreDetail];
    
    selectFlag = NO;
    
    self.goodsIDString = @"";
    
    self.selectString = @"";
    
    self.keywords = @"";
    
    page = 1;
    
    tempString = @"";
    
    fNowOpen = 1000;
    
    cateId = @"";
    
    sortString = @"";
    sortTypeString = @"";
    
    SWBTabBarController *tabBarC = [SWBTabBarController sharedManager];
    [tabBarC.myView setHidden:YES];
    
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(-15, 0, 250+5, 44)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-30, 0, DWIDTH_CONTROLLER_DEFAULT - 120, 41)];
    searchBar.delegate = self;
    
    for (UIView *view in searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    searchBar.placeholder = @"搜索积分商城商品";
    [headV addSubview:searchBar];
    [self naviBarAddCoverViewOnTitleView:headV];
    
    DImgButton *leftBtn = [[DImgButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [leftBtn addTarget:self action:@selector(toLeftNavButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 25, 25)];
    leftImageV.layer.cornerRadius = 2.0;
    leftImageV.layer.masksToBounds = YES;
    [leftImageV setImage:[UIImage imageNamed:@"img_pub_02"]];
    leftImageV.contentMode = UIViewContentModeScaleAspectFit;
    [leftBtn addSubview:leftImageV];
    [self setNaviBarLeftBtn:leftBtn];
    
    DImgButton *rightBtn = [[DImgButton alloc]initWithFrame:CGRectMake(30, 10, 20, 20)];
    [rightBtn addTarget:self action:@selector(toRightNavButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 25, 25)];
    rightImageV.layer.cornerRadius = 2.0;
    rightImageV.layer.masksToBounds = YES;
    [rightImageV setImage:[UIImage imageNamed:@"pay_img_04"]];
    rightImageV.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addSubview:rightImageV];
    [self setNaviBarRightBtn:rightBtn];
    
#pragma scrollView
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT)];
    self.scrollView.contentSize = CGSizeMake(1, 700);
    
#pragma headView
    
    self.headTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 85) style:UITableViewStylePlain];
    
    self.headTableView.scrollEnabled = NO;
    
    self.headTableView.dataSource = self;
    self.headTableView.delegate = self;
    
#pragma tableView
    
    [self addTableView:YES];
    [self.dMainTableView setFrame:DRect(0, 64, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT - 64)];
    
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    
        self.dMainTableView.tableFooterView = [UIView new];
    
    [self.dMainTableView registerNib:[UINib nibWithNibName:@"DGoodsListTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodslist"];
    
#pragma 分类
    
    self.selectView = [[UIView alloc] initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT - 105, DHEIGHT_CONTROLLER_DEFAULT)];
    self.selectView.backgroundColor = DColor_ffffff;
    
    [self.view addSubview:self.selectView];
    
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.selectView.frame.size.width, DHEIGHT_CONTROLLER_DEFAULT - 64) style:UITableViewStyleGrouped];
    
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    
    self.selectTableView.backgroundColor = DColor_White;
    
    [self.selectView addSubview:self.selectTableView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.selectView.frame.size.width / 2.3, 22, 100, 30)];
    self.titleLabel.text = @"分类";
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = DColor_word_bg;
    [self.selectView addSubview:self.titleLabel];
    
    [self loadingData:@"" sortType:@""];
}

- (void)viewWillDisappear:(BOOL)animated{
    SWBTabBarController *tabBarC = [SWBTabBarController sharedManager];
    [tabBarC.myView setHidden:NO];
}

#pragma tableView delegate 的方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dMainTableView == tableView)
        return 2;
    else if ([tableView isEqual:self.selectTableView]) {
        if (_contents.count > 0) {
            return _contents.count+1;
        }
        return 1;
    }
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.selectTableView]) {
        return 40;
    }
    return 0.5f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([tableView isEqual:self.selectTableView]) {

    }
    return 0.5f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.selectTableView) {
        if (section == fNowOpen) {
            if (_contents.count >= section) {
                return [[[_contents objectAtIndex:section-1]objectForKey:@"two"] count];
            }
            return  0;
        }
    } else if(tableView == self.dMainTableView){
        if (section == 0) {
            return 2;
        } else {
            return 2;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.selectTableView]) {
        UIView *bV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        bV.backgroundColor = DColor_cccccc;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, 320, 39.5)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = section;
        [btn addTarget:self action:@selector(toFenleiBtns:) forControlEvents:UIControlEventTouchUpInside];
        [bV addSubview:btn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 170, 39.5)];
        [label setFont:DFont_12];
        [label setTextColor:DColor_666666];
        //    label.tag = 2000+section;
        if (section == 0) {
            label.text = @"全部商品";
        }else{
            label.text = [NSString stringWithFormat:@"%@",[[_contents objectAtIndex:section-1] objectForKey:@"cate_name"]];
        }
        [btn addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(180, 13, 13, 7)];
        [imageView setTag:2000+section];
        [imageView setImage:[UIImage imageNamed:@"img_pub_gray"]];
        [btn addSubview:imageView];
        if (section == 0) {
            [imageView setHidden:YES];
        }
        
        return bV;
    }else{
        return nil;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.dMainTableView){
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                DJiFenShopTableViewCell *cell = [DTools loadTableViewCell:self.headTableView cellClass:[DJiFenShopTableViewCell class]];
                cell.fenNumber.text = [NSString stringWithFormat:@"粉丝数 %@",collectionString];
                if ([iscollect isEqualToString:@"1"]) {
                    [cell.collectionButton setBackgroundImage:[UIImage imageNamed:@"img_jf_02"] forState:UIControlStateNormal];
                    cell.collectionLabel.textColor = DColor_c4291f;
                } else {
                    [cell.collectionButton setBackgroundImage:[UIImage imageNamed:@"img_jf_09"] forState:UIControlStateNormal];
                    cell.collectionLabel.textColor = [UIColor grayColor];
                }
                [cell.collectionButton addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            } else {
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
#pragma 轮播图
                
                imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 193)];
                imageScrollView.backgroundColor = DColor_a0a0a0;
                [imageScrollView setPagingEnabled:YES];
                //设置滚动条类型
                imageScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
                //是否自动裁切超出部分
                imageScrollView.clipsToBounds = YES;
                //设置是否可以缩放
                imageScrollView.scrollEnabled = YES;
                imageScrollView.showsHorizontalScrollIndicator = FALSE;//水平滚动条是否显示
                imageScrollView.showsVerticalScrollIndicator = FALSE;//垂直滚动条是否显示
                [cell addSubview:imageScrollView];
                
                pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT/2-35, 170, 70, 30)];
                [pageControl setCurrentPageIndicatorTintColor:DColor_mainRed];
                [pageControl setPageIndicatorTintColor:DColor_ffffff];
                
                [cell addSubview:pageControl];
                
                [self forADImage];
                
                return cell;
            }
        } else {
            if (indexPath.row == 0) {
                
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse2"];
                
#pragma 选择按钮
                
                UIView *slideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 40)];
                [self.scrollView addSubview:slideView];
                slideView.backgroundColor = DColor_White;
                
                self.oneBtn = [[DImgButton alloc] initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
                [self.oneBtn setTitle:@"默认" forState:UIControlStateNormal];
                self.oneBtn.titleLabel.font = DFont_12;
                [self.oneBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.oneBtn setTitleColor:DColor_c4291f forState:UIControlStateNormal];
                [slideView addSubview:self.oneBtn];
                
                self.twoBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 10, 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
                [self.twoBtn setTitle:@"销量" forState:UIControlStateNormal];
                self.twoBtn.titleLabel.font = DFont_12;
                [self.twoBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.twoBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
                self.twoImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 15, 15, 10, 10)];
                self.twoImageV.layer.cornerRadius = 2.0;
                self.twoImageV.layer.masksToBounds = YES;
                [self.twoImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
                self.twoImageV.contentMode = UIViewContentModeScaleAspectFit;
                [self.twoBtn addSubview:self.twoImageV];
                [slideView addSubview:self.twoBtn];
                
                twoFlag = NO;
                
                self.threeBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.twoBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
                [self.threeBtn setTitle:@"评价" forState:UIControlStateNormal];
                self.threeBtn.titleLabel.font = DFont_12;
                [self.threeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.threeBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
                self.threeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 15, 15, 10, 10)];
                self.threeImageV.layer.cornerRadius = 2.0;
                self.threeImageV.layer.masksToBounds = YES;
                [self.threeImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
                self.threeImageV.contentMode = UIViewContentModeScaleAspectFit;
                [self.threeBtn addSubview:self.threeImageV];
                [slideView addSubview:self.threeBtn];
                
                threeFlag = NO;
                
                self.fourBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.threeBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
                [self.fourBtn setTitle:@"价格" forState:UIControlStateNormal];
                self.fourBtn.titleLabel.font = DFont_12;
                [self.fourBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.fourBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
                self.fourImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 15, 15, 10, 10)];
                self.fourImageV.layer.cornerRadius = 2.0;
                self.fourImageV.layer.masksToBounds = YES;
                [self.fourImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
                self.fourImageV.contentMode = UIViewContentModeScaleAspectFit;
                [self.fourBtn addSubview:self.fourImageV];
                [slideView addSubview:self.fourBtn];
                
                fourFlag = NO;
                
                self.fiveBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fourBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
                [self.fiveBtn setTitle:@"新品" forState:UIControlStateNormal];
                self.fiveBtn.titleLabel.font = DFont_12;
                [self.fiveBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.fiveBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
                self.fiveImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 15, 15, 10, 10)];
                self.fiveImageV.layer.cornerRadius = 2.0;
                self.fiveImageV.layer.masksToBounds = YES;
                [self.fiveImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
                self.fiveImageV.contentMode = UIViewContentModeScaleAspectFit;
                [self.fiveBtn addSubview:self.fiveImageV];
                [slideView addSubview:self.fiveBtn];
                
                fiveFlag = NO;

                
                [cell addSubview:slideView];
                
                return cell;
                
            } else {
                
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse1"];
                
#pragma collectionView
                
                UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
                
                flowlayout.minimumInteritemSpacing = 1.0f;
                flowlayout.minimumLineSpacing = 1.0f;
                
                if (self.jiFenShopListArray.count > 0) {
                    self.goodsListCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, DWIDTH_CONTROLLER_DEFAULT*((215 + 10)/320.0)*(self.jiFenShopListArray.count/2+(self.jiFenShopListArray.count%2 > 0?1:0))) collectionViewLayout:flowlayout];
                }else{
                    self.goodsListCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT/320.0, DWIDTH_CONTROLLER_DEFAULT/320.0/5) collectionViewLayout:flowlayout];
                }
                
                self.goodsListCollectionView.backgroundColor = DColor_White;
                
                self.goodsListCollectionView.delegate = self;
                self.goodsListCollectionView.dataSource = self;
                
                self.goodsListCollectionView.scrollEnabled = NO;
                
                [self.goodsListCollectionView registerNib:[UINib nibWithNibName:@"DGoodsListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"goodsList"];
                
                [cell addSubview:self.goodsListCollectionView];
                
                return cell;
                
            }
        }
    } else if (tableView == self.selectTableView) {
            static NSString *CellIdentifier = @"SKSTableViewCell";
            
            SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
                cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
            cell.isExpandable = NO;
            cell.textLabel.text = [self.contents[indexPath.row] objectForKey:@"cate_name"];
            
            return cell;
    } else {
        DGoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodslist"];
        if (indexPath.row < self.jiFenShopListArray.count) {
            DGoodsListModel *goodsListModel = [self.jiFenShopListArray objectAtIndex:indexPath.row];
            [cell.headImageView setImageWithURL:[NSURL URLWithString:[goodsListModel default_image]]];
            cell.titleLabel.text = [goodsListModel goods_name];
            cell.commintLabel.text = [NSString stringWithFormat:@"%@%%好评",[goodsListModel haoping]];
            NSMutableAttributedString *moneyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@.00",[goodsListModel price]]];
            [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(moneyString.length - 2, 2)];
            cell.moneyLabel.attributedText = moneyString;
            cell.commitNumberLabel.text = [NSString stringWithFormat:@"评论%@条",[goodsListModel comments]];
        }
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    DGoodsListSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"select"];
    
    if (!cell) {
        cell = [[DGoodsListSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"select"];
    }
    
    cell.contentView.backgroundColor = DColor_mainRed;
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", [self.contents[indexPath.row][indexPath.subRow] cate_name]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.dMainTableView){
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 85;
            } else {
                return 193;
            }
        } else {
            if (indexPath.row == 0) {
                return 40;
            } else {
                if (self.jiFenShopListArray.count > 0) {
                    return (DWIDTH_CONTROLLER_DEFAULT*(215 + 10)/320)*(self.jiFenShopListArray.count/2+(self.jiFenShopListArray.count%2 > 0?1:0)) - 35 * page;
                }
            }
        }
    } else if ([tableView isEqual:self.selectTableView]) {
        return 44.0f;
    }
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == self.selectTableView) {
        [self.oneBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
        [self.twoBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
        [self.threeBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
        [self.fourBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
        [self.fiveBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
        [self.twoImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
        [self.threeImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
        [self.fourImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
        [self.fiveImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
        [self loadingData:@"" sortType:@""];
        [self.oneBtn setTitleColor:DColor_c4291f forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.twoImageV.transform = CGAffineTransformMakeRotation(0);
            self.threeImageV.transform = CGAffineTransformMakeRotation(0);
            self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            self.fiveImageV.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            cateId = [[[[_contents objectAtIndex:indexPath.section - 1] objectForKey:@"two"] objectAtIndex:indexPath.row] objectForKey:@"cate_id"];
            [self refreshData:^(BOOL finish) {
                
            }];
        }];
        [UIView animateWithDuration:1.0f animations:^{
            self.selectView.frame = CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
            self.mView.hidden = YES;
        } completion:^(BOOL finished) {
            NSLog(@"FINISHED");
        }];
    }
}

#pragma collectionView 方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.jiFenShopListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DGoodsListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsList" forIndexPath:indexPath];
    DJFenModel *jiFenList = [self.jiFenShopListArray objectAtIndex:indexPath.item];
    [cell.goodsImageView setImageWithURL:[NSURL URLWithString:[jiFenList default_image]]];
    cell.goodsName.text = [jiFenList goods_name];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@积分",[jiFenList if_jifen]];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake((DWIDTH_CONTROLLER_DEFAULT/320.0)*5, (DWIDTH_CONTROLLER_DEFAULT/320.0)*8, (DWIDTH_CONTROLLER_DEFAULT/320.0)*5, (DWIDTH_CONTROLLER_DEFAULT/320.0)*8);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DWIDTH_CONTROLLER_DEFAULT/320.0)*150, (DWIDTH_CONTROLLER_DEFAULT/320.0)*215);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.item);
    DWebViewController *vc = [[DWebViewController alloc]init];
    DJFenModel *jiFenList = [self.jiFenShopListArray objectAtIndex:indexPath.row];
    vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",jiFenList.goods_id,get_userId];
    vc.type = IS_NEED_ADD;
    vc.goodId = [NSString stringWithFormat:@"%@",jiFenList.goods_id];
    vc.imageUrl = [NSString stringWithFormat:@"%@",jiFenList.default_image];
    vc.googsTitle = [NSString stringWithFormat:@"%@",jiFenList.goods_name];
    vc.isHelp = 6;
    push(vc);
}


#pragma 按钮的实现方法
- (void)buttonAction:(DImgButton *)btn{
    [self.oneBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.twoBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.threeBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.fourBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.fiveBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.twoImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    [self.threeImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    [self.fourImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    [self.fiveImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    if (btn == self.oneBtn) {
        [self loadingData:@"" sortType:@""];
        [self.oneBtn setTitleColor:DColor_c4291f forState:UIControlStateNormal];
        twoFlag = NO;
        threeFlag = NO;
        fourFlag = NO;
        fiveFlag = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.twoImageV.transform = CGAffineTransformMakeRotation(0);
            self.threeImageV.transform = CGAffineTransformMakeRotation(0);
            self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            self.fiveImageV.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
        }];
    } else if (btn == self.twoBtn){
        [self.twoBtn setTitleColor:DColor_c4291f forState:UIControlStateNormal];
        [self.twoImageV setImage:[UIImage imageNamed:@"img_pub_red"]];
        threeFlag = NO;
        fourFlag = NO;
        fiveFlag = NO;
        if (twoFlag) {
            [self loadingData:@"sales" sortType:@"asc"];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(M_PI);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
                self.fiveImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                twoFlag = NO;
            }];
        }
        else {
            [self loadingData:@"sales" sortType:@"desc"];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
                self.fiveImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                twoFlag = YES;
            }];
        }
    } else if (btn == self.threeBtn){
        [self.threeBtn setTitleColor:DColor_c4291f forState:UIControlStateNormal];
        [self.threeImageV setImage:[UIImage imageNamed:@"img_pub_red"]];
        twoFlag = NO;
        fourFlag = NO;
        fiveFlag = NO;
        if (threeFlag) {
            [self loadingData:@"comments" sortType:@"asc"];
            [UIView animateWithDuration:0.5 animations:^{
                self.threeImageV.transform = CGAffineTransformMakeRotation(M_PI);
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
                self.fiveImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                threeFlag = NO;
            }];
        }
        else {
            [self loadingData:@"comments" sortType:@"desc"];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
                self.fiveImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                threeFlag = YES;
            }];
        }
    } else if (btn == self.fourBtn){
        [self.fourBtn setTitleColor:DColor_c4291f forState:UIControlStateNormal];
        [self.fourImageV setImage:[UIImage imageNamed:@"img_pub_red"]];
        twoFlag = NO;
        threeFlag = NO;
        fiveFlag = NO;
        if (fourFlag) {
            [self loadingData:@"jifen" sortType:@"asc"];
            [UIView animateWithDuration:0.5 animations:^{
                self.fourImageV.transform = CGAffineTransformMakeRotation(M_PI);
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fiveImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                fourFlag = NO;
            }];
        }
        else {
            [self loadingData:@"jifen" sortType:@"desc"];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
                self.fiveImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                fourFlag = YES;
            }];
        }
    } else if (btn == self.fiveBtn){
        [self.fiveBtn setTitleColor:DColor_c4291f forState:UIControlStateNormal];
        [self.fiveImageV setImage:[UIImage imageNamed:@"img_pub_red"]];
        twoFlag = NO;
        threeFlag = NO;
        fourFlag = NO;
        if (fiveFlag) {
            [self loadingData:@"xinpin" sortType:@"asc"];
            [UIView animateWithDuration:0.5 animations:^{
                self.fiveImageV.transform = CGAffineTransformMakeRotation(M_PI);
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                fiveFlag = NO;
            }];
        }
        else {
            [self loadingData:@"xinpin" sortType:@"desc"];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
                self.fiveImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                fiveFlag = YES;
            }];
        }
        
    }
}
#pragma 网络请求方法
- (void)loadingData:(NSString *)sortStr sortType:(NSString *)sortType{
    NSDictionary *parameter = @{@"keyword":self.keywords,@"sort":sortStr,@"descAsc":sortType,@"page":[NSString stringWithFormat:@"%ld",page]};
    sortString = sortStr;
    sortTypeString = sortType;
    NSLog(@"111111%@",parameter);
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Jifens.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSArray *array = responseObject.result;
            self.jiFenShopListArray = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                DJFenModel *jFen = [[DJFenModel alloc] init];
                [jFen setValuesForKeysWithDictionary:dic];
                [self.jiFenShopListArray addObject:jFen];
            }
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *indesPath1 = [NSIndexPath indexPathForRow:1 inSection:1];
            NSArray *array0 = @[indesPath,indesPath1];
            [self.dMainTableView reloadRowsAtIndexPaths:array0 withRowAnimation:UITableViewRowAnimationNone];
            [self.goodsListCollectionView reloadData];
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


- (void)loadingList:(NSString *)goodsScreenString{
    NSDictionary *parameter = @{@"attrValues":goodsScreenString};
    NSLog(@"111111%@",parameter);
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.list" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSArray *dataArr = [responseObject.result objectForKey:@"data"];
            self.jiFenShopListArray = [NSMutableArray array];
            for (NSDictionary *dic in dataArr) {
                DGoodsListModel *goodsList = [[DGoodsListModel alloc] init];
                [goodsList setValuesForKeysWithDictionary:dic];
                [self.jiFenShopListArray addObject:goodsList];
                self.goodsIDString = [NSString stringWithFormat:@"%@,%@",self.goodsIDString,[goodsList goods_id]];
            }
            self.goodsIDString = [self.goodsIDString substringWithRange:NSMakeRange(1, self.goodsIDString.length - 1)];
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *indesPath1 = [NSIndexPath indexPathForRow:1 inSection:1];
            NSArray *array0 = @[indesPath,indesPath1];
            [self.dMainTableView reloadRowsAtIndexPaths:array0 withRowAnimation:UITableViewRowAnimationNone];
            [self.goodsListCollectionView reloadData];
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

#pragma 返回方法
- (void)toLeftNavButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 分类界面
- (void)toRightNavButton:(id)sender{
    [self loadingData1:@"114"];
    [UIView animateWithDuration:1.0f animations:^{
        
        self.selectView.frame = CGRectMake(105, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
    } completion:^(BOOL finished) {
        self.mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 105, DHEIGHT_CONTROLLER_DEFAULT)];
        self.mView.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
        self.mView.layer.contentsGravity = kCAGravityResizeAspect;
        self.mView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.mView addGestureRecognizer:singleTap];
        
        [self.view addSubview:self.mView];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 分类网络请求
#warning 需要修改 积分商城的分类接口
- (void)loadingData1:(NSString *)storesString{
//    NSDictionary *dic = @{@"storeId":storesString};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Jifens.goodsCategory" parameters:nil ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            
            self.contents = [NSMutableArray array];
            
            NSLog(@"result = %@",responseObject.result);
            NSArray *array = responseObject.result;
            for (NSDictionary *dic in array) {
                [self.contents addObject:dic];
            }
            NSLog(@"%@",self.contents);
            [self.selectTableView reloadData];
        } else {
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





#pragma mark-----
#pragma mark---------imageScrollViews---------
//广告nanner
- (void)forADImage
{
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"GuangGaoHtmls.show" parameters:@{@"code":@"djk_jifen_goods"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"---%@",responseObject.result);
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
        NSLog(@"operation = %@",operation);
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation = %@",operation);
        NSLog(@"error = %@",error);
    }];
}

- (void)bindAds:(NSArray *)items
{
    if (items == nil || items.count == 0) {
        return;
    }
    
    // ad view
    NSInteger count = items.count;
    
    imageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < count; i ++) {
        
        ShouyeBannerModel *item = [items objectAtIndex:i];
        NSURL *url = [commonTools getImgURL:item.img];
        NSLog(@"url = %@",url);
        [imageArray addObject:url];
    }
    
    imageScrollView.delegate=self;
    CGFloat Width=imageScrollView.frame.size.width;
    CGFloat Height=imageScrollView.frame.size.height;
    SwbClickImageView *firstView=[[SwbClickImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    firstView.backgroundColor = DColor_a0a0a0;
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
                //                FoodShopDetailViewController *shopVC = [[FoodShopDetailViewController alloc]init];
                //                shopVC.storeId = item.storeId;
                //                [self.navigationController pushViewController:shopVC animated:YES];
            }
            if ([item.linkType isEqualToString:@"store_list"]) {//商家列表
                showMessage(@"商家列表");
                //                FoodViewController *foodVC = [[FoodViewController alloc]init];
                //                foodVC.navTitle = item.title;
                //                foodVC.StoreListType = DEFAULT_LIST;
                //                foodVC.bannerModel = item;
                //                [self.navigationController pushViewController:foodVC animated:YES];
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
                vc.sjORjf = JIFEN;
                push(vc);
            }
            if ([item.linkType isEqualToString:@"goods_list"]) {//商品列表
                showMessage(@"商品列表");
                //                ProductListViewController *vc = [[ProductListViewController alloc]init];
                //                vc.bannerModel = item;
                //                [self.navigationController pushViewController:vc animated:YES];
            }
            //代金券详情
            if ([item.linkType isEqualToString:@"goods_detail_coupon"]) {
                showMessage(@"代金券详情");
                //                CashCouponDetailViewController *CashCouponDetailVC = [[CashCouponDetailViewController alloc]init];
                //                CashCouponDetailVC.goodsId = item.goodsId;
                //                [self.navigationController pushViewController:CashCouponDetailVC animated:YES];
            }
            
        }];
    }
    
    //    UIImageView *lastView=[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:0]];
    SwbClickImageView *lastView=[[SwbClickImageView alloc] initWithFrame:CGRectMake(Width*(imageArray.count+1), 0, Width, Height)];
    lastView.backgroundColor = DColor_a0a0a0;
    //    lastView.contentMode = UIViewContentModeScaleAspectFit;
    [lastView setImageWithURL:[imageArray objectAtIndex:0] placeholderImage:DPlaceholderImage_Big];
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
//    [self.scrollView addSubview:pageControl];
    [pageControl addTarget:self action:@selector(pageTurn:)forControlEvents:UIControlEventValueChanged];
    
    myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    
    
    
}
-(void)scrollToNextPage:(id)sender
{
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
    myTimer=[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth=imageScrollView.frame.size.width;
    CGFloat pageHeigth=imageScrollView.frame.size.height;
    int currentPage=floor((imageScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
//    NSLog(@"the current offset==%f",imageScrollView.contentOffset.x);
//    NSLog(@"the current page==%d",currentPage);
    
    if (currentPage==0) {
        [imageScrollView scrollRectToVisible:CGRectMake(pageWidth*imageArray.count, 0, pageWidth, pageHeigth) animated:NO];
        pageControl.currentPage=imageArray.count-1;
//        NSLog(@"pageControl currentPage==%d",pageControl.currentPage);
//        NSLog(@"the last image");
        return;
    }else  if(currentPage==[imageArray count]+1){
        [imageScrollView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
        pageControl.currentPage=0;
//        NSLog(@"pageControl currentPage==%d",pageControl.currentPage);
//        NSLog(@"the first image");
        return;
    }
    pageControl.currentPage=currentPage-1;
//    NSLog(@"pageControl currentPage==%d",pageControl.currentPage);
    //    [self pageTurn:pageControl];
    
}

-(void)pageTurn:(UIPageControl *)sender
{
    NSInteger pageNum=pageControl.currentPage;
    CGSize viewSize=imageScrollView.frame.size;
    [imageScrollView setContentOffset:CGPointMake((pageNum+1)*viewSize.width, 0)];
    [myTimer invalidate];
}


//----------------------------------- 万恶的分割线 --------------------------------------

- (void)addData:(void (^)(BOOL finish))success
{
    NSLog(@"%@",cateId);
    NSDictionary *parameter = @{@"keyword":self.keywords,@"sort":sortString,@"descAsc":sortTypeString,@"page":[NSString stringWithFormat:@"%ld",page+1],@"cateId":cateId};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Jifens.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"---------------%ld",page);
            NSLog(@"result = %@",responseObject.result);
            NSArray *dataArr = responseObject.result;
            for (NSDictionary *dic in dataArr) {
                DJFenModel *jFen = [[DJFenModel alloc] init];
                [jFen setValuesForKeysWithDictionary:dic];
                [self.jiFenShopListArray addObject:jFen];
            }
            page = page + 1;
            if (dataArr.count < 10) {
                isEnd = YES;
            }
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *indesPath1 = [NSIndexPath indexPathForRow:1 inSection:1];
            NSArray *array0 = @[indesPath,indesPath1];
            [self.dMainTableView reloadRowsAtIndexPaths:array0 withRowAnimation:UITableViewRowAnimationNone];
            [self.goodsListCollectionView reloadData];
            success(YES);
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
        _jiFenShopListArray = nil;
        NSIndexPath *indesPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *indesPath1 = [NSIndexPath indexPathForRow:1 inSection:1];
        NSArray *array0 = @[indesPath,indesPath1];
        [self.dMainTableView reloadRowsAtIndexPaths:array0 withRowAnimation:UITableViewRowAnimationNone];
        success(NO);
    }];
    
}

#pragma mark-----
#pragma mark---------MJRefresh---------

//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        showMessage(@"加载完成");
        success (YES);
    }else{
        [self addData:^(BOOL finish) {
            success(finish);
        }];
    }
    
}

//刷新数据
- (void) refreshData:(void (^)(BOOL finish))success
{
    //重新加载数据。一切都重新初始化
    [self.footer resetNoMoreData];
    [self.jiFenShopListArray removeAllObjects];
    self.jiFenShopListArray = nil;
    self.jiFenShopListArray = [NSMutableArray array];
    page = 0;
    isEnd = NO;
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}

#pragma SearchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.keywords = searchBar.text;
    [self loadingData:@"" sortType:@""];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar

{
    searchBar.showsCancelButton = NO;
    
    searchBar.text = @"";
    
    [searchBar resignFirstResponder];
    
}

#pragma buttonAction
- (void) toFenleiBtns:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"btn.tag = %ld",btn.tag);
    
    if (btn.tag == 0) {
        return;
    }
    
    
    if (btn.tag == fNowOpen) {
        fNowOpen = 1000;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[_contents objectAtIndex:btn.tag-1]objectForKey:@"two"]] ;
        for (int i = 0; i < isFlagArr.count; i++) {
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
            [arr addObject:indesPath];
        }
        UIImageView *imageV = (UIImageView *)[btn viewWithTag:2000+btn.tag];
        imageV.transform = CGAffineTransformMakeRotation(0);
        
        [self.selectTableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationBottom];
    }else{
        if (fNowOpen != 1000) {
            
            NSInteger nowClose = fNowOpen;
            fNowOpen = 1000;
            NSMutableArray *arr0 = [[NSMutableArray alloc]init];
            NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[_contents objectAtIndex:nowClose-1]objectForKey:@"two"]] ;
            for (int i = 0; i < isFlagArr.count; i++) {
                NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:nowClose];
                [arr0 addObject:indesPath];
            }
            
            UIImageView *imageV0 = (UIImageView *)[self.selectTableView viewWithTag:2000+nowClose];
            imageV0.transform = CGAffineTransformMakeRotation(0);
            [self.selectTableView deleteRowsAtIndexPaths:arr0 withRowAnimation:UITableViewRowAnimationNone];
            fNowOpen = btn.tag;
        }else{
            fNowOpen = btn.tag;
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[_contents objectAtIndex:btn.tag-1]objectForKey:@"two"]] ;
        for (int i = 0; i < isFlagArr.count; i++) {
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
            [arr addObject:indesPath];
        }
        
        UIImageView *imageV1 = (UIImageView *)[btn viewWithTag:2000+btn.tag];
        imageV1.transform = CGAffineTransformMakeRotation(M_PI);
        
        [self.selectTableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
        
    }
}

#pragma cell buttonAction
- (void)collectionAction:(UIButton *)but{
    
    if ([iscollect isEqualToString:@"0"]){
        NSDictionary *parameter = @{@"userId":_userModel.userId,@"objectId":[NSString stringWithFormat:@"%@",self.storeId],@"type":@"2"};
        NSLog(@"111111%@",parameter);
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyCollectss.collect" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
                iscollect = @"1";
                collectionString = [NSString stringWithFormat:@"%d",[collectionString intValue] + 1];
                NSIndexPath *indesPath = [NSIndexPath indexPathForRow:0 inSection:0];
                NSArray *array = @[indesPath];
                [self.dMainTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
                self.block();
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
        
    } else {
        NSDictionary *parameter = @{@"userId":_userModel.userId,@"itemId":[NSString stringWithFormat:@"%@",self.storeId],@"type":@"store"};
        NSLog(@"111111%@",parameter);
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyCollectss.delete" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
                iscollect = @"0";
                collectionString = [NSString stringWithFormat:@"%d",[collectionString intValue] - 1];
                NSIndexPath *indesPath = [NSIndexPath indexPathForRow:0 inSection:0];
                NSArray *array = @[indesPath];
                [self.dMainTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
                self.block();
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
}

- (void)loadingStoreDetail{
#warning 需要修改
    NSDictionary *parameter = @{@"userId":[FileOperation getUserId]};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Jifens.jfStoreInformation" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            self.storeDic = responseObject.result;
            
            iscollect = [NSString stringWithFormat:@"%@",[self.storeDic objectForKey:@"ifcollectStore"]];
            
            collectionString = [NSString stringWithFormat:@"%@",[self.storeDic objectForKey:@"collectCount"]];
            
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *indesPath1 = [NSIndexPath indexPathForRow:1 inSection:1];
            NSArray *array0 = @[indesPath,indesPath1];
            [self.dMainTableView reloadRowsAtIndexPaths:array0 withRowAnimation:UITableViewRowAnimationNone];
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

#pragma singleTap
-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    
    [UIView animateWithDuration:0.5f  animations:^{
        self.selectView.frame = CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
        self.mView.hidden = YES;
    } completion:^(BOOL finished) {
        self.selectString = @"";
        NSLog(@"FINISHED");
    }];
    
}
- (void)callBack:(CallBackDWebViewController)block
{
    self.block = block;
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
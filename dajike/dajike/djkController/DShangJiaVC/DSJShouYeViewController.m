//
//  DJiFenShopViewController.m
//  dajike
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DSJShouYeViewController.h"
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
#import "DWebViewController.h"
#import "SWBTabBar.h"

@interface DSJShouYeViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SKSTableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>{
    BOOL twoFlag;
    BOOL threeFlag;
    BOOL fourFlag;
    BOOL fiveFlag;
    
    BOOL selectFlag;
    
    UIScrollView *imageScrollView;
    UIPageControl *pageControl;
    
    UIImageView *logoImageView;
    
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
    
    UIView *slideView;
    
    NSString *cateId;
    
    NSInteger fNowOpen;
    
    NSDictionary *dictionary;
    
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

@property (nonatomic, strong) NSMutableArray *goodsListArray;

@property (nonatomic, strong) UICollectionView *goodsListCollectionView;

@property (nonatomic, strong) NSString *selectString;

@property (nonatomic, strong) NSString *goodsIDString;

@property (nonatomic, strong) NSMutableArray *oneArray;

@property (nonatomic, strong) NSString *keywords;

@property (nonatomic, strong) NSDictionary *storeDic;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DSJShouYeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    SWBTabBarController *tabBarC = [SWBTabBarController sharedManager];
    [tabBarC.myView setHidden:YES];
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
            [self.dMainTableView reloadData];
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
    
    tempString = @"";
    
    cateId = @"";
    
    fNowOpen = 1000;
    
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(-15, 0, 250+5, 44)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-30, 8, 250-5, 25)];
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
    
    searchBar.placeholder = @"搜索店铺内商品";
    [headV addSubview:searchBar];
    [self naviBarAddCoverViewOnTitleView:headV];
    
    DImgButton *leftBtn = [[DImgButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [leftBtn addTarget:self action:@selector(toLeftNavButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 19, 24)];
    leftImageV.layer.cornerRadius = 2.0;
    leftImageV.layer.masksToBounds = YES;
    [leftImageV setImage:[UIImage imageNamed:@"img_pub_02"]];
    leftImageV.contentMode = UIViewContentModeScaleAspectFit;
    [leftBtn addSubview:leftImageV];
    [self setNaviBarLeftBtn:leftBtn];
    
    DImgButton *rightBtn = [[DImgButton alloc]initWithFrame:CGRectMake(30, 10, 20, 20)];
    [rightBtn addTarget:self action:@selector(toRightNavButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImageV = [[UIImageView alloc]initWithFrame:CGRectMake(28, 10, 20, 20)];
    rightImageV.layer.cornerRadius = 2.0;
    rightImageV.layer.masksToBounds = YES;
    [rightImageV setImage:[UIImage imageNamed:@"img_pub_04_01"]];
    rightImageV.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addSubview:rightImageV];
    [self setNaviBarRightBtn:rightBtn];
    
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
    
#pragma collectionView
    
//    [self.scrollView addSubview:self.goodsListCollectionView];
    
//    self.goodsListCollectionView.hidden = YES;
    
#pragma 分类
    
    self.selectView = [[UIView alloc] initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT - 105, DHEIGHT_CONTROLLER_DEFAULT)];
    self.selectView.backgroundColor = DColor_ffffff;
    
    [self.view addSubview:self.selectView];
    
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.selectView.frame.size.width, DHEIGHT_CONTROLLER_DEFAULT - 64) style:UITableViewStyleGrouped];
    
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    
    self.selectTableView.backgroundColor = DColor_White;
    
    [self.selectTableView registerNib:[UINib nibWithNibName:@"DGoodsListSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"select"];
    
    [self.selectView addSubview:self.selectTableView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.selectView.frame.size.width / 2.3, 22, 100, 30)];
    self.titleLabel.text = @"分类";
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = DColor_word_bg;
    [self.selectView addSubview:self.titleLabel];
    
    [self loadingData:@""];
    
    page = 0;
    
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
                return [self.contents[section - 1] count] - 1;
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
//    return self.goodsListArray.count;
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
            label.text = [NSString stringWithFormat:@"%@",self.contents[section - 1][0]];
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
                cell.nameLabel.text = [[self.storeDic objectForKey:@"store"] objectForKey:@"store_name"];
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
                logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 193)];
                [logoImageView setImageWithURL:[commonTools getImgURL:[[self.storeDic objectForKey:@"store"] objectForKey:@"store_logo"]] placeholderImage:[UIImage imageNamed:@"2_06"]];
                [cell addSubview:logoImageView];
                
                return cell;
            }
        } else {
            if (indexPath.row == 0) {
                
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse2"];
                
            slideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 40)];
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
                
                UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
                
                flowlayout.minimumInteritemSpacing = 1.0f;
                flowlayout.minimumLineSpacing = 1.0f;
                
                //            self.goodsListCollectionView = [[UICollectionView alloc] initWithFrame:DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT, 700 - 380) collectionViewLayout:flowlayout];
                if (self.goodsListArray.count > 0) {
                    self.goodsListCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, DWIDTH_CONTROLLER_DEFAULT*((215 + 10)/320.0)*(self.goodsListArray.count/2+(self.goodsListArray.count%2 > 0?1:0))) collectionViewLayout:flowlayout];
                }else{
                    self.goodsListCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT/320.0, DWIDTH_CONTROLLER_DEFAULT/320.0/5) collectionViewLayout:flowlayout];
                }
                
                self.goodsListCollectionView.backgroundColor = DColor_White;
                
                self.goodsListCollectionView.scrollEnabled = NO;
                
                self.goodsListCollectionView.delegate = self;
                self.goodsListCollectionView.dataSource = self;
                
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
        
        cell.textLabel.text = self.contents[indexPath.section - 1][1][2];
        
        return cell;
    } else {
        DGoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodslist"];
        if (indexPath.row < self.goodsListArray.count) {
            DGoodsListModel *goodsListModel = [self.goodsListArray objectAtIndex:indexPath.row];
            [cell.headImageView setImageWithURL:[NSURL URLWithString:[goodsListModel default_image]]];
            cell.titleLabel.text = [goodsListModel goods_name];
            cell.commintLabel.text = [NSString stringWithFormat:@"%.2lf%%好评",[[goodsListModel haoping] floatValue] * 100.0];
            NSMutableAttributedString *moneyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[goodsListModel price]]];
            [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(moneyString.length - 2, 2)];
            cell.moneyLabel.attributedText = moneyString;
            cell.commitNumberLabel.text = [NSString stringWithFormat:@"评论%@条",[goodsListModel comments]];
        }
        return cell;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"fenleiCell";
    UITableViewCell *fenleiCell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (fenleiCell == nil) {
        fenleiCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        fenleiCell.backgroundColor = DColor_f6f1ef;
    }
    [fenleiCell.textLabel setFont:DFont_14];
    [fenleiCell.textLabel setTextColor:DColor_666666];
    
    fenleiCell.textLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.row - 1][1][2]];
    
    return fenleiCell;
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
                    if (self.goodsListArray.count > 0) {
                        return (DWIDTH_CONTROLLER_DEFAULT*(215 + 10)/320)*(self.goodsListArray.count/2+(self.goodsListArray.count%2 > 0?1:0)) - 40 * page;
                }
            }
        }
    }else if ([tableView isEqual:self.selectTableView]) {
        return 44.0f;
    }
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == self.selectTableView) {
        SKSTableViewCell *cell = (SKSTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[SKSTableViewCell class]]){
            cateId = self.contents[indexPath.section - 1][1][1];
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:1.0f animations:^{
                self.selectView.frame = CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
                self.mView.hidden = YES;
            } completion:^(BOOL finished) {
                NSLog(@"FINISHED");
            }];
        }
    }
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.contents[indexPath.row - 1] count] - 1;
}

#pragma collectionView 方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DGoodsListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsList" forIndexPath:indexPath];
    DGoodsListModel *goodList = [self.goodsListArray objectAtIndex:indexPath.item];
    [cell.goodsImageView setImageWithURL:[NSURL URLWithString:[goodList default_image]]];
    cell.goodsName.text = [goodList goods_name];
    cell.moneyLabel.text = [NSString stringWithFormat:@"¥%@",[goodList price]];
    cell.commitLabel.text = [NSString stringWithFormat:@"评论%@条",[goodList comments]];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake((DWIDTH_CONTROLLER_DEFAULT / 320.0) * 5, (DWIDTH_CONTROLLER_DEFAULT / 320.0) * 8, (DWIDTH_CONTROLLER_DEFAULT / 320.0) * 5, (DWIDTH_CONTROLLER_DEFAULT / 320.0) * 8);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DWIDTH_CONTROLLER_DEFAULT / 320.0) * 150, (DWIDTH_CONTROLLER_DEFAULT / 320.0) * 215);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    DWebViewController *vc = [[DWebViewController alloc]init];
    DGoodsListModel *jFenModel = [self.goodsListArray objectAtIndex:indexPath.row];
    vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",jFenModel.goods_id,get_userId];
    vc.type = IS_NEED_ADD;
    vc.goodId = [NSString stringWithFormat:@"%@",jFenModel.goods_id];
    vc.imageUrl = [NSString stringWithFormat:@"%@",jFenModel.default_image];
    vc.googsTitle = [NSString stringWithFormat:@"%@",jFenModel.goods_name];
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
        [self loadingData:@""];
        twoFlag = NO;
        threeFlag = NO;
        fourFlag = NO;
        fiveFlag = NO;
        [self.oneBtn setTitleColor:DColor_c4291f forState:UIControlStateNormal];
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
            [self loadingData:@"sum_sales_asc"];
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
            [self loadingData:@"sum_sales_desc"];
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
            [self loadingData:@"haoping_asc"];
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
            [self loadingData:@"haoping_desc"];
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
            [self loadingData:@"price_asc"];
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
            [self loadingData:@"price_desc"];
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
            [self loadingData:@"add_time_asc"];
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
            [self loadingData:@"add_time_desc"];
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
- (void)loadingData:(NSString *)orderString{
    NSDictionary *parameter = @{@"order":orderString,@"storeId":[NSString stringWithFormat:@"%@",self.storeId],@"keywords":self.keywords,@"cateId":cateId};
    tempString = orderString;
    NSLog(@"111111%@",parameter);
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.list" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSArray *dataArr = [responseObject.result objectForKey:@"data"];
            self.goodsListArray = [NSMutableArray array];
            for (NSDictionary *dic in dataArr) {
                DGoodsListModel *goodsList = [[DGoodsListModel alloc] init];
                [goodsList setValuesForKeysWithDictionary:dic];
                [self.goodsListArray addObject:goodsList];
                self.goodsIDString = [NSString stringWithFormat:@"%@,%@",self.goodsIDString,[goodsList goods_id]];
            }
            self.goodsIDString = [self.goodsIDString substringWithRange:NSMakeRange(1, self.goodsIDString.length - 1)];
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *indesPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
            NSIndexPath *indesPath2 = [NSIndexPath indexPathForRow:1 inSection:1];
            NSArray *array = @[indesPath,indesPath1,indesPath2];
            [self.dMainTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
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

- (void)loadingStoreDetail{
#pragma 域名配置
    // 获取到数据之后，需要改
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Configs.domain" parameters:nil ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            dictionary = responseObject.result;
        }
        [self.dMainTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
    
    NSDictionary *parameter = @{@"storeId":self.storeId};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Stores.showUser" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            self.storeDic = responseObject.result;
            
            iscollect = [NSString stringWithFormat:@"%@",[self.storeDic objectForKey:@"iscollect"]];
            
            collectionString = [NSString stringWithFormat:@"%@",[self.storeDic objectForKey:@"collectCount"]];
            
            [self.dMainTableView reloadData];
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
#warning 需要修改一下商家ID
- (void)toRightNavButton:(id)sender{
    [self loadingData1:self.storeId];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 分类网络请求
- (void)loadingData1:(NSString *)storesString{
    NSDictionary *dic = @{@"storeId":storesString};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Stores.category" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            self.contents = [NSMutableArray array];
//            NSLog(@"result = %@",responseObject.result);
            NSDictionary *dic = responseObject.result;
            NSInteger number = 0;
            for (NSString *temp in responseObject.result) {
                secondArray = [dic objectForKey:temp];
                headArray = [NSMutableArray array];
                for (NSInteger i = 0; i < secondArray.count; i++) {
                    [headArray insertObject:temp atIndex:i];
                    [headArray insertObject:[secondArray objectAtIndex:i] atIndex:i+1];
                }
                [_contents insertObject:headArray atIndex:number++];
            }
//            NSLog(@"****************%@",[[[_contents objectAtIndex:1] objectAtIndex:1] objectAtIndex:2]);
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

//----------------------------------- 万恶的分割线 --------------------------------------

- (void)addData:(void (^)(BOOL finish))success
{
    NSDictionary *parameter = @{@"order":tempString,@"page":[NSString stringWithFormat:@"%ld",page+1],@"storeId":self.storeId,@"keywords":self.keywords,@"cateId":cateId};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.list" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"---------------%ld",page);
            NSLog(@"result = %@",responseObject.result);
            page = [[responseObject.result objectForKey:@"page"] intValue];
            NSArray *dataArr = [responseObject.result objectForKey:@"data"];
            for (NSDictionary *dic in dataArr) {
                DGoodsListModel *goodsList = [[DGoodsListModel alloc] init];
                goodsList = [JsonStringTransfer dictionary:dic ToModel:goodsList];
                [self.goodsListArray addObject:goodsList];
                self.goodsIDString = [NSString stringWithFormat:@"%@,%@",self.goodsIDString,[goodsList goods_id]];
            }
            
            self.goodsIDString = [self.goodsIDString substringWithRange:NSMakeRange(1, self.goodsIDString.length - 1)];
            
            if (dataArr.count == 0) {
                page -= 1;
            }
            
            if (self.goodsListArray.count < 10) {
                page -= 1;
            }
            
            if (dataArr.count < 10) {
                isEnd = YES;
            }
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *indesPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
            NSIndexPath *indesPath2 = [NSIndexPath indexPathForRow:1 inSection:1];
            NSArray *array = @[indesPath,indesPath1,indesPath2];
            [self.dMainTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
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
        _goodsListArray = nil;
        [self.dMainTableView reloadData];
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
    [self.goodsListArray removeAllObjects];
    self.goodsListArray = nil;
    self.goodsListArray = [[NSMutableArray alloc]init];
    page = 0;
    isEnd = NO;
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}

#pragma SearchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.keywords = searchBar.text;
    [self loadingData:@""];
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
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
        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[_contents objectAtIndex:btn.tag-1]] ;
        for (int i = 0; i < isFlagArr.count - 1; i++) {
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
            NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[_contents objectAtIndex:nowClose-1]] ;
            for (int i = 0; i < isFlagArr.count - 1; i++) {
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
        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[_contents objectAtIndex:btn.tag-1]] ;
        for (int i = 0; i < isFlagArr.count - 1; i++) {
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
            [arr addObject:indesPath];
        }
        
        UIImageView *imageV1 = (UIImageView *)[btn viewWithTag:2000+btn.tag];
        imageV1.transform = CGAffineTransformMakeRotation(M_PI);
        
        [self.selectTableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
        
    }
}
- (void)callback:(CallBackDWebViewController)block
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

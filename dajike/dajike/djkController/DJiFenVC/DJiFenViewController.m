//
//  DJiFenViewController.m
//  dajike
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

/*
 
 *  积分兑换首页
 
 */


#import "DJiFenViewController.h"
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
#import "DJFenModel.h"
#import "DWebViewController.h"
#import "SWBTabBar.h"

@interface DJiFenViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    BOOL twoFlag;
    BOOL threeFlag;
    BOOL fourFlag;
    BOOL fiveFlag;
    
//    NSInteger selectFlag;
    
    NSMutableArray *headArray;
    NSArray *secondArray;

    NSMutableDictionary     *_userInfoDic;
    UserInfoModel           *_userModel;
    AccountOverViewModel    *_accountModel;
    
    NSInteger page;
    NSString *sortString;
    NSString *sortTypeString;
    
    DJFenModel *collectCountJiFenModel;
    
    
    UIView *headV;
    DImgButton *leftBtn;
    CGRect _frame;
    UIView *slideView;
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

@property (nonatomic, strong) UITableView *headTableView;

@property (nonatomic, strong) NSMutableArray *jiFenListArray;

@property (nonatomic, strong) NSString *selectString;

@property (nonatomic, strong) NSString *goodsIDString;

@property (nonatomic, strong) NSString *keyword;
@end

@implementation DJiFenViewController

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
            [self.headTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeNavImg:@"img_mine_clear"];
//    [self setNaviBarTitle:@"我的"];
    [self.view setBackgroundColor:DColor_f3f3f3];
    [self.headerView setBackgroundColor:DColor_f3f3f3];
    
//    [self addTableView:YES];
    self.dMainTableView = [[UITableView alloc]initWithFrame:DRect(0, 64, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT-64-50-15) style:UITableViewStylePlain];
    self.dMainTableView.delegate = self;
    [self.view addSubview:self.dMainTableView];
    
    /*
    //添加无数据时的显示界面，正常情况下隐藏
    self.noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading_no_s"]];
    self.noDataView.contentMode = UIViewContentModeScaleAspectFit;
    [self.noDataView setFrame:CGRectMake(0, 0, self.dMainTableView.frame.size.width, self.dMainTableView.frame.size.height)];
    [self.dMainTableView addSubview:self.noDataView];
    [self.noDataView setHidden:YES];
//    [self.noDataView setFrame:CGRectMake(0, 0, self.dMainTableView.frame.size.width, 0)];
     */
    
    //  列表 cell 从头开始显示  需要实现一个代理方法
    if ([self.dMainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.dMainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self.dMainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.dMainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
#endif
    
    [self addHeaderAndFooter];

    
    self.dMainTableView.backgroundColor = [UIColor clearColor];
    self.dMainTableView.layer.borderColor = [[UIColor blueColor] CGColor];
//    [self.view addSubview:self.dMainTableView];
    
    CGRect frame = self.dMainTableView.frame;
    frame.size.height += frame.origin.y;
    frame.size.height += 64;
    frame.origin.y = 0;
    self.dMainTableView.frame = frame;
    self.dMainTableView.separatorColor = UITableViewCellSeparatorStyleNone;
    self.dMainTableView.showsVerticalScrollIndicator = NO;
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    self.dMainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.dMainTableView registerNib:[UINib nibWithNibName:@"DGoodsListTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodslist"];
    [self.dMainTableView reloadData];

    self.goodsIDString = @"";

    self.selectString = @"";

    self.keyword = @"";
    
    
    headV = [[UIView alloc]initWithFrame:CGRectMake(40, 25, 250, 25)];
    headV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 245, 25)];
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
    [self.view addSubview:headV];
    
    leftBtn = [[DImgButton alloc]initWithFrame:CGRectMake(10, 27, 25, 25)];
    [leftBtn addTarget:self action:@selector(toLeftNavButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 25)];
    leftImageV.layer.cornerRadius = 2.0;
    leftImageV.layer.masksToBounds = YES;
    [leftImageV setImage:[UIImage imageNamed:@"img_pub_02"]];
    leftImageV.contentMode = UIViewContentModeScaleAspectFit;
    [leftBtn addSubview:leftImageV];
    //    [self setNaviBarLeftBtn:leftBtn];
    [self.view addSubview:leftBtn];

//    _midLab = [[UILabel alloc]initWithFrame:CGRectMake((DWIDTH_CONTROLLER_DEFAULT-40)/2, 40, 40, 25)];
//    _midLab.textAlignment = NSTextAlignmentCenter;
//    [DTools setLable:_midLab Font:DFont_Navb titleColor:DColor_ffffff backColor:[UIColor clearColor]];
//    _midLab.text = @"我的";
//    [self.view addSubview:_midLab];
    
//    _leftBut = [[UIButton alloc]initWithFrame:CGRectMake(20, 40, 25, 25)];
//    _rightBut = [[UIButton alloc]initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT - 50, 40, 25, 25)];
//    [_leftBut setImage:[UIImage imageNamed:@"anquan_img_09.png"] forState:UIControlStateNormal];
//    [_rightBut setImage:[UIImage imageNamed:@"anquan_img_10.png"] forState:UIControlStateNormal];
//    [_leftBut addTarget:self action:@selector(navLeftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [_rightBut addTarget:self action:@selector(navRightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_leftBut];
//    [self.view addSubview:_rightBut];
    
    self.loginImg.layer.masksToBounds = YES;
    self.loginImg.backgroundColor = [UIColor whiteColor];
    self.loginImg.layer.cornerRadius = 42.0;
    self.loginImg.layer.borderColor = [[UIColor colorWithRed:212 green:192 blue:161 alpha:1]CGColor];
    self.loginImg.layer.borderWidth = 2.0;
    
//    [self.but_1 addTarget:self action:@selector(collectButAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.but_1.tag = 1;
//    [self.but_2 addTarget:self action:@selector(collectButAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.but_2.tag = 2;
    
    _frame = self.headerBackImg.frame;
    _frame.size.width = DWIDTH_CONTROLLER_DEFAULT;
    self.headerBackImg.frame = _frame;
    [self loadingData:@"" sortType:@""];
}

- (void)viewWillDisappear:(BOOL)animated{
    SWBTabBarController *tabBarC = [SWBTabBarController sharedManager];
    [tabBarC.myView setHidden:NO];
}

#pragma tableView delegate 的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    for (UISearchBar *searchBar in headV.subviews) {
//        [searchBar endEditing:YES];
//        searchBar.showsCancelButton = NO;
////        searchBar.text = @"";
////        self.keyword = searchBar.text;
////        [self loadingData:@"" sortType:@""];
//    }
    if (scrollView.contentOffset.y < 0) {
        headV.hidden = NO;
        leftBtn.hidden = NO;
//        _midLab.hidden = NO;
        
        CGRect frame_1 = _frame;
        frame_1.size.height -= scrollView.contentOffset.y;
        frame_1.size.width -= frame_1.size.width*scrollView.contentOffset.y/_frame.size.height;
        frame_1.origin.x += (_frame.size.width -frame_1.size.width)/2;
        frame_1.origin.y += scrollView.contentOffset.y;
        self.headerBackImg.frame = frame_1;
        
    }else if (scrollView.contentOffset.y > 20){
        headV.hidden = YES;
        leftBtn.hidden = YES;
//        _midLab.hidden = YES;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSLog(@"height:%f",self.headerView.frame.size.height);
        return self.headerView.frame.size.height;
    }else{
        return 40.0;
    }

    return 0.5f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.jiFenListArray.count == 0) {
            return DHEIGHT_CONTROLLER_DEFAULT-297.0;
        }
    }
    
    return 0.5f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(tableView == self.headTableView){
//        return 2;
//    }
    if (section == 0) {
        return 0;
    }
//    if (self.jiFenListArray.count == 0) {
////        [self.dMainTableView.tableFooterView setHidden:NO];
//        [self.noDataView setFrame:CGRectMake(0, 0, self.dMainTableView.frame.size.width, self.dMainTableView.frame.size.height-297)];
////        self.dMainTableView.tableFooterView = self.noDataView;
//    }else{
////        [self.dMainTableView.tableFooterView setHidden:YES];
//        [self.noDataView  setFrame:CGRectMake(0, 0, self.dMainTableView.frame.size.width, 0)];
////        self.dMainTableView.tableFooterView = self.noDataView;
//    }
    return self.jiFenListArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        [DTools setLable:self.lab_1 Font:DFont_12 titleColor:DColor_ffffff backColor:[UIColor clearColor]];
        [DTools setLable:self.lab_2 Font:DFont_12 titleColor:DColor_ffffff backColor:[UIColor clearColor]];
        
        NSURL *imgUrl = [commonTools getImgURL:_userModel.portrait];
        [self.loginImg setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"nan.png"]];
        self.lab_1.text = _userModel.userName;
        self.lab_2.text = [NSString stringWithFormat:@"我的积分: %@",_accountModel.jifen];
        return self.headerView;
    }else{
        if (slideView == nil) {
            slideView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, DWIDTH_CONTROLLER_DEFAULT, 40)];
            slideView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.65];
#pragma 选择按钮
            
            self.oneBtn = [[DImgButton alloc] initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
            [self.oneBtn setTitle:@"默认" forState:UIControlStateNormal];
            self.oneBtn.titleLabel.font = DFont_12;
            [self.oneBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.oneBtn setTitleColor:DColor_c4291f forState:UIControlStateNormal];
            [slideView addSubview:self.oneBtn];
            
            self.twoBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
            [self.twoBtn setTitle:@"销量" forState:UIControlStateNormal];
            self.twoBtn.titleLabel.font = DFont_12;
            [self.twoBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.twoBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
            self.twoImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 10, 15, 10, 10)];
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
            self.threeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 10, 15, 10, 10)];
            self.threeImageV.layer.cornerRadius = 2.0;
            self.threeImageV.layer.masksToBounds = YES;
            [self.threeImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
            self.threeImageV.contentMode = UIViewContentModeScaleAspectFit;
            [self.threeBtn addSubview:self.threeImageV];
            [slideView addSubview:self.threeBtn];
            
            threeFlag = NO;
            
            self.fourBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.threeBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
            [self.fourBtn setTitle:@"积分" forState:UIControlStateNormal];
            self.fourBtn.titleLabel.font = DFont_12;
            [self.fourBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.fourBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
            self.fourImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 10, 15, 10, 10)];
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
        }
        

        return slideView;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.jiFenListArray.count == 0) {
            UIImageView *nodataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT-297)];
            [nodataImageView setImage:[UIImage imageNamed:@"loading_no_s"]];
            [nodataImageView setContentMode:UIViewContentModeScaleAspectFit];
            return nodataImageView;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView == self.headTableView){
//        if (indexPath.row == 0) {
//            DJiFenTableViewCell *cell = [DTools loadTableViewCell:self.headTableView cellClass:[DJiFenTableViewCell class]];
//            cell.userInteractionEnabled = NO;
//            cell.backgroundColor= [UIColor clearColor];
//            cell.backgroundView = nil;
////            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_jf_08"]];
//            NSURL *imgUrl = [commonTools getImgURL:_userModel.portrait];
//            [cell.rectImageView setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"nan.png"]];
//            return cell;
//        }else {
//            DMyJiFenTableViewCell *cell = [DTools loadTableViewCell:self.headTableView cellClass:[DMyJiFenTableViewCell class]];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            cell.backgroundColor= [UIColor clearColor];
//            cell.backgroundView = nil;
//            if ([FileOperation isLogin]) {
//                cell.nameLabel.text = _userModel.userName;
//                cell.numberLabel.text = [NSString stringWithFormat:@"我的积分: %@",_accountModel.jifen];
//            }else{
//                cell.nameLabel.text = @"未命名";
//                cell.numberLabel.text = [NSString stringWithFormat:@"我的积分: %d",0];
//            }
//            return cell;
//        }
//    } else {
//        DGoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodslist"];
//        if (indexPath.row < self.jiFenListArray.count) {
//            DJFenModel *jFenModel = [self.jiFenListArray objectAtIndex:indexPath.row];
//            [cell.headImageView setImageWithURL:[NSURL URLWithString:[jFenModel default_image]]];
//            cell.titleLabel.text = [jFenModel goods_name];
//            cell.moneyLabel.hidden = YES;
//            cell.commintLabel.text = [NSString stringWithFormat:@"%@%%好评",[jFenModel goodcommentrate]];
//            NSMutableAttributedString *moneyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@.00 积分",[jFenModel if_jifen]]];
//            [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(moneyString.length - 2, 2)];
//            [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, moneyString.length - 2)];
//            cell.logoLabel.attributedText = moneyString;
//            cell.commitNumberLabel.text = [NSString stringWithFormat:@"评论%@条",[jFenModel comments]];
//        }
//        return cell;
//    }
    
    DGoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodslist"];
    if (indexPath.row < self.jiFenListArray.count) {
        DJFenModel *jFenModel = [self.jiFenListArray objectAtIndex:indexPath.row];
        [cell.headImageView setImageWithURL:[NSURL URLWithString:[jFenModel default_image]]];
        cell.titleLabel.text = [jFenModel goods_name];
        cell.moneyLabel.hidden = YES;
        cell.commintLabel.text = [NSString stringWithFormat:@"%@%%好评",[jFenModel goodcommentrate]];
        NSMutableAttributedString *moneyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 积分",[jFenModel if_jifen]]];
        [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(moneyString.length - 2, 2)];
        [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, moneyString.length - 2)];
        cell.logoLabel.attributedText = moneyString;
        cell.commitNumberLabel.text = [NSString stringWithFormat:@"评论%@条",[jFenModel comments]];
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView == self.headTableView){
//        if (indexPath.row == 0) {
//            return 147;
//        }else if (indexPath.row == 1){
//            return 53;
//        }
//    }
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (!(tableView == self.headTableView)) {
//        DWebViewController *vc = [[DWebViewController alloc]init];
//        DJFenModel *jFenModel = [self.jiFenListArray objectAtIndex:indexPath.row];
//        vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",jFenModel.goods_id,get_userId];
//        vc.isHelp = 6;
//        push(vc);
//    }
    DWebViewController *vc = [[DWebViewController alloc]init];
    DJFenModel *jFenModel = [self.jiFenListArray objectAtIndex:indexPath.row];
    vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",jFenModel.goods_id,get_userId];
    vc.type = IS_NEED_ADD;
    vc.goodId = [NSString stringWithFormat:@"%@",jFenModel.goods_id];
    vc.imageUrl = [NSString stringWithFormat:@"%@",jFenModel.default_image];
    vc.googsTitle = [NSString stringWithFormat:@"%@",jFenModel.goods_name];
    vc.isHelp = 6;
    vc.sjORjf = JIFEN;
    push(vc);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.headTableView){
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
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
//            fourFlag = YES;
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
    NSDictionary *parameter = @{@"keyword":self.keyword,@"sort":sortStr,@"descAsc":sortType};
    sortString = sortStr;
    sortTypeString = sortType;
    NSLog(@"111111%@",parameter);
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Jifens.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSArray *array = responseObject.result;
            self.jiFenListArray = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                DJFenModel *jFen = [[DJFenModel alloc] init];
                jFen = [JsonStringTransfer dictionary:dic ToModel:jFen];
                NSLog(@"%@",jFen.goods_name);
                if (jFen.goods_name == nil){
                    collectCountJiFenModel = jFen;
                } else {
                    [self.jiFenListArray addObject:jFen];
                }
            }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//----------------------------------- 万恶的分割线 --------------------------------------

- (void)addData:(void (^)(BOOL finish))success
{
    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%ld",page+1],@"keyword":self.keyword,@"sort":sortString,@"descAsc":sortTypeString};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Jifens.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"---------------%ld",page);
            NSLog(@"result = %@",responseObject.result);
            page = page + 1;
            NSArray *dataArr = responseObject.result;
            for (NSDictionary *dic in dataArr) {
                DJFenModel *jFen = [[DJFenModel alloc] init];
                [jFen setValuesForKeysWithDictionary:dic];
                [self.jiFenListArray addObject:jFen];
            }
            self.goodsIDString = [self.goodsIDString substringWithRange:NSMakeRange(1, self.goodsIDString.length - 1)];
            
            if (self.jiFenListArray.count < 10) {
                isEnd = YES;
            }
            [self.dMainTableView reloadData];
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
        _jiFenListArray = nil;
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
        [ProgressHUD showMessage:@"加载完成" Width:280 High:10];
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
    [self.jiFenListArray removeAllObjects];
    self.jiFenListArray = nil;
    self.jiFenListArray = [[NSMutableArray alloc]init];
    page = 0;
    isEnd = NO;
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}

#pragma SearchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.keyword = searchBar.text;
    [self loadingData:@"" sortType:@""];
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
    self.keyword = searchBar.text;
    [self loadingData:@"" sortType:@""];
    
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

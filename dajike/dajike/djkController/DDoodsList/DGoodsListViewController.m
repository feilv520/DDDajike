//
//  DGoodsListViewController.m
//  dajike
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

/*
 
 *     商品列表
 
 */

#import "DGoodsListViewController.h"
#import "dDefine.h"
#import "DGoodsListTableViewCell.h"
#import "DGoodsListBlurView.h"
//#import "SKSTableView.h"
//#import "SKSTableViewCell.h"
#import "DGoodsListCollectionViewCell.h"
#import "DGoodsListModel.h"
#import "SWBTabBarController.h"
#import "DGoodsListSelectTableViewCell.h"
#import "DWebViewController.h"
#import "SWBTabBar.h"

@interface DGoodsListViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate>{
    BOOL twoFlag;
    BOOL threeFlag;
    BOOL fourFlag;
    
    BOOL selectFlag;
    
    NSMutableArray *headArray;
    NSArray *secondArray;
    NSMutableArray *shaixuanArr;
    
    NSIndexPath *selectIndexPath;
    
    //商品列表参数
    NSString *attrIds;
    NSString *attrValues;
    NSString *order;
    NSString *storeId;
    NSInteger page;
    
    //首次进入，显示加载动画
    BOOL isFirst;
    
    //搜索框
    UISearchBar *dSearchBar;
    
    NSIndexPath *clickIndexPath;
    
    NSInteger fNowOpen;
    
    NSInteger clickFlag;
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

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIView *mView;

@property (nonatomic, strong) DGoodsListBlurView *blurView;

@property (nonatomic, strong) UITableView *selectTableView;

@property (nonatomic, strong) NSMutableArray *contents;

@property (nonatomic, strong) UICollectionView *goodsListCollectionView;

@property (nonatomic, strong) NSMutableArray *goodsListArray;

@property (nonatomic, strong) NSString *selectString;

//@property (nonatomic, strong) NSString *goodsIDString;



@end

@implementation DGoodsListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectFlag = NO;
    
    clickFlag = 1000;
    fNowOpen = 1000;
    
//    self.goodsIDString = @"";
    
    self.selectString = @"";
    
    if (self.keyWords == nil) {
        self.keyWords = @"";
    }
    if (self.cateId == nil) {
        self.cateId = @"";
    }
    
    attrIds = @"";
    storeId = @"";
    page = 0;
    attrValues = @"";
    isFirst = YES;
    self.selectString = @"";
    
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(-15, 0, 250+5, 44)];
    dSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-30, 0, 250-5, 41)];
    dSearchBar.delegate = self;
    
    for (UIView *view in dSearchBar.subviews) {
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
    
    dSearchBar.placeholder = @"请输入商品/店铺";
    if (![self.keyWords isEqualToString:@""]) {
        dSearchBar.text = self.keyWords;
    }
    [headV addSubview:dSearchBar];
    [self naviBarAddCoverViewOnTitleView:headV];
    
    DImgButton *leftBtn = [[DImgButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [leftBtn addTarget:self action:@selector(toLeftNavButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 19, 25)];
    leftImageV.layer.cornerRadius = 2.0;
    leftImageV.layer.masksToBounds = YES;
    [leftImageV setImage:[UIImage imageNamed:@"img_pub_02"]];
    leftImageV.contentMode = UIViewContentModeScaleAspectFit;
    [leftBtn addSubview:leftImageV];
    [self setNaviBarLeftBtn:leftBtn];
    
    DImgButton *rightBtn = [[DImgButton alloc]initWithFrame:CGRectMake(30, 10, 20, 20)];
    [rightBtn addTarget:self action:@selector(toRightNavButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 20, 20)];
    rightImageV.layer.cornerRadius = 2.0;
    rightImageV.layer.masksToBounds = YES;
    [rightImageV setImage:[UIImage imageNamed:@"pay_img_03"]];
    rightImageV.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addSubview:rightImageV];
    [self setNaviBarRightBtn:rightBtn];
    
    UIView *slideView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DWIDTH_CONTROLLER_DEFAULT, 40)];
    [self.view addSubview:slideView];
    slideView.backgroundColor = DColor_White;
    
#pragma 选择按钮
    
    self.oneBtn = [[DImgButton alloc] initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
    [self.oneBtn setTitle:@"默认" forState:UIControlStateNormal];
    self.oneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.oneBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.oneBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
    [slideView addSubview:self.oneBtn];
    
    self.twoBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
    [self.twoBtn setTitle:@"销量" forState:UIControlStateNormal];
    self.twoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.twoBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.twoBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
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
    self.threeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.threeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.threeBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    self.threeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 10, 15, 10, 10)];
    self.threeImageV.layer.cornerRadius = 2.0;
    self.threeImageV.layer.masksToBounds = YES;
    [self.threeImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    self.threeImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.threeBtn addSubview:self.threeImageV];
    [slideView addSubview:self.threeBtn];
    
    threeFlag = NO;
    
    self.fourBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.threeBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
    [self.fourBtn setTitle:@"价格" forState:UIControlStateNormal];
    self.fourBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.fourBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fourBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    self.fourImageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.oneBtn.frame) - 10, 15, 10, 10)];
    self.fourImageV.layer.cornerRadius = 2.0;
    self.fourImageV.layer.masksToBounds = YES;
    [self.fourImageV setImage:[UIImage imageNamed:@"img_pub_gray"]];
    self.fourImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.fourBtn addSubview:self.fourImageV];
    [slideView addSubview:self.fourBtn];
    
    fourFlag = NO;
    
    self.fiveBtn = [[DImgButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fourBtn.frame), 0, DWIDTH_CONTROLLER_DEFAULT / 5, 40)];
    [self.fiveBtn setTitle:@"筛选" forState:UIControlStateNormal];
    self.fiveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.fiveBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fiveBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [slideView addSubview:self.fiveBtn];
    
#pragma tableView
    
    [self addTableView:YES];
    [self.dMainTableView setFrame:DRect(0, 104, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT - 104)];
    
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    
    [self.dMainTableView registerNib:[UINib nibWithNibName:@"DGoodsListTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodslist"];

#pragma collectionView
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowlayout.minimumInteritemSpacing = 1.0f;
    flowlayout.minimumLineSpacing = 1.0f;
    
    self.goodsListCollectionView = [[UICollectionView alloc] initWithFrame:DRect(0, 104, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT - 104) collectionViewLayout:flowlayout];
    
    self.goodsListCollectionView.backgroundColor = DColor_f7f7f7;
    
    self.goodsListCollectionView.delegate = self;
    self.goodsListCollectionView.dataSource = self;
    
    [self.goodsListCollectionView registerNib:[UINib nibWithNibName:@"DGoodsListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"goodsList"];
    
    [self.view addSubview:self.goodsListCollectionView];
    [self addCollectHeaderAndFooter];
    
    self.goodsListCollectionView.hidden = YES;
    
#pragma 筛选
    
    self.selectView = [[UIView alloc] initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT - 105, DHEIGHT_CONTROLLER_DEFAULT)];
    self.selectView.backgroundColor = DColor_ffffff;
    
    [self.view addSubview:self.selectView];
    
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.selectView.frame.size.width, DHEIGHT_CONTROLLER_DEFAULT - 64) style:UITableViewStyleGrouped];
    
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    
    self.selectTableView.backgroundColor = DColor_White;
    
    [self.selectTableView registerNib:[UINib nibWithNibName:@"DGoodsListSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"select"];
    
    [self.selectView addSubview:self.selectTableView];
    
    self.cancelBtn = [[DImgButton alloc] initWithFrame:CGRectMake(0, 22, 50, 40)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cancelBtn addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.selectView addSubview:self.cancelBtn];
    
    self.successBtn = [[DImgButton alloc] initWithFrame:CGRectMake(self.selectView.frame.size.width - 50, 22, 50, 40)];
    [self.successBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.successBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.successBtn addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.successBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.selectView addSubview:self.successBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + 38, 22, 100, 30)];
    self.titleLabel.text = @"筛选";
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textColor = DColor_word_bg;
    [self.selectView addSubview:self.titleLabel];
    order = @"";
    [self refreshData:^(BOOL finish) {
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    SWBTabBarController *tabBarC = [SWBTabBarController sharedManager];
    [tabBarC.myView setHidden:YES];
    
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    SWBTabBarController *tabBarC = [SWBTabBarController sharedManager];
    [tabBarC.myView setHidden:NO];
    
    //动画效果消失
    if([DMyAfHTTPClient sharedClient].indicator.animatCount)
        [DMyAfHTTPClient sharedClient].indicator.animatCount = 0;
    [[DMyAfHTTPClient sharedClient].indicator progresshHUDRemovedFast];
}
#pragma mark----加载下拉刷新和上拉加载
//加载下拉刷新和上拉加载
- (void) addCollectHeaderAndFooter
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header1 = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self refreshData:^(BOOL finish) {
            [self.goodsListCollectionView.header endRefreshing];
        }];
    }];
    //设置图片
    [header1 prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:@"1.png"];
    [idleImages addObject:image];
    UIImage *image1 = [UIImage imageNamed:@"2.png"];
    [idleImages addObject:image1];
    [header1 setImages:idleImages forState:MJRefreshStateIdle];
    
    [header1 setImages:idleImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [header1 setImages:idleImages forState:MJRefreshStateRefreshing];
    
    // 隐藏时间
    header1.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header1.stateLabel.hidden = YES;
    
    self.goodsListCollectionView.header = header1;
    //    [self.header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshBackNormalFooter *footer1 = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData:^(BOOL finish) {
            [self.goodsListCollectionView.footer endRefreshing];
            if (isEnd == YES) {
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [self.goodsListCollectionView.footer noticeNoMoreData];
                //                                [self.footer setState:MJRefreshStateLoadIngEnd];
                //                                self.footer.statusLabel.text = @"内容全部加载完毕";
            }
        }];
    }];
    // 设置文字
    [footer1 setTitle:@"下拉加载刷新" forState:MJRefreshStateIdle];
    [footer1 setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [footer1 setTitle:@"全部加载完毕" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer1.stateLabel.font = [UIFont systemFontOfSize:17];
    
    // 设置颜色
    footer1.stateLabel.textColor = [UIColor grayColor];
    
    self.goodsListCollectionView.footer = footer1;
    //    [self.footer beginRefreshing];
    
}


#pragma 取消和完成动作
- (void)selectButtonAction:(DImgButton *)btn{
    if (btn == self.cancelBtn) {
        [UIView animateWithDuration:0.5f  animations:^{
            self.selectView.frame = CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
            self.mView.hidden = YES;
        } completion:^(BOOL finished) {
            fNowOpen = 1000;
            NSLog(@"FINISHED");
        }];
    } else if(btn == self.successBtn){
//        [self.oneBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
//        [self.fiveBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
        [self buttonAction:self.oneBtn];
        
        attrIds = @"";
        for (int i = 0; i < shaixuanArr.count; i++) {
            NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:i]objectForKey:@"isFlag"]] ;
            BOOL hasSelected = NO;
            for (int j = 0; j < isFlagArr.count; j++) {
                BOOL isflag = [[isFlagArr objectAtIndex:j]boolValue];
                if (isflag == YES) {
                    hasSelected = YES;
                }
            }
            if (hasSelected == YES) {
                if ([attrIds isEqualToString:@""]) {
                    attrIds = [NSString stringWithFormat:@"%@",[[shaixuanArr objectAtIndex:i]objectForKey:@"attr_id"]];
                }else{
                    attrIds = [attrIds stringByAppendingString:[NSString stringWithFormat:@",%@",[[shaixuanArr objectAtIndex:i]objectForKey:@"attr_id"]]];
                }
            }
        }
        [self refreshData:^(BOOL finish) {
        }];

        [UIView animateWithDuration:0.5f  animations:^{
            self.selectView.frame = CGRectMake(DWIDTH_CONTROLLER_DEFAULT, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT);
            self.mView.hidden = YES;
            
        } completion:^(BOOL finished) {
//            [self refreshData:^(BOOL finish) {
//            }];
//            self.selectString = @"";
            fNowOpen = 1000;
//            clickFlag = 1000;
//            [self.selectTableView reloadData];
        }];
    }
}

#pragma tableView delegate 的方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.selectTableView]) {
//        if (_contents.count > 0) {
//            return _contents.count;
//        }
//        return 0;
        if (shaixuanArr.count > 0) {
            return shaixuanArr.count;
        }
        return 0;
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
            if (shaixuanArr.count > section) {
                return [[[shaixuanArr objectAtIndex:section]objectForKey:@"def_value"] count];
            }
            return  0;
        }
        return 0;
    } else if (self.dMainTableView == tableView){
        if (self.goodsListArray.count == 0) {
            [self.noDataView setHidden:NO];
        }else{
            [self.noDataView setHidden:YES];
        }
        return self.goodsListArray.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.selectTableView]) {
//        UIView *bV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//        bV.backgroundColor = DColor_cccccc;
//        
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, 320, 39.5)];
//        btn.backgroundColor = [UIColor whiteColor];
//        btn.tag = section;
//        [btn addTarget:self action:@selector(toFenleiBtns:) forControlEvents:UIControlEventTouchUpInside];
//        [bV addSubview:btn];
//        
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 170, 39.5)];
//        [label setFont:DFont_12];
//        [label setTextColor:DColor_666666];
//        //    label.tag = 2000+section;
//        label.text = [NSString stringWithFormat:@"%@",[[_contents objectAtIndex:section] objectAtIndex:0]];
//        
//        if (section == clickFlag) {
//            if ([self.selectString hasPrefix:@","]) {
//                self.selectString = [self.selectString substringWithRange:NSMakeRange(1, self.selectString.length - 1)];
//            }
//            
//            NSLog(@"%@",self.selectString);
//            if (![self.selectString isEqualToString:@""]) {
//                label.text = [NSString stringWithFormat:@"%@(%@)",label.text,self.selectString];
//            }
//        }
//        [btn addSubview:label];
//        
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(180, 13, 13, 7)];
//        [imageView setTag:2000+section];
//        [imageView setImage:[UIImage imageNamed:@"img_pub_gray"]];
//        [btn addSubview:imageView];
//        
//        if (section == clickFlag){
//            imageView.transform = CGAffineTransformMakeRotation(M_PI);
//            NSLog(@"%ld",clickFlag);
//        }
//        return bV;
        
        UIView *bV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        bV.backgroundColor = DColor_cccccc;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, 320, 39)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = section;
        [btn addTarget:self action:@selector(toFenleiBtns:) forControlEvents:UIControlEventTouchUpInside];
        [bV addSubview:btn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 170, 39)];
        [label setFont:DFont_12];
        [label setTextColor:DColor_666666];
        //    label.tag = 2000+section;
        label.text = [NSString stringWithFormat:@"%@",[[shaixuanArr objectAtIndex:section]objectForKey:@"attr_name"]];
        NSString *selectAttrStr = [NSString stringWithFormat:@"%@",[[shaixuanArr objectAtIndex:section] objectForKey:@"selectAttr"]];
        if ([selectAttrStr isEqualToString:@""]) {
            label.text = [NSString stringWithFormat:@"%@",label.text];
        }else{
            label.text = [NSString stringWithFormat:@"%@(%@)",label.text,selectAttrStr];
        }
        [btn addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(180, 13, 13, 7)];
        [imageView setTag:2000+section];
        [imageView setImage:[UIImage imageNamed:@"img_pub_gray"]];
        [btn addSubview:imageView];
        
        return bV;

    }else{
        return nil;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.selectTableView) {

//        DGoodsListSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"select"];
//        
//        cell.contentView.backgroundColor = DColor_mainRed;
//        
//        cell.nameLabel.text = [NSString stringWithFormat:@"%@", [self.contents[indexPath.section] objectAtIndex:indexPath.row + 1]];
//        
//        return cell;
        
        NSString *stridentifer = @"select";
        [self.selectTableView registerNib:[UINib nibWithNibName:@"DGoodsListSelectTableViewCell" bundle:nil] forCellReuseIdentifier:stridentifer];
        DGoodsListSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stridentifer];
        NSLog(@"shaixuanArr = %@",shaixuanArr);
        if (shaixuanArr.count > indexPath.section) {
            NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:indexPath.section]objectForKey:@"isFlag"]] ;
            if (isFlagArr.count > indexPath.row) {
                BOOL isflag = [[isFlagArr objectAtIndex:indexPath.row]boolValue];
                if (isflag) {
                    [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_02"]];
                }else{
                    [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_01"]];
                }
                cell.nameLabel.text = [NSString stringWithFormat:@"%@",[[[shaixuanArr objectAtIndex:indexPath.section]objectForKey:@"def_value"] objectAtIndex:indexPath.row]];
            }
            
            cell.contentView.backgroundColor = DColor_mainRed;
            //    cell.nameLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.row][indexPath.subRow]];
        }
        return cell;

    } else {
        DGoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodslist"];
        if (indexPath.row < self.goodsListArray.count){
            DGoodsListModel *goodsListModel = [self.goodsListArray objectAtIndex:indexPath.row];
            [cell.headImageView setImageWithURL:[NSURL URLWithString:[goodsListModel default_image]]];
            cell.titleLabel.text = [goodsListModel goods_name];
            cell.commintLabel.text = [NSString stringWithFormat:@"%.2lf%%好评",[[goodsListModel haoping] floatValue] * 100.0];
            NSMutableAttributedString *moneyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[goodsListModel price]]];
            if (moneyString.length < 2)
                [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(moneyString.length - 1, 1)];
            else
                [moneyString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(moneyString.length - 2, 2)];
            cell.moneyLabel.attributedText = moneyString;
            cell.commitNumberLabel.text = [NSString stringWithFormat:@"评论%@条",[goodsListModel comments]];
        }
        return cell;
    }
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DGoodsListSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"select"];
//    
//    cell.contentView.backgroundColor = DColor_mainRed;
//    
//    cell.nameLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.row][indexPath.subRow]];
//    
//    return cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.selectTableView]) {
        return 44.0f;
    }
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == self.selectTableView) {
//        DGoodsListSelectTableViewCell *cell = (DGoodsListSelectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        if ([cell isKindOfClass:[DGoodsListSelectTableViewCell class]]){
//            if (cell.flag) {
//                self.selectString = [self.selectString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%@",cell.nameLabel.text] withString:@""];
//                if (![self.selectString hasPrefix:@","] && ![self.selectString hasSuffix:@","]) {
//                    self.selectString = [self.selectString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",cell.nameLabel.text] withString:@""];
//                }
//                if ([self.selectString hasSuffix:@","]) {
//                    self.selectString = [self.selectString substringWithRange:NSMakeRange(1, self.selectString.length - 1)];
//                }
//                [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_01"]];
//                cell.flag = NO;
//            } else {
//                if ([self.selectString isEqualToString:@""]) {
//                    self.selectString = [NSString stringWithFormat:@"%@",cell.nameLabel.text];
//                } else {
//                    self.selectString = [NSString stringWithFormat:@"%@,%@",self.selectString,cell.nameLabel.text];
//                }
//                [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_02"]];
//                cell.flag = YES;
//            }
//            [self.selectTableView reloadData];
        
        DGoodsListSelectTableViewCell *cell = (DGoodsListSelectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"shaixuanArr%@",shaixuanArr);
        NSLog(@"indexPath.row%d",indexPath.row);
        if ([cell isKindOfClass:[DGoodsListSelectTableViewCell class]]){
            NSString *selectAttrStr = [NSString stringWithFormat:@"%@",[[shaixuanArr objectAtIndex:indexPath.section] objectForKey:@"selectAttr"]];
            
            NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:indexPath.section]objectForKey:@"isFlag"]] ;
            BOOL isflag = [[isFlagArr objectAtIndex:indexPath.row]boolValue];
            if (isflag) {
                selectAttrStr = [selectAttrStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%@",cell.nameLabel.text] withString:@""];
                
                if (![selectAttrStr hasPrefix:@","] && ![selectAttrStr hasSuffix:@","]) {
                    selectAttrStr = [selectAttrStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",cell.nameLabel.text] withString:@""];
                }
                if ([selectAttrStr hasSuffix:@","]) {
                    selectAttrStr = [selectAttrStr substringWithRange:NSMakeRange(0, selectAttrStr.length - 1)];
                }
                if ([selectAttrStr hasPrefix:@","]) {
                    selectAttrStr = [selectAttrStr substringWithRange:NSMakeRange(1, selectAttrStr.length - 1)];
                }
                [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_01"]];
                isflag = NO;
            } else {
                if ([selectAttrStr isEqualToString:@""]) {
                    selectAttrStr = [NSString stringWithFormat:@"%@",cell.nameLabel.text];
                } else {
                    selectAttrStr = [NSString stringWithFormat:@"%@,%@",selectAttrStr,cell.nameLabel.text];
                }
                [cell.selectImageView setImage:[UIImage imageNamed:@"shaixuan_img_02"]];
                isflag = YES;
            }
            [isFlagArr replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%hhd",isflag]];
            NSMutableDictionary *shaixuanDic = [shaixuanArr objectAtIndex:indexPath.section];
            [shaixuanDic setObject:isFlagArr forKey:@"isFlag"];
            [shaixuanDic setObject:selectAttrStr forKey:@"selectAttr"];
            [shaixuanArr replaceObjectAtIndex:indexPath.section withObject:shaixuanDic];
            [self.selectTableView reloadData];
        }
    }else
    {
        DWebViewController *vc = [[DWebViewController alloc]init];
        DGoodsListModel *goodsListModel = [self.goodsListArray objectAtIndex:indexPath.row];
        vc.type = IS_NEED_ADD;
        vc.goodId = [NSString stringWithFormat:@"%@",goodsListModel.goods_id];
        vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",goodsListModel.goods_id,get_userId];
        vc.imageUrl = [NSString stringWithFormat:@"%@",goodsListModel.default_image];
        vc.googsTitle = [NSString stringWithFormat:@"%@",goodsListModel.goods_name];
        vc.isHelp = 6;
        push(vc);
    }
}

//- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.contents[indexPath.row] count] - 1;
//}

#pragma collectionView 方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // 设置尾部控件的显示和隐藏
    self.goodsListCollectionView.footer.hidden = self.goodsListArray.count == 0;
    if (self.goodsListArray.count == 0) {
        [self.noDataView setHidden:NO];
    }else{
        [self.noDataView setHidden:YES];
    }
    return self.goodsListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DGoodsListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsList" forIndexPath:indexPath];
    if (self.goodsListArray.count > indexPath.item){
        DGoodsListModel *goodList = [self.goodsListArray objectAtIndex:indexPath.item];
        [cell.goodsImageView setImageWithURL:[NSURL URLWithString:[goodList default_image]]];
        cell.goodsName.text = [goodList goods_name];
        cell.moneyLabel.text = [NSString stringWithFormat:@"¥%@",goodList.price];
        cell.commitLabel.text = [NSString stringWithFormat:@"评论%@条",goodList.comments];
    }
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    return UIEdgeInsetsMake((DWIDTH_CONTROLLER_DEFAULT/320.0)*5, (DWIDTH_CONTROLLER_DEFAULT/320.0)*8, (DWIDTH_CONTROLLER_DEFAULT/320.0)*5, (DWIDTH_CONTROLLER_DEFAULT/320.0)*8);
    return UIEdgeInsetsMake((DWIDTH_CONTROLLER_DEFAULT/320.0)*0, (DWIDTH_CONTROLLER_DEFAULT/320.0)*0, (DWIDTH_CONTROLLER_DEFAULT/320.0)*0, (DWIDTH_CONTROLLER_DEFAULT/320.0)*0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake((DWIDTH_CONTROLLER_DEFAULT/320.0)*150, (DWIDTH_CONTROLLER_DEFAULT/320.0)*186);
    return CGSizeMake((DWIDTH_CONTROLLER_DEFAULT/320.0)*157.0, (DWIDTH_CONTROLLER_DEFAULT/320.0)*(215.0));
}
//每个cell之间的间距
- (CGFloat)minimumInteritemSpacing {
    return 6.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",indexPath.item);
    DWebViewController *vc = [[DWebViewController alloc]init];
    DGoodsListModel *goodsListModel = [self.goodsListArray objectAtIndex:indexPath.row];
    vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",goodsListModel.goods_id,get_userId];
    vc.type = IS_NEED_ADD;
    vc.goodId = [NSString stringWithFormat:@"%@",goodsListModel.goods_id];
    vc.imageUrl = [NSString stringWithFormat:@"%@",goodsListModel.default_image];
    vc.googsTitle = [NSString stringWithFormat:@"%@",goodsListModel.goods_name];
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
    if (btn == self.oneBtn) {
        order = @"";
        twoFlag = NO;
        threeFlag = NO;
        fourFlag = NO;
        [self refreshData:^(BOOL finish) {
        }];
        [self.oneBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.twoImageV.transform = CGAffineTransformMakeRotation(0);
            self.threeImageV.transform = CGAffineTransformMakeRotation(0);
            self.fourImageV.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            
        }];
    } else if (btn == self.twoBtn){
        [self.twoBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
        [self.twoImageV setImage:[UIImage imageNamed:@"img_pub_red"]];
        threeFlag = NO;
        fourFlag = NO;
        if (twoFlag) {
            order = @"sum_sales_asc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(M_PI);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                twoFlag = NO;
            }];
        }
        else {
            order = @"sum_sales_desc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                twoFlag = YES;
            }];
        }
    } else if (btn == self.threeBtn){
        twoFlag = NO;
        fourFlag = NO;
        [self.threeBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
        [self.threeImageV setImage:[UIImage imageNamed:@"img_pub_red"]];
        if (threeFlag) {
            order = @"haoping_asc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5 animations:^{
                self.threeImageV.transform = CGAffineTransformMakeRotation(M_PI);
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                threeFlag = NO;
            }];
        }
        else {
            order = @"haoping_desc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                threeFlag = YES;
            }];
        }
    } else if (btn == self.fourBtn){
        twoFlag = NO;
        threeFlag = NO;
        [self.fourBtn setTitleColor:DColor_mainRed forState:UIControlStateNormal];
        [self.fourImageV setImage:[UIImage imageNamed:@"img_pub_red"]];
        if (fourFlag) {
            order = @"price_asc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5 animations:^{
                self.fourImageV.transform = CGAffineTransformMakeRotation(M_PI);
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                fourFlag = NO;
            }];
        }
        else {
            order = @"price_desc";
            [self refreshData:^(BOOL finish) {
            }];
            [UIView animateWithDuration:0.5 animations:^{
                self.twoImageV.transform = CGAffineTransformMakeRotation(0);
                self.threeImageV.transform = CGAffineTransformMakeRotation(0);
                self.fourImageV.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                fourFlag = YES;
            }];
        }
    } else if (btn == self.fiveBtn){
        [self.fiveBtn setTitleColor:DColor_mainColor forState:UIControlStateNormal];
        [self loadingScreen:@""];
        [UIView animateWithDuration:0.5f animations:^{
            self.twoImageV.transform = CGAffineTransformMakeRotation(0);
            self.threeImageV.transform = CGAffineTransformMakeRotation(0);
            self.fourImageV.transform = CGAffineTransformMakeRotation(0);
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

#pragma mark-----
#pragma mark---------load data---------
//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        showMessage(@"加载完成");
        success (YES);
    }else{
        [self loadingData:^(BOOL finish) {
            success(finish);
        }];
    }
}

//刷新数据
- (void) refreshData:(void (^)(BOOL finish))success
{
    //重新加载数据。一切都重新初始化
    [self.footer resetNoMoreData];
    [(MJRefreshBackNormalFooter *)self.goodsListCollectionView.footer resetNoMoreData];
    //重新加载数据。一切都重新初始化
    isEnd = NO;
    page = 0;
    if (_goodsListArray != nil) {
        [_goodsListArray removeAllObjects];
        _goodsListArray = nil;
    }
    _goodsListArray = [[NSMutableArray alloc]init];
    
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}


#pragma 网络请求方法
- (void)loadingData:(void (^)(BOOL finish))success
{
//    NSDictionary *parameter = @{@"order":order,@"cateId":[NSString stringWithFormat:@"%@",self.cateId],@"keywords":self.keyWords,@"attrIds":attrIds,@"attrValues":self.selectString,@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10"};
//    NSLog(@"111111%@",parameter);
//    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.list" parameters:parameter ifAddActivityIndicator:isFirst success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
//        if (responseObject.succeed) {
//            NSLog(@"result = %@",responseObject.result);
//            NSArray *dataArr = [responseObject.result objectForKey:@"data"];
//            for (NSDictionary *dic in dataArr) {
//                DGoodsListModel *goodsList = [[DGoodsListModel alloc] init];
//                goodsList = [JsonStringTransfer dictionary:dic ToModel:goodsList];
//                [self.goodsListArray addObject:goodsList];
//            }
//            page++;
//            if (dataArr.count < 10) {
//                isEnd = YES;
//            }
//            [self.dMainTableView reloadData];
//            [self.goodsListCollectionView reloadData];
//        }
//        else
//        {
//            if ([responseObject.msg length] == 0) {
//                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
//            }else
//                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
//        }
//        success(YES);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error = %@",error);
//        NSLog(@"operation6 = %@",operation);
//        success(YES);
//    }];
//    isFirst = NO;
    
    attrValues = @"";
    for (int i = 0; i < shaixuanArr.count; i++) {
        NSString *selectAttrStr = [NSString stringWithFormat:@"%@",[[shaixuanArr objectAtIndex:i] objectForKey:@"selectAttr"]];
        if (![selectAttrStr isEqualToString:@""]) {
            if ([attrValues isEqualToString:@""]) {
                attrValues = [NSMutableString stringWithFormat:@"%@",selectAttrStr];
            }else{
                attrValues = [attrValues stringByAppendingFormat:@",%@",selectAttrStr];
            }
        }
    }
    
    NSDictionary *parameter = @{@"order":order,@"storeId":storeId,@"keywords":self.keyWords,@"attrIds":attrIds,@"attrValues":attrValues,@"cateId":self.cateId,@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10"};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.list" parameters:parameter ifAddActivityIndicator:isFirst success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSArray *dataArr = [responseObject.result objectForKey:@"data"];
            for (NSDictionary *dic in dataArr) {
                DGoodsListModel *goodsList = [[DGoodsListModel alloc] init];
                goodsList = [JsonStringTransfer dictionary:dic ToModel:goodsList];
                [self.goodsListArray addObject:goodsList];
            }
            page++;
            if (dataArr.count < 10) {
                isEnd = YES;
            }
            [self.dMainTableView reloadData];
            [self.goodsListCollectionView reloadData];
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
        success(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
        success(YES);
    }];
    isFirst = NO;

}

- (void)loadingScreen:(NSString *)goodsIDString{
    NSMutableString *goodsid;
//    if ([self.cateId isEqualToString:@""]) {
//        if (self.goodsListArray.count > 0) {
//            NSInteger count;
//            if (self.goodsListArray.count > 10) {
//                count = 10;
//            }else{
//                count = self.goodsListArray.count;
//            }
//            for (int i = 0; i < count; i++) {
//                DGoodsListModel *model = (DGoodsListModel *)[self.goodsListArray objectAtIndex:i];
//                if (i == 0) {
//                    goodsid = [NSMutableString stringWithFormat:@"%@",model.goods_id];
//                }else{
//                    [goodsid appendFormat:@",%@",model.goods_id];
//                }
//            }
//        }else{
//            goodsid = [NSMutableString stringWithFormat:@"%@",@""];
//        }
//    }else{
//        goodsid = [NSMutableString stringWithFormat:@"%@",self.cateId];
//    }
    if (self.goodsListArray.count > 0) {
        NSInteger count;
        if (self.goodsListArray.count > 10) {
            count = 10;
        }else{
            count = self.goodsListArray.count;
        }
        for (int i = 0; i < count; i++) {
            DGoodsListModel *model = (DGoodsListModel *)[self.goodsListArray objectAtIndex:i];
            if (i == 0) {
                goodsid = [NSMutableString stringWithFormat:@"%@",model.goods_id];
            }else{
                [goodsid appendFormat:@",%@",model.goods_id];
            }
        }
    }else{
        goodsid = [NSMutableString stringWithFormat:@"%@",@""];
    }

    NSDictionary *parameter = @{@"goodsIds":goodsid,@"keywords":self.keyWords};

    NSLog(@"111111%@",parameter);
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.screen" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
//            //无数据时的处理
//            if ([responseObject.result isKindOfClass:[NSString class]]) {
//                [self.selectTableView reloadData];
//                showMessage(@"没有筛选数据");
//                return ;
//            }
//            if (headArray != nil) {
//                [headArray removeAllObjects];
//                headArray = nil;
//            }
//            if (self.contents != nil) {
//                [self.contents removeAllObjects];
//                self.contents = nil;
//            }
//            headArray = [NSMutableArray array];
//            self.contents = [NSMutableArray array];
//            NSInteger number = 0;
//            NSLog(@"result = %@",responseObject.result);
//            for (NSDictionary *dic in responseObject.result) {
//                NSLog(@"%@",[dic objectForKey:@"attr_name"]);
//                headArray = [NSMutableArray array];
//                [headArray addObject:[dic objectForKey:@"attr_name"]];
//                secondArray = [[dic objectForKey:@"def_value"] componentsSeparatedByString:@","];
//                for (NSInteger i = 0; i < secondArray.count; i++) {
//                    [headArray addObject:[secondArray objectAtIndex:i]];
//                }
//                [_contents insertObject:headArray atIndex:number++];
//            }
//            [self.selectTableView reloadData];
            
            if (shaixuanArr != nil) {
                [shaixuanArr removeAllObjects];
                shaixuanArr = nil;
            }
            shaixuanArr = [[NSMutableArray alloc]init];
            if ([responseObject.result isKindOfClass:[NSString class]]) {
                [self.selectTableView reloadData];
                showMessage(@"没有相关筛选！");
                return ;
            }
            //            if ([responseObject.result isEqualToString:@""]) {
            //                 [self.selectTableView reloadData];
            //                return ;
            //            }
            for (NSDictionary *dic in responseObject.result) {
                NSMutableDictionary *muDic = [[NSMutableDictionary alloc]init];
                NSArray *defValueArr = [[dic objectForKey:@"def_value"] componentsSeparatedByString:@","];
                [muDic setObject:defValueArr forKey:@"def_value"];
                [muDic setObject:[dic objectForKey:@"attr_id"] forKey:@"attr_id"];
                [muDic setObject:[dic objectForKey:@"attr_name"] forKey:@"attr_name"];
                NSMutableArray *isflagArr = [[NSMutableArray alloc]init];
                for (int i = 0; i < defValueArr.count; i++) {
                    [isflagArr insertObject:@"0" atIndex:i];
                }
                [muDic setObject:isflagArr forKey:@"isFlag"];
                [muDic setObject:@"" forKey:@"selectAttr"];
                [shaixuanArr addObject:muDic];
            }
            [self.selectTableView reloadData];
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

//- (void)loadingList:(NSString *)goodsScreenString{
//    NSDictionary *parameter = @{@"attrValues":goodsScreenString};
//    NSLog(@"111111%@",parameter);
//    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.list" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
//        if (responseObject.succeed) {
//            NSLog(@"result = %@",responseObject.result);
//            NSArray *dataArr = [responseObject.result objectForKey:@"data"];
//            self.goodsListArray = [NSMutableArray array];
//            for (NSDictionary *dic in dataArr) {
//                DGoodsListModel *goodsList = [[DGoodsListModel alloc] init];
//                [goodsList setValuesForKeysWithDictionary:dic];
//                [self.goodsListArray addObject:goodsList];
////                self.goodsIDString = [NSString stringWithFormat:@"%@,%ld",self.goodsIDString,[goodsList goods_id]];
//            }
////            self.goodsIDString = [self.goodsIDString substringWithRange:NSMakeRange(1, self.goodsIDString.length - 1)];
//            [self.dMainTableView reloadData];
//            [self.goodsListCollectionView reloadData];
//        }
//        else
//        {
//            if ([responseObject.msg length] == 0) {
//                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
//            }else
//                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error = %@",error);
//        NSLog(@"operation6 = %@",operation);
//    }];
//
//}

#pragma 返回方法
- (void)toLeftNavButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 切换展示方式
- (void)toRightNavButton:(id)sender{
    self.dMainTableView.hidden = !self.dMainTableView.hidden;
    self.goodsListCollectionView.hidden = !self.goodsListCollectionView.hidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma buttonAction
- (void) toFenleiBtns:(id)sender
{
//    UIButton *btn = (UIButton*)sender;
//    NSLog(@"btn.tag = %ld",btn.tag);
//    
//    clickFlag = btn.tag;
//    
//    if (btn.tag == fNowOpen) {
//        fNowOpen = 1000;
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[_contents objectAtIndex:btn.tag]] ;
//        for (int i = 0; i < isFlagArr.count - 1; i++) {
//            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
//            [arr addObject:indesPath];
//        }
//        UIImageView *imageV = (UIImageView *)[btn viewWithTag:2000+btn.tag];
//        imageV.transform = CGAffineTransformMakeRotation(0);
//        
//        [self.selectTableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationBottom];
//    }else{
//        if (fNowOpen != 1000) {
//            
//            NSInteger nowClose = fNowOpen;
//            fNowOpen = 1000;
//            NSMutableArray *arr0 = [[NSMutableArray alloc]init];
//            NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[_contents objectAtIndex:nowClose]] ;
//            for (int i = 0; i < isFlagArr.count - 1; i++) {
//                NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:nowClose];
//                [arr0 addObject:indesPath];
//            }
//            
//            UIImageView *imageV0 = (UIImageView *)[self.selectTableView viewWithTag:2000+nowClose];
//            imageV0.transform = CGAffineTransformMakeRotation(0);
//            [self.selectTableView deleteRowsAtIndexPaths:arr0 withRowAnimation:UITableViewRowAnimationNone];
//            fNowOpen = btn.tag;
//        }else{
//            fNowOpen = btn.tag;
//        }
//        
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[_contents objectAtIndex:btn.tag]] ;
//        for (int i = 0; i < isFlagArr.count - 1; i++) {
//            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
//            [arr addObject:indesPath];
//        }
//        
//        UIImageView *imageV1 = (UIImageView *)[btn viewWithTag:2000+btn.tag];
//        imageV1.transform = CGAffineTransformMakeRotation(M_PI);
//        
//        [self.selectTableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
//        
//    }
    
    UIButton *btn = (UIButton*)sender;
    NSLog(@"btn.tag = %d",btn.tag);
    
    
    
    if (btn.tag == fNowOpen) {
        fNowOpen = 1000;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:btn.tag]objectForKey:@"isFlag"]] ;
        for (int i = 0; i < isFlagArr.count; i++) {
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
            [arr addObject:indesPath];
        }
        UIImageView *imageV = (UIImageView *)[btn viewWithTag:2000+btn.tag];
        imageV.transform = CGAffineTransformMakeRotation(0);
        
        [self.selectTableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
        
    }else{
        if (fNowOpen != 1000) {
            
            NSInteger nowClose = fNowOpen;
            fNowOpen = 1000;
            NSMutableArray *arr0 = [[NSMutableArray alloc]init];
            NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:nowClose]objectForKey:@"isFlag"]] ;
            for (int i = 0; i < isFlagArr.count; i++) {
                NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:nowClose];
                [arr0 addObject:indesPath];
            }
            
            UIImageView *imageV = (UIImageView *)[self.selectTableView viewWithTag:2000+nowClose];
            imageV.transform = CGAffineTransformMakeRotation(0);
            
            [self.selectTableView deleteRowsAtIndexPaths:arr0 withRowAnimation:UITableViewRowAnimationTop];
            fNowOpen = btn.tag;
            
        }else{
            fNowOpen = btn.tag;
            
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray *isFlagArr = [NSMutableArray arrayWithArray:[[shaixuanArr objectAtIndex:btn.tag]objectForKey:@"isFlag"]] ;
        for (int i = 0; i < isFlagArr.count; i++) {
            NSIndexPath *indesPath = [NSIndexPath indexPathForRow:i inSection:btn.tag];
            [arr addObject:indesPath];
        }
        
        UIImageView *imageV = (UIImageView *)[btn viewWithTag:2000+btn.tag];
        imageV.transform = CGAffineTransformMakeRotation(M_PI);
        
        
        [self.selectTableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
        
    }

}


#pragma SearchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.oneBtn setTitleColor:DColor_mainColor forState:UIControlStateNormal];
    [self.twoBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.threeBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.fourBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    [self.fiveBtn setTitleColor:DColor_word_bg forState:UIControlStateNormal];
    self.keyWords = dSearchBar.text;
    [self refreshData:^(BOOL finish) {
    }];
    [dSearchBar resignFirstResponder];
    dSearchBar.showsCancelButton = NO;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    dSearchBar.showsCancelButton = YES;
    if ([dSearchBar.text isEqualToString:@""]) {
        self.keyWords = @"";
        [self refreshData:^(BOOL finish) {
        }];
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar

{
    dSearchBar.showsCancelButton = NO;
    
    dSearchBar.text = @"";
    self.keyWords = @"";
    
    [dSearchBar resignFirstResponder];
    [self refreshData:^(BOOL finish) {
    }];
    
}

#pragma scrollView delegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    dSearchBar.text = @"";
    [dSearchBar endEditing:YES];
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
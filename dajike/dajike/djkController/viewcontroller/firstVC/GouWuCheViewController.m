//
//  GouWuCheViewController.m
//  dajike
//
//  Created by swb on 15/7/8.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "GouWuCheViewController.h"
#import "dDefine.h"
#import "defines.h"
#import "MyClickLb.h"
#import "GouWuCheClickView.h"
#import "DGouWuCheOperation.h"
#import "SWBTabBarController.h"
#import "DTabView.h"
#import "SWBTabBar.h"
//各种要跳转的controller们
#import "DLoginViewController.h"
#import "DConfirmOrderViewController.h"
#import "DCollectListViewController.h"
#import "DWebViewController.h"
#import "DSJShouYeViewController.h"
//各种model们
#import "DGoodsListModel.h"
//各种cell们
#import "DgouwucheCell.h"
#import "DgouwucheOneCell.h"
#import "DgouwucheLastCell.h"
#import "DgouwucheKongCell.h"

#define STORE_DELETE_BTN_HEIGHT 34
#define STORE_DELETE_BTN_WIDTH  (STORE_DELETE_BTN_HEIGHT*2)

static NSString *cell_DgouwucheCell = @"DgouwucheCell";
static NSString *cell_DgouwucheOneCell = @"DgouwucheOneCell";
static NSString *cell_DgouwucheLastCell = @"DgouwucheLastCell";

@interface GouWuCheViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIButton    *quanXuanBtn;//全选按钮
    UILabel     *quanXuanLb;
    MyClickLb   *_jiesuanLb;//结算按钮--可点击的Lb
    UILabel     *allMoneyLb;//合计Lb
    UILabel     *yuefeiLb;//运费Lb
    UIView      *viewBg_JieSuan;//底部的结算
    UIView      *viewBg_BianJi;//底部的编辑
    DImgButton  *_bianJiBtn;//默认为图片
    DImgButton  *_okBtn;//点击后变为完成
    BOOL        _btnSwitch;//设置开关  切换导航栏按钮
    
    NSMutableArray *_cell0SelectStateArr;//第一行的Cell选择状态
    NSMutableArray *_cellSelectStateArr;//每一行的选择状态
    
    NSMutableArray *_storeArr;
    NSMutableArray *_goodsArr;
    
    NSMutableArray *_xiaoJiMoneyArr;//每个小计
    NSMutableArray *_buyNumArr;//购买数量
    
    NSMutableArray *_guessArr;//猜你喜欢
//    NSString *_imgUrlYuMing;
    
    float   _moneyNum;
    UIView      *headerView;//透视图，未登录状态下显示
    int     _gouWuCheNum;
}


@end

@implementation GouWuCheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNaviBarTitle:@"购物车"];
    _btnSwitch = NO;
    _moneyNum = 0.00;
//    _imgUrlYuMing = @"";
    _bianJiBtn = [DBaseNavView createNavBtnWithImgNormal:@"img_car_09" imgHighlight:@"img_car_09" imgSelected:@"img_car_09" target:self action:@selector(bianjiBtn:)];
    _bianJiBtn.selected = NO;
    _okBtn = [DBaseNavView createNavBtnWithTitle:@"完成" target:self action:@selector(bianjiBtn:)];
    _okBtn.selected = NO;
    
//    NSMutableDictionary *dic = [[FileOperation readFileToDictionary:SET_PLIST]mutableCopy];
//    _imgUrlYuMing = [dic objectForKey:@"image_domain"];
    
    //设置底部结算view
    [self bottomJieSuanView];
    //设置底部编辑view  刚开始隐藏
    [self bottomBianJiView];
    
    //添加基类列表
    [self setMainTableViewUI];
    //添加全选btn
    [self addQuanXuanBtn];
    
    DTabView *tabView = [[DTabView alloc]initWithFrame:DRect(0, DHEIGHT_CONTROLLER_DEFAULT-49, DWIDTH_CONTROLLER_DEFAULT, 49)];
    [tabView setMainView:2];
    [self.view addSubview:tabView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _guessArr = [[NSMutableArray alloc]init];
    [self initCreateHeaderView];
    quanXuanBtn.selected = NO;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if ([FileOperation isLogin]) {
        dic = [[DGouWuCheOperation syncGouWuChe]mutableCopy];
        //同步后台购物车
        [self synchronizationGouWuChe:dic];
    }else {
        //获取本地购物车
        dic = [[DGouWuCheOperation traverseGouWuChe]mutableCopy];
        //设置数据源
        [self setDataSource:dic];
    }
    //猜你喜欢
    [self guessYouLike];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [viewBg_JieSuan setHidden:NO];
    [viewBg_BianJi setHidden:YES];
}
//同步后台购物车
- (void)synchronizationGouWuChe:(NSMutableDictionary *)dic
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",[[JsonStringTransfer objectToJsonString:dic] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"map", nil];
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Carts.saveOrGet" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            [self setDataSource:[responseObject.result mutableCopy]];
            [DGouWuCheOperation updateStatus];
            [self setUIFrame];
        }else
            showMessage(responseObject.msg);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}
//猜你喜欢
- (void)guessYouLike
{
    NSString *goodsIds = [FileOperation getCurrentGoodsIds];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:goodsIds,@"goodsIds", nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Carts.guessFavorites" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            NSLog(@"operation6 = %@",operation);
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                NSMutableArray *catesArr = [[responseObject.result allKeys]mutableCopy];
                for (int i=0; i<catesArr.count; i++) {
//                    NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
                    for (NSDictionary *tmpDic in [responseObject.result objectForKey:[NSString stringWithFormat:@"%@",[catesArr objectAtIndex:i]]]) {
                        DGoodsListModel *model = [[DGoodsListModel alloc]init];
                        model = [JsonStringTransfer dictionary:tmpDic ToModel:model];
//                        [tmpArr addObject:model];
                        [_guessArr addObject:model];
                    }
//                    [_guessArr addObject:tmpArr];
                }
                NSLog(@"%@",_guessArr);
                [self.dMainTableView reloadData];
            }else
                showMessage(responseObject.msg);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"失败");
        }];
    });
}
//添加基类列表
- (void)setMainTableViewUI
{
    [self addTableView:NO];
    [self.dMainTableView setFrame:DRect(0, 64, DWIDTH_CONTROLLER_DEFAULT, CGRectGetMinY(viewBg_JieSuan.frame)-64)];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    registerNib(@"DgouwucheCell", cell_DgouwucheCell);
    registerNib(@"DgouwucheOneCell", cell_DgouwucheOneCell);
    registerNib(@"DgouwucheLastCell", cell_DgouwucheLastCell);
}
//初始化创建透视图
- (void)initCreateHeaderView
{
    headerView = (UIView *)[self.view viewWithTag:911];
    if (!headerView) {
        headerView = [self.view createViewWithFrame:DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT, 40) andBackgroundColor:DColor_White];
        headerView.tag = 911;
    }
    
    UILabel *lb = (UILabel *)[headerView viewWithTag:912];
    if (!lb) {
        lb = [self.view creatLabelWithFrame:DRect(10, 5, 200, 30) AndFont:16.0f AndBackgroundColor:DColor_Clear AndText:@"立即登录 同步购物车" AndTextAlignment:NSTextAlignmentLeft AndTextColor:DColor_666666 andCornerRadius:0.0f];
        lb.tag = 912;
        [headerView addSubview:lb];
    }
    
    UIImageView *imgv = (UIImageView *)[headerView viewWithTag:913];
    if (!imgv) {
        imgv = [self.view createImageViewWithFrame:DRect(DWIDTH_CONTROLLER_DEFAULT-30, 10, 20, 20) andImageName:@"img_pub_02_1"];
        imgv.tag = 913;
        [headerView addSubview:imgv];
    }
    
    UIButton *btn = (UIButton *)[headerView viewWithTag:10086];
    if (!btn) {
        btn = [self.view createButtonWithFrame:DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT, 40) andBackImageName:nil andTarget:self andAction:@selector(loginAction) andTitle:nil andTag:10086];
        [headerView addSubview:btn];
    }
    
    [self setHeaderView];
}

//判断是否登录 设置头视图
- (void)setHeaderView
{
    if ([FileOperation isLogin]) {
        self.dMainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 5)];
    }else
        self.dMainTableView.tableHeaderView = headerView;
}
//设置数据源
- (void)setDataSource:(NSMutableDictionary *)dic
{
    _gouWuCheNum = 0;
    _storeArr = [[NSMutableArray alloc]init];
    _goodsArr = [[NSMutableArray alloc]init];
    _cell0SelectStateArr = [[NSMutableArray alloc]init];
    _cellSelectStateArr = [[NSMutableArray alloc]init];
    _buyNumArr = [[NSMutableArray alloc]init];
    _xiaoJiMoneyArr = [[NSMutableArray alloc]init];
    _storeArr = [[dic allKeys]mutableCopy];
    for (int i= 0; i<_storeArr.count; i++) {
        NSMutableArray *arr = [[dic objectForKey:[_storeArr objectAtIndex:i]]mutableCopy];
        _gouWuCheNum = _gouWuCheNum+(int)arr.count;
        NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
        NSMutableArray *buyNumAarry = [[NSMutableArray alloc]init];
        for (int j=0; j<arr.count; j++) {
            [tmpArr addObject:@"0"];
            [buyNumAarry addObject:[[arr objectAtIndex:j]objectForKey:@"number"]];
        }
        [_cellSelectStateArr addObject:tmpArr];
        [_buyNumArr addObject:buyNumAarry];
        [_goodsArr addObject:arr];
        [_xiaoJiMoneyArr addObject:@"0"];
        [_cell0SelectStateArr addObject:@"0"];
    }
    if (_storeArr.count>0) {
        [self setNaviBarRightBtn:_bianJiBtn];
        [quanXuanBtn setHidden:NO];
        [quanXuanLb setHidden:NO];
        [self.dMainTableView setFrame:DRect(0, 64, DWIDTH_CONTROLLER_DEFAULT, CGRectGetMinY(viewBg_JieSuan.frame)-64)];
        
    }else {
        [self setNaviBarRightBtn:nil];
        [quanXuanBtn setHidden:YES];
        [quanXuanLb setHidden:YES];
        [self.dMainTableView setFrame:DRect(0, 64, DWIDTH_CONTROLLER_DEFAULT, CGRectGetMaxY(viewBg_JieSuan.frame)-64)];
    }
    [self.dMainTableView reloadData];
    
    NSLog(@"%d",_gouWuCheNum);
    [FileOperation setPlistObject:[NSString stringWithFormat:@"%d",_gouWuCheNum] forKey:@"cartCount" ofFilePath:[FileOperation creatPlistIfNotExist:jibaobaoUser]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeGouWuCheNum" object:nil];
}
//登录
- (void)loginAction
{
    DLoginViewController *vc = [[DLoginViewController alloc]init];
    vc.fromVC = GOUWUCHE_VC;
    [vc callBack:^{
        [self.dMainTableView reloadData];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeGouWuCheNum" object:nil];
    }];
    push(vc);
}

//设置底部结算view
- (void)bottomJieSuanView
{
    viewBg_JieSuan = [self.view createViewWithFrame:DRect(0, DHEIGHT_CONTROLLER_DEFAULT-94, DWIDTH_CONTROLLER_DEFAULT, 44) andBackgroundColor:DColor_White];
    [self.view addSubview:viewBg_JieSuan];
    UIView *lineV1 = [self.view createViewWithFrame:DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT, 0.5) andBackgroundColor:DColor_line_bg];
    [viewBg_JieSuan addSubview:lineV1];
    UIView *lineV2 = [self.view createViewWithFrame:DRect(0, viewBg_JieSuan.frame.size.height-0.5, DWIDTH_CONTROLLER_DEFAULT, 0.5) andBackgroundColor:DColor_line_bg];
    [viewBg_JieSuan addSubview:lineV2];
    
    //结算Btn
    _jiesuanLb = [[MyClickLb alloc]initWithFrame:DRect(DWIDTH_CONTROLLER_DEFAULT-80, 7, 70, 30)];
    _jiesuanLb.textAlignment = NSTextAlignmentCenter;
    _jiesuanLb.backgroundColor = DColor_c4291f;
    _jiesuanLb.font = DFont_13b;
    _jiesuanLb.textColor = DColor_White;
    _jiesuanLb.layer.cornerRadius = 4.0f;
    _jiesuanLb.layer.masksToBounds = YES;
    [_jiesuanLb callbackClickedLb:^(MyClickLb *clickLb) {
        NSLog(@"结算");
        if ([FileOperation isLogin]) {
            if ([self checkData:888]) {
                DConfirmOrderViewController *vc = [[DConfirmOrderViewController alloc]init];
                vc.type = GOU_WU_CHE;
                vc.shifukuan = [_xiaoJiMoneyArr valueForKeyPath:@"@sum.floatValue"];
                vc.xiaoJiArr = [[self xiaojiArr]mutableCopy];
                vc.deleteArr = [[self sortDeleteArr]mutableCopy];
                NSLog(@"%@",[self sortDeleteArr]);
                vc.mDic = [[self buy]mutableCopy];
                push(vc);
            }
        }else
            showMessage(@"请先登录后再结算");
    }];
    [viewBg_JieSuan addSubview:_jiesuanLb];
    //合计lb
    allMoneyLb = [self.view creatLabelWithFrame:CGRectZero AndFont:13.0f AndBackgroundColor:DColor_Clear AndText:@"合计：¥410.00" AndTextAlignment:NSTextAlignmentRight AndTextColor:DColor_666666 andCornerRadius:0.0f];
    //运费lb
    yuefeiLb = [self.view creatLabelWithFrame:CGRectZero AndFont:13.0f AndBackgroundColor:DColor_Clear AndText:@"不含运费" AndTextAlignment:NSTextAlignmentRight AndTextColor:DColor_666666 andCornerRadius:0.0f];
    //集成设置allMoneyLb和yuefeiLb的frame
    [self setUIFrame];
    [viewBg_JieSuan addSubview:yuefeiLb];
    [viewBg_JieSuan addSubview:allMoneyLb];
}
//集成设置allMoneyLb和yuefeiLb的frame
- (void)setUIFrame
{
    NSMutableArray *jiesuanArr = [[self sortDeleteArr]mutableCopy];
    _jiesuanLb.text = [NSString stringWithFormat:@" 结算（%lu）",(unsigned long)jiesuanArr.count];
    NSNumber *sum = [_xiaoJiMoneyArr valueForKeyPath:@"@sum.floatValue"];
    allMoneyLb.text = [NSString stringWithFormat:@"合计：¥%.2f",[sum floatValue]];
    CGRect jiesuanRect = [self.view contentAdaptionLabel:_jiesuanLb.text withSize:DSize(500, 30) withTextFont:13.0f];
    _jiesuanLb.frame = DRect(DWIDTH_CONTROLLER_DEFAULT-jiesuanRect.size.width-15, 7, jiesuanRect.size.width+5, 30);
    allMoneyLb.frame = DRect(CGRectGetMinX(_jiesuanLb.frame)-5-120, 3, 120, 18);
    yuefeiLb.frame = DRect(CGRectGetMinX(allMoneyLb.frame), CGRectGetMaxY(allMoneyLb.frame)+3, 120, 18);
}
//添加全选按钮
- (void)addQuanXuanBtn
{
    //全选btn
    quanXuanBtn = [self.view createButtonWithFrame:DRect(0, CGRectGetMinY(viewBg_BianJi.frame), 40, 44) andBackImageName:nil andTarget:self andAction:@selector(allSelectedBtn:) andTitle:nil andTag:909];
    quanXuanBtn.selected = NO;
    [quanXuanBtn setImage:[UIImage imageNamed:@"img_car_04.png"] forState:UIControlStateNormal];
    [quanXuanBtn setImage:[UIImage imageNamed:@"img_car_02"] forState:UIControlStateSelected];
    [quanXuanBtn setImageEdgeInsets:UIEdgeInsetsMake(11, 15, 11, 5)];
    [self.view addSubview:quanXuanBtn];
    //全选Lb
    quanXuanLb = [self.view creatLabelWithFrame:DRect(CGRectGetMaxX(quanXuanBtn.frame)+2, CGRectGetMinY(quanXuanBtn.frame)+7, 50, 30) AndFont:12.0f AndBackgroundColor:DColor_Clear AndText:@"全选" AndTextAlignment:NSTextAlignmentLeft AndTextColor:DColor_666666 andCornerRadius:0.0f];
    [self.view addSubview:quanXuanLb];
}
//设置底部编辑view
- (void)bottomBianJiView
{
    viewBg_BianJi = [self.view createViewWithFrame:viewBg_JieSuan.frame andBackgroundColor:DColor_White];
    [viewBg_BianJi setHidden:YES];
    [self.view addSubview:viewBg_BianJi];
    
    UIView *lineV1 = [self.view createViewWithFrame:DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT, 0.5) andBackgroundColor:DColor_line_bg];
    [viewBg_BianJi addSubview:lineV1];
    UIView *lineV2 = [self.view createViewWithFrame:DRect(0, viewBg_JieSuan.frame.size.height-0.5, DWIDTH_CONTROLLER_DEFAULT, 0.5) andBackgroundColor:DColor_line_bg];
    [viewBg_BianJi addSubview:lineV2];
    
    //删除Btn
    UIButton *deleteBtn = [self.view createButtonWithFrame:DRect(DWIDTH_CONTROLLER_DEFAULT-STORE_DELETE_BTN_WIDTH-10, 5, STORE_DELETE_BTN_WIDTH, STORE_DELETE_BTN_HEIGHT) andBackImageName:nil andTarget:self andAction:@selector(storeWithDeleteBtn:) andTitle:@"删除" andTag:666];
    [deleteBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
    [deleteBtn setTitleColor:DColor_c4291f forState:UIControlStateHighlighted];
    deleteBtn.layer.cornerRadius = 5.0f;
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.layer.borderWidth = 0.8f;
    deleteBtn.layer.borderColor = DColor_line_bg.CGColor;
    [viewBg_BianJi addSubview:deleteBtn];
    //收藏Btn
    UIButton *storeBtn = [self.view createButtonWithFrame:DRect(CGRectGetMinX(deleteBtn.frame)-STORE_DELETE_BTN_WIDTH-20, 5, STORE_DELETE_BTN_WIDTH, STORE_DELETE_BTN_HEIGHT) andBackImageName:nil andTarget:self andAction:@selector(storeWithDeleteBtn:) andTitle:@"收藏" andTag:888];
    [storeBtn setTitleColor:DColor_666666 forState:UIControlStateNormal];
    [storeBtn setTitleColor:DColor_c4291f forState:UIControlStateHighlighted];
    storeBtn.layer.cornerRadius = 5.0f;
    storeBtn.layer.masksToBounds = YES;
    storeBtn.layer.borderWidth = 0.8f;
    storeBtn.layer.borderColor = DColor_line_bg.CGColor;
    [viewBg_BianJi addSubview:storeBtn];
}
//右上角编辑按钮
- (void)bianjiBtn:(DImgButton *)btn
{
    NSLog(@"编辑");
    if (!_btnSwitch) {
        [self setNaviBarRightBtn:_okBtn];
        [viewBg_JieSuan setHidden:YES];
        [viewBg_BianJi setHidden:NO];
    }else {
        [self setNaviBarRightBtn:_bianJiBtn];
        [viewBg_JieSuan setHidden:NO];
        [viewBg_BianJi setHidden:YES];
    }
    _btnSwitch = !_btnSwitch;
}
//全选按钮
- (void)allSelectedBtn:(UIButton *)btn
{
    NSLog(@"全选");
    BOOL stockFlag = NO;
    BOOL buyNumFlag = NO;
    for (int i=0 ;i<_storeArr.count;i++) {
        for (NSDictionary *tmpDic in [_goodsArr objectAtIndex:i]) {
            if ([[tmpDic objectForKey:@"stock"] intValue] == 0) {
                stockFlag = YES;
                break;
            }
        }
    }
    if (stockFlag) {
        showMessage(@"有商品库存不足，请重新选择");
        return ;
    }
    for (int j=0; j<_storeArr.count; j++) {
        for (int k=0;k<[[_buyNumArr objectAtIndex:j]count];k++) {
            if ([[[_buyNumArr objectAtIndex:j]objectAtIndex:k]intValue] == 0) {
                buyNumFlag = YES;
                break;
            }
        }
    }
    if (buyNumFlag) {
        showMessage(@"购买数量不能为0，请重新选择");
        return;
    }
    btn.selected = !btn.selected;
    [self allSelectAction:btn.selected];
}
//点击全选 触发事件
- (void)allSelectAction:(BOOL)btnSelected
{
    for (int i=0;i<_cell0SelectStateArr.count;i++) {
        float allMoney = 0.00;
        if (btnSelected) {
            [_cell0SelectStateArr replaceObjectAtIndex:i withObject:@"1"];
            for (int j=0; j<[[_goodsArr objectAtIndex:i]count]; j++) {
                allMoney = allMoney + [[[[_goodsArr objectAtIndex:i]objectAtIndex:j]objectForKey:@"goodsPrice"]floatValue]*[[[_buyNumArr objectAtIndex:i]objectAtIndex:j]intValue];
            }
        }else {
            [_cell0SelectStateArr replaceObjectAtIndex:i withObject:@"0"];
            for (int j=0; j<[[_cellSelectStateArr objectAtIndex:i]count]; j++) {
                [[_cellSelectStateArr objectAtIndex:i]replaceObjectAtIndex:j withObject:@"0"];
            }
        }
        [_xiaoJiMoneyArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.2f",allMoney]];
    }
    [self setUIFrame];
    [self.dMainTableView reloadData];
}
//收藏tag == 888   删除tag == 666
- (void)storeWithDeleteBtn:(UIButton *)btn
{
    if (btn.tag == 888) {
        NSLog(@"收藏");
        if ([FileOperation isLogin]) {
            if ([self checkData:777]) {
                [self storeUpGouWuChe];
            }
        }
    }
    if (btn.tag == 666) {
        NSLog(@"删除");
        if ([self checkData:666]) {
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除购物车里的商品？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertV show];
        }
        
    }
}
#pragma mark  alterView  delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteGouWuChe];
    }
}
#pragma mark 批量收藏
- (void)storeUpGouWuChe
{
    NSMutableArray *arr = [[self sortDeleteArr]mutableCopy];
    NSMutableArray *goodsIdArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in arr) {
        [goodsIdArr addObject:[dic objectForKey:@"goodsId"]];
    }
    NSSet *mArr = [NSSet setWithArray:goodsIdArr];//数组去重
    NSString *goodsId = [[mArr allObjects]componentsJoinedByString:@","];
    NSLog(@"goodsId = %@",goodsId);
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",@"1",@"type",goodsId,@"objectId", nil];
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyCollectss.collect" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        showMessage(responseObject.msg);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark -------  DataSource   &&  delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_storeArr.count>0) {
        return _storeArr.count+1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_storeArr.count > 0) {
        if (section == _storeArr.count) {
            return 2;
        }
        return [[_goodsArr objectAtIndex:section] count]+2;
    }else
    {
        if (section == 0) {
            return 1;
        }else
            return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_storeArr.count > 0) {
        if (section == _storeArr.count) {
            return 10;
        }
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_storeArr.count>0) {
        if (indexPath.row == 0) {
            return 40;
        }
        if (indexPath.section != _storeArr.count) {
            if (indexPath.row == [[_goodsArr objectAtIndex:indexPath.section]count]+1) {
                return 40;
            }
        }
        if (indexPath.section == _storeArr.count) {
            if (indexPath.row == 1) {
                return 140;
            }
        }
        return 80;
    }else
    {
        if (indexPath.section == 0) {
            return 250;
        }else
        {
            if (indexPath.row == 0) {
                return 40;
            }else
                return 140;
        }
    }
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_storeArr.count==0) {
        if (indexPath.section == 0) {
            DgouwucheKongCell *myCell = [self loadDgouwucheKongCell:indexPath];
            return myCell;
        }
    }
    NSInteger num = _storeArr.count>0?_storeArr.count:1;
    if (indexPath.section == num) {
        if (indexPath.row == 0) {
            DgouwucheLastCell *myCell = [self loadDgouwucheLastCell:tableView withIndexPath:indexPath withFlag:1];
            return myCell;
        }
        UITableViewCell *myCell = [self loadTableViewCell:indexPath];
        return myCell;
    }else
    {
        if (indexPath.row == 0) {
            DgouwucheOneCell *myCell = [self loadDgouwucheOneCell:tableView withIndexPath:indexPath];
            return myCell;
        }else if (indexPath.row == [[_goodsArr objectAtIndex:indexPath.section]count]+1) {
            DgouwucheLastCell *myCell = [self loadDgouwucheLastCell:tableView withIndexPath:indexPath withFlag:2];
            return myCell;
        }else {
            DgouwucheCell *myCell = [self loadDgouwucheCell:tableView withIndexPath:indexPath];
            return myCell;
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_storeArr.count == 0) {
        return;
    }
    NSInteger num = _storeArr.count>0?_storeArr.count:1;
    if (indexPath.section == num) {
        if (indexPath.row == 0) {
            return;
        }
    }
    if (indexPath.row == 0) {
        DSJShouYeViewController *vc = [[DSJShouYeViewController alloc] init];
        vc.storeId = [NSString stringWithFormat:@"%@",[_storeArr objectAtIndex:indexPath.section]];
        push(vc);
    }else if (indexPath.row == [[_goodsArr objectAtIndex:indexPath.section] count]+1) {
        return;
    }else {
        //跳商品详情
        DWebViewController *vc = [[DWebViewController alloc]init];
        vc.isHelp = 6;
        vc.urlStr = [NSString stringWithFormat:@"goodsId=%d&userId=%@",[[[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1] objectForKey:@"goodsId"] intValue],get_userId];
        vc.googsTitle = [NSString stringWithFormat:@"%@",[[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1] objectForKey:@"goodsName"]];
        vc.imageUrl = [NSString stringWithFormat:@"%@",[[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1] objectForKey:@"goodsDefaultImage"]];
        push(vc);
    }
}

#pragma mark   ----  loadCell ----
- (DgouwucheCell *)loadDgouwucheCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    DgouwucheCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell_DgouwucheCell];
    if (_buyNumArr.count>0) {
        myCell.buyNum = [[_buyNumArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1];
    }
    if (_goodsArr.count>0) {
        myCell.mDic = [[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1]mutableCopy];
    }
    if ([[_cell0SelectStateArr objectAtIndex:indexPath.section]intValue] == 1) {
        myCell.selectBtn.selected = YES;
        [[_cellSelectStateArr objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row-1 withObject:@"1"];
    }else {
        if ([[[_cellSelectStateArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1]intValue] == 1) {
            myCell.selectBtn.selected = YES;
        }else
            myCell.selectBtn.selected = NO;
    }
    [myCell callBtnClicked:^(int btnTag) {
        float money = [[_xiaoJiMoneyArr objectAtIndex:indexPath.section]floatValue];
        if (btnTag == 1) {
            NSLog(@"选择");
            BOOL stockFlag = NO;
            BOOL buyNumFlag = NO;
            for (NSDictionary *tmpDic in [_goodsArr objectAtIndex:indexPath.section]) {
                if ([[tmpDic objectForKey:@"stock"] intValue] == 0) {
                    stockFlag = YES;
                    break;
                }
            }
            if (stockFlag) {
                showMessage(@"有商品库存不足，请重新选择");
                return ;
            }
            for (int j=0; j<[[_buyNumArr objectAtIndex:indexPath.section]count]; j++) {
                if ([[[_buyNumArr objectAtIndex:indexPath.section]objectAtIndex:j]intValue] == 0) {
                    buyNumFlag = YES;
                    break;
                }
            }
            if (buyNumFlag) {
                showMessage(@"购买商品数量不能为0，请重新选择");
                return;
            }
            myCell.selectBtn.selected = !myCell.selectBtn.selected;
            
            if (myCell.selectBtn.selected) {
                [[_cellSelectStateArr objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row-1 withObject:@"1"];
                money = money + [[[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1]objectForKey:@"goodsPrice"]floatValue]*[[[_buyNumArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1]intValue];
            }else {
                [[_cellSelectStateArr objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row-1 withObject:@"0"];
                money = money - [[[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1]objectForKey:@"goodsPrice"]floatValue]*[[[_buyNumArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1]intValue];
            }
            [self checkBtnState:[_cellSelectStateArr objectAtIndex:indexPath.section] withIndex:indexPath];
        }
        if (btnTag == 2) {
            NSLog(@"-------------------");
            if ([myCell.buyNumLb.text intValue] == 1) {
                showMessage(@"数量不能小于1");
            }else {
                [[_buyNumArr objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row-1 withObject:[NSString stringWithFormat:@"%d",[myCell.buyNumLb.text intValue]-1]];
                if (myCell.selectBtn.selected) {
                    money = money - [[[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1]objectForKey:@"goodsPrice"]floatValue];
                }
            }
        }
        if (btnTag == 3) {
            NSLog(@"+++++++++++++++++++");
            if ([myCell.buyNumLb.text intValue] == [[[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1]objectForKey:@"stock"]intValue]) {
                showMessage(@"库存不足");
            }else {
                [[_buyNumArr objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row-1 withObject:[NSString stringWithFormat:@"%d",[myCell.buyNumLb.text intValue]+1]];
                if (myCell.selectBtn.selected) {
                    money = money + [[[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1]objectForKey:@"goodsPrice"]floatValue];
                }
            }
        }
        [_xiaoJiMoneyArr replaceObjectAtIndex:indexPath.section withObject:[NSString stringWithFormat:@"%.2f",money]];
        [self setUIFrame];
        [self.dMainTableView reloadData];
    }];
    return myCell;
}
- (DgouwucheKongCell *)loadDgouwucheKongCell:(NSIndexPath *)indexPath
{
    DgouwucheKongCell *meCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DgouwucheKongCell class]];
    [meCell callBack:^(NSInteger btnTag) {
        if (btnTag == 1) {
            NSLog(@"逛逛");
            SWBTabBarController *tabBarVC = [SWBTabBarController sharedManager];
            tabBarVC.selectedIndex = 0;
        }
        if (btnTag == 2) {
            NSLog(@"我的收藏");
            DCollectListViewController *vc = [[DCollectListViewController alloc]init];
            vc.collectType = GOODS;
            push(vc);
        }
    }];
    return meCell;
}
- (DgouwucheOneCell *)loadDgouwucheOneCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    DgouwucheOneCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell_DgouwucheOneCell];
    [myCell.storeLogoImg setImageWithURL:[commonTools getImgURL:[[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"storeLogo"]] placeholderImage:DPlaceholderImage];
    myCell.storeNameLb.text = [[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"storeName"];
    if ([[_cell0SelectStateArr objectAtIndex:indexPath.section]intValue] == 1) {
        myCell.selectBtn.selected = YES;
    }else
        myCell.selectBtn.selected = NO;
    [myCell callAllSelectBtnClicked:^{
        NSLog(@"\nsection%ld  cell上面的全选",(long)indexPath.section);
        BOOL stockFlag = NO;
        BOOL buyNumFlag = NO;
        for (NSDictionary *tmpDic in [_goodsArr objectAtIndex:indexPath.section]) {
            if ([[tmpDic objectForKey:@"stock"] intValue] == 0) {
                stockFlag = YES;
                break;
            }
        }
        if (stockFlag) {
            showMessage(@"有商品库存不足，请重新选择");
            return ;
        }
        for (int j=0; j<[[_buyNumArr objectAtIndex:indexPath.section]count]; j++) {
            if ([[[_buyNumArr objectAtIndex:indexPath.section]objectAtIndex:j]intValue] == 0) {
                buyNumFlag = YES;
                break;
            }
        }
        if (buyNumFlag) {
            showMessage(@"购买商品数量不能为0，请重新选择");
            return;
        }
        myCell.selectBtn.selected = !myCell.selectBtn.selected;
        if (myCell.selectBtn.selected) {
            [_cell0SelectStateArr replaceObjectAtIndex:indexPath.section withObject:@"1"];
        }else {
            [_cell0SelectStateArr replaceObjectAtIndex:indexPath.section withObject:@"0"];
        }
        [self checkCell0BtnState:indexPath];
    }];
    return myCell;
}
- (DgouwucheLastCell *)loadDgouwucheLastCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withFlag:(int)cellFlag
{
    DgouwucheLastCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell_DgouwucheLastCell];
    if (cellFlag == 1) {
        myCell.titleLb.textColor = DColor_666666;
        myCell.titleLb.text = @"猜你喜欢";
    }
    if (cellFlag == 2) {
        myCell.titleLb.textColor = DColor_c4291f;
        myCell.titleLb.text = [NSString stringWithFormat:@"小计：¥%.2f",[[_xiaoJiMoneyArr objectAtIndex:indexPath.section]floatValue]];
    }
    myCell.titleLb.font = [UIFont systemFontOfSize:15.0f];
    return myCell;
}
- (UITableViewCell *)loadTableViewCell:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = [DTools loadNotNibTableViewCell:self.dMainTableView cellClass:[UITableViewCell class]];
    UIScrollView *youLikeScorllView = (UIScrollView *)[myCell.contentView viewWithTag:777];
    if (!youLikeScorllView) {
        youLikeScorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 140)];
        youLikeScorllView.tag = 777;
        youLikeScorllView.showsHorizontalScrollIndicator = NO;
        [myCell.contentView addSubview:youLikeScorllView];
    }
    for (int i=0; i<_guessArr.count; i++) {
        GouWuCheClickView * mImgView = (GouWuCheClickView *)[youLikeScorllView viewWithTag:i+1];
        DGoodsListModel *model = [_guessArr objectAtIndex:i];
        if (!mImgView) {
            mImgView = [[GouWuCheClickView alloc]initWithFrame:CGRectMake(i*90+5, 5, 90, 130)];
            mImgView.tag = i+1;
            [youLikeScorllView addSubview:mImgView];
        }
//        [mImgView.imgView setImageWithURL:[commonTools getImgURL:[NSString stringWithFormat:@"%@/%@",_imgUrlYuMing,model.default_image]] placeholderImage:PlaceholderImage];
        [mImgView.imgView setImageWithURL:[commonTools getImgURL:[NSString stringWithFormat:@"%@",model.default_image]] placeholderImage:DPlaceholderImage];
        mImgView.nameLb.text = model.goods_name;
        mImgView.priceLb.text = [NSString stringWithFormat:@"¥%.2f",[model.price floatValue]];
        __weak GouWuCheViewController *weakSelf = self;
        [mImgView callBackClicked:^(GouWuCheClickView *clickImgView) {
            NSLog(@"推荐%ld",clickImgView.tag);
            DWebViewController *vc = [[DWebViewController alloc]init];
            vc.isHelp = 6;
            vc.urlStr = [NSString stringWithFormat:@"goodsId=%@&userId=%@",model.goods_id,get_userId];
            vc.googsTitle = model.goods_name;
            vc.imageUrl = [NSString stringWithFormat:@"%@",model.goods_id];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
    }
    [youLikeScorllView setContentSize:CGSizeMake(_guessArr.count*90+10, 0)];
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myCell;
}
#pragma mark --------万能的分割线 ----------

//每次点击cell上的选择按钮   判断第一行cell上和全选按钮的状态
- (void)checkBtnState:(NSMutableArray *)selectArr withIndex:(NSIndexPath *)indexPath
{
    BOOL flag = NO;
    for (int i=0; i<selectArr.count; i++) {
        if ([[selectArr objectAtIndex:i]intValue]==0) {
            flag = YES;
            break;
        }
    }
    if (!flag) {
        [_cell0SelectStateArr replaceObjectAtIndex:indexPath.section withObject:@"1"];
        [self checkCell0BtnState:indexPath];
    }else {
        [_cell0SelectStateArr replaceObjectAtIndex:indexPath.section withObject:@"0"];
        quanXuanBtn.selected = NO;
        [self.dMainTableView reloadData];
    }
}
//判断第一行上面的cell的选择按钮的状态
- (void)checkCell0BtnState:(NSIndexPath *)indexPath
{
    float moneyA = 0.00;
    if ([[_cell0SelectStateArr objectAtIndex:indexPath.section]intValue] == 1) {
        for (int j=0; j<[[_goodsArr objectAtIndex:indexPath.section]count]; j++) {
            moneyA = moneyA+[[[[_goodsArr objectAtIndex:indexPath.section]objectAtIndex:j]objectForKey:@"goodsPrice"]floatValue]*[[[_buyNumArr objectAtIndex:indexPath.section]objectAtIndex:j]intValue];
        }
        BOOL flag = NO;
        for (int i=0; i<_cell0SelectStateArr.count; i++) {
            if ([[_cell0SelectStateArr objectAtIndex:i]intValue]==0) {
                flag = YES;
                break;
            }
        }
        if (!flag) {
            NSLog(@"%@",quanXuanBtn.superview);
            quanXuanBtn.selected = YES;
        }else
            quanXuanBtn.selected = NO;
    }else {
        quanXuanBtn.selected = NO;
        for (int j = 0; j<[[_cellSelectStateArr objectAtIndex:indexPath.section]count]; j++) {
            [[_cellSelectStateArr objectAtIndex:indexPath.section] replaceObjectAtIndex:j withObject:@"0"];
        }
    }
    [_xiaoJiMoneyArr replaceObjectAtIndex:indexPath.section withObject:[NSString stringWithFormat:@"%.2f",moneyA]];
    [self setUIFrame];
    [self.dMainTableView reloadData];
}
//删除购物车中商品
- (void)deleteGouWuChe
{
    NSMutableArray *arrr = [[self sortDeleteArr]mutableCopy];
    //删除本地购物车商品
    [DGouWuCheOperation deleteGouWuCheProducts:arrr];
    //如果已登录，删除后台与本地
    if ([FileOperation isLogin]) {
        NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",[[JsonStringTransfer objectToJsonString:arrr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"list", nil];
        
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"Carts.delete" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            NSLog(@"operation6 = %@",operation);
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                [self updateDataSource];
                [self.dMainTableView reloadData];
            }
            showMessage(responseObject.msg);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else {
        [self updateDataSource];
        [self setUIFrame];
        [self.dMainTableView reloadData];
    }
}
//删除完之后更新数据源
- (void)updateDataSource
{
    if ([FileOperation isLogin]) {
        [self synchronizationGouWuChe:[[NSMutableDictionary alloc]init]];
    }else {
        //获取本地购物车
        NSMutableDictionary *dic = [[DGouWuCheOperation traverseGouWuChe]mutableCopy];
        //设置数据源
        [self setDataSource:dic];
    }
//    [_cell0SelectStateArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if ([[_cell0SelectStateArr objectAtIndex:idx]intValue] == 1) {
//            [_storeArr removeObjectAtIndex:idx];
//            [_goodsArr removeObjectAtIndex:idx];
//            [_cell0SelectStateArr removeObjectAtIndex:idx];
//            [_cellSelectStateArr removeObjectAtIndex:idx];
//            [_buyNumArr removeObjectAtIndex:idx];
//            [_xiaoJiMoneyArr removeObjectAtIndex:idx];
//        }
//    }];
}
//筛选出要删除或结算的商品   收藏
- (NSMutableArray *)sortDeleteArr
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *cell0arr = [_cell0SelectStateArr mutableCopy];
    NSMutableArray *cellarr = [_cellSelectStateArr mutableCopy];
    for (int i=0; i<cell0arr.count; i++) {
        for (int j=0; j<[[cellarr objectAtIndex:i]count]; j++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            if ([[cell0arr objectAtIndex:i]intValue]==1) {
                [dic setObject:[NSString stringWithFormat:@"%d",[[[[_goodsArr objectAtIndex:i]objectAtIndex:j]objectForKey:@"specId"] intValue]] forKey:@"specId"];
                [dic setObject:[NSString stringWithFormat:@"%d",[[_storeArr objectAtIndex:i] intValue]] forKey:@"storeId"];
                [dic setObject:[NSString stringWithFormat:@"%d",[[[[_goodsArr objectAtIndex:i]objectAtIndex:j]objectForKey:@"goodsId"] intValue]] forKey:@"goodsId"];
                [arr addObject:dic];
            }else if ([[[cellarr objectAtIndex:i]objectAtIndex:j]intValue]==1) {
                [dic setObject:[NSString stringWithFormat:@"%d",[[[[_goodsArr objectAtIndex:i]objectAtIndex:j]objectForKey:@"specId"] intValue]] forKey:@"specId"];
                [dic setObject:[NSString stringWithFormat:@"%d",[[_storeArr objectAtIndex:i] intValue]] forKey:@"storeId"];
                [dic setObject:[NSString stringWithFormat:@"%d",[[[[_goodsArr objectAtIndex:i]objectAtIndex:j]objectForKey:@"goodsId"] intValue]] forKey:@"goodsId"];
                [arr addObject:dic];
            }
        }
    }
    return arr;
}
//结算传到确认订单界面的数据：购买数量需要替换为后来选择的数量
- (NSMutableDictionary *)buy
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    for (int i=0; i<_storeArr.count; i++) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int j=0; j<[[_goodsArr objectAtIndex:i]count]; j++) {
            NSMutableDictionary *tmpDic =[[[_goodsArr objectAtIndex:i]objectAtIndex:j]mutableCopy];
            [tmpDic setObject:[[_buyNumArr objectAtIndex:i] objectAtIndex:j] forKey:@"number"];
            if ([[_cell0SelectStateArr objectAtIndex:i]intValue]==1) {
                [arr addObject:tmpDic];
            }else if ([[[_cellSelectStateArr objectAtIndex:i]objectAtIndex:j]intValue]==1) {
                [arr addObject:tmpDic];
            }
        }
        if (arr.count>0) {
            [dic setObject:arr forKey:[NSString stringWithFormat:@"%d",[[_storeArr objectAtIndex:i] intValue]]];
        }
    }
    return dic;
}
//结算的每个小计money
- (NSMutableArray *)xiaojiArr
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSString *xiaoji in _xiaoJiMoneyArr) {
        if (![xiaoji isEqualToString:@"0"]) {
            [arr addObject:xiaoji];
        }
    }
    return arr;
}

//检查数据正确性
- (BOOL)checkData:(int)btn
{
    //
    BOOL flag = NO;
    for (int i=0; i<_storeArr.count; i++) {
        for (int j=0; j<[[_goodsArr objectAtIndex:i]count]; j++) {
            if ([[[_cellSelectStateArr objectAtIndex:i]objectAtIndex:j] intValue]==1) {
                flag = YES;
                break;
            }
        }
    }
    if (!flag) {
        if (btn == 666) {
            showMessage(@"请选择要删除的商品");
        }
        if (btn == 777) {
            showMessage(@"请选择要收藏的商品");
        }
        if (btn == 888) {
            showMessage(@"请选择要购买的商品");
        }
        return NO;
    }
    return YES;
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

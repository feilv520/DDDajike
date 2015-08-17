//
//  DMyOrderListViewController.m
//  dajike
//
//  Created by swb on 15/7/14.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DMyOrderListViewController.h"
#import "PYTabbar.h"
#import "DOrderOperation.h"
#import "dDefine.h"
#import "PayPopView.h"
#import "defines.h"
//model
#import "orderGoodsModel.h"
#import "DMyOrderModel.h"
#import "UserInfoModel.h"
//cell
#import "DMyOrderCell.h"
#import "DProductOrderCell.h"
//controller
#import "DOrderDetailViewController.h"  //商品订单详情
#import "DCouponOrderDetailViewController.h"  //代金券订单详情
#import "DGoodCommetViewController.h"   //评价商品
#import "DVerifyPhoneNumViewController.h"//忘记密码
#import "DPayPlatFormViewController.h"  //支付平台
#import "DWebViewController.h"          //查看物流


@interface DMyOrderListViewController ()<UITableViewDataSource,UITableViewDelegate,PYTabbarDelegate,UIAlertViewDelegate>
{
    PYTabbar *headTabbar;
    NSString * _orderType;
    //当前页数
    NSInteger  page;
    NSMutableArray *dataArray;
    NSMutableArray *_orderGoodsArr;
    //
    int _selectIndex;
    BOOL _isFirst;
}

@end

@implementation DMyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"我的订单"];
    _orderType = @"";
    dataArray = [[NSMutableArray alloc]init];
    _orderGoodsArr = [[NSMutableArray alloc]init];
    page = 0;
    _isFirst = YES;
    _selectIndex = -1;
    [self addHeadTabbar];
    
    [self addTableView:YES];
    [self.dMainTableView setFrame:CGRectMake(0, CGRectGetMaxY(headTabbar.frame)+5, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT-CGRectGetMaxY(headTabbar.frame)-5)];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    if (self.type == DAI_FU_KUAN) {
        _orderType = @"11";
        headTabbar.selectedIndex = 1;
    }else if (self.type == DAI_FA_HUO) {
        _orderType = @"10";
        headTabbar.selectedIndex = 2;
    }else if (self.type == DAI_SHOU_HUO) {
        _orderType = @"30";
        headTabbar.selectedIndex = 3;
    }else if (self.type == DAI_PING_JIA) {
        _orderType = @"40";
        headTabbar.selectedIndex = 4;
    }else {
        [self getData:^(BOOL finish) {
            
        }];
    }
}
//添加上面的分页选择bar
- (void) addHeadTabbar
{
    NSArray * arr = @[
                      @"全部",
                      @"待付款",
                      @"待发货",
                      @"待收货",
                      @"待评价",
                      @""
                      ];
    
    headTabbar = [[PYTabbar alloc]initWithStrings:arr andFrame:CGRectMake(0, ViewCtrlTopBarHeight+5, DWIDTH_CONTROLLER_DEFAULT, 40) containerView:self.view];
    [headTabbar setBackgroundColor:[UIColor whiteColor]];
    [headTabbar setSelectedItemBackgroundColor:[UIColor whiteColor]];
    [headTabbar setDelegate:self];
    [self.view addSubview:headTabbar];
}
//获取订单
- (void)getData:(void (^)(BOOL finish))success
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:_orderType, @"status", get_userId,@"userId", [NSString stringWithFormat:@"%d",page+1],@"fromPage",nil];
    // 耗时的操作
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.list" parameters:parameter ifAddActivityIndicator:_isFirst success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            NSString *totalCount = [responseObject.result objectForKey:@"totalCount"];
            page = [[responseObject.result objectForKey:@"page"] intValue];
            if ([totalCount intValue] > 0 && [totalCount intValue] < 100) {
                if ([_orderType isEqualToString:@"11"]) {
                    [headTabbar setTitle:[NSString stringWithFormat:@"待付款%@",totalCount] atIndex:1];
                }else if ([_orderType isEqualToString:@"10"]){
                    [headTabbar setTitle:[NSString stringWithFormat:@"待发货%@",totalCount] atIndex:2];
                }else if ([_orderType isEqualToString:@"30"]){
                    [headTabbar setTitle:[NSString stringWithFormat:@"待收货%@",totalCount] atIndex:3];
                }else if ([_orderType isEqualToString:@"40"]){
                    [headTabbar setTitle:[NSString stringWithFormat:@"待评价%@",totalCount] atIndex:4];
                }else{
                    [headTabbar setTitle:[NSString stringWithFormat:@"全部%@",totalCount] atIndex:0];
                }
            }
            
            NSMutableArray *tmpArr = [[responseObject.result objectForKey:@"data"]mutableCopy];
            for (int i=0; i<tmpArr.count; i++) {
                
                NSMutableArray *arr = [[[tmpArr objectAtIndex:i]objectForKey:@"orderGoods"]mutableCopy];
                for (int j=0; j<arr.count; j++) {
                    orderGoodsModel *tmpModel = [[orderGoodsModel alloc]init];
                    tmpModel = [JsonStringTransfer dictionary:[arr objectAtIndex:j] ToModel:tmpModel];
                    if (![commonTools isNull:tmpModel.create_time]) {
                        tmpModel.isCommented = YES;
                    }
                    [arr replaceObjectAtIndex:j withObject:tmpModel];
                }
                [_orderGoodsArr addObject:arr];
                
                DMyOrderModel *myOrdersAjaxListModel = [[DMyOrderModel alloc]init];
                myOrdersAjaxListModel = [JsonStringTransfer dictionary:[tmpArr objectAtIndex:i] ToModel:myOrdersAjaxListModel];
                myOrdersAjaxListModel.buyNum = (int)arr.count;
                if (arr.count>1) {
                    for (int t=0; t<arr.count; t++) {
                        orderGoodsModel *model = [arr objectAtIndex:t];
                        if (![commonTools isNull:model.create_time]) {
                            myOrdersAjaxListModel.isCommented = YES;
                            break;
                        }
                    }
                }else {
                    orderGoodsModel *model = [arr objectAtIndex:0];
                    if ([commonTools isNull:model.create_time]) {
                        myOrdersAjaxListModel.isCommented = NO;
                    }else
                        myOrdersAjaxListModel.isCommented = YES;
                }
                [dataArray addObject:myOrdersAjaxListModel];
                
            }
            if (page >= [[responseObject.result objectForKey:@"totalPage"] intValue]) {
                isEnd = YES;
            }
//            double delayInSeconds = 1.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                
//            });
            [self.dMainTableView reloadData];
            _isFirst = NO;
            success(YES);
        }else
            showMessage(responseObject.msg);
        success(NO);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
        success(NO);
    }];
}
#pragma mark ----- tableview delegate && datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count == 0) {
        [self.noDataView setHidden:NO];
    }else{
        [self.noDataView setHidden:YES];
    }
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMyOrderCell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DMyOrderCell class]];
    for (UIView *tmpView in myCell.cellViewBg.subviews) {
        [tmpView removeFromSuperview];
    }
    if (indexPath.row == dataArray.count) {
        return myCell;
    }
    DMyOrderModel *mOrderModel = [dataArray objectAtIndex:indexPath.section];
    myCell.myOrderModel = mOrderModel;
    if (mOrderModel.buyNum > 1) {
        UIScrollView *imgScr = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 5, 280, 65)];
        imgScr.showsHorizontalScrollIndicator = NO;
        for (int i=0; i<mOrderModel.buyNum; i++) {
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(i*60+10*i, 2, 60, 60)];
            imgV.layer.cornerRadius = 6.0f;
            imgV.layer.masksToBounds = YES;
            orderGoodsModel *model = [[_orderGoodsArr objectAtIndex:indexPath.section]objectAtIndex:i];
            [imgV setImageWithURL:[commonTools getImgURL:model.goods_image] placeholderImage:DPlaceholderImage];
            [imgScr addSubview:imgV];
        }
        [imgScr setContentSize:CGSizeMake(myCell.myOrderModel.buyNum*70, 0)];
        [myCell.cellViewBg addSubview:imgScr];
    }else {
        DProductOrderCell *cellv = [DTools loadTableViewCell:self.dMainTableView cellClass:[DProductOrderCell class]];
        [cellv setFrame:DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT-24, 75)];
        cellv.orderGoodModel = [[_orderGoodsArr objectAtIndex:indexPath.section]objectAtIndex:0];
        [myCell.cellViewBg addSubview:cellv];
    }
    [myCell callBackBtnClicked:^(NSString *callBackStr) {
        _selectIndex = (int)indexPath.section;
        if ([callBackStr isEqualToString:@"取消订单"]) {
            NSLog(@"取消订单");
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要取消该订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertV.tag = 1;
            [alertV show];
        }
        if ([callBackStr isEqualToString:@"付款"]) {
            NSLog(@"付款");
            [self pay:mOrderModel withArr:[[_orderGoodsArr objectAtIndex:indexPath.section]mutableCopy]];
        }
        if ([callBackStr isEqualToString:@"删除订单"]) {
            NSLog(@"删除订单");
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要删除该订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertV.tag = 2;
            [alertV show];
        }
        if ([callBackStr isEqualToString:@"确认收货"]) {
            NSLog(@"确认收货");
            [self inputDaJiKePayPassword];
        }
        if ([callBackStr isEqualToString:@"查看物流"]) {
            NSLog(@"查看物流");
            [self getWuLiuDetail:mOrderModel];
        }
        if ([callBackStr isEqualToString:@"评价"]) {
            NSLog(@"评价");
            [self comment:mOrderModel.order_id withIndex:indexPath.section];
        }
        if ([callBackStr isEqualToString:@""]) {
            NSLog(@"点击cell");
            //代金券
            if ([mOrderModel.type isEqualToString:@"coupon"]) {
                DCouponOrderDetailViewController *indentDetailVC = [[DCouponOrderDetailViewController alloc]initWithNibName:nil bundle:nil];
                indentDetailVC.model = mOrderModel;
                indentDetailVC.couponArr = [[_orderGoodsArr objectAtIndex:indexPath.section]mutableCopy];
                __weak DMyOrderListViewController *weakSelf = self;
                [indentDetailVC callback:^{
                    [weakSelf refreshData:^(BOOL finish) {
                        
                    }];
                }];
                push(indentDetailVC);
            }else if ([mOrderModel.type isEqualToString:@"third_czk"]) {
                showMessage(@"该商品无订单详情");
            }else {
                //商品
                if (_orderGoodsArr.count == 0) {
                    return;
                }
                DOrderDetailViewController *vc = [[DOrderDetailViewController alloc]init];
                vc.productArr = [[_orderGoodsArr objectAtIndex:indexPath.section]mutableCopy];
                vc.model = [dataArray objectAtIndex:indexPath.section];
                __weak DMyOrderListViewController *weakSelf = self;
                [vc callback:^{
                    [weakSelf refreshData:^(BOOL finish) {
                        
                    }];
                }];
                push(vc);
            }
        }
    }];
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 取消订单
- (void)cancleOrder
{
    if (dataArray.count == 0) {
        return;
    }
    DMyOrderModel *orderListModel = dataArray[_selectIndex];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",orderListModel.order_id,@"orderId", @"buyer",@"type", nil];
    
    [DOrderOperation cancelOrder:parameter success:^{
        [self refreshData:^(BOOL finish) {
            
        }];
    }];
    
}
#pragma mark 删除订单
- (void)deleteOrder
{
    if (dataArray.count == 0) {
        return;
    }
    DMyOrderModel *orderListModel = dataArray[_selectIndex];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",orderListModel.order_id,@"orderIds", @"buyer",@"type", nil];
    [DOrderOperation deleteOrder:parameter success:^{
        _isFirst = YES;
        [self refreshData:^(BOOL finish) {
            
        }];
    }];
}
#pragma mark 付款
- (void)pay:(DMyOrderModel *)model withArr:(NSMutableArray *)arr
{
    DPayPlatFormViewController *vc = [[DPayPlatFormViewController alloc]init];
    vc.payJine = [NSString stringWithFormat:@"%.2f",[model.yueJine floatValue]];
    vc.orderSn = model.order_sn;
    vc.authUserId = model.authUserId;
    vc.authAppId = model.authAppId;
    vc.isChongzhiSelect = false;
    vc.isShouyiSelect = false;
    
    vc.orderId = model.order_id;
    vc.mArr = arr;
    NSMutableArray *aarr = [[NSMutableArray alloc]init];
    [aarr addObject:[NSString stringWithFormat:@"%@",model.order_sn]];
    vc.orderSnsArr = aarr;
    vc.buyType = MATERIRAL;
    vc.comeFrom = @"DMyOrderListViewController";
    vc.myOrderModel = model;
    push(vc);
}
#pragma mark 确认收货
- (void)confirmReceiveWithPassword:(NSString *)password
{
    if (dataArray.count == 0) {
        return;
    }
    DMyOrderModel *orderListModel = dataArray[_selectIndex];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",[DES3Util encrypt:orderListModel.order_id],@"orderId", [DES3Util encrypt:password],@"payPassword", nil];
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.confirmReceive" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            [self refreshData:^(BOOL finish) {
                
            }];
        }else{
            
        }
        [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark 查看物流
- (void)getWuLiuDetail:(DMyOrderModel *)model
{
    if ([commonTools isNull:model.invoice_no]) {
        showMessage(@"暂无物流信息");
        return;
    }
    NSArray *arr = [model.invoice_no componentsSeparatedByString:@"|"];
    DWebViewController *vc = [[DWebViewController alloc]init];
    vc.urlStr = [NSString stringWithFormat:@"type=%@&postid=%@",[arr firstObject],[arr lastObject]];
    vc.isHelp = 7;
    push(vc);
}
#pragma mark 评价
- (void)comment:(NSString *)orderId withIndex:(NSInteger)index
{
    NSMutableArray *commentArr = [[NSMutableArray alloc]init];
    if (_orderGoodsArr.count == 0) {
        return;
    }
    //筛选出还未评价的商品
    for (int i=0; i<[[_orderGoodsArr objectAtIndex:index]count]; i++) {
        
        orderGoodsModel *model = [[_orderGoodsArr objectAtIndex:index]objectAtIndex:i];
        if ([commonTools isNull:model.create_time]) {
            [commentArr addObject:model];
        }
    }
    DGoodCommetViewController *vc = [[DGoodCommetViewController alloc]init];
    vc.productAarry = [commentArr mutableCopy];
    vc.orderId = orderId;
    [vc callBack:^{
//        _isFirst = YES;
//        [self refreshData:^(BOOL finish) {
//            
//        }];
        [_orderGoodsArr removeObjectAtIndex:index];
        [dataArray removeObjectAtIndex:index];
//        [headTabbar setTitle:[NSString stringWithFormat:@"待评价%@",totalCount] atIndex:4];
        [self.dMainTableView reloadData];
    }];
    push(vc);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 1) {
            [self cancleOrder];
        }else if (alertView.tag == 2) {
            [self deleteOrder];
        }
    }
}

//确认收货需要支付密码
- (void)inputDaJiKePayPassword
{
    PayPopView *vv = [[PayPopView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT)];
    vv.tag = 8008;
    vv.jineLb.text = @"请确保您已收到货物";
    vv.backgroundColor = [UIColor clearColor];
    
    __weak DMyOrderListViewController *weakSelf = self;
    [vv.mimaLb callbackClickedLb:^(MyClickLb *clickLb) {
        NSLog(@"忘记密码");
        //找回密码
        DVerifyPhoneNumViewController *vc = [[DVerifyPhoneNumViewController alloc]initWithNibName:@"DVerifyPhoneNumViewController" bundle:nil];
        vc.verigyTape = password2_verify;
        NSDictionary *userInfoDic = [[NSDictionary alloc]init];
        userInfoDic = [[FileOperation readFileToDictionary:dajikeUser]mutableCopy];
        UserInfoModel *model = [[UserInfoModel alloc]init];
        model = [JsonStringTransfer dictionary:userInfoDic ToModel:model];
        vc.userModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [vv callbackHidden:^(int flag,NSString *password){
        if (flag == 0) {
            [UIView animateWithDuration:0.25f animations:^{
                vv.alpha = 0.1f;
            } completion:^(BOOL finished) {
                [vv setHidden:YES];
            }];
        }
        if (flag == 1) {
            [weakSelf checkPayPassword:password];
            NSLog(@"支付吧--____%@",password);
        }
    }];
    [self.view addSubview:vv];
}
//校验支付密码
- (void)checkPayPassword:(NSString *)password
{
    NSDictionary *dic = @{@"userId":get_userId,@"password":[DES3Util encrypt:password]};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.validatePassword" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"____校验支付密码：%@",responseObject.result);
            
            PayPopView *vv = (PayPopView *)[self.view viewWithTag:8008];
            if (vv) {
                [UIView animateWithDuration:0.25f animations:^{
                    
                    vv.alpha = 0.1f;
                    [vv setHidden:YES];
                } completion:^(BOOL finished) {
                    
                }];
            }
            [self confirmReceiveWithPassword:password];
        }
        else
        {
            [ProgressHUD showMessage:@"密码错误" Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

#pragma mark------
#pragma mark------PYTabbarDelegate--------
- (void)filterView:(PYTabbar *)filterView didSelectedAtIndex:(NSInteger)index
{
//    [self.mainTabview setEditing:NO animated:YES];
//    [self.mainTabview performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    switch (index) {
        case 0:
            _orderType = @"";//<null>
            break;
        case 1:
            _orderType = @"11";
            break;
        case 2:
            _orderType = @"10";
            break;
        case 3:
            _orderType = @"30";
            break;
        case 4:
            _orderType = @"40";
            break;
        default:
            break;
    }
    _isFirst = YES;
    [self refreshData:^(BOOL finish) {
        
    }];
    
}

//If the delegate implement this method it can return a custom animation speed for the hide/unhide
- (CGFloat)filterViewDisplayAnimatioSpeed:(PYTabbar *)filterView
{
    return 0.20;
    //     NSLog(@"ss2");
}
//If the delegate implement this methid it can return a custom animation speed for the selection
- (CGFloat)filterViewSelectionAnimationSpeed:(PYTabbar *)filterView
{
    return 0.20;
    //     NSLog(@"s3");
}
//Implement this method to know when the selection animation begin
- (void)filterViewSelectionAnimationDidBegin:(PYTabbar *)filterView
{
    //    NSLog(@"ss4");
    
}
//Implement this method to know when the selection animation end
- (void)filterViewSelectionAnimationDidEnd:(PYTabbar *)filterView
{
    //     NSLog(@"ss5");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---------MJRefresh---------

//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        showMessage(@"加载完成");
        success (YES);
    }else{
        [self getData:^(BOOL finish) {
            success(finish);
        }];
    }
    
}

//刷新数据
- (void) refreshData:(void (^)(BOOL finish))success
{
    //重新加载数据。一切都重新初始化
    [self.footer resetNoMoreData];
    [dataArray removeAllObjects];
    dataArray = nil;
    dataArray = [[NSMutableArray alloc]init];
    page = 0;
    isEnd = NO;
    [_orderGoodsArr removeAllObjects];
    _orderGoodsArr = nil;
    _orderGoodsArr = [[NSMutableArray alloc]init];
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
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

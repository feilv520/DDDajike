//
//  DProductBuySuccessViewController.m
//  dajike
//
//  Created by swb on 15/7/22.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DProductBuySuccessViewController.h"
#import "dDefine.h"
#import "SWBTabBarController.h"
#import "SWBTabBar.h"
#import "DTabView.h"
//cell
#import "DBuySuccessCell.h"
#import "DOrderAddressCell.h"
#import "DBuySeccess1Cell.h"
//model
#import "OrdersDetailModel.h"
//controller
#import "DOrderDetailViewController.h"
#import "DMyOrderListViewController.h"

@interface DProductBuySuccessViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    OrdersDetailModel *_orderDetailModel;
    UIButton *_btn;
}

@end

@implementation DProductBuySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"购买成功"];
    self.view.backgroundColor = DColor_f6f1ef;
    _orderDetailModel = [[OrdersDetailModel alloc]init];
    [self addTableView:NO];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    [self initCreateBottomFooterView];
    if ([self.comeFrom isEqualToString:@"DMyOrderListViewController"]) {
        [self getOrderDetail];
    }
//
}
//获取订单详情
- (void)getOrderDetail
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",_orderId,@"orderId", @"buyer",@"type", nil];
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.detail" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            _orderDetailModel = [JsonStringTransfer dictionary:responseObject.result ToModel:_orderDetailModel];
            [self.dMainTableView reloadData];
        }else
            showMessage(responseObject.msg);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//初始化创建底部按钮
- (void)initCreateBottomFooterView
{
    UIView *viewBg = [self.view createViewWithFrame:DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT, 100) andBackgroundColor:DColor_Clear];
    
    _btn = [self.view createButtonWithFrame:DRect(DWIDTH_CONTROLLER_DEFAULT/2-140, 30, 120, 40) andBackImageName:nil andTarget:self andAction:@selector(btnClicked:) andTitle:@"订单详情" andTag:909];
    if (self.orderSnsArr.count > 1) {
        [_btn setTitle:@"我的订单" forState:UIControlStateNormal];
    }else
        [_btn setTitle:@"订单详情" forState:UIControlStateNormal];
    _btn.backgroundColor = DColor_c4291f;
    [_btn setTitleColor:DColor_White forState:UIControlStateNormal];
    _btn.layer.cornerRadius = 5.0f;
    _btn.layer.masksToBounds = YES;
    _btn.titleLabel.font = DFont_15b;
    [viewBg addSubview:_btn];
    
    UIButton *btn2 = [self.view createButtonWithFrame:DRect(DWIDTH_CONTROLLER_DEFAULT/2+20, 30, 120, 40) andBackImageName:nil andTarget:self andAction:@selector(btnClicked:) andTitle:@"去首页逛逛" andTag:910];
    btn2.backgroundColor = DColor_c4291f;
    [btn2 setTitleColor:DColor_White forState:UIControlStateNormal];
    btn2.layer.cornerRadius = 5.0f;
    btn2.layer.masksToBounds = YES;
    btn2.titleLabel.font = DFont_15b;
    [viewBg addSubview:btn2];
    
    self.dMainTableView.tableFooterView = viewBg;
}
- (void)btnClicked:(UIButton *)btn
{
    if (btn.tag == 909) {
        //去订单详情
        //商品
        if (self.orderSnsArr.count > 1) {
            DMyOrderListViewController *vc = [[DMyOrderListViewController alloc]init];
            vc.type = DAI_FA_HUO;
            push(vc);
        }else {
            DOrderDetailViewController *vc = [[DOrderDetailViewController alloc]init];
            vc.buyNumSt = self.buyNumSt;
            vc.goodsDetailModel = self.goodDetailModel;
            vc.model = self.myOrderModel;
            vc.orderIdStr = self.orderId;
            vc.productArr = self.mArr;
            [vc callback:^{
                NSLog(@"石头人");
            }];
            push(vc);
        }
    }
    if (btn.tag == 910) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        //去首页逛逛
        SWBTabBarController *tabBarVC = [SWBTabBarController sharedManager];
//        tabBarVC.myView.selectView.tabImgView.image = [UIImage imageNamed:@"djk_index_05"];
//        tabBarVC.myView.selectView.tabLb.textColor = DColor_tabbarTextW;
        tabBarVC.myView.hidden = NO;
        tabBarVC.selectedIndex = 0;
//        DTabView *tabV = tabBarVC.myView.subviews[0];
//        tabV.tabImgView.image = [UIImage imageNamed:@"djk_index_02"];
//        tabV.tabLb.textColor = DColor_c4291f;
//        tabBarVC.myView.selectView = tabV;
    }
}

#pragma mark  tableView  delegate  &&  dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 90;
    }
    if (indexPath.row == 1) {
        return 70;
    }
    if (indexPath.row == 2) {
        return self.orderSnsArr.count*30+30;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DBuySuccessCell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DBuySuccessCell class]];
        if (self.getType == DUI_HUAN) {
            myCell.titleLb.text = @"恭喜您兑换成功！";
        }else
            myCell.titleLb.text = @"恭喜您够买成功！";
        
        return myCell;
    }
    if (indexPath.row == 1) {
        DOrderAddressCell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DOrderAddressCell class]];
        if ([self.comeFrom isEqualToString:@"DMyOrderListViewController"]) {
            myCell.model = _orderDetailModel;
        }else
            myCell.addressModel = self.addressModel;
//
        return myCell;
    }
    if (indexPath.row == 2) {
        DBuySeccess1Cell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DBuySeccess1Cell class]];
        for (UIView *tmpV in myCell.orderSnView.subviews) {
            [tmpV removeFromSuperview];
        }
        if ([self.comeFrom isEqualToString:@"DMyOrderListViewController"]) {
            myCell.model = _orderDetailModel;
        }else {
            if (self.getType == DUI_HUAN) {
                myCell.flag = @"duihuan";
            }
            myCell.allMoney = self.allMoney;
            myCell.orderSnArr = self.orderSnsArr;
        }
//
        return myCell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

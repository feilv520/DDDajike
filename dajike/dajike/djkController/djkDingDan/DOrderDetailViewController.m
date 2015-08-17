//
//  DOrderDetailViewController.m
//  dajike
//
//  Created by swb on 15/7/16.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DOrderDetailViewController.h"
#import "dDefine.h"
#import "MyClickLb.h"
#import "DOrderOperation.h"
#import "PayPopView.h"
#import "defines.h"
//cell
#import "DOrderFirstCell.h"
#import "DOrderAddressCell.h"
#import "DOrderSecondCell.h"
#import "DProductOrderCell.h"
#import "DOrderThirdCell.h"
#import "DOrderLastCell.h"
#import "DOrderFourthCell.h"
//model
#import "OrdersDetailModel.h"
#import "orderGoodsModel.h"
#import "UserInfoModel.h"
//controller
#import "DGoodCommetViewController.h"   //商品评价
#import "DVerifyPhoneNumViewController.h"//忘记密码
#import "DWebViewController.h"          //商品详情
#import "DSJShouYeViewController.h"     //进入店铺
#import "DPayPlatFormViewController.h"  //支付平台

//宏
#define BTN_WIDTH 90
#define BTN_HEIGHT 35
#define BTN_INTERVAL ((DWIDTH_CONTROLLER_DEFAULT-(BTN_WIDTH*3))/4)

#define ONE_BTN ((DWIDTH_CONTROLLER_DEFAULT-BTN_WIDTH)/2)
#define TWO_BTN (DWIDTH_CONTROLLER_DEFAULT/2-BTN_WIDTH-BTN_INTERVAL/2)

@interface DOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    OrdersDetailModel *_orderDetailModel;
    orderGoodsModel *_orderGoodsModel;
    //屏幕底部的按钮
    MyClickLb *lbLeft;
    MyClickLb *lbCenter;
    MyClickLb *lbRight;
    NSString *_orderId;
    
    int _isJiFen;
}

@end

@implementation DOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"订单详情"];
    _orderId = @"";
    _isJiFen = 0;
    [self addTableView:NO];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    _orderDetailModel = [[OrdersDetailModel alloc]init];
    _orderGoodsModel = [[orderGoodsModel alloc]init];
    self.dMainTableView.frame = DRect(0, 44, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT-50);
    [self initBottomBtnUI];
    if ([commonTools isNull:self.orderIdStr]) {
        _orderId = self.model.order_id;
    }else
        _orderId = self.orderIdStr;
    
    if (self.productArr.count == 1) {
        if ([[self.productArr objectAtIndex:0] isKindOfClass:[orderGoodsModel class]]) {
            _orderGoodsModel = [self.productArr objectAtIndex:0];
            _isJiFen = [_orderGoodsModel.if_jifen intValue];
        }
    }
    
    [self getData];
}
- (void)getData
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",_orderId,@"orderId", @"buyer",@"type", nil];
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.detail" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            _orderDetailModel = [JsonStringTransfer dictionary:responseObject.result ToModel:_orderDetailModel];
            [self setBottomLbFrame];
            [self.dMainTableView reloadData];
        }else
            showMessage(responseObject.msg);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//界面底部btn
- (void)initBottomBtnUI
{
    UIView *viewBg = [self.view createViewWithFrame:DRect(0, DHEIGHT_CONTROLLER_DEFAULT-50, DWIDTH_CONTROLLER_DEFAULT, 50) andBackgroundColor:DColor_White];
    viewBg.userInteractionEnabled = YES;
    [self.view addSubview:viewBg];
    
    UIView *lineV = [self.view createViewWithFrame:DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT, 0.5) andBackgroundColor:DColor_line_bg];
    [viewBg addSubview:lineV];
    
    lbLeft = [self createLbTitle];
    lbLeft.frame = DRect(ONE_BTN, 7, BTN_WIDTH, BTN_HEIGHT);
    lbCenter = [self createLbTitle];
    lbRight = [self createLbTitle];
    
//    [self setBottomLbFrame];
    
    __weak DOrderDetailViewController *weakSelf = self;
    [lbLeft callbackClickedLb:^(MyClickLb *clickLb) {
        [weakSelf checkClickLbTitle:clickLb.text];
    }];
    [lbCenter callbackClickedLb:^(MyClickLb *clickLb) {
        [weakSelf checkClickLbTitle:clickLb.text];
    }];
    [lbRight callbackClickedLb:^(MyClickLb *clickLb) {
        [weakSelf checkClickLbTitle:clickLb.text];
    }];
    [viewBg addSubview:lbLeft];
    [viewBg addSubview:lbCenter];
    [viewBg addSubview:lbRight];
}

//集成创建底部控件
- (MyClickLb *)createLbTitle
{
    MyClickLb *lb = [[MyClickLb alloc]initWithFrame:CGRectMake(0, 0, BTN_WIDTH, BTN_HEIGHT)];
    lb.layer.cornerRadius = 3.0f;
    lb.layer.masksToBounds = YES;
    lb.layer.borderColor = DColor_line_bg.CGColor;
    lb.layer.borderWidth = 0.8f;
    lb.font = [UIFont systemFontOfSize:13.0f];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = DColor_666666;
    return lb;
}
//动态设定底部控件frame
- (void)setBottomLbFrame
{
    lbCenter.hidden = NO;
    lbRight.hidden = NO;
    lbCenter.textColor = DColor_666666;
    lbCenter.textColor = DColor_666666;
    lbCenter.backgroundColor = DColor_Clear;
    lbRight.backgroundColor = DColor_Clear;
    switch ([_orderDetailModel.status intValue]) {
        case 0:{
            lbLeft.text = @"删除订单";
            lbCenter.hidden = YES;
            lbRight.hidden = YES;}
            break;
        case 10:{
            lbLeft.text = @"取消订单";
            lbCenter.hidden = YES;
            lbRight.hidden = YES;}
            break;
        case 11:{
            lbLeft.text = @"取消订单";
            lbLeft.frame = DRect(TWO_BTN, 7, BTN_WIDTH, BTN_HEIGHT);
            lbCenter.text = @"付款";
            lbCenter.textColor = DColor_White;
            lbCenter.backgroundColor = DColor_c4291f;
            lbRight.hidden = YES;}
            break;
        case 20:{
            lbLeft.text = @"取消订单";
            lbCenter.hidden = YES;
            lbRight.hidden = YES;}
            break;
        case 30:{
            lbLeft.text = @"查看物流";
            lbLeft.frame = DRect(TWO_BTN, 7, BTN_WIDTH, BTN_HEIGHT);
            lbCenter.text = @"确认收货";
            lbRight.hidden = YES;}
            break;
        case 40:{
            if (self.model.isCommented) {
                lbLeft.text = @"删除订单";
                lbLeft.frame = DRect(TWO_BTN, 7, BTN_WIDTH, BTN_HEIGHT);
                lbCenter.text = @"查看物流";
                lbRight.hidden = YES;
            }else {
                lbLeft.text = @"删除订单";
                lbLeft.frame = DRect(BTN_INTERVAL, 7, BTN_WIDTH, BTN_HEIGHT);
                lbCenter.text = @"查看物流";
                lbRight.text = @"评价";
                lbRight.textColor = DColor_White;
                lbRight.backgroundColor = DColor_c4291f;
            }}
            break;
            
        default:
            break;
    }
    lbCenter.frame = DRect(CGRectGetMaxX(lbLeft.frame)+BTN_INTERVAL, CGRectGetMinY(lbLeft.frame), BTN_WIDTH, BTN_HEIGHT);
    lbRight.frame = DRect(CGRectGetMaxX(lbCenter.frame)+BTN_INTERVAL, CGRectGetMinY(lbLeft.frame), BTN_WIDTH, BTN_HEIGHT);
}
//动态设定按钮事件
- (void)checkClickLbTitle:(NSString *)lbTitle
{
    if ([lbTitle isEqualToString:@"取消订单"]) {
        NSLog(@"取消订单");
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要取消该订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertV.tag = 1;
        [alertV show];
    }
    if ([lbTitle isEqualToString:@"删除订单"]) {
        NSLog(@"删除订单");
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要删除该订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertV.tag = 2;
        [alertV show];
    }
    if ([lbTitle isEqualToString:@"付款"]) {
        NSLog(@"付款");
        [self pay];
    }
    if ([lbTitle isEqualToString:@"查看物流"]) {
        NSLog(@"查看物流");
        if ([commonTools isNull:self.model.invoice_no]) {
            showMessage(@"暂无物流信息");
            return;
        }
        NSArray *arr = [self.model.invoice_no componentsSeparatedByString:@"|"];
        DWebViewController *vc = [[DWebViewController alloc]init];
        vc.urlStr = [NSString stringWithFormat:@"type=%@&postid=%@",[arr firstObject],[arr lastObject]];
        vc.isHelp = 7;
        push(vc);
    }
    if ([lbTitle isEqualToString:@"确认收货"]) {
        NSLog(@"确认收货");
        [self inputDaJiKePayPassword];
    }
    if ([lbTitle isEqualToString:@"评价"]) {
        NSLog(@"评价");
        //筛选出未评价的商品
        NSMutableArray *commentGoodsArr = [[NSMutableArray alloc]init];
        for (int i =0; i<self.productArr.count; i++) {
            orderGoodsModel *model = [self.productArr objectAtIndex:i];
            if ([commonTools isNull:model.create_time]) {
                [commentGoodsArr addObject:model];
            }
        }
        DGoodCommetViewController *vc = [[DGoodCommetViewController alloc]init];
        vc.productAarry = [commentGoodsArr mutableCopy];
        vc.orderId = _orderId;
        [vc callBack:^{
            [self getData];
            [self setBottomLbFrame];
        }];
        push(vc);
    }
}

#pragma mark tableView datasource  &&  delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isJiFen==0 && [self.goodsDetailModel.ifJifen intValue] == 0) {
        return 5+self.productArr.count;
    }else
        return 4+self.productArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120;
    }else if (indexPath.row == 1) {
        return 70;
    }else if (indexPath.row == 2) {
        return 40;
    }else if (indexPath.row >= 3 && indexPath.row < self.productArr.count+3) {
        return 75;
    }else if (indexPath.row == self.productArr.count+3) {
        if (_isJiFen==0 && [self.goodsDetailModel.ifJifen intValue] == 0) {
            return 160;
        }else
            return 65;
    }else if (indexPath.row == self.productArr.count+4) {
        return 100;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DOrderFirstCell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DOrderFirstCell class]];
        myCell.ifJiFen = _isJiFen;
        myCell.goodsDetailModel = self.goodsDetailModel;
        myCell.model = _orderDetailModel;
        return myCell;
    }
    if (indexPath.row == 1) {
        DOrderAddressCell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DOrderAddressCell class]];
        myCell.model = _orderDetailModel;
        return myCell;
    }
    if (indexPath.row == 2) {
        DOrderSecondCell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DOrderSecondCell class]];
        if (self.model != nil) {
            myCell.model = self.model;
        }
        if (self.goodsDetailModel != nil) {
            myCell.goodsDetailModel = self.goodsDetailModel;
        }
        myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return myCell;
    }
    if (indexPath.row >= 3 && indexPath.row < self.productArr.count+3) {
        DProductOrderCell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DProductOrderCell class]];
        if ([[self.productArr objectAtIndex:indexPath.row-3] isKindOfClass:[orderGoodsModel class]]) {
            myCell.orderGoodModel = [self.productArr objectAtIndex:indexPath.row-3];
        }
        if ([[self.productArr objectAtIndex:indexPath.row-3] isKindOfClass:[DGoodsDetailModel class]]) {
            DGoodsDetailModel *model = [self.productArr objectAtIndex:indexPath.row-3];
            myCell.buyNum = self.buyNumSt;
            myCell.goodsDetailModel = model;
        }
        return myCell;
    }
    if (indexPath.row == self.productArr.count+3) {
        if (_isJiFen==0 && [self.goodsDetailModel.ifJifen intValue] == 0) {
            DOrderThirdCell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DOrderThirdCell class]];
            myCell.orderDetailModel = _orderDetailModel;
            return myCell;
        }else {
            DOrderFourthCell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DOrderFourthCell class]];
            myCell.model = _orderDetailModel;
            return myCell;
        }
    }
    if (indexPath.row == self.productArr.count+4) {
        DOrderLastCell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DOrderLastCell class]];
        myCell.model = _orderDetailModel;
        return myCell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        DSJShouYeViewController *vc = [[DSJShouYeViewController alloc] init];
        vc.storeId = [NSString stringWithFormat:@"%@",_orderDetailModel.storeId];
        push(vc);
    }
    if (indexPath.row >= 3 && indexPath.row < self.productArr.count+3) {
        NSLog(@"跳转到该商品页");
        //跳商品详情
        DWebViewController *vc = [[DWebViewController alloc]init];
        vc.isHelp = 6;
        if ([[self.productArr objectAtIndex:indexPath.row-3] isKindOfClass:[orderGoodsModel class]]) {
            orderGoodsModel *orderGoodsModel = [self.productArr objectAtIndex:indexPath.row-3];
            vc.urlStr = [NSString stringWithFormat:@"goodsId=%d&userId=%@",[orderGoodsModel.goods_id intValue],get_userId];
            vc.imageUrl = [NSString stringWithFormat:@"%@",orderGoodsModel.goods_image];
            vc.googsTitle = [NSString stringWithFormat:@"%@",orderGoodsModel.goods_name];
        }
        if ([[self.productArr objectAtIndex:indexPath.row-3] isKindOfClass:[DGoodsDetailModel class]]) {
            DGoodsDetailModel *model = [self.productArr objectAtIndex:indexPath.row-3];
            vc.urlStr = [NSString stringWithFormat:@"goodsId=%d&userId=%@",[model.goodsId intValue],get_userId];
            vc.imageUrl = [NSString stringWithFormat:@"%@",model.goodsDefaultImage];
            vc.googsTitle = [NSString stringWithFormat:@"%@",model.goodsName];
        }
        push(vc);
    }
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
//取消订单
- (void)cancleOrder
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",_orderId,@"orderId", @"buyer",@"type", nil];
    [DOrderOperation cancelOrder:parameter success:^{
        self.block();
        pop();
    }];
}
//删除订单
- (void)deleteOrder
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",_orderId,@"orderIds", @"buyer",@"type", nil];
    [DOrderOperation deleteOrder:parameter success:^{
        self.block();
        pop();
    }];
}
//确认收货
#pragma mark 确认收货
- (void)confirmReceiveWithPassword:(NSString *)password
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:get_userId,@"userId",[DES3Util encrypt:_orderId],@"orderId", [DES3Util encrypt:password],@"payPassword", nil];
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.confirmReceive" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            self.block();
            pop();
        }else{
            
        }
        [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark 付款
- (void)pay
{
    DPayPlatFormViewController *vc = [[DPayPlatFormViewController alloc]init];
    vc.payJine = [NSString stringWithFormat:@"%.2f",[self.model.yueJine floatValue]];
    vc.orderSn = self.model.order_sn;
    vc.authUserId = self.model.authUserId;
    vc.authAppId = self.model.authAppId;
    vc.isChongzhiSelect = false;
    vc.isShouyiSelect = false;
    
    vc.orderId = self.model.order_id;
    vc.mArr = self.productArr;
    NSMutableArray *aarr = [[NSMutableArray alloc]init];
    [aarr addObject:[NSString stringWithFormat:@"%@",self.model.order_sn]];
    vc.orderSnsArr = aarr;
    vc.buyType = MATERIRAL;
    vc.comeFrom = @"DMyOrderListViewController";
    vc.myOrderModel = self.model;
    push(vc);
}
//确认收货需要支付密码
- (void)inputDaJiKePayPassword
{
    PayPopView *vv = [[PayPopView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT)];
    vv.tag = 8008;
    vv.jineLb.text = @"请确保您已收到货物";
    vv.backgroundColor = [UIColor clearColor];
    
    __weak DOrderDetailViewController *weakSelf = self;
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

- (void)callback:(CallbackToDMyOrderListViewController)block
{
    self.block = block;
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

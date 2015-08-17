//
//  NewIndentViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 **   类：支付方式
 */

#import "NewIndentViewController.h"
#import "defines.h"
#import "BuySuccessViewController.h"
#import "BuySucceedViewController.h"
#import "PayView.h"
#import "WXApi.h"
#import "OrdersDetailModel.h"

@interface NewIndentViewController ()
{
    NSMutableDictionary *_mDic;
    OrdersDetailModel *_ordersDetailModel;
}

@end

@implementation NewIndentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    titleLabel.text = @"支付平台";
    
    self.payBtn.layer.cornerRadius = 3.0f;
    self.payBtn.layer.masksToBounds = YES;
    _mDic = [[NSMutableDictionary alloc]init];
    
    self.delegate = self;
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    self.moneyLb.text = self.payJine;
    
    //注册通知 微信支付成功后执
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buyProductSuccess:) name:@"buySuccess" object:nil];
    
    if (self.order_id != nil){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //获取订单详情信息
            [self myOrdersDetail];
            
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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


// 判断支付方式
- (NSString *)checkPayTypeHas:(BOOL)payType
{
    if (payType) {
        return @"true";
    }else
        return @"false";
}


- (void)pay
{
    NSLog(@"%@;%@;%@",self.dingdaoModel.orderSns,self.dingdaoModel.authUserId,self.dingdaoModel.authAppId);
    NSDictionary *dic = @{@"orderSns":self.dingdaoModel.orderSns,@"shouyi":[self checkPayTypeHas:self.isShouyiSelect],@"chongzhi":[self checkPayTypeHas:self.isChongzhiSelect],@"authUserId":self.dingdaoModel.authUserId,@"authAppId":self.dingdaoModel.authAppId,@"payChannelId":@"4"};
    
    PayView *payV = [[PayView alloc]initWithFrame:CGRectMake(0, 0, 0.5, 0.5)];
    [payV payRequestWithParam:dic ifAddActivityIndicator:NO success:^(id ret) {
        NSLog(@"%@",ret);
        
        if ([[ret objectForKey:@"result_code"]intValue] == 200) {
            
            _mDic = [[ret objectForKey:@"data"]mutableCopy];
            
            [self wxPay];
            
        }
        else
        {
            if ([[ret objectForKey:@"msg"]length] == 0) {
                [ProgressHUD showMessage:@"支付失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:[ret objectForKey:@"msg"] Width:100 High:80];
        }
        
        
    }];
    [self.view addSubview:payV];
}

- (void)wxPay
{
    //构造支付请求
    PayReq *request = [[PayReq alloc]init];
    request.partnerId = [_mDic objectForKey:@"partnerid"];
    request.prepayId = [_mDic objectForKey:@"prepayid"];
    request.package = [_mDic objectForKey:@"package"];
    request.nonceStr = [_mDic objectForKey:@"noncestr"];
    request.timeStamp = [[_mDic objectForKey:@"timestamp"] intValue];
    request.sign = [_mDic objectForKey:@"sign"];
    
    [WXApi sendReq:request];
}

- (IBAction)paySuccessAction:(id)sender {
    
    [self pay];
    
}
//购买商品，支付成功后从Delegate毁掉执行
- (void)buyProductSuccess:(NSNotification *)notify
{
    //购买商品
    if ([self.buyType intValue] == 1) {
        BuySucceedViewController *vc = [[BuySucceedViewController alloc]init];
        vc.flagstr = @"1";
        vc.goodsName = self.goodsName;
        vc.money = self.money;
        vc.arr = self.arr;
        vc.model = self.model;
        vc.yunfei = self.yunfei;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //购买代金券
    if ([self.buyType intValue] == 2) {
        BuySuccessViewController *vc = [[BuySuccessViewController alloc]init];
        vc.arr = [self.arr mutableCopy];
        vc.goodName = self.goodsName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //移除
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"buySuccess" object:nil];
}

- (IBAction)selectPayAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 2) {
        self.img1.image = [UIImage imageNamed:@"img_box_02"];
        self.img2.image = [UIImage imageNamed:@"img_box_01"];
        self.img3.image = [UIImage imageNamed:@"img_box_01"];
    }
    if (btn.tag == 3) {
        [ProgressHUD showMessage:@"该支付方式尚不支持" Width:100 High:80];
        return;
//        self.img1.image = [UIImage imageNamed:@"img_box_01"];
//        self.img2.image = [UIImage imageNamed:@"img_box_02"];
//        self.img3.image = [UIImage imageNamed:@"img_box_01"];
    }
    if (btn.tag == 4) {
        [ProgressHUD showMessage:@"该支付方式尚不支持" Width:100 High:80];
        return;
//        self.img1.image = [UIImage imageNamed:@"img_box_01"];
//        self.img2.image = [UIImage imageNamed:@"img_box_01"];
//        self.img3.image = [UIImage imageNamed:@"img_box_02"];
    }
}

//订单详情
- (void)myOrdersDetail{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId], @"userId",self.order_id,@"orderId",  @"buyer",@"type",nil];
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.detail" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSDictionary *detailDict = responseObject.result;
            NSMutableDictionary *dict0 = [NSMutableDictionary dictionaryWithDictionary:detailDict];
            NSDictionary *dict = [[detailDict objectForKey:@"orderGoods"]objectAtIndex:0];
            NSArray *keyArr = [dict allKeys];
            for ( NSString *key in keyArr) {
                [dict0 setValue:[dict objectForKey:key] forKey:key];
            }
            [dict0 removeObjectForKey:@"orderGoods"];
            _ordersDetailModel = [[OrdersDetailModel alloc]init];
            _ordersDetailModel = [JsonStringTransfer dictionary:detailDict ToModel:_ordersDetailModel];
            
            self.goodsName = _ordersDetailModel.goodsName;
            self.yunfei = _ordersDetailModel.shippingFee;
            
            NSDictionary *modelDict = [NSDictionary dictionaryWithObjectsAndKeys:_ordersDetailModel.consignee,@"consignee",_ordersDetailModel.regionName,@"regionName",_ordersDetailModel.phoneMob,@"phoneMob", _ordersDetailModel.address,@"address",nil];
            MyAddressModel *addressModel = [[MyAddressModel alloc]init];
            addressModel = [JsonStringTransfer dictionary:modelDict ToModel:addressModel];
            self.model = addressModel;
            
            NSString *spec_1 = [NSString stringWithFormat:@"%@:%@",_ordersDetailModel.specName1,_ordersDetailModel.spec1];
            NSString *spec_2 = [NSString stringWithFormat:@"%@:%@",_ordersDetailModel.specName2,_ordersDetailModel.spec2];
            NSDictionary *typeDict = [NSDictionary dictionaryWithObjectsAndKeys:_ordersDetailModel.quantity,@"goodsNumber",spec_1,@"spec_1",spec_2,@"spec_2", nil];
            self.arr = [NSMutableArray arrayWithObject:typeDict];
            
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

@end

//
//  DPayPlatFormViewController.m
//  dajike
//
//  Created by swb on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DPayPlatFormViewController.h"
#import "dDefine.h"
#import "PayView.h"
#import "WXApi.h"
#import "DGouWuCheOperation.h"
#import "DProductBuySuccessViewController.h"

@interface DPayPlatFormViewController ()
{
    NSMutableDictionary *_mDic;
}

@end

@implementation DPayPlatFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviBarTitle:@"支付平台"];
    _mDic = [[NSMutableDictionary alloc]init];
    self.payBtn.layer.cornerRadius = 3.0f;
    self.payBtn.layer.masksToBounds = YES;
    
    self.payMoneyLb.text = self.payJine;
    CGRect rect = [self.view contentAdaptionLabel:self.payMoneyLb.text withSize:CGSizeMake(500, 28) withTextFont:18.0f];
    self.payMoneyCon.constant = rect.size.width+5;
    //注册通知 微信支付成功后执
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buyProductSuccess:) name:@"DJKbuySuccess" object:nil];
}

//购买商品，支付成功后从Delegate毁掉执行
- (void)buyProductSuccess:(NSNotification *)notify
{
    //购买商品
    if (self.buyType == MATERIRAL) {
        DProductBuySuccessViewController *vc = [[DProductBuySuccessViewController alloc]init];
        vc.orderId = self.orderId;
        vc.allMoney = self.allMoney;
        vc.orderSnsArr = self.orderSnsArr;
        vc.addressModel = self.addressModel;
        vc.goodDetailModel = self.goodDetailModel;
        vc.myOrderModel = self.myOrderModel;
        vc.mArr = self.mArr;
        vc.comeFrom = self.comeFrom;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //购买代金券
    if (self.buyType == COUPON) {
        
    }
    if (self.deleteArr.count>0) {
        [DGouWuCheOperation deleteGouWuCheProducts:self.deleteArr];
    }
    //移除
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"DJKbuySuccess" object:nil];
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
    NSDictionary *dic = @{@"orderSns":self.orderSn,@"shouyi":[self checkPayTypeHas:self.isShouyiSelect],@"chongzhi":[self checkPayTypeHas:self.isChongzhiSelect],@"authUserId":self.authUserId,@"authAppId":self.authAppId,@"payChannelId":@"4"};
    
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


- (IBAction)payAction:(id)sender {
    [self pay];
}
@end

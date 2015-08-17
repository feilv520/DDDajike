//
//  DConfirmOrderViewController.m
//  dajike
//
//  Created by swb on 15/7/22.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DConfirmOrderViewController.h"
#import "dDefine.h"
#import "defines.h"
#import "ShouYiBiLiPayObject.h"
#import "PayPopView.h"
#import "PayView.h"
#import "DGouWuCheOperation.h"
//cell
#import "DOrderAddressCell.h"
#import "DConfirmOrder1Cell.h"
#import "DConfirmOrder2Cell.h"
#import "DConfirmOrder3Cell.h"
#import "DConfirmOrder4Cell.h"
#import "DProductOrderCell.h"
//model
#import "MyAddressModel.h"
#import "AccountOverViewModel.h"
#import "CreateDingDanModel.h"
#import "DGoodsDetailModel.h"
#import "UserInfoModel.h"
//controller
#import "DMyAddressListAndSafeViewController.h"//地址列表
#import "DPayPlatFormViewController.h"//支付平台
#import "DVerifyPhoneNumViewController.h"//忘记密码
#import "DProductBuySuccessViewController.h"//购买成功
#import "DProductQingDanViewController.h"//商品清单
#import "DWebViewController.h"//商品详情

@interface DConfirmOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel     *_moneyLb;//实付款
    UILabel     *_yunfeiLb;//运费
    MyAddressModel  *_addressModel;
    AccountOverViewModel *_accountModel;
    CreateDingDanModel  *_dingdanModel;
    BOOL        _isSelectAddress;
    float       _shouyiPay; //收益比例
    NSMutableArray    *_yunfeiArr;//运费
    float       _allMoney;//订单总金额
    int       _allJiFen;//总兑换积分
    float       _jineNum;//选择的收益账户和充值账户的金额
    float       _yunfeiMoney;//运费
    int         _buyNum;//购买数量
    NSString    *_orderId;//订单id
    
    BOOL            _shouyiPaySelect;
    BOOL            _chongzhiPaySelect;
    
    NSMutableArray *_storeIdArr;
    NSMutableArray *_goodsArr;
    NSMutableArray *_goodsIdArr;
    NSMutableArray *_buyArr;
    NSMutableArray *_orderSnArr;
    
    NSMutableDictionary *_jiesuanDic;
}

@end

@implementation DConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"确认订单"];
    _isSelectAddress = NO;
    _shouyiPaySelect    = NO;
    _chongzhiPaySelect  = NO;
    _shouyiPay = 0.00;
    _orderId = @"";
    _jineNum = 0.00;
    _yunfeiMoney = 0.00;
    _buyNum = [self.model.number intValue];
    _allMoney= 0.00;
    _allJiFen = 0.00;
    _allJiFen = [self.model.ifJifen intValue] * [self.model.number intValue];
    _yunfeiArr = [[NSMutableArray alloc]init];
    _storeIdArr = [[NSMutableArray alloc]init];
    _goodsArr = [[NSMutableArray alloc]init];
    _goodsIdArr = [[NSMutableArray alloc]init];
    _buyArr = [[NSMutableArray alloc]init];
    _orderSnArr = [[NSMutableArray alloc]init];
    _jiesuanDic = [[NSMutableDictionary alloc]init];
    _addressModel = [[MyAddressModel alloc]init];
    _accountModel = [[AccountOverViewModel alloc]init];
    _dingdanModel = [[CreateDingDanModel alloc]init];
    [self addTableView:NO];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    self.dMainTableView.frame = DRect(0, 44, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT-60);
    [self setBottomView];
    
    if (self.type == LI_JI_GOU_MAI || self.type == LI_JI_DUI_HUAN) {
        _allMoney = _buyNum*[self.model.goodsPrice floatValue];
        _allJiFen = _buyNum*[self.model.ifJifen intValue];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [arr addObject:[NSString stringWithFormat:@"%@",self.model.goodsId]];
        [_goodsIdArr addObject:arr];
        [_yunfeiArr addObject:@"0.00"];
        [_buyArr addObject:self.model];
    }
    if (self.type == GOU_WU_CHE) {
        _allMoney = [self.shifukuan floatValue];
        _storeIdArr = [[self.mDic allKeys]mutableCopy];
        for (int i=0;i<_storeIdArr.count;i++) {
            [_yunfeiArr addObject:@"0.00"];
            [_goodsArr addObject:[self.mDic objectForKey:[NSString stringWithFormat:@"%d",[[_storeIdArr objectAtIndex:i] intValue]]]];
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            NSMutableArray *jiesuanArr = [[NSMutableArray alloc]init];
            //获取单件商品运费，多件商品中运费较高的
            for (NSDictionary *tmpDic in [_goodsArr objectAtIndex:i]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [arr addObject:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"goodsId"]]];
                DGoodsDetailModel *model = [[DGoodsDetailModel alloc]init];
                model = [JsonStringTransfer dictionary:tmpDic ToModel:model];
                [_buyArr addObject:model];
                [dic setObject:[tmpDic objectForKey:@"goodsId"] forKey:@"goodsId"];
                [dic setObject:[tmpDic objectForKey:@"specId"] forKey:@"specId"];
                [dic setObject:[tmpDic objectForKey:@"number"] forKey:@"number"];
                [dic setObject:[tmpDic objectForKey:@"lastTime"] forKey:@"lastTime"];
                [jiesuanArr addObject:dic];
            }
            [_goodsIdArr addObject:arr];
            [_jiesuanDic setObject:jiesuanArr forKey:[NSString stringWithFormat:@"%@",[_storeIdArr objectAtIndex:i]]];
        }
    }
    NSLog(@"_buyArr=%@",_buyArr);
    if (self.type == LI_JI_DUI_HUAN) {
        _moneyLb.text = [NSString stringWithFormat:@"%d",_allJiFen];
    }else
        _moneyLb.text = [NSString stringWithFormat:@"%.2f",_allMoney];
    //获取收货地址
//    [self getAddress];
    //获取账户余额
//    [self getZhangHuYuE];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _addressModel = [[MyAddressModel alloc]init];
    _accountModel = [[AccountOverViewModel alloc]init];
    _isSelectAddress = NO;
    [self getZhangHuYuE];
    [self getAddress];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    PayPopView *vv = (PayPopView *)[self.view viewWithTag:8008];
    if (vv) {
        [UIView animateWithDuration:0.25f animations:^{
            
            vv.alpha = 0.1f;
            [vv setHidden:YES];
        } completion:^(BOOL finished) {
            
        }];
    }
    _allMoney = _allMoney-_yunfeiMoney;
}
//初始化创建屏幕底部的view
- (void)setBottomView
{
    UIView *viewBg = [self.view createViewWithFrame:DRect(0, DHEIGHT_CONTROLLER_DEFAULT-60, DWIDTH_CONTROLLER_DEFAULT, 60) andBackgroundColor:DColor_White];
    [self.view addSubview:viewBg];
    
    UIView *lineView = [self.view createViewWithFrame:DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT, 0.5) andBackgroundColor:DColor_line_bg];
    [viewBg addSubview:lineView];
    
    UILabel *lb1 = [self.view creatLabelWithFrame:DRect(10, 5, 55, 20) AndFont:13.0f AndBackgroundColor:DColor_Clear AndText:@"实付款：" AndTextAlignment:NSTextAlignmentLeft AndTextColor:DColor_666666 andCornerRadius:0.0f];
    if (self.type == LI_JI_DUI_HUAN) {
        lb1.text = @"应付积分：";
    }else {
        lb1.text = @"实付款：";
    }
    CGRect rect = [self.view contentAdaptionLabel:lb1.text withSize:CGSizeMake(500, 20) withTextFont:13.0f];
    lb1.frame = CGRectMake(10, 5, rect.size.width+5, 20);
    [viewBg addSubview:lb1];
    
    _moneyLb = [self.view creatLabelWithFrame:DRect(CGRectGetMaxX(lb1.frame), 5, 160, 20) AndFont:13.0f AndBackgroundColor:DColor_Clear AndText:@"¥777" AndTextAlignment:NSTextAlignmentLeft AndTextColor:DColor_c4291f andCornerRadius:0.0f];
    [viewBg addSubview:_moneyLb];
    
    UILabel *lb2 = [self.view creatLabelWithFrame:DRect(CGRectGetMinX(lb1.frame), CGRectGetMaxY(lb1.frame)+5, 55, 20) AndFont:13.0f AndBackgroundColor:DColor_Clear AndText:@"含运费：" AndTextAlignment:NSTextAlignmentLeft AndTextColor:DColor_999999 andCornerRadius:0.0f];
    [viewBg addSubview:lb2];
    
    _yunfeiLb = [self.view creatLabelWithFrame:DRect(CGRectGetMaxX(lb2.frame), CGRectGetMinY(lb2.frame), 160, 20) AndFont:13.0f AndBackgroundColor:DColor_Clear AndText:@"0.00" AndTextAlignment:NSTextAlignmentLeft AndTextColor:DColor_999999 andCornerRadius:0.0f];
    [viewBg addSubview:_yunfeiLb];
    
    UIButton *btn = [self.view createButtonWithFrame:DRect(DWIDTH_CONTROLLER_DEFAULT-110, 12, 100, 36) andBackImageName:nil andTarget:self andAction:@selector(okBtn:) andTitle:@"确认" andTag:112];
    if (self.type == LI_JI_DUI_HUAN) {
        [btn setTitle:@"兑换" forState:UIControlStateNormal];
    }else {
        [btn setTitle:@"确认" forState:UIControlStateNormal];
    }
    btn.backgroundColor = DColor_c4291f;
    [btn setTitleColor:DColor_White forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3.5f;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = DFont_15b;
    [viewBg addSubview:btn];
}
//确认
- (void)okBtn:(UIButton *)btn
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%d",_buyNum] forKey:[NSString stringWithFormat:@"%@",self.model.specId]];
    [arr addObject:dic];
    if ([self checkData]) {
        NSDictionary *parameter = [[NSDictionary alloc]init];
        NSString *method = @"";
        if (self.type == LI_JI_GOU_MAI || self.type == LI_JI_DUI_HUAN) {
            parameter = @{@"goodsId":self.model.goodsId,@"list":[JsonStringTransfer objectToJsonString:arr],@"addressId":_addressModel.addrId,@"userId":get_userId,@"cellphone":_addressModel.phoneMob};
            method = @"MyOrders.createOrder";
        }
        if (self.type == GOU_WU_CHE) {
            parameter = @{@"addressId":_addressModel.addrId,@"userId":get_userId,@"cellphone":_addressModel.phoneMob,@"map":[[JsonStringTransfer objectToJsonString:_jiesuanDic] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
            method = @"MyOrders.add";
        }
        
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:method parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                
                NSMutableDictionary *dic = [responseObject.result mutableCopy];
                NSString *jsonStr = [dic objectForKey:@"order"];
                NSMutableArray *arr = [JsonStringTransfer jsonStringToDictionary:jsonStr];
                _orderSnArr = [[[dic objectForKey:@"orderSns"] componentsSeparatedByString:@","]mutableCopy];
                NSMutableDictionary *mdic = [[arr objectAtIndex:0]mutableCopy];
                _orderId = [NSString stringWithFormat:@"%@",[mdic objectForKey:@"orderId"]];
                _dingdanModel = [JsonStringTransfer dictionary:dic ToModel:_dingdanModel];
                if (self.type == LI_JI_DUI_HUAN) {
                    [self inputDaJiKePayPassword];
                }else {
                    if (!_chongzhiPaySelect && !_shouyiPaySelect) {
                        [self noSelectPayType];
                    }else {
                        [self inputDaJiKePayPassword];
                    }
                }
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

//检查数据正确性
- (BOOL)checkData
{
    if (!_isSelectAddress) {
        showMessage(@"请确认收货地址");
        return NO;
    }else
        return YES;
}
//没有选择支付方式或所选支付方式钱不够支付，跳支付平台去支付
- (void)noSelectPayType
{
    DPayPlatFormViewController *vc = [[DPayPlatFormViewController alloc]init];
    vc.isChongzhiSelect = _chongzhiPaySelect;
    vc.isShouyiSelect = _shouyiPaySelect;
    vc.orderSn = _dingdanModel.orderSns;
    vc.authAppId = _dingdanModel.authAppId;
    vc.authUserId = _dingdanModel.authUserId;
//    vc.dingdaoModel = _dingdanModel;
    vc.buyType = MATERIRAL;
    vc.orderId = _orderId;
//    if ([_moneyLb.text floatValue]>0) {
        vc.payJine = _moneyLb.text;
//    }else
//        vc.payJine = [NSString stringWithFormat:@"%.2f",_allMoney];
    vc.allMoney = [NSString stringWithFormat:@"%.2f",_allMoney];
    vc.orderSnsArr = _orderSnArr;
    vc.addressModel = _addressModel;
    if (self.type == LI_JI_GOU_MAI) {
        vc.goodDetailModel = self.model;
    }
    if (self.type == GOU_WU_CHE) {
        vc.mArr = _buyArr;
    }
    vc.deleteArr = self.deleteArr;
    [self.navigationController pushViewController:vc animated:YES];
}
// 选择支付方式需要输入大集客支付密码
- (void)inputDaJiKePayPassword
{
    PayPopView *vv = [[PayPopView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT+64)];
    vv.tag = 8008;
    if (self.type == LI_JI_DUI_HUAN) {
        vv.jineLb.text = [NSString stringWithFormat:@"%d积分",_allJiFen];
    }else {
        if ([_moneyLb.text floatValue]>0) {
            vv.jineLb.text = [NSString stringWithFormat:@"¥%.2f元",[_moneyLb.text floatValue]];
        }else
            vv.jineLb.text = [NSString stringWithFormat:@"¥%.2f元",_allMoney];
    }
    vv.backgroundColor = [UIColor clearColor];
    
    __weak DConfirmOrderViewController *weakSelf = self;
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
    NSDictionary *dic = @{@"userId":[FileOperation getUserId],@"password":[DES3Util encrypt:password]};
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
            if (self.type == LI_JI_DUI_HUAN) {
                [self payAction];
            }else {
                if ([_moneyLb.text floatValue]>0) {
                    [self noSelectPayType];
                }else {
                    [self payAction];
                }
            }
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

// 支付
- (void)payAction
{
    NSDictionary *dic = @{@"orderSns":_dingdanModel.orderSns,@"shouyi":[self checkPayTypeHas:_shouyiPaySelect],@"chongzhi":[self checkPayTypeHas:_chongzhiPaySelect],@"authUserId":_dingdanModel.authUserId,@"authAppId":_dingdanModel.authAppId};
    
    PayView *payV = [[PayView alloc]initWithFrame:CGRectMake(0, 0, 0.5, 0.5)];
    [payV payRequestWithParam:dic ifAddActivityIndicator:NO success:^(id ret) {
        NSLog(@"%@",ret);
        if ([[ret objectForKey:@"result_code"]intValue] == 200) {
            //支付成功后删除本地购物车里面结算后的
            if (self.deleteArr.count>0) {
                [DGouWuCheOperation deleteGouWuCheProducts:self.deleteArr];
            }
            [self paySuccess];
        }else {
            if ([[ret objectForKey:@"msg"]length] == 0) {
                [ProgressHUD showMessage:@"支付失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:[ret objectForKey:@"msg"] Width:100 High:80];
        }
        
    }];
    [self.view addSubview:payV];
    
    NSLog(@"支付");
}

//支付成功后跳转
- (void)paySuccess
{
    DProductBuySuccessViewController *vc = [[DProductBuySuccessViewController alloc]init];
    vc.orderId = _orderId;
    vc.buyNumSt = [NSString stringWithFormat:@"%d",_buyNum];
    if (self.type == LI_JI_DUI_HUAN) {
        vc.allMoney = [NSString stringWithFormat:@"%d",_allJiFen];
        vc.getType = DUI_HUAN;
    }else
        vc.allMoney = [NSString stringWithFormat:@"%.2f",_allMoney];
    vc.orderSnsArr = _orderSnArr;
    vc.addressModel = _addressModel;
    if (self.type == LI_JI_GOU_MAI || self.type == LI_JI_DUI_HUAN) {
        vc.goodDetailModel = self.model;
    }
//    if (self.type == GOU_WU_CHE) {
        vc.mArr = _buyArr;
//    }
    [self.navigationController pushViewController:vc animated:YES];
}
// 判断支付方式
- (NSString *)checkPayTypeHas:(BOOL)payType
{
    if (payType) {
        return @"true";
    }else
        return @"false";
}

//获取收货地址
- (void)getAddress
{
    NSDictionary *parameter1 = @{@"userId":get_userId};
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyAddress.getSingleAddress" parameters:parameter1 ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            NSMutableDictionary *dic = [responseObject.result mutableCopy];
            
            _addressModel = [JsonStringTransfer dictionary:dic ToModel:_addressModel];
            _isSelectAddress = YES;
            for (int i=0;i<_goodsIdArr.count;i++) {
                NSMutableString *goodsId = [[NSMutableString alloc]init];
                goodsId = nil;
                for (NSString *goodIds in [_goodsIdArr objectAtIndex:i]) {
                    if (goodsId == nil) {
                        goodsId = [goodIds mutableCopy];
                    }else
                        [goodsId appendFormat:@",%@",goodIds];
                }
                [self getYunFei:goodsId withIndex:i];
            }
        }else {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
    
    [ShouYiBiLiPayObject getShouYiBiLiPayJinE:^(NSMutableDictionary *ret) {
        _shouyiPay = [[ret objectForKey:@"shouyiPayBili"]floatValue];
    }];
}
//获取运费
- (void)getYunFei:(NSString *)goodsIds withIndex:(int)index
{
    NSDictionary *parameter = @{@"goodsIds":goodsIds,@"addressId":_addressModel.addrId};
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.getYunFei" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            //动态改变运费，清空数组，重新求和
            [_yunfeiArr replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%.2f",[responseObject.result floatValue]]];
//            [_yunfeiArr addObject:[NSString stringWithFormat:@"%.2f",[responseObject.result floatValue]]];
            //总运费，数组求和
            NSNumber *sum = [_yunfeiArr valueForKeyPath:@"@sum.floatValue"];
            _yunfeiMoney = [sum  floatValue];
            _allMoney = _allMoney + [responseObject.result floatValue];
            _yunfeiLb.text = [NSString stringWithFormat:@"%.2f",_yunfeiMoney];
            if (self.type == LI_JI_DUI_HUAN) {
                
            }else {
                if (_allMoney > _jineNum) {
                    _moneyLb.text = [NSString stringWithFormat:@"%.2f",_allMoney-_jineNum];
                }else
                {
                    _moneyLb.text = @"0.00";
                }
            }
            [self.dMainTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
//获取账户可用余额
- (void)getZhangHuYuE
{
    if ([commonTools isNull:get_userId]) {
        return;
    }
    NSDictionary *parameter2 = @{@"userId":get_userId};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.index" parameters:parameter2 ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"responseObject.result = %@",responseObject.result);
            NSDictionary *dic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
            _accountModel = [JsonStringTransfer dictionary:dic ToModel:_accountModel];
            [self.dMainTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

#pragma mark  tableView  delegate  &&  dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == LI_JI_GOU_MAI || self.type == LI_JI_DUI_HUAN) {
        return 4;
    }
    if (self.type == GOU_WU_CHE) {
        return 2+self.mDic.count;
    }
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_isSelectAddress) {
            return 70;
        }
        return 40;
    }
    if (self.type == LI_JI_GOU_MAI || self.type == LI_JI_DUI_HUAN) {
        if (indexPath.row == 1) {
            return 140;
        }
        if (indexPath.row == 2) {
            return 40;
        }
        if (indexPath.row == 3) {
            if (self.type == LI_JI_DUI_HUAN) {
                return 40;
            }
            return 65;
        }
    }
    if (self.type == GOU_WU_CHE) {
        if (0<indexPath.row && indexPath.row <=self.mDic.count) {
            return 140;
        }
        if (indexPath.row == self.mDic.count+1) {
            return 65;
        }
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_isSelectAddress) {
            DOrderAddressCell *myCell = [self loadAddressCell:indexPath];
            return myCell;
        }else {
            UITableViewCell *myCell = [DTools loadNotNibTableViewCell:self.dMainTableView cellClass:[UITableViewCell class]];
            myCell.textLabel.textColor = DColor_666666;
            myCell.textLabel.font = DFont_15;
            myCell.textLabel.text = @"选择收货地址";
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return myCell;
        }
    }
    if (self.type == LI_JI_GOU_MAI || self.type == LI_JI_DUI_HUAN) {
        if (indexPath.row == 1) {
            DConfirmOrder1Cell *myCell = [self loadConfirmOrder1Cell:indexPath];
            return myCell;
        }
        if (indexPath.row == 2) {
            DConfirmOrder2Cell *myCell = [self loadConfirmOrder2Cell:indexPath];
            return myCell;
        }
        if (indexPath.row == 3) {
            if (self.type == LI_JI_DUI_HUAN) {
                DConfirmOrder4Cell *myCell = [self loadConfirmOrder4Cell:indexPath];
                return myCell;
            }
            DConfirmOrder3Cell *myCell = [self loadConfirmOrder3Cell:indexPath];
            return myCell;
        }
    }
    if (self.type == GOU_WU_CHE) {
        if ( 0 < indexPath.row &&indexPath.row <= self.mDic.count) {
            DConfirmOrder1Cell *myCell = [self loadConfirmOrder1Cell:indexPath];
            return myCell;
        }
        if (indexPath.row == self.mDic.count+1) {
            DConfirmOrder3Cell *myCell = [self loadConfirmOrder3Cell:indexPath];
            return myCell;
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        DMyAddressListAndSafeViewController *vc = [[DMyAddressListAndSafeViewController alloc]init];
        vc.address_safe = ADDRESS;
        vc.fromWhere = @"DConfirmOrderViewController";
        [vc callback:^(MyAddressModel *addressModel) {
            NSLog(@"成功");
//            _isSelectAddress = YES;
//            _addressModel = addressModel;
//            _allMoney = _allMoney - _yunfeiMoney;
////            [_yunfeiArr removeAllObjects];
////            _yunfeiArr = [[NSMutableArray alloc]init];
//            for (int i=0;i<_goodsIdArr.count;i++) {
//                NSMutableString *goodsId = [[NSMutableString alloc]init];
//                goodsId = nil;
//                for (NSString *goodIds in [_goodsIdArr objectAtIndex:i]) {
//                    if (goodsId == nil) {
//                        goodsId = [goodIds mutableCopy];
//                    }else
//                        [goodsId appendFormat:@",%@",goodIds];
//                }
//                [self getYunFei:goodsId withIndex:i];
//            }
        }];
        push(vc);
    }
}

#pragma mark  loadCell
- (DOrderAddressCell *)loadAddressCell:(NSIndexPath *)indexPath
{
    DOrderAddressCell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DOrderAddressCell class]];
    myCell.addressModel = _addressModel;
    myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return myCell;
}
- (DConfirmOrder1Cell *)loadConfirmOrder1Cell:(NSIndexPath *)indexPath
{
    DConfirmOrder1Cell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DConfirmOrder1Cell class]];
    if (_yunfeiArr.count >0) {
        myCell.yunfei = [NSString stringWithFormat:@"%.2f",[[_yunfeiArr objectAtIndex:indexPath.row-1]floatValue]];
    }
    if (self.type == LI_JI_GOU_MAI || self.type == LI_JI_DUI_HUAN) {
        if (self.type == LI_JI_DUI_HUAN) {
            myCell.flag = @"jiliduihuan";
        }
        myCell.buyNum = [NSString stringWithFormat:@"%d",_buyNum];
        myCell.goodsDetailModel = self.model;
        
    }
    if (self.type == GOU_WU_CHE) {
        myCell.storeLogo = [[[_goodsArr objectAtIndex:indexPath.row-1]objectAtIndex:0] objectForKey:@"storeLogo"];
        myCell.storeName = [[[_goodsArr objectAtIndex:indexPath.row-1]objectAtIndex:0] objectForKey:@"storeName"];
        myCell.buyNum = [NSString stringWithFormat:@"%lu",(unsigned long)[[_goodsArr objectAtIndex:indexPath.row-1] count]];
        myCell.xiaoji = [self.xiaoJiArr objectAtIndex:indexPath.row-1];
        myCell.dic = [[_goodsArr objectAtIndex:indexPath.row-1]objectAtIndex:0];
    }
    myCell.orderNumLb.text = [NSString stringWithFormat:@"订单%ld",(long)indexPath.row];
    
    for (UIView *tmpView in myCell.cellViewBg.subviews) {
        [tmpView removeFromSuperview];
    }
    if (_goodsArr.count == 0) {
        DProductOrderCell *cellv = [self loadProductOrderCell:indexPath];
        [myCell.cellViewBg addSubview:cellv];
    }else {
        if ([[_goodsArr objectAtIndex:indexPath.row-1]count] > 1) {
            UIScrollView *imgScr = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 5, 280, 65)];
            imgScr.showsHorizontalScrollIndicator = NO;
            for (int i=0; i<[[_goodsArr objectAtIndex:indexPath.row-1]count]; i++) {
                UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(i*60+10*i, 2, 60, 60)];
                imgV.layer.cornerRadius = 6.0f;
                imgV.layer.masksToBounds = YES;
                [imgV setImageWithURL:[commonTools getImgURL:[[[_goodsArr objectAtIndex:indexPath.row-1] objectAtIndex:i] objectForKey:@"goodsDefaultImage"]] placeholderImage:DPlaceholderImage];
                [imgScr addSubview:imgV];
            }
            [imgScr setContentSize:CGSizeMake([[_goodsArr objectAtIndex:indexPath.row-1]count]*70, 0)];
            [myCell.cellViewBg addSubview:imgScr];
        }else {
            DProductOrderCell *cellv = [self loadProductOrderCell:indexPath];
            [myCell.cellViewBg addSubview:cellv];
        }
    }
    [myCell callBack:^{
        NSLog(@"点击cell");
        //跳商品清单
        if (self.type == LI_JI_DUI_HUAN || self.type == LI_JI_GOU_MAI) {
            //跳商品详情
            [self gotoDWebViewController:indexPath];
        }
        if (self.type == GOU_WU_CHE) {
            if ([[_goodsArr objectAtIndex:indexPath.row-1]count]>1) {
                DProductQingDanViewController *vc = [[DProductQingDanViewController alloc]init];
                vc.productArr = [[_goodsArr objectAtIndex:indexPath.row-1]mutableCopy];
                push(vc);
            }else {
                //跳商品详情
                [self gotoDWebViewController:indexPath];
            }
        }
    }];
    return myCell;
}
//跳商品详情
- (void)gotoDWebViewController:(NSIndexPath *)indexPath
{
    DWebViewController *vc = [[DWebViewController alloc]init];
    vc.isHelp = 6;
    if (self.type == LI_JI_DUI_HUAN || self.type == LI_JI_GOU_MAI) {
        vc.urlStr = [NSString stringWithFormat:@"goodsId=%d&userId=%@",[self.model.goodsId intValue],get_userId];
        vc.imageUrl = [NSString stringWithFormat:@"%@",self.model.goodsDefaultImage];
        vc.googsTitle = [NSString stringWithFormat:@"%@",self.model.goodsName];
    }
    if (self.type == GOU_WU_CHE) {
        vc.urlStr = [NSString stringWithFormat:@"goodsId=%d&userId=%@",[[[[_goodsArr objectAtIndex:indexPath.row-1]objectAtIndex:0] objectForKey:@"goodsId"] intValue],get_userId];
        vc.imageUrl = [NSString stringWithFormat:@"%@",[[[_goodsArr objectAtIndex:indexPath.row-1]objectAtIndex:0] objectForKey:@"goodsDefaultImage"]];
        vc.googsTitle = [NSString stringWithFormat:@"%@",[[[_goodsArr objectAtIndex:indexPath.row-1]objectAtIndex:0] objectForKey:@"goodsName"]];
    }
    push(vc);
}
- (DConfirmOrder2Cell *)loadConfirmOrder2Cell:(NSIndexPath *)indexPath
{
    DConfirmOrder2Cell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DConfirmOrder2Cell class]];
    myCell.numLb.text = [NSString stringWithFormat:@"%d",_buyNum];
    [myCell callBack:^(NSInteger btnTag) {
        if (btnTag == 2) {
            NSLog(@"减-------");
            if (_buyNum == 1) {
                showMessage(@"购买数量不能小于1");
            }else {
                _buyNum--;
                
                myCell.numLb.text = [NSString stringWithFormat:@"%d",[myCell.numLb.text intValue]-1];
                
                if (_shouyiPaySelect) {
                    _jineNum = _jineNum - _shouyiPay*[self.model.goodsPrice floatValue];
                }
                _allMoney = _allMoney-[self.model.goodsPrice floatValue];
                _allJiFen = _allJiFen-[self.model.ifJifen intValue];
            }
        }
        if (btnTag == 3) {
            NSLog(@"加+++++++");
            if ([self check:myCell]) {
                _buyNum++;
                myCell.numLb.text = [NSString stringWithFormat:@"%d",[myCell.numLb.text intValue]+1];
                
                if (_shouyiPaySelect) {
                    _jineNum = _jineNum + _shouyiPay*[self.model.goodsPrice floatValue];
                }
                _allMoney =[self.model.goodsPrice floatValue]+_allMoney;
                _allJiFen = _allJiFen + [self.model.ifJifen intValue];
            }else {
                
            }
        }
        if (self.type == LI_JI_DUI_HUAN) {
            _moneyLb.text = [NSString stringWithFormat:@"%d",_allJiFen];
        }else {
            if (_allMoney > _jineNum) {
                _moneyLb.text = [NSString stringWithFormat:@"%.2f",_allMoney-_jineNum];
            }else
            {
                _moneyLb.text = @"0.00";
            }
        }
        [self.dMainTableView reloadData];
        
    }];
    return myCell;
}
- (BOOL)check:(DConfirmOrder2Cell *)myCell
{
    if (self.type == LI_JI_DUI_HUAN) {
        if (_allJiFen + [self.model.ifJifen intValue]>[_accountModel.jifen intValue]) {
            showMessage(@"可用积分不足");
            return NO;
        }
    }else {
        if ([myCell.numLb.text intValue] >= [self.model.stock intValue]) {
            showMessage(@"库存不足");
            return NO;
        }
    }
    return YES;
}
- (DConfirmOrder3Cell *)loadConfirmOrder3Cell:(NSIndexPath *)indexPath
{
    DConfirmOrder3Cell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DConfirmOrder3Cell class]];
    if (myCell.shouyiBtn.selected) {
        if (_allMoney*_shouyiPay > [_accountModel.shouyi_yue_forPay_enable floatValue]) {
            myCell.shouyiLb.text = [NSString stringWithFormat:@"收益账户可用余额：¥%.2f元",[_accountModel.shouyi_yue_forPay_enable floatValue]];
        }else
            myCell.shouyiLb.text = [NSString stringWithFormat:@"收益账户可用余额：¥%.2f元",_shouyiPay*_allMoney];
    }else
        myCell.shouyiLb.text = [NSString stringWithFormat:@"收益账户可用余额：¥%.2f元",[_accountModel.shouyi_yue_forPay_enable floatValue]];
    
    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
    if (fabs([_accountModel.shouyi_yue_forPay_enable floatValue]-0.01)<=0.01) {
        myCell.shouyiBtn.userInteractionEnabled = NO;
        myCell.shouyiLb.textColor = [UIColor lightGrayColor];
    }else {
        myCell.shouyiBtn.userInteractionEnabled = YES;
        myCell.shouyiLb.textColor = DColor_666666;
    }
    
    if (fabs([_accountModel.chongzhi_jine_index floatValue]-0.01)<=0.01) {
        myCell.chongzhiBtn.userInteractionEnabled = NO;
        myCell.chongzhiLb.textColor = [UIColor lightGrayColor];
    }else {
        myCell.chongzhiBtn.userInteractionEnabled = YES;
        myCell.chongzhiLb.textColor = DColor_666666;
    }
    
    [myCell callBack:^(NSInteger btnTag) {
        if (btnTag == 1) {
            NSLog(@"选择收益");
            myCell.shouyiBtn.selected = !myCell.shouyiBtn.selected;
            _shouyiPaySelect = !_shouyiPaySelect;
            
            if (myCell.shouyiBtn.selected) {
                _jineNum = _jineNum + (_allMoney*_shouyiPay > [_accountModel.shouyi_yue_forPay_enable floatValue]?[_accountModel.shouyi_yue_forPay_enable floatValue]:_allMoney*_shouyiPay);
            }else {
                _jineNum = _jineNum - (_allMoney*_shouyiPay > [_accountModel.shouyi_yue_forPay_enable floatValue]?[_accountModel.shouyi_yue_forPay_enable floatValue]:_allMoney*_shouyiPay);
            }
        }
        if (btnTag == 2) {
            NSLog(@"选择充值");
            myCell.chongzhiBtn.selected = !myCell.chongzhiBtn.selected;
            _chongzhiPaySelect = !_chongzhiPaySelect;
            
            if (myCell.chongzhiBtn.selected) {
                _jineNum = _jineNum + [_accountModel.chongzhi_jine_index floatValue];
            }else
                _jineNum = _jineNum - [_accountModel.chongzhi_jine_index floatValue];
        }
        
        if (_allMoney > _jineNum) {
            _moneyLb.text = [NSString stringWithFormat:@"%.2f",_allMoney-_jineNum];
        }else
        {
            _moneyLb.text = @"0.00";
        }
        [self.dMainTableView reloadData];
    }];
    return myCell;
}

- (DConfirmOrder4Cell *)loadConfirmOrder4Cell:(NSIndexPath *)indexPath
{
    DConfirmOrder4Cell *myCell = [DTools loadTableViewCell:self.dMainTableView cellClass:[DConfirmOrder4Cell class]];
    myCell.jifenLb.text = [NSString stringWithFormat:@"可用兑换积分：%@",_accountModel.jifen];
    if ([_accountModel.jifen intValue] == 0) {
        myCell.jifenLb.textColor = DColor_999999;
    }else {
        myCell.jifenLb.textColor = DColor_666666;
    }
    return myCell;
}

- (DProductOrderCell *)loadProductOrderCell:(NSIndexPath *)indexPath
{
    DProductOrderCell *cellv = [DTools loadTableViewCell:self.dMainTableView cellClass:[DProductOrderCell class]];
    [cellv setFrame:DRect(0, 0, DWIDTH_CONTROLLER_DEFAULT-24, 75)];
    if (self.type == LI_JI_GOU_MAI || self.type == LI_JI_DUI_HUAN) {
        cellv.buyNum = [NSString stringWithFormat:@"%d",_buyNum];
        cellv.goodsDetailModel = self.model;
    }
    if (self.type == GOU_WU_CHE) {
        cellv.dic = [[[_goodsArr objectAtIndex:indexPath.row-1]objectAtIndex:0]mutableCopy];
    }
    if (self.type == LI_JI_DUI_HUAN) {
        cellv.goodPriceLb.text = [NSString stringWithFormat:@"%d积分",[self.model.ifJifen intValue]];
    }
    return cellv;
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

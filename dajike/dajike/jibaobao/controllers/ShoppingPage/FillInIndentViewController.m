//
//  FillInIndentViewController.m
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 **   购物---》填写订单
 */

#import "FillInIndentViewController.h"
#import "defines.h"
#import "UIView+MyView.h"
#import "WriteIndentCell.h"
#import "ReceiveAddressCell.h"
#import "TypeAndNumView.h"
#import "BuySucceedViewController.h"
#import "MyAddressEditingViewController.h"
#import "MyAddressListViewController.h"
#import "FindPassword0ViewController.h"

#import "MyAddressModel.h"
#import "ShopPhotosModel.h"
#import "AccountOverViewModel.h"
#import "CreateDingDanModel.h"
#import "PayView.h"
#import "PayPopView.h"
#import "NewIndentViewController.h"
#import "BuySucceedViewController.h"
#import "BoundPhoneViewController.h"
#import "ShouYiBiLiPayObject.h"

static NSString *swbCell1 = @"swbCell111";
static NSString *swbCell2 = @"swbCell222";

@interface FillInIndentViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@end

@implementation FillInIndentViewController
{
    UILabel         *_moneyNumLb;
    UILabel *_shifukuanLb;
    
    UILabel *_yuanLb;
    NSMutableDictionary *_dic;
    
    BOOL            _isSelectAddress;      //是否填写收货地址
    
    MyAddressModel  *_addressModel;
    
    AccountOverViewModel *_accountModel;
    
    CreateDingDanModel  *_dingdanModel;
    
    NSMutableArray  *_specIdArr;    //商品规格Id
    
    NSMutableArray  *_typeNumArr;   //商品类型数量
    
    NSMutableArray  *_numArr;       //选择数量
    
    NSString        *_telNum;       //绑定的手机号
    
    BOOL            _shouyiPaySelect;
    BOOL            _chongzhiPaySelect;
    BOOL            _jifenPaySelect;
    
    float           _jineNum;
    
    float           _allMoney;
    
    float           _shouyiPay;
    
    NSString         *  _yunFeiMoney;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isSelectAddress = NO;
    _shouyiPaySelect      = NO;
    _chongzhiPaySelect  = NO;
    _jifenPaySelect = NO;
    _jineNum = 0.00;
    _allMoney = 0.00;
    _shouyiPay = 0.00;
    _yunFeiMoney = @"";
    self.view.backgroundColor = Color_bg;
    _addressModel = [[MyAddressModel alloc]init];
    _accountModel = [[AccountOverViewModel alloc]init];
    _dingdanModel = [[CreateDingDanModel alloc]init];
    _specIdArr  = [[NSMutableArray alloc]init];
    _typeNumArr = [[NSMutableArray alloc]init];
    _numArr     = [[NSMutableArray alloc]init];
    _dic        = [[NSMutableDictionary alloc]init];
    
    NSLog(@"%@",[FileOperation getUserId]);
    NSString *filePath = [FileOperation creatPlistIfNotExist:jibaobaoUser];
    _telNum = [FileOperation getobjectForKey:@"phoneMob" ofFilePath:filePath];
    
    titleLabel.text = @"填写订单";
    self.delegate = self;
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    
    [self addTableView:UITableViewStylePlain];
    [self.mainTabview setFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64-50)];
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"WriteIndentCell" bundle:nil] forCellReuseIdentifier:swbCell1];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"ReceiveAddressCell" bundle:nil] forCellReuseIdentifier:swbCell2];
    
    [self addBottomView];
    
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getZhangHuYuE];
}

//------------------------- 分割线 --------------------------------

- (void)getData
{
    
    NSDictionary *parameter = @{@"goodsId":self.goodModel.goods_id};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.getGuiGe" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            _dic = [responseObject.result mutableCopy];
            
            _specIdArr = [[_dic allKeys]mutableCopy];
            
            NSMutableArray *arr = [[_dic allKeys]mutableCopy];
            
            for (int i=0; i<arr.count; i++) {
                NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc]init];
                [tmpDic setObject:[arr objectAtIndex:i] forKey:@"specId"];
                [tmpDic setObject:@"0" forKey:@"goodsNumber"];
                
                [_numArr addObject:tmpDic];
                
                ShopPhotosModel *model = [[ShopPhotosModel alloc]init];
                model = [JsonStringTransfer dictionary:[_dic objectForKey:[arr objectAtIndex:i]] ToModel:model];
                [arr replaceObjectAtIndex:i withObject:model];
            }
            [_typeNumArr addObjectsFromArray:arr];

            [self.mainTabview reloadData];
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"网络连接失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
    
    
    NSDictionary *parameter1 = @{@"userId":[FileOperation getUserId]};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyAddress.getSingleAddress" parameters:parameter1 ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            NSMutableDictionary *dic = [responseObject.result mutableCopy];
            
            _addressModel = [JsonStringTransfer dictionary:dic ToModel:_addressModel];
            _isSelectAddress = YES;
            
            [self getYunFei];
            
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
    
    [ShouYiBiLiPayObject getShouYiBiLiPayJinE:^(NSMutableDictionary *ret) {
        _shouyiPay = [[ret objectForKey:@"shouyiPayBili"]floatValue];
    }];
}
//获取账户可用余额
- (void)getZhangHuYuE
{
    if ([FileOperation getUserId] == nil) {
        return;
    }
    NSDictionary *parameter2 = @{@"userId":[FileOperation getUserId]};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.index" parameters:parameter2 ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"responseObject.result = %@",responseObject.result);
            NSDictionary *dic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
            _accountModel = [JsonStringTransfer dictionary:dic ToModel:_accountModel];
            [self.mainTabview reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}
//获取运费
- (void)getYunFei
{
    NSDictionary *parameter = @{@"goodsId":self.goodModel.goods_id,@"addressId":_addressModel.addrId};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.getYunFei" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            _yunFeiMoney = [NSString stringWithFormat:@"%.2f",[responseObject.result floatValue]];
            _allMoney = _allMoney + [_yunFeiMoney floatValue];
            
            if (_allMoney > _jineNum) {
                _moneyNumLb.text = [NSString stringWithFormat:@"%.2f",_allMoney-_jineNum];
                CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_shifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
            }else
            {
                _moneyNumLb.text = @"0.00";
                CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_shifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
            }
            
            [self.mainTabview reloadData];
            
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

//屏幕下方的View
- (void)addBottomView
{
    UIView *viewBg = [self.view createViewWithFrame:CGRectMake(0, HEIGHT_CONTROLLER_DEFAULT-114, WIDTH_CONTROLLER_DEFAULT, 50) andBackgroundColor:[UIColor whiteColor]];
    UIView *lineView = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 1) andBackgroundColor:Color_line_bg];
    [viewBg addSubview:lineView];
    _shifukuanLb = [self.view creatLabelWithFrame:CGRectMake(10, 10, 80, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"实付款：" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
//    CGRect rect0 = [self.view contentAdaptionLabel:lb1.text withTextFont:15.0f];
    CGRect rect0 = [self.view contentAdaptionLabel:_shifukuanLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0];
    _shifukuanLb.frame = CGRectMake(10, 10, rect0.size.width, 30);
    [viewBg addSubview:_shifukuanLb];
    _moneyNumLb = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(_shifukuanLb.frame)+5, 10, 100, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"0.00" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_mainColor andCornerRadius:0.0f];
    CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0];
    _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_shifukuanLb.frame)+5, 10, rect.size.width, 30);
    [viewBg addSubview:_moneyNumLb];
    _yuanLb = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+5, 10, 20, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"元" AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    [viewBg addSubview:_yuanLb];
    UIButton *okBtn = [self.view createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-90, 10, 80, 30) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:@"确定" andTag:14];
    okBtn.backgroundColor = Color_mainColor;
    okBtn.layer.cornerRadius = 2.0f;
    okBtn.layer.masksToBounds = YES;
    [viewBg addSubview:okBtn];
    [self.view addSubview:viewBg];
}
#pragma mark   Tableview   Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 44*_typeNumArr.count;
    }
    if (indexPath.row == 5) {
        if (_isSelectAddress) {
            return 70;
        }else
            return 44;
    }
    if (indexPath.row == 6) {
        return 80;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell1 = @"cell111";
    if (indexPath.row == 6) {
        WriteIndentCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell1];
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        myCell.backgroundColor = Color_bg;
        
        if (myCell.shouyiBtn.selected) {
            myCell.shouyiImg.image = [UIImage imageNamed:@"img_box_02"];
        }else
            myCell.shouyiImg.image = [UIImage imageNamed:@"img_box_01"];
        
        if (myCell.chongzhiBtn.selected) {
            myCell.chongzhiImg.image = [UIImage imageNamed:@"img_box_02"];
        }else
            myCell.chongzhiImg.image = [UIImage imageNamed:@"img_box_01"];
        
//        if (myCell.jifenBtn.selected) {
//            myCell.jifenImg.image = [UIImage imageNamed:@"img_box_02"];
//        }else
//            myCell.jifenImg.image = [UIImage imageNamed:@"img_box_01"];
//        myCell.model = _accountModel;
        if (myCell.shouyiBtn.selected) {
            if (_allMoney*_shouyiPay > [_accountModel.shouyi_yue_forPay_enable floatValue]) {
                myCell.shouyiLb.text = [NSString stringWithFormat:@"账户可用余额：¥%.2f元",[_accountModel.shouyi_yue_forPay_enable floatValue]];
            }else
                myCell.shouyiLb.text = [NSString stringWithFormat:@"账户可用余额：¥%.2f元",_shouyiPay*_allMoney];
        }else
            myCell.shouyiLb.text = [NSString stringWithFormat:@"账户可用余额：¥%.2f元",[_accountModel.shouyi_yue_forPay_enable floatValue]];
//        if (myCell.chongzhiBtn.selected) {
//            if (myCell.shouyiBtn.selected) {
//                if ([_goodModel.price floatValue]-[myCell.shouyiLb.text floatValue] > [_accountModel.chongzhi_jine_index floatValue]) {
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
//                }else {
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_goodModel.price floatValue]-[myCell.shouyiLb.text floatValue]];
//                }
//                
//            }else {
//                if ([_goodModel.price floatValue] > [_accountModel.chongzhi_jine_index floatValue]) {
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
//                }else
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_goodModel.price floatValue]];
//            }
//        }else {
            myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
//        }
        
        if (fabs([_accountModel.shouyi_yue_forPay_enable floatValue]-0.01)<=0.01) {
            myCell.shouyiBtn.userInteractionEnabled = NO;
            myCell.shouyiLb.textColor = [UIColor lightGrayColor];
        }else {
            myCell.shouyiBtn.userInteractionEnabled = YES;
            myCell.shouyiLb.textColor = Color_word_bg;
        }
        
        if (fabs([_accountModel.chongzhi_jine_index floatValue]-0.01)<=0.01) {
            myCell.chongzhiBtn.userInteractionEnabled = NO;
            myCell.chongzhiLb.textColor = [UIColor lightGrayColor];
        }else {
            myCell.chongzhiBtn.userInteractionEnabled = YES;
            myCell.chongzhiLb.textColor = Color_word_bg;
        }
        
//        if (myCell.chongzhiBtn.selected) {
//            if (myCell.shouyiBtn.selected && myCell.jifenBtn.selected) {
//                if ([_goodModel.price floatValue]-[myCell.shouyiLb.text floatValue]-10 > [_accountModel.chongzhi_jine_index floatValue]) {
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
//                }else
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_goodModel.price floatValue]-[myCell.shouyiLb.text floatValue]-10];
//                
//            }else if (myCell.shouyiBtn.selected) {
//                if ([_goodModel.price floatValue]-[myCell.shouyiLb.text floatValue] > [_accountModel.chongzhi_jine_index floatValue]) {
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
//                }else
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_goodModel.price floatValue]-[myCell.shouyiLb.text floatValue]];
//            }else if (myCell.jifenBtn.selected) {
//                if ([_goodModel.price floatValue]-10 > [_accountModel.chongzhi_jine_index floatValue]) {
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
//                }else
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_goodModel.price floatValue]-10];
//            }else {
//                if ([_goodModel.price floatValue] > [_accountModel.chongzhi_jine_index floatValue]) {
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
//                }else
//                    myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_goodModel.price floatValue]];
//            }
//
//        }else
//            myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];

        //        myCell.shouyiLb.text = [NSString stringWithFormat:@"账户可用余额：¥%.2f元",[_accountModel.shouyi_yue_forPay_enable floatValue]/2];
//        myCell.chongzhiLb.text = [NSString stringWithFormat:@"充值账户：¥%.2f元",[_accountModel.chongzhi_jine_index floatValue]];
//        myCell.jifenLb.text = [NSString stringWithFormat:@"可用%.2f积分抵制10元",[_accountModel.jifen floatValue]];
        [myCell callBackSelectPayType:^(int btnTag) {
            if (btnTag == 888) {
                NSLog(@"收益账户");
                
                myCell.shouyiBtn.selected = !myCell.shouyiBtn.selected;
                _shouyiPaySelect = !_shouyiPaySelect;
                
                if (myCell.shouyiBtn.selected) {
                    _jineNum = _jineNum + (_allMoney*_shouyiPay > [_accountModel.shouyi_yue_forPay_enable floatValue]?[_accountModel.shouyi_yue_forPay_enable floatValue]:_allMoney*_shouyiPay);
                    
                    
                }else {
                    _jineNum = _jineNum - (_allMoney*_shouyiPay > [_accountModel.shouyi_yue_forPay_enable floatValue]?[_accountModel.shouyi_yue_forPay_enable floatValue]:_allMoney*_shouyiPay);
                    
                }
                
            }
            if (btnTag == 777) {
                NSLog(@"充值账户");
                myCell.chongzhiBtn.selected = !myCell.chongzhiBtn.selected;
                _chongzhiPaySelect = !_chongzhiPaySelect;
                
                if (myCell.chongzhiBtn.selected) {
                    _jineNum = _jineNum + [_accountModel.chongzhi_jine_index floatValue];
                }else
                    _jineNum = _jineNum - [_accountModel.chongzhi_jine_index floatValue];
            }
            if (btnTag == 666) {
                NSLog(@"积分");
                myCell.jifenBtn.selected = !myCell.jifenBtn.selected;
                _jifenPaySelect = !_jifenPaySelect;
            }
            if (_allMoney > _jineNum) {
                _moneyNumLb.text = [NSString stringWithFormat:@"%.2f",_allMoney-_jineNum];
                CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_shifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
            }else
            {
                _moneyNumLb.text = @"0.00";
                CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_shifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
            }
            [self.mainTabview reloadData];
        }];
        return myCell;
    }
    if (indexPath.row == 5) {
        if (_isSelectAddress) {
            ReceiveAddressCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell2];
            myCell.model = _addressModel;
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return myCell;
        }
    }
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell1];
    myCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (!myCell) {
        myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
    }
    UILabel *lb1 = (UILabel *)[myCell.contentView viewWithTag:36];
    if (!lb1) {
        lb1 = [self.view creatLabelWithFrame:CGRectMake(10, 7, 160, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
        lb1.tag = 36;
        [myCell.contentView addSubview:lb1];
    }
    lb1.frame = CGRectMake(10, 7, 160, 30);
    lb1.hidden = NO;
    lb1.textColor = Color_word_bg;
    lb1.font = [UIFont systemFontOfSize:15.0f];
    UILabel *lb2 = (UILabel *)[myCell.contentView viewWithTag:37];
    if (!lb2) {
        lb2 = [self.view creatLabelWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-150, 7, 140, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentRight AndTextColor:Color_word_bg andCornerRadius:0.0f];
        lb2.tag = 37;
        [myCell.contentView addSubview:lb2];
    }
    lb2.frame = CGRectMake(WIDTH_CONTROLLER_DEFAULT-150, 7, 140, 30);
    lb2.hidden = NO;
    lb2.textColor = Color_word_bg;
    UIView *viewBg = (UIView *)[myCell.contentView viewWithTag:38];
    if (!viewBg) {
        viewBg = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, _typeNumArr.count*44) andBackgroundColor:[UIColor clearColor]];
        viewBg.tag = 38;
        [myCell.contentView addSubview:viewBg];
    }
    viewBg.frame = CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, _typeNumArr.count*44);
    viewBg.hidden = NO;
    UIImageView *imgView = (UIImageView *)[myCell.contentView viewWithTag:39];
    if (!imgView) {
        imgView = [self.view createImageViewWithFrame:CGRectMake(10, 10, 24, 24) andImageName:@"img_positive"];
        imgView.tag = 39;
        [myCell.contentView addSubview:imgView];
    }
    imgView.hidden = NO;
    myCell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        lb1.text = self.goodModel.goods_name;
        lb2.text = [NSString stringWithFormat:@"%.2f元",[self.goodModel.price floatValue]];
        lb2.textColor = Color_mainColor;
        viewBg.hidden = YES;
        imgView.hidden = YES;
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 1) {
        lb1.text = @"类型和数量";
        lb2.hidden = YES;
        viewBg.hidden = YES;
        imgView.hidden = YES;
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 2) {
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        lb2.hidden = YES;
        imgView.hidden = YES;
        lb1.hidden = YES;
        for (UIView *tmpV in viewBg.subviews) {
            [tmpV removeFromSuperview];
        }
        for (int i=0; i<_typeNumArr.count; i++) {
            ShopPhotosModel *model = [_typeNumArr objectAtIndex:i];
            TypeAndNumView *iv = [[TypeAndNumView alloc]initWithFrame:CGRectMake(10, 44*i, WIDTH_CONTROLLER_DEFAULT, 44)];
            iv.typeLb.text = [NSString stringWithFormat:@"%@%@",model.spec_1,model.spec_2];
            iv.numLb.text = [NSString stringWithFormat:@"(剩余%d单)",[model.stock intValue]];
            iv.numTf.text = [NSString stringWithFormat:@"%d",[[[_numArr objectAtIndex:i]objectForKey:@"goodsNumber"] intValue]];
            iv.jiaBtn.tag = 100;
            iv.numTf.tag = i+50;
            iv.jianBtn.tag = 1;
            [viewBg addSubview:iv];
            [iv callBackBtnClicked:^(UIButton *btn) {
                NSLog(@"哈哈");
                if (btn.tag == 100) {
                    if (iv.numTf.tag == i+50) {
                        if ([iv.numTf.text intValue] >= [model.stock intValue]) {
                            [ProgressHUD showMessage:@"库存不足" Width:100 High:80];
                        }else {
                            iv.numTf.text = [NSString stringWithFormat:@"%d",[iv.numTf.text intValue]+1];
                            [[_numArr objectAtIndex:i] setObject:iv.numTf.text forKey:@"goodsNumber"];
//                            [_numArr replaceObjectAtIndex:i withObject:iv.numTf.text];
                            
                            
                            if (_shouyiPaySelect) {
                                _jineNum = _jineNum + _shouyiPay*[self.goodModel.price floatValue];
                            }
                            _allMoney =[self.goodModel.price floatValue]+_allMoney;
                            if (_allMoney > _jineNum) {
                                _moneyNumLb.text = [NSString stringWithFormat:@"%.2f",_allMoney-_jineNum];
                                CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                                _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_shifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                                _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
                            }else
                            {
                                _moneyNumLb.text = @"0.00";
                                CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                                _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_shifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                                _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
                            }
                            [self.mainTabview reloadData];
                        }
                        
                    }
                }
                if (btn.tag == 1) {
                    if (iv.numTf.tag == i+50) {
                        if ([iv.numTf.text intValue] == 0) {
                            [ProgressHUD showMessage:@"数量不能少于0个" Width:100 High:80];
                        }else {
                            iv.numTf.text = [NSString stringWithFormat:@"%d",[iv.numTf.text intValue]-1];
                            [[_numArr objectAtIndex:i] setObject:iv.numTf.text forKey:@"goodsNumber"];
//                            [_numArr replaceObjectAtIndex:i withObject:iv.numTf.text];
                            
                            if (_shouyiPaySelect) {
                                _jineNum = _jineNum - _shouyiPay*[self.goodModel.price floatValue];
                            }
                            _allMoney = _allMoney-[self.goodModel.price floatValue];
                            if (_allMoney > _jineNum) {
                                _moneyNumLb.text = [NSString stringWithFormat:@"%.2f",_allMoney-_jineNum];
                                CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                                _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_shifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                                _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
                            }else
                            {
                                _moneyNumLb.text = @"0.00";
                                CGRect rect = [self.view contentAdaptionLabel:_moneyNumLb.text withSize:CGSizeMake(1000, 30) withTextFont:15.0f];
                                _moneyNumLb.frame = CGRectMake(CGRectGetMaxX(_shifukuanLb.frame)+5, 10, rect.size.width+5, 30);
                                _yuanLb.frame = CGRectMake(CGRectGetMaxX(_moneyNumLb.frame)+1, 10, 20, 30);
                            }
                            [self.mainTabview reloadData];
                        }
                    }
                }
            }];
        }
    }
    if (indexPath.row == 3) {
        lb1.text = @"运费：";
        lb2.text = [NSString stringWithFormat:@"%.2f元",[_yunFeiMoney floatValue]];
        viewBg.hidden = YES;
        imgView.hidden = YES;
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 4) {
        lb1.text = @"选择收货地址";
        lb1.font = [UIFont systemFontOfSize:16.0f];
        lb1.textColor = [UIColor darkGrayColor];
        lb2.hidden = YES;
        viewBg.hidden = YES;
        imgView.hidden = YES;
        myCell.backgroundColor = Color_bg;
        
    }
    if (indexPath.row == 5) {
        lb1.text = @"编辑收货地址";
        myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        lb2.hidden = YES;
        viewBg.hidden = YES;
        imgView.hidden = YES;
    }
    if (indexPath.row == 7) {
        lb1.text = @"您已绑定的手机号";
        lb2.hidden = YES;
        viewBg.hidden = YES;
        imgView.hidden = YES;
    }
    if (indexPath.row == 8) {
        if ([commonTools isNull:_telNum]) {
            lb1.text = @"您还未绑定手机号";
        }else
            lb1.text = [NSString stringWithFormat:@"%@****%@",[_telNum substringToIndex:3],[_telNum substringFromIndex:7]];
        lb2.frame = CGRectMake(WIDTH_CONTROLLER_DEFAULT-160, 7, 120, 30);
        lb2.text = @"绑定新手机号";
        viewBg.hidden = YES;
        imgView.hidden = YES;
        myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 9) {
        lb1.frame = CGRectMake(44, 7, 100, 30);
        lb1.text = @"正品";
        lb2.hidden = YES;
        viewBg.hidden = YES;
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        imgView.hidden = NO;
    }
    return myCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 5) {
        [self shouHuoAddress];
    }
    if (indexPath.row == 8) {
        [self boundTelePhoneNum];
    }
}
//绑定手机号
- (void)boundTelePhoneNum
{
    BoundPhoneViewController *vc = [[BoundPhoneViewController alloc]init];
    vc.flagStr = @"808";
    if ([commonTools isNull:_telNum]) {
        vc.phoneType = Bound_PHONE;
    }else{
        vc.phoneType = PHONE_VERIFY;
    }
    [vc backToFillInIndentViewController:^(NSString *telNum) {
        _telNum = telNum;
        [self.mainTabview reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
//编辑或新建收货地址
- (void)shouHuoAddress
{
    MyAddressListViewController *vc = [[MyAddressListViewController alloc]init];
    vc.flagStr = @"FillInIndentViewController";
    vc.userId = [FileOperation getUserId];
    [vc callBackAddress:^(MyAddressModel *addressModel) {
        NSLog(@"成功");
        _isSelectAddress = YES;
        _addressModel = addressModel;
        _allMoney = _allMoney - [_yunFeiMoney floatValue];
        [self getYunFei];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
//确认，创建订单
- (void)btnClickedAction:(id)sender
{
    NSLog(@"确定");
    NSLog(@"%@",_numArr);
    
    NSMutableArray *restulArr = [[self sortNumArr:_numArr]mutableCopy];
    
    if ([self checkDataIsRight]) {
        NSDictionary *parameter = @{@"goodsId":self.goodModel.goods_id,@"list":[JsonStringTransfer objectToJsonString:restulArr],@"addressId":_addressModel.addrId,@"userId":[FileOperation getUserId]};
        
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.createOrder" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                
                NSMutableDictionary *dic = [responseObject.result mutableCopy];
                
                _dingdanModel = [JsonStringTransfer dictionary:dic ToModel:_dingdanModel];
                if (!_chongzhiPaySelect && !_shouyiPaySelect) {
                    [self noSelectPayType];
                }else {
                    [self inputDaJiKePayPassword];
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
//没有选择支付方式或所选支付方式钱不够支付，跳支付平台去支付
- (void)noSelectPayType
{
    NewIndentViewController *vc = [[NewIndentViewController alloc]init];
    vc.payJine = _moneyNumLb.text;
    vc.isChongzhiSelect = _chongzhiPaySelect;
    vc.isShouyiSelect = _shouyiPaySelect;
    vc.dingdaoModel = _dingdanModel;
    vc.buyType = @"1";
    
    vc.goodsName = self.goodModel.goods_name;
    if ([_moneyNumLb.text floatValue]>0) {
        vc.money = _moneyNumLb.text;
    }else
        vc.money = [NSString stringWithFormat:@"%.2f",_allMoney];
    vc.arr = [[self myArr]mutableCopy];
    vc.model = _addressModel;
    vc.yunfei = [NSString stringWithFormat:@"%.2f",[_yunFeiMoney floatValue]];
    [self.navigationController pushViewController:vc animated:YES];
}
// 选择支付方式需要输入大集客支付密码
- (void)inputDaJiKePayPassword
{
    PayPopView *vv = [[PayPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT)];
    vv.tag = 8008;
    if ([_moneyNumLb.text floatValue]>0) {
        vv.jineLb.text = [NSString stringWithFormat:@"¥%.2f元",[_moneyNumLb.text floatValue]];
    }else
        vv.jineLb.text = [NSString stringWithFormat:@"¥%.2f元",_allMoney];
    vv.backgroundColor = [UIColor clearColor];
    
    __weak FillInIndentViewController *weakSelf = self;
    [vv.mimaLb callbackClickedLb:^(MyClickLb *clickLb) {
        NSLog(@"忘记密码");
        //找回密码
        FindPassword0ViewController *FindPassword0VC = [[FindPassword0ViewController alloc]initWithNibName:nil bundle:nil];
        [weakSelf.navigationController pushViewController:FindPassword0VC animated:YES];
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

//遍历购买数量数组，查出数量>0的规格
- (NSMutableArray *)sortNumArr:(NSMutableArray *)arr
{
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *tmpDic in arr) {
        if ([[tmpDic objectForKey:@"goodsNumber"]intValue]>0) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[tmpDic objectForKey:@"goodsNumber"] forKey:[tmpDic objectForKey:@"specId"]];
            [resultArr addObject:dic];
        }
    }
    NSLog(@"resultArr = %@",resultArr);
    return resultArr;
}

//拿到需要支付的规格，传到下个界面
- (NSMutableArray *)myArr
{
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *tmpDic in _numArr) {
        if ([[tmpDic objectForKey:@"goodsNumber"]intValue]>0) {
            NSMutableDictionary *dicc = [[_dic objectForKey:[tmpDic objectForKey:@"specId"]]mutableCopy];
            [dicc setObject:[tmpDic objectForKey:@"goodsNumber"] forKey:@"goodsNumber"];
            
            [resultArr addObject:dicc];
        }
    }
    return resultArr;
}

//校验支付密码
- (void)checkPayPassword:(NSString *)password
{
    NSDictionary *dic = @{@"userId":[FileOperation getUserId],@"password":[DES3Util encrypt:password]};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.validatePassword" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
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
            if ([_moneyNumLb.text floatValue]>0) {
                [self noSelectPayType];
            }else {
                [self payAction];
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
    BuySucceedViewController *vc = [[BuySucceedViewController alloc]init];
    vc.flagstr = @"1";
    vc.goodsName = self.goodModel.goods_name;
//    if ([_moneyNumLb.text floatValue]>0) {
        vc.money = _moneyNumLb.text;
//    }else
//        vc.money = [NSString stringWithFormat:@"%.2f",_allMoney];
    vc.arr = [[self myArr]mutableCopy];
    vc.model = _addressModel;
    vc.yunfei = [NSString stringWithFormat:@"%.2f",[_yunFeiMoney floatValue]];
    [self.navigationController pushViewController:vc animated:YES];
}

//数据正确性检查
- (BOOL)checkDataIsRight
{
    BOOL flag = NO;
    for (int i=0; i<_numArr.count; i++) {
        if ([[[_numArr objectAtIndex:i]objectForKey:@"goodsNumber"] intValue]>0) {
            flag = YES;
            break;
        }
    }
    if (!flag) {
        [ProgressHUD showMessage:@"请先选择您要购买的商品类型和数量" Width:100 High:80];
        return NO;
    }
    
    if (!_isSelectAddress) {
        [ProgressHUD showMessage:@"请填写您的收货地址" Width:100 High:80];
        return NO;
    }
    
//    if (!_shouyiPaySelect && !_chongzhiPaySelect && !_jifenPaySelect) {
//        [ProgressHUD showMessage:@"请选择支付方式" Width:100 High:80];
//        return NO;
//    }
    
    return YES;
}


// 判断支付方式
- (NSString *)checkPayTypeHas:(BOOL)payType
{
    if (payType) {
        return @"true";
    }else
        return @"false";
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

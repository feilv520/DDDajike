//
//  JMineViewController.m
//  jibaobao
//
//  Created by dajike on 15/4/30.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "JMineViewController.h"
#import "MyMD5.h"
#import "mineMainCell1.h"
#import "mineMainCell2.h"
#import "mineMainCell3.h"
#import "mineMainCell4.h"
#import "MineNextCell.h"
#import "AccountViewController.h"
#import "CouponListViewController.h"
#import "CollectViewController.h"
#import "OrderForAllViewController.h"
#import "MyInformationViewController.h"
#import "LoginViewController.h"
#import "NoneLoginCell.h"
#import "BoundPhoneViewController.h"
#import "MyAddressListViewController.h"
#import "SafetySettingViewController.h"
#import "HelpCenterViewController.h"
#import "SeetingViewController.h"
#include "DidBoundBankCardViewController.h"
#import "defines.h"
#import "FileOperation.h"
#import "MyAfHTTPClient.h"
#import "AFNetworking.h"
#import "MyAccountsFriends.h"

#import "DES3Util.h"
#import "AnalysisData.h"
#import "UserInfoModel.h"
#import "AccountOverViewModel.h"
#import "GeneralHongBaoViewController.h"
#import "JTabBarController.h"
#import "AccountDetailViewController.h"
#import "MessageListViewController.h"

static NSString *cell1 = @"cell111";

@interface JMineViewController ()
{
    NSMutableDictionary     *_userInfoDic;
    UserInfoModel           *_userModel;
    
    BOOL isLogin;
    //账户概览
    AccountOverViewModel *accountOverViewItem;
}
@property (nonatomic, strong) NSString *stringSC;
@end

@implementation JMineViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self initViewAndUserInfo];
    JTabBarController *jTabBarVC = [JTabBarController sharedManager];
    [jTabBarVC.tabBarView setHidden:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    [self setNavType:MINE_NAV action:nil];
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    CGRect frame = self.mainTabview.frame;
    frame.size.height = self.mainTabview.frame.size.height + 5;
    self.mainTabview.frame = frame;
    self.mainTabview.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1.0f];
}

- (void)initViewAndUserInfo{
    NSString *filePAth = [FileOperation creatPlistIfNotExist:SET_PLIST];
    if ([[FileOperation getobjectForKey:kIsLogin ofFilePath:filePAth] boolValue] == 1) {
        isLogin = YES;
        _userInfoDic = [[NSMutableDictionary alloc]init];
        _userInfoDic = [[FileOperation readFileToDictionary:jibaobaoUser]mutableCopy];
        _userModel = [[UserInfoModel alloc]init];
        _userModel = [JsonStringTransfer dictionary:_userInfoDic ToModel:_userModel];
        [self getUerInfo];
        [self getMyAccountInfo];
    }else{
        isLogin = NO;
    }
    [self.mainTabview reloadData];
}

//获取用户会员信息，存入本地
- (void)getUerInfo
{
    NSLog(@"%@",[FileOperation getUserId]);
    if ([FileOperation getUserId] == nil) {
        return;
    }
    NSDictionary *parameter = @{@"userId":[FileOperation getUserId]};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyUserInfos.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSString *jsonStr = [AnalysisData decodeToString:responseObject.result];
            _userInfoDic = [[JsonStringTransfer jsonStringToDictionary:jsonStr]mutableCopy];
//            [self count];
            NSString *filePath = [FileOperation creatPlistIfNotExist:jibaobaoUser];
            [FileOperation writeToPlistFile:filePath withDic:_userInfoDic];
            _userModel = [JsonStringTransfer dictionary:_userInfoDic ToModel:_userModel];
        }
        [self.mainTabview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
//获取用户账户概览
- (void) getMyAccountInfo
{
    if ([FileOperation getUserId] == nil) {
        return;
    }
    NSDictionary *parameter = @{@"userId":[FileOperation getUserId]};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"responseObject.result = %@",responseObject.result);
            NSDictionary *dic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
            AccountOverViewModel *model = [[AccountOverViewModel alloc]init];
            model = [JsonStringTransfer dictionary:dic ToModel:model];
            accountOverViewItem = model;
            [self.mainTabview reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark------
#pragma mark------uitableViewDelegate uitableViewDatasource--------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10.0;
    }
    return 0.2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 3;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (row == 0) {
            //判断是否登录
            if (isLogin) {
                return 70;
            }else{
                return 130;
            }
        }
    }else{
        if(row == 2){
            if (iPhone6Plus) {
                return 390;
            }
            return 349;
            
        }

    }
//    if (row == 0) {
//        //判断是否登录
//        if (isLogin) {
//            return 70;
//        }else{
//           return 130;
//        }
//        
//    }else if(row == 4){
//        if (iPhone6Plus) {
//            return 390;
//        }
//        return 349;
//        
//    }
    return 50;
}
 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (row == 0) {
            //判断是否登录
            if (isLogin) {
                mineMainCell1 *cell1 = [self loadmineMainCell1:self.mainTabview];
                UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginBack"]];
                cell1.backgroundView = imageV;
                cell1.model = _userModel;
                return cell1;
            }else{
                NoneLoginCell *cell1 = [self loadNoneLoginCell:self.mainTabview];
                UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginBack"]];
                cell1.backgroundView = imageV;
                [cell1.loginButton addTarget:self action:@selector(loginButtonClip) forControlEvents:UIControlEventTouchUpInside];
                return cell1;
            }
        }else if(row == 1){
            mineMainCell2 *cell2 = [self loadmineMainCell2:self.mainTabview];
            if (isLogin) {
                cell2.numbel1.text = _userModel.couponCount;
                cell2.numLabel2.text = _userModel.collectCount;
            }else{
                cell2.numbel1.text = @"0";
                cell2.numLabel2.text = @"0";
            }
            
            [cell2.button1 addTarget:self action:@selector(couponButton) forControlEvents:UIControlEventTouchUpInside];
            [cell2.button2 addTarget:self action:@selector(myShoucang) forControlEvents:UIControlEventTouchUpInside];
            return cell2;
            
        }
    }else{
        if(row == 0){
            MineNextCell *cell5 = [self loadmineMainCell5:self.mainTabview];
            return cell5;
        }else if(row == 1){
            mineMainCell3 *cell3 = [self loadmineMainCell3:self.mainTabview];
            if (isLogin) {
                if (accountOverViewItem != nil) {
                    cell3.accountOverViewModel = accountOverViewItem;
                }
                cell3.but_1.tag = 1;
                cell3.but_2.tag = 2;
                cell3.but_3.tag = 3;
                cell3.but_1.enabled = YES;
                cell3.but_2.enabled = YES;
                cell3.but_3.enabled = YES;
                [cell3.but_1 addTarget:self action:@selector(moneyButAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell3.but_2 addTarget:self action:@selector(moneyButAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell3.but_3 addTarget:self action:@selector(moneyButAction:) forControlEvents:UIControlEventTouchUpInside];
            }else {
                cell3.moneylabel1.text = @"0.00";
                cell3.moneylabel2.text = @"0.00";
                cell3.moneylabel3.text = @"0.00";
                cell3.but_1.enabled = NO;
                cell3.but_2.enabled = NO;
                cell3.but_3.enabled = NO;
                
            }
            return cell3;
            
        }else if(row == 2){
            mineMainCell4 *cell4 = [self loadmineMainCell4:self.mainTabview];
            
            [cell4.button1 addTarget:self action:@selector(addOrders) forControlEvents:UIControlEventTouchUpInside];
            [cell4.button2 addTarget:self action:@selector(choujiang) forControlEvents:UIControlEventTouchUpInside];
            [cell4.button3 addTarget:self action:@selector(myBankCard) forControlEvents:UIControlEventTouchUpInside];
            [cell4.button4 addTarget:self action:@selector(myRedPacket) forControlEvents:UIControlEventTouchUpInside];
            [cell4.button5 addTarget:self action:@selector(myPhone) forControlEvents:UIControlEventTouchUpInside];
            [cell4.button6 addTarget:self action:@selector(addressManage) forControlEvents:UIControlEventTouchUpInside];
            [cell4.button7 addTarget:self action:@selector(myFriends) forControlEvents:UIControlEventTouchUpInside];
            [cell4.button8 addTarget:self action:@selector(safeSetting) forControlEvents:UIControlEventTouchUpInside];
            [cell4.button9 addTarget:self action:@selector(helpCenter) forControlEvents:UIControlEventTouchUpInside];
            
            cell4.userInfoModel = _userModel;
            return cell4;
            
        }

    }
    return nil;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = [indexPath row];
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (row == 0) {
            if (isLogin) {
                //个人资料
                MyInformationViewController *MyInformationVC = [[MyInformationViewController alloc]initWithNibName:nil bundle:nil];
                MyInformationVC.userInfoModel = _userModel;
                [self.navigationController pushViewController:MyInformationVC animated:YES];
            }
            
        }
    }
    if (section == 1) {
        if (row ==0) {
            if (isLogin) {
                AccountViewController *accountVC = [[AccountViewController alloc]initWithNibName:nil bundle:nil];
                accountVC.navigationItem.title = @"我的账户";
                if ((accountOverViewItem != nil)&&(accountOverViewItem.yye_yue != nil)) {
                    accountVC.accountOverModel = accountOverViewItem;
                }
                
                [self.navigationController pushViewController:accountVC animated:YES];
            }else{
                [self loginButtonClip];
            }
            
        }

    }
        
}

- (void)moneyButAction:(UIButton *)but{
    AccountDetailViewController * integralVC = [[AccountDetailViewController alloc]initWithNibName:nil bundle:nil];
    switch (but.tag) {
            
        case 1:
            integralVC.AccountDetailType = CHONGZHI;
            integralVC.totalAccount = [commonTools moneyTolayout:accountOverViewItem.chongzhi_jine_index];
            break;
        case 2:
            integralVC.AccountDetailType = ZHANGHU;
            integralVC.totalAccount = [commonTools moneyTolayout:accountOverViewItem.shouyi_yue];
            break;
        case 3:
            integralVC.AccountDetailType = JIFEN;
            integralVC.totalAccount = [commonTools moneyTolayout:accountOverViewItem.jifen];
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:integralVC animated:YES];
}
#pragma mark------
#pragma mark------loadTableViewCell---------
- (mineMainCell1 *)loadmineMainCell1:(UITableView *)tableView
{
    NSString * const nibName  = @"mineMainCell1";
    
    mineMainCell1 *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (mineMainCell2 *)loadmineMainCell2:(UITableView *)tableView
{
    NSString * const nibName  = @"mineMainCell2";
    
    mineMainCell2 *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (mineMainCell3 *)loadmineMainCell3:(UITableView *)tableView
{
    NSString * const nibName  = @"mineMainCell3";
    
    mineMainCell3 *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (mineMainCell4 *)loadmineMainCell4:(UITableView *)tableView
{
    NSString * const nibName  = @"mineMainCell4";
    
    mineMainCell4 *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

- (MineNextCell *)loadmineMainCell5:(UITableView *)tableView
{
    NSString * const nibName  = @"MineNextCell";
    
    MineNextCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (NoneLoginCell *)loadNoneLoginCell:(UITableView *)tableView
{
    NSString * const nibName  = @"NoneLoginCell";
    
    NoneLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

#pragma mark------
#pragma mark------to cell Buttons---------
//优惠券
- (void) couponButton
{
    if (isLogin) {
        //优惠券列表
        CouponListViewController *couponListVC = [[CouponListViewController alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:couponListVC animated:YES];
    }else{
        [self loginButtonClip];
    }
  
    
}
//我的收藏
- (void) myShoucang
{
    if (isLogin) {
        CollectViewController *CollectVC = [[CollectViewController alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:CollectVC animated:YES];
    }else{
        [self loginButtonClip];
    }
    
}

- (void)count{
    NSLog(@"123123123123123123123");
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId],@"userId",[NSString stringWithFormat:@"%d",1],@"page",@"10",@"pageSize", nil];
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId],@"userId",[NSString stringWithFormat:@"%d",1],@"page",@"10",@"pageSize",@"3",@"latitude",@"3",@"longitude",nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyCollectss.couponList" parameters:dict ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                _stringSC = @"0";
                _stringSC = [responseObject.result objectForKey:@"totalCount"];
                [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyCollectss.storeList" parameters:dict1 ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                    if (responseObject.succeed == YES) {
                        _stringSC = [NSString stringWithFormat:@"%d",[[responseObject.result objectForKey:@"totalCount"] intValue] + [_stringSC intValue]];
                        NSLog(@"--00--00--%@",_stringSC);
                        [self.mainTabview reloadData];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    });
    
    
    
    
}
//全部订单
- (void) addOrders
{
    if (isLogin) {
        OrderForAllViewController *OrderForAllVC = [[OrderForAllViewController alloc]initWithNibName:nil bundle:nil];
        OrderForAllVC.userInfoModel = _userModel;
        [self.navigationController pushViewController:OrderForAllVC animated:YES];
    }else{
        [self loginButtonClip];
    }
    
}
//我要抽奖
- (void)choujiang
{
    [[JTabBarController sharedManager] selectAtIndex:2];
}
//我的银行卡
- (void) myBankCard
{
    if (isLogin) {
        DidBoundBankCardViewController *DidBoundBankCardVC = [[DidBoundBankCardViewController alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:DidBoundBankCardVC animated:YES];
    }else{
        [self loginButtonClip];
    }
    
}
//红包
- (void)myRedPacket
{
    if (isLogin) {
        GeneralHongBaoViewController *vc = [[GeneralHongBaoViewController alloc]init];
        vc.userId = _userModel.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self loginButtonClip];
    }
    
}

//我的手机
- (void) myPhone
{
    if (isLogin) {
        BoundPhoneViewController *BoundPhoneVC = [[BoundPhoneViewController alloc]initWithNibName:nil bundle:nil];
        //绑定手机号状态
        if ([_userModel.phoneMobBindStatus intValue]==0) {
            BoundPhoneVC.phoneType = Bound_PHONE;
        }else{
            BoundPhoneVC.phoneType = PHONE_VERIFY;
        }
        
        [BoundPhoneVC callBackRegisterSuccess:^{
            [ProgressHUD showMessage:@"注册成功" Width:100 High:80];
        }];
        [self.navigationController pushViewController:BoundPhoneVC animated:YES];
    }else{
        [self loginButtonClip];
    }
    
}
//地址管理
- (void) addressManage
{
    if (isLogin) {
        MyAddressListViewController *addressVC = [[MyAddressListViewController alloc]initWithNibName:nil bundle:nil];
        addressVC.userId = _userModel.userId;
        [self.navigationController pushViewController:addressVC animated:YES];
    }else{
        [self loginButtonClip];
    }
    
}
//我的好友
- (void) myFriends
{
    if (isLogin) {
        MyAccountsFriends *friendsVC = [[MyAccountsFriends alloc]init];
        friendsVC.userInfoModel = _userModel;
        [self.navigationController pushViewController:friendsVC animated:YES];
    }else{
        [self loginButtonClip];
    }
    
    
}
//安全设置
- (void) safeSetting
{
    if (isLogin) {
        SafetySettingViewController *safetyVC = [[SafetySettingViewController alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:safetyVC animated:YES];
    }else{
        [self loginButtonClip];
    }
    
}
//帮助中心
- (void) helpCenter
{
    HelpCenterViewController *helpCenterVC = [[HelpCenterViewController alloc]initWithNibName:nil bundle:nil];
    helpCenterVC.isHelp = 1;
    [self.navigationController pushViewController:helpCenterVC animated:YES];
}
//登录
- (void) loginButtonClip
{
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}

//设置
- (void)left1Cliped:(id)sender
{
    SeetingViewController *setVC = [[SeetingViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:setVC animated:YES];
}


//消息

- (void)right1Cliped:(id)sender{
    MessageListViewController *messageVC = [[MessageListViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:messageVC animated:YES];

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

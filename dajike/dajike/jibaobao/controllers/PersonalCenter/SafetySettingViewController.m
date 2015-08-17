//
//  SafetySettingViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SafetySettingViewController.h"
#import "MineNextCell.h"
#import "defines.h"
#import "BoundPhoneViewController.h"
#import "SetPaymentCodeViewController.h"

@interface SafetySettingViewController ()
{
    NSArray *dataArray;
}
@end

@implementation SafetySettingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"安全设置";
        
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableView:UITableViewStyleGrouped];
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    [self addData];
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    [self addTableViewFootView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self initUserInfoModel];
    [self.mainTabview reloadData];
}

- (void)initUserInfoModel{
    
    if ([FileOperation isLogin]) {
        NSDictionary *userInfoDic = [[NSMutableDictionary alloc]init];
        userInfoDic = [[FileOperation readFileToDictionary:jibaobaoUser]mutableCopy];
        
        self.userInfoModel = [[UserInfoModel alloc]init];
        self.userInfoModel = [JsonStringTransfer dictionary:userInfoDic ToModel:self.userInfoModel];
    }else{
        
    }
}

//添加footView 保存
- (void) addTableViewFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 100)];
    footView.backgroundColor = Color_gray3;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 40, WIDTH_CONTROLLER_DEFAULT-30, 30)];
    btn.backgroundColor = Color_mainColor;
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(toSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    self.mainTabview.tableFooterView = footView;
}
- (void)addData
{
    dataArray = @[
                  @{
                      @"title1" : @"手机号",
                      @"title2" : @"未设置",
                      },
                  @{
                      @"title1" : @"密码登录",
                      @"title2" : @"未设置",
                      },
                  @{
                      @"title1" : @"大集客支付密码",
                      @"title2" : @"未设置",
                      }
                  ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark------
#pragma mark------uitableViewDelegate uitableViewDatasource--------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
//- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 0;
//}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineNextCell *cell1 = [self loadmineMineNextCell:self.mainTabview];
    cell1.titleLabel.text = [NSString stringWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"title1"]];
    if (indexPath.row == 0) {
        if ([self.userInfoModel.phoneMobBindStatus isEqualToString:@"0"]) {
            cell1.titleTwoLabel.text = [NSString stringWithString:[[dataArray objectAtIndex:indexPath.row]objectForKey:@"title2"]];
        }else{
            if ([commonTools isNull:self.userInfoModel.phoneMob]) {
                cell1.titleTwoLabel.text = @"";
            }else {
                NSMutableString *phoneMob = [NSMutableString stringWithString:self.userInfoModel.phoneMob];
                [phoneMob replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
                cell1.titleTwoLabel.text = phoneMob;
            }
        }
    }else if (indexPath.row == 1){

        if ([self.userInfoModel.password isEqualToString:@""]) {
            cell1.titleTwoLabel.text = [NSString stringWithString:[[dataArray objectAtIndex:indexPath.row]objectForKey:@"title2"]];
        }else{
            cell1.titleTwoLabel.text = @"";
        }
        
    }else if (indexPath.row == 2){
        if ([self.userInfoModel.password2 isEqualToString:@""]) {
            cell1.titleTwoLabel.text = [NSString stringWithString:[[dataArray objectAtIndex:indexPath.row]objectForKey:@"title2"]];
        }else{
            cell1.titleTwoLabel.text = @"";
        }

    }
    
    return cell1;
    
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0://手机号
        {
            BoundPhoneViewController *BoundPhoneVC = [[BoundPhoneViewController alloc]initWithNibName:nil bundle:nil];
            if ([self.userInfoModel.phoneMobBindStatus intValue]==0) {
                BoundPhoneVC.phoneType = Bound_PHONE;
            }else{
                BoundPhoneVC.phoneType = PHONE_VERIFY;
            }
            [self.navigationController pushViewController:BoundPhoneVC animated:YES];
        }
            break;
        case 1://密码登录
        {
            BoundPhoneViewController *vc = [[BoundPhoneViewController alloc]init];
            vc.phoneType = MIMA_VERIFY;
            [vc backToSafetySettingViewController:^{
                [ProgressHUD showMessage:@"密码设置成功" Width:100 High:80];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2://大集客支付密码
        {
            BoundPhoneViewController *vc = [[BoundPhoneViewController alloc]init];
            vc.phoneType = ZFMIMA_VERIFY;
            [vc backToSafetySettingViewController:^{
                [ProgressHUD showMessage:@"支付密码设置成功" Width:100 High:80];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark------
#pragma mark------loadTableView--------
- (MineNextCell *)loadmineMineNextCell:(UITableView *)tableView
{
    NSString * const nibName  = @"MineNextCell";
    
    MineNextCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

//保存
- (void)toSaveButton:(id) sender
{
    
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

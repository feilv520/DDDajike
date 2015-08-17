//
//  DMyAddressListViewController.m
//  dajike
//
//  Created by songjw on 15/7/13.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DMyAddressListAndSafeViewController.h"
#import "DEdittingAddressViewController.h"
#import "AddressManageCell.h"
#import "dDefine.h"
#import "DTools.h"
#import "DEdittingAddressViewController.h"
#import "DVerifyPhoneNumViewController.h"
#import "MyAddressModel.h"
#import "defines.h"
#import "UserInfoModel.h"

@interface DMyAddressListAndSafeViewController (){
    NSMutableArray *_addressListArr;
    NSArray *_safeArr;
    int _deleteBtnTag;
    UserInfoModel *_userModel;
}

@end

@implementation DMyAddressListAndSafeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    if ([FileOperation isLogin] &&
        self.address_safe == SAFE) {
        NSDictionary *userInfoDic = [[FileOperation readFileToDictionary:dajikeUser]mutableCopy];
        _userModel = [[UserInfoModel alloc]init];
        _userModel = [JsonStringTransfer dictionary:userInfoDic ToModel:_userModel];
    }
    [self.dMainTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:DColor_f3f3f3];
    [self addData];
    [self initView];
    
}
- (void)initView{
    [self addTableView:NO];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    
    if (self.address_safe == ADDRESS) {
        [self setNaviBarTitle:@"地址管理"];
        [self addTableViewFootView];
        [self getData];
    }
    if (self.address_safe == SAFE) {
        [self setNaviBarTitle:@"安全中心"];
        
    }
    
}
- (void)addData{
    if (self.address_safe == ADDRESS) {
        _addressListArr = [[NSMutableArray alloc]init];
        
    }
    if (self.address_safe == SAFE) {
        
        _safeArr = @[
                      @{
                          @"title1" : @"手机号",
                          @"title2" : @"未绑定",
                          },
                      @{
                          @"title1" : @"登录密码",
                          @"title2" : @"未设置",
                          },
                      @{
                          @"title1" : @"大集客支付密码",
                          @"title2" : @"未设置",
                          }
                      ];

    }
}
- (void)getData
{
    if ([FileOperation getUserId] == nil) {
        return;
    }
    NSDictionary *parameter = @{@"userId":[FileOperation getUserId]};
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyAddress.list" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSString *jsonStr = [AnalysisData decodeToString:responseObject.result];
            NSMutableArray *arr = [[JsonStringTransfer jsonStringToDictionary:jsonStr]mutableCopy];
            
            for (int i=0; i<arr.count; i++) {
                MyAddressModel *model = [[MyAddressModel alloc]init];
                model = [JsonStringTransfer dictionary:[arr objectAtIndex:i] ToModel:model];
                [arr replaceObjectAtIndex:i withObject:model];
            }
            [_addressListArr addObjectsFromArray:arr];
            
            [self.dMainTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
//添加footView 新增收获地址按钮
- (void) addTableViewFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DWIDTH_CONTROLLER_DEFAULT, 100)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 40, DWIDTH_CONTROLLER_DEFAULT-30, 30)];
    [DTools setButtton:btn Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
    if (self.address_safe == ADDRESS) {
        [btn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    }else if (self.address_safe == SAFE){
        [btn setTitle:@"保存" forState:UIControlStateNormal];
    }
    
    [btn setTintColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(toShouhuoButton:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    self.dMainTableView.tableFooterView = footView;
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
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.address_safe == ADDRESS) {
        return _addressListArr.count;
    }
    if (self.address_safe == SAFE) {
        return 3;
    }
    return 0;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.address_safe == ADDRESS) {
        return 90;
    }
    if (self.address_safe == SAFE) {
        return 45;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (self.address_safe == ADDRESS) {
        //    AddressManageCell *cell = [self loadAddressManageCell:self.dMainTableView];
        AddressManageCell *cell = [DTools loadTableViewCell:self.dMainTableView cellClass:[AddressManageCell class]];
        MyAddressModel *model = [_addressListArr objectAtIndex:indexPath.row];
        cell.model = [_addressListArr objectAtIndex:indexPath.row];
        NSLog(@"%@",model.state);
        if ([model.state isEqualToString:@"<null>"] ) {
            [cell.statusImageView setImage:[UIImage imageNamed:@"img_yo_sel"]];
        }else if ([model.state intValue] == 1) {
            [cell.statusImageView setImage:[UIImage imageNamed:@"img_yo_sel"]];
        }else{
            [cell.statusImageView setImage:[UIImage imageNamed:@"img_yes_sel"]];
        }
        cell.editButton.tag = row+100;
        cell.delateButton.tag = row+200;
        [cell.editButton addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
        [cell.delateButton addTarget:self action:@selector(dalateAddress:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }
    if (self.address_safe == SAFE) {
        NSString *const cellID = @"gongyong";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [DTools setLable:cell.textLabel Font:DFont_13 titleColor:DColor_808080 backColor:[UIColor clearColor]];
        cell.textLabel.text = [_safeArr[indexPath.row] objectForKey:@"title1"];
        switch (indexPath.row) {
            case 0:{
                if ([_userModel.phoneMobBindStatus intValue] == 1) {
                    [DTools setLable:cell.detailTextLabel Font:DFont_13 titleColor:DColor_808080 backColor:[UIColor clearColor]];
                    NSMutableString *phoneNum =[NSMutableString stringWithString:_userModel.phoneMob];
                    [phoneNum replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
                    cell.detailTextLabel.text = phoneNum;
                    break;
                }
            }
            case 1:{
                if ([_userModel.password intValue] == 1) {
                    cell.detailTextLabel.text = @"";
                    break;
                }
            }
            case 2:{
                if ([_userModel.password2 intValue] == 1) {
                    cell.detailTextLabel.text = @"";
                    break;
                }
            }
                
            default:
                [DTools setLable:cell.detailTextLabel Font:DFont_13 titleColor:DColor_c4291f backColor:[UIColor clearColor]];
                cell.detailTextLabel.text = [_safeArr[indexPath.row] objectForKey:@"title2"];
                break;
        }
        return cell;

    }
    return nil;
}- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.address_safe == ADDRESS) {
        MyAddressModel *model = [[MyAddressModel alloc]init];
        model = [_addressListArr objectAtIndex:indexPath.row];
        NSDictionary *parameter = @{@"userId":[FileOperation getUserId],@"addressId":model.addrId};
        
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyAddress.saveDefault" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                NSLog(@"设置默认地址成功");
                for (int i=0; i<_addressListArr.count; i++){
                    MyAddressModel *model1 = [_addressListArr objectAtIndex:i];
                    if (indexPath.row == i) {
                        if ([model1.state intValue] == 1) {
                            model1.state = @"0";
                        }else{
                            model1.state = @"1";
                        }
                    }else{
                        model1.state = @"1";
                    }
                    
                    [_addressListArr replaceObjectAtIndex:i withObject:model1];
                }
                if ([self.fromWhere isEqualToString:@"DConfirmOrderViewController"]) {
                    MyAddressModel *model2 = [_addressListArr objectAtIndex:indexPath.row];
                    if ([model2.state isEqualToString:@"0"]) {
                        self.block(model2);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }
                [tableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            NSLog(@"operation6 = %@",operation);
        }];
    }
    if (self.address_safe == SAFE) {
        DVerifyPhoneNumViewController *setPasswordVC = [[DVerifyPhoneNumViewController alloc]initWithNibName:@"DVerifyPhoneNumViewController" bundle:nil];
        if ([_userModel.phoneMobBindStatus intValue] == 1) {
            switch (indexPath.row) {
                case 0:
                    setPasswordVC.verigyTape = safe_phone_verify;
                    break;
                case 1:
                    setPasswordVC.verigyTape = safe_password_verify;
                    break;
                case 2:
                    setPasswordVC.verigyTape = safe_password2_verify;
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:
                    setPasswordVC.verigyTape = safe_phone_bound;
                    break;
                case 1:
                    setPasswordVC.verigyTape = safe_password_bound;
                    break;
                case 2:
                    setPasswordVC.verigyTape = safe_password2_bound;
                    break;
            }
        }
        
        setPasswordVC.userModel = _userModel;
        [self.navigationController pushViewController:setPasswordVC animated:YES];
    }
}

//新增收货地址
- (void)toShouhuoButton:(UIButton *)but{
    if (self.address_safe == ADDRESS) {
//        @"新增收货地址"
        DEdittingAddressViewController *MyAddressEditingVC = [[DEdittingAddressViewController alloc]initWithNibName:nil bundle:nil];
        MyAddressEditingVC.flagStr = @"1";
        MyAddressEditingVC.comefrom = self.fromWhere;
        [MyAddressEditingVC callBackAddressEdit:^(int flag,MyAddressModel *addressModel) {
        [_addressListArr removeAllObjects];
        [self getData];
        if ([self.fromWhere isEqualToString:@"DConfirmOrderViewController"]) {
            self.block(addressModel);
//            [self.navigationController popViewControllerAnimated:YES];
        }
        }];
        [self.navigationController pushViewController:MyAddressEditingVC animated:YES];
    }else if (self.address_safe == SAFE){
//        @"保存"
    }
    
    
}
//编辑收货地址
- (void)editAddress:(UIButton *)but{
    UIButton *btn = (UIButton *)but;
    NSInteger row = btn.tag - 100;
    NSLog(@"%ld",(long)row);
    DEdittingAddressViewController *MyAddressEditingVC = [[DEdittingAddressViewController alloc]initWithNibName:nil bundle:nil];
    MyAddressEditingVC.flagStr = @"2";
    MyAddressEditingVC.comefrom = self.fromWhere;
    [MyAddressEditingVC callBackAddressEdit:^(int flag,MyAddressModel *addressModel) {
        [_addressListArr removeAllObjects];
        [self getData];
        if ([self.fromWhere isEqualToString:@"DConfirmOrderViewController"]) {
            self.block(addressModel);
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    MyAddressEditingVC.model = [_addressListArr objectAtIndex:row];
    [self.navigationController pushViewController:MyAddressEditingVC animated:YES];
    
}
//删除收货地址
- (void)dalateAddress:(UIButton *)but{
    
    UIButton *btn = (UIButton *)but;
    _deleteBtnTag = (int)(btn.tag - 200);
    NSLog(@"%d",_deleteBtnTag);
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除该收货地址吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消");
    }else {
        NSLog(@"确定");
        MyAddressModel *model = [_addressListArr objectAtIndex:_deleteBtnTag];
        
        NSDictionary *parameter = @{@"userId":[FileOperation getUserId],@"addressId":model.addrId};
        
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyAddress.delete" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                [_addressListArr removeObjectAtIndex:_deleteBtnTag];
                [self.dMainTableView reloadData];
            }
            else
            {
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            NSLog(@"operation6 = %@",operation);
        }];
    }
}

- (void)callback:(CallbackDConfirmOrderViewController)block
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

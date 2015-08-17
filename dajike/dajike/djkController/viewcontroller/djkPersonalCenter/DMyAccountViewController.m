//
//  DMyAccountViewController.m
//  dajike
//
//  Created by songjw on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DMyAccountViewController.h"
#import "dDefine.h"
#import "DTools.h"
#import "commonTools.h"
#import "DMyAccountDetailViewController.h"

@interface DMyAccountViewController (){
    NSMutableArray *dataArray;
}

@end

@implementation DMyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:DColor_f3f3f3];
    [self setNaviBarTitle:@"我的账户"];
    [self addTableView:NO];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    
}
#pragma mark------
#pragma mark------uitableViewDelegate uitableViewDatasource--------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 25;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"accountCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [DTools setLable:cell.textLabel Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setLable:cell.detailTextLabel Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];

     NSString *detailText = [[NSString alloc]init];
    if (indexPath.section == 0){
        NSArray *array0 = @[@"营业额账户",@"充值账户",@"积分"];
        cell.textLabel.text = array0[indexPath.row];
        detailText = dataArray[indexPath.row];
        
        if (indexPath.row == 2) {
            cell.detailTextLabel.text = detailText;
            return cell;
        }
        
    }else if (indexPath.section == 1){
        NSArray *array0 = @[@"收益账户",@"奖励收益",@"今日抽奖"];
        cell.textLabel.text = array0[indexPath.row];
        detailText = dataArray[indexPath.row + 2];
        if (indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.detailTextLabel.text =[NSString stringWithFormat:@"¥%@", [commonTools moneyTolayout:detailText]];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DMyAccountDetailViewController * integralVC = [[DMyAccountDetailViewController alloc]initWithNibName:nil bundle:nil];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            integralVC.AccountDetailType = YINGYEE;
        }else if (indexPath.row == 1){
            integralVC.AccountDetailType = CHONGZHI;
        }else{
            integralVC.AccountDetailType = JIFEN;
        }
        if (dataArray.count > 0) {
            integralVC.totalAccount = [commonTools moneyTolayout:[dataArray objectAtIndex:indexPath.row]];
            if (indexPath.row == 2) {
                integralVC.totalAccount = [dataArray objectAtIndex:indexPath.row];
            }
        }
    }else{
        if (indexPath.row == 0) {
            integralVC.AccountDetailType = ZHANGHU;
        }else if (indexPath.row == 1){
            integralVC.AccountDetailType = JIANGLI;
        }else{
            return;
        }
        if (dataArray.count > 0) {
            integralVC.totalAccount = [commonTools moneyTolayout:[dataArray objectAtIndex:indexPath.row+2]];
        }
    }
    
    
    [self.navigationController pushViewController:integralVC animated:YES];
}

- (void)setAccountModel:(AccountOverViewModel *)model
{
    if (dataArray.count > 0) {
        [dataArray removeAllObjects];
        dataArray = nil;
    }
    dataArray = [[NSMutableArray alloc]init];
    [dataArray addObject:model.yye_yue];
    [dataArray addObject:model.chongzhi_jine_index];
    [dataArray addObject:model.jifen];
    [dataArray addObject:model.shouyi_yue];
    [dataArray addObject:model.shouyi_yue_ing];
    [dataArray addObject:model.choujiang_yue_ing];
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

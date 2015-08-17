//
//  AccountViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "AccountViewController.h"
#import "MineNextCell.h"
#import "defines.h"
#import "AccountDetailViewController.h"


@interface AccountViewController ()
{
    NSMutableArray *dataArray;
}
@end

@implementation AccountViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"我的账户";
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
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MineNextCell *cell1 = [self loadmineMineNextCell:self.mainTabview];
        NSArray * dataArray0 = @[@"营业额账户",@"充值账户",@"积分"];
        cell1.titleLabel.text = [NSString stringWithString:[dataArray0 objectAtIndex:indexPath.row]];
        if (dataArray.count > 0) {
            float a = [[dataArray objectAtIndex:indexPath.row]floatValue];
            a = a*100;
            a = round(a);
            a = a/100;
            cell1.titleTwoLabel.text = [NSString stringWithFormat:@"%.2f",a];
        }
        return cell1;
    }else{
        MineNextCell *cell1 = [self loadmineMineNextCell:self.mainTabview];
        NSArray * dataArray0 = @[@"收益账户",@"奖励收益",@"今日抽奖"];
        cell1.titleLabel.text = [NSString stringWithString:[dataArray0 objectAtIndex:indexPath.row]];
        if (dataArray.count > 0) {
            cell1.titleTwoLabel.text = [NSString stringWithString:[dataArray objectAtIndex:2+indexPath.row]];
        }
        if (indexPath.row == 2) {
           //不可点击，去除箭头
            [cell1.arrowImageV setHidden:YES];
        }
        return cell1;
    }
   
    
    return nil;

}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AccountDetailViewController * integralVC = [[AccountDetailViewController alloc]initWithNibName:nil bundle:nil];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            integralVC.AccountDetailType = YINGYEE;
        }else if (indexPath.row == 1){
            integralVC.AccountDetailType = CHONGZHI;
        }else{
            integralVC.AccountDetailType = JIFEN;
        }
    }else{
        if (indexPath.row == 0) {
            integralVC.AccountDetailType = ZHANGHU;
        }else if (indexPath.row == 1){
            integralVC.AccountDetailType = JIANGLI;
        }else{
            return;
        }
    }
    
    if (dataArray.count > 0) {
         integralVC.totalAccount = [NSString stringWithString:[dataArray objectAtIndex:indexPath.row]];
    }
    [self.navigationController pushViewController:integralVC animated:YES];
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


- (void)setAccountOverModel:(AccountOverViewModel *)model
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  DMyBankCardListViewController.m
//  dajike
//
//  Created by songjw on 15/7/15.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DMyBankCardListViewController.h"
#import "dDefine.h"
#import "DBaseNavView.h"
#import "DMyAfHTTPClient.h"
#import "FileOperation.h"
#import "AnalysisData.h"
#import "BankBoundListModel.h"
#import "BoundBankCardCell.h"
#import "DTools.h"
#import "DBankCardInfoViewController.h"
#import "DBoundBankCardViewController.h"

@interface DMyBankCardListViewController (){
    DImgButton *_rightBut;
    NSMutableArray *dataArray;
    
}

@end

@implementation DMyBankCardListViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self addData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"我的银行卡"];
    [self.view setBackgroundColor:DColor_f3f3f3];
    [self addTableView:NO];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    _rightBut = [DBaseNavView createNavBtnWithImgNormal:@"djk_bank_07" imgHighlight:@"djk_bank_07" imgSelected:@"djk_bank_07" target:self action:@selector(rightButAction)];
    [self setNaviBarRightBtn:_rightBut];
//    [self addData];
}
- (void)rightButAction{
    DBoundBankCardViewController *BoundBankCardVC = [[DBoundBankCardViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:BoundBankCardVC animated:YES];
}

- (void)addData
{
    //获取我的银行卡列表
    if ([FileOperation isLogin]) {//已登录
        NSString *userId = [FileOperation getUserId];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyBanks.list" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            
            
            if (responseObject.succeed == YES) {
                NSArray *resultArr= [AnalysisData decodeAndDecriptWittDESArray:responseObject.result];
                dataArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in resultArr) {
                    BankBoundListModel *bankListItem = [[BankBoundListModel alloc]init];
                    bankListItem = [JsonStringTransfer dictionary:dic ToModel:bankListItem];
                    NSLog(@"bankcode = %@",bankListItem.bankCode);
                    NSLog(@"bankname = %@",bankListItem.bankName);
                    [dataArray addObject:bankListItem];
                }
                [self.dMainTableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"operation = %@",operation);
            NSLog(@"error = %@",error);
        }];
    }
    
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
    return dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BankCardListCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BankCardListCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [DTools setLable:cell.textLabel Font:DFont_12 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setLable:cell.detailTextLabel Font:DFont_11 titleColor:DColor_b2b2b2 backColor:DColor_ffffff];
    cell.imageView.image = [UIImage imageNamed:@"img_yl.png"];
    BankBoundListModel *model = [dataArray objectAtIndex:row];
    cell.textLabel.text = model.bankName;
    NSMutableString *kahao = [NSMutableString stringWithString:model.kahao];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"尾号%@储蓄卡",[kahao substringWithRange:NSMakeRange(kahao.length-4, 4)]];
//    BoundBankCardCell *cell = [DTools loadTableViewCell:self.dMainTableView cellClass:[BoundBankCardCell class]];
//    if (dataArray > 0) {
//        cell.bankBoundModel = [dataArray objectAtIndex:row];
//    }
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    DBankCardInfoViewController *BankCardInfoVC = [[DBankCardInfoViewController alloc]initWithNibName:nil bundle:nil];
    BankCardInfoVC.bankId = [NSString stringWithFormat:@"%@",((BankBoundListModel *)[dataArray objectAtIndex:row]).id];
    [self.navigationController pushViewController:BankCardInfoVC animated:YES];
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

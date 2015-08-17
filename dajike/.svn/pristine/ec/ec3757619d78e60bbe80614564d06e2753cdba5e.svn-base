//
//  DidBoundBankCardViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "DidBoundBankCardViewController.h"
#import "BoundBankCardCell.h"
#import "BoundBankCardViewController.h"
#import "BankCardInfoViewController.h"
#import "defines.h"
#import "BankBoundListModel.h"


@interface DidBoundBankCardViewController ()
{
    NSMutableArray *dataArray;
}

@end

@implementation DidBoundBankCardViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"已绑定银行卡";
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTableView:UITableViewStyleGrouped];
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    
    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn0 setFrame:CGRectMake(0, 0, 20, 20)];
    [btn0 setBackgroundImage:[UIImage imageNamed:@"img_plus"] forState:UIControlStateNormal];
    //            UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //            [navRightBtn setFrame:CGRectMake(0, 0, 34, 44)];
    //            [navRightBtn setBackgroundColor:[UIColor clearColor]];
    [btn0 addTarget:self action:@selector(addButtonClip:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barRightButtonItem0 = [[UIBarButtonItem alloc] initWithCustomView:btn0];
    self.navigationItem.rightBarButtonItem = barRightButtonItem0;
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //添加绑定银行卡后再返回已绑定银行卡页面要重新加载数据
    [self addData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addData
{
    //获取我的银行卡列表
    if ([FileOperation isLogin]) {//已登录
        NSString *userId = [FileOperation getUserId];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyBanks.list" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            
            
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
                [self.mainTabview reloadData];
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
    BoundBankCardCell *cell = [self loadBoundBankCardCell:self.mainTabview];
    if (dataArray > 0) {
        cell.bankBoundModel = [dataArray objectAtIndex:row];
    }
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    
    BankCardInfoViewController *BankCardInfoVC = [[BankCardInfoViewController alloc]initWithNibName:nil bundle:nil];
    BankCardInfoVC.bankId = [NSString stringWithFormat:@"%@",((BankBoundListModel *)[dataArray objectAtIndex:row]).id];
    [self.navigationController pushViewController:BankCardInfoVC animated:YES];
}
#pragma mark------
#pragma mark------loadTableView--------
- (BoundBankCardCell *)loadBoundBankCardCell:(UITableView *)tableView
{
    NSString * const nibName  = @"BoundBankCardCell";
    
    BoundBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

- (void) addButtonClip:(id) sender
{
    BoundBankCardViewController *BoundBankCardVC = [[BoundBankCardViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:BoundBankCardVC animated:YES];
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

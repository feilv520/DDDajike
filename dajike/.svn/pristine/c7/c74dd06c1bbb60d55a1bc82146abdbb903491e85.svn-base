//
//  CouponListViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponListCell.h"
#import "CouponListModel.h"
#import "CouponDetailsListViewController.h"
#import "defines.h"


@interface CouponListViewController ()
{
    NSMutableArray *dataArray;
}

@end

@implementation CouponListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"优惠券";
        
    dataArray = [[NSMutableArray alloc]init];
        
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addData
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId],@"userId", nil];
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyCoupons.list" parameters:dict ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"opertion:%@",operation);
        NSLog(@"result:%@",responseObject.result);
        if (responseObject.succeed == YES) {
            NSDictionary *resultDict= responseObject.result;
            for (NSDictionary *dic in resultDict) {
                
                CouponListModel *couponModel = [[CouponListModel alloc]init];
                   
                couponModel = [JsonStringTransfer dictionary:dic ToModel:couponModel];
    
                [dataArray addObject:couponModel];
            }
            [self.mainTabview reloadData];
    }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];

}

#pragma mark------
#pragma mark------uitableViewDelegate uitableViewDatasource--------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count == 0) {
        [self.noDataView setHidden:NO];
    }else{
        [self.noDataView setHidden:YES];
    }

    return dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CouponListCell *cell = [self loadCouponListCell:self.mainTabview];
    static NSString *cellID = @"cellId";
    
    CouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponListCell" owner:nil options:nil] lastObject];
    
    }
    CouponListModel *model = dataArray[indexPath.row];
    cell.couponListModel = model;
    
    
   // cell.titleLabel1.text = [[dataArray objectAtIndex:indexPath.row]objectForKey:@"title1"];
//    cell.titleLavel2.text = [[dataArray objectAtIndex:indexPath.row]objectForKey:@"title2"];
//    cell.numLabel.text = [[dataArray objectAtIndex:indexPath.row]objectForKey:@"number"];
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponDetailsListViewController *couponDetailsListVC = [[CouponDetailsListViewController alloc]initWithNibName:nil bundle:nil];
    CouponListModel *model = [dataArray objectAtIndex:indexPath.row];
    couponDetailsListVC.coupon_id = model.coupon_id;
    couponDetailsListVC.orderId = model.order_id;
    [self.navigationController pushViewController:couponDetailsListVC animated:YES];
}

#pragma mark------
#pragma mark------loadTableView--------
- (CouponListCell *)loadCouponListCell:(UITableView *)tableView
{
    NSString * const nibName  = @"CouponListCell";
    
    CouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
        
    }
    
    return cell;
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

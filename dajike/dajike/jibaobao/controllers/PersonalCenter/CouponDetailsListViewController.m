//
//  CouponDetailsListViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "CouponDetailsListViewController.h"

#import "CouponListCell.h" 
#import "CouponPasswordCell.h"
#import "CouponQRCodeCell.h"

#import "defines.h"
#import "CouponDetailsListModel.h"

#import "QRCodeGenerator.h"
#import "QRViewController.h"

#import "CashCouponDetailViewController.h"

@interface CouponDetailsListViewController ()
{
    
    CouponDetailsListModel *_myModel;
    
}

@end

@implementation CouponDetailsListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"优惠券详情";
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myModel  = [[CouponDetailsListModel alloc]init];
    
    [self addTableView:UITableViewStyleGrouped];
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    [self addData];

}

- (void)codepd
{
    
    UIImage *image = [QRCodeGenerator qrImageForString:@"sdjhsgdjasdw2312jsdjlasd" imageSize:50];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.image = image;
    [self.view addSubview:imageView];
    

    
}
//- (void)seanAction:(id)sender
//{
//
//    QRViewController *ctrl = [[QRViewController alloc] initWithBlock:^(NSString *result, BOOL flag) {
//        NSLog(@"%@",result);
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
//        
//    }];
//    
//    [self presentViewController:ctrl animated:YES completion:nil];
//    
//
//    
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addData
{
    NSLog(@"%@",self.coupon_id);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId],@"userId",self.orderId,@"orderId",nil];
    
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyCoupons.detail" parameters:dict ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        
        NSLog(@"opertion:%@",operation);
        NSLog(@"result:%@",responseObject.result);
        if (responseObject.succeed == YES) {
       
        NSMutableDictionary *mDic = [[AnalysisData decodeAndDecriptWittDESstring:responseObject.result]mutableCopy];
            
             _myModel = [JsonStringTransfer dictionary:mDic ToModel:_myModel];
          
            [self.mainTabview reloadData];
        
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];

    
    
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
    return 3;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    
    if (indexPath.row == 0) {
        return 50;
        
    }else if (indexPath.row == 1){
        return 31;
        
    }else if (indexPath.row == 2){
        return 160;
        
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        static NSString *cellID = @"cellId";
        CouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponListCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.couponDetailModel = _myModel;
        return cell;
    }else if (indexPath.row == 1){
        static NSString *cellId = @"cell";
        CouponPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponPasswordCell" owner:nil options:nil]lastObject];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.passwordLabel.text = _myModel.code;
        return cell;
    }else if (indexPath.row == 2){
        
        static NSString *cellId = @"cell";
        CouponQRCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
           
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponQRCodeCell" owner:nil options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.couponDetailModel = _myModel;
        return cell;
    }
  
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        CashCouponDetailViewController *couponVC2 = [[CashCouponDetailViewController alloc]init];
        couponVC2.navigationItem.title = @"代金券详情";
        couponVC2.goodsId = self.coupon_id;
        [self.navigationController pushViewController:couponVC2 animated:YES];
    }
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
- (CouponPasswordCell *)loadCouponPasswordCell:(UITableView *)tableView
{
    NSString * const nibName  = @"CouponPasswordCell";
    
    CouponPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (CouponQRCodeCell *)loadCouponQRCodeCell:(UITableView *)tableView
{
    NSString * const nibName  = @"CouponQRCodeCell";
    
    CouponQRCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
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

//
//  BuySuccessViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
    类：购买成功
 */

#import "BuySuccessViewController.h"
#import "defines.h"
#import "UIView+MyView.h"
#import "CouponListViewController.h"
#import "BuySucceedCell.h"
#import "AllProductSortCell.h"
#import "CouponBuyCell.h"

static NSString *swbCell1 = @"BuySucceedCell";
static NSString *swbCell2 = @"AllProductSortCell";
static NSString *swbCell3 = @"CouponBuyCell";

@interface BuySuccessViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_codeMiMaArr;
}

@end

@implementation BuySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleLabel.text = @"购买成功";
    _codeMiMaArr = [[NSMutableArray alloc]init];
    self.delegate = self;
    
    [self setTableView];
    
    [self getData];
}

// ----------------- 我是分割线， 代码开始 -----------------

- (void)getData
{
    for (int i=0; i<self.arr.count; i++) {
        [self getCouponMiMa:[NSString stringWithFormat:@"%@",[[self.arr objectAtIndex:i]objectForKey:@"orderId"]]];
    }
}
//获取代金券密码
- (void)getCouponMiMa:(NSString *)orderId
{
    NSDictionary *parameter = @{@"orderId":orderId,@"userId":[FileOperation getUserId]};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyCoupons.detail" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSMutableDictionary *tmpDic = [[AnalysisData decodeAndDecriptWittDESArray:responseObject.result]mutableCopy];
            [_codeMiMaArr addObject:[tmpDic objectForKey:@"code"]];
            if (_codeMiMaArr.count == self.arr.count) {
                [self.mainTabview reloadData];
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
//初始化创建界面
- (void)setTableView
{
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self addTableView:UITableViewStyleGrouped];
    
    [self setScrollBtnHidden:YES];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    self.mainTabview.scrollEnabled = NO;
    [self.mainTabview registerNib:[UINib nibWithNibName:@"BuySucceedCell" bundle:nil] forCellReuseIdentifier:swbCell1];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"AllProductSortCell" bundle:nil] forCellReuseIdentifier:swbCell2];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"CouponBuyCell" bundle:nil] forCellReuseIdentifier:swbCell3];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 60;
    }
    if (indexPath.row == 2) {
        return self.arr.count*20+(self.arr.count+1)*5+35;
    }
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *mView = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 80) andBackgroundColor:[UIColor clearColor]];
    UIButton *btn1 = [self.view createButtonWithFrame:CGRectMake(10, 20, WIDTH_CONTROLLER_DEFAULT/2-30, 40) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:@"查看全部优惠券" andTag:22];
    btn1.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:135.0/255.0 blue:34.0/255.0 alpha:1.0f];
    btn1.layer.cornerRadius = 2.0f;
    btn1.layer.masksToBounds = YES;
    btn1.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [mView addSubview:btn1];
    UIButton *btn2 = [self.view createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/2+20, 20, WIDTH_CONTROLLER_DEFAULT/2-30, 40) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:@"继续购物" andTag:33];
    btn2.backgroundColor = Color_mainColor;
    btn2.layer.cornerRadius = 2.0f;
    btn2.layer.masksToBounds = YES;
    btn2.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [mView addSubview:btn2];
    return mView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        BuySucceedCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell1];
        return myCell;
    }
    if (indexPath.row == 1) {
        AllProductSortCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell2];
        myCell.titleLb.text = @"商品名称";
        [myCell.allBtn setTitle:self.goodName forState:UIControlStateNormal];
        CGRect rect = [self.view contentAdaptionLabel:self.goodName withSize:CGSizeMake(500, 21) withTextFont:15.0f];
        [myCell.allBtn setTitleColor:Color_Black forState:UIControlStateNormal];
        myCell.userInteractionEnabled = NO;
        myCell.btnCon.constant = rect.size.width+5;
        return myCell;
    }
    else {
        CouponBuyCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell3];
        myCell.couponArr = [_codeMiMaArr mutableCopy];
        return myCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// tag ==  22.查看全部优惠券  33.继续购物
- (void)btnClickedAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 22) {
        NSLog(@"查看全部优惠券");
        CouponListViewController *listVC = [[CouponListViewController alloc]init];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    if (btn.tag == 33) {
        NSLog(@"继续购物");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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

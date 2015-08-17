//
//  AllSubbranchViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 **  类： 全部分店
 */

#import "AllSubbranchViewController.h"
#import "defines.h"
#import "AllSubbranchCell.h"
#import "FoodShopDetailViewController.h"

static NSString *swbCell = @"swbCell00";

@interface AllSubbranchViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AllSubbranchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleLabel.text = @"商家列表";
    self.delegate = self;
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self addTableView:UITableViewStylePlain];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    [self addHeaderAndFooter];
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"AllSubbranchCell" bundle:nil] forCellReuseIdentifier:swbCell];
    
}

// -------------- 我是分割线，代码开始 ---------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllSubbranchCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell];
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoodShopDetailViewController *foodVC = [[FoodShopDetailViewController alloc]init];
    [self.navigationController pushViewController:foodVC animated:YES];
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

//
//  ProductSortViewController.m
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
 **   商品列表---》商品分类
 */

#import "ProductSortViewController.h"
#import "defines.h"
#import "UIView+MyView.h"
#import "AllProductSortCell.h"
#import "MyClickLb.h"

#define testPid @"2"       //测试数据

#define rightPid @"5"      //正确数据

static NSString *swbCell1 = @"swbCell111";

@interface ProductSortViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *_titleArr;
    
    NSMutableDictionary      *_dataSource;
    
}

@end

@implementation ProductSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleLabel.text = @"全部商品";
    _titleArr = [[NSMutableArray alloc]init];
    _dataSource = [[NSMutableDictionary alloc]init];
    [titleLabel setFrame:CGRectMake(10, 7, 100, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
    titleLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:46.0/255.0 blue:46.0/255.0 alpha:1.0f];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:titleLabel];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIButton *btn = [self.view createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-50, 12, 20, 26) andBackImageName:@"img_arrow_01_right" andTarget:self andAction:@selector(btnClickedAction:) andTitle:nil andTag:23];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.delegate = self;
    
//    [self setNavType:SEARCH_BUTTON];
//    [self setScrollBtnHidden:YES];
    
    [self addTableView:UITableViewStylePlain];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    self.mainTabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"AllProductSortCell" bundle:nil] forCellReuseIdentifier:swbCell1];
    
    [self getData];
    
    
    
}

// --------------------------- 分割线 ------------------------------------

- (void)getData
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:rightPid,@"pid", nil];
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Goods.goodsCategory" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            
            _dataSource = [responseObject.result mutableCopy];
            NSLog(@"%@",_dataSource);
            _titleArr = [[_dataSource allKeys]mutableCopy];
            
            // 更新界面
            [self.mainTabview reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

- (void)btnClickedAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int arrCount = (int)[[_dataSource objectForKey:[_titleArr objectAtIndex:indexPath.row]] count];
    int rowHeight = (arrCount/2+arrCount%2)*40+30;
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllProductSortCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell1];
    myCell.titleLb.text = [_titleArr objectAtIndex:indexPath.row];
    __weak ProductSortViewController *weakSelf = self;
    myCell.allBtn.tag = indexPath.row*2+2;
    [myCell callBackAllProduct:^(int btnTag){
        weakSelf.block([[[_dataSource objectForKey:[_titleArr objectAtIndex:(btnTag-2)/2]]objectAtIndex:0]objectAtIndex:0],[_titleArr objectAtIndex:(btnTag-2)/2]);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    NSMutableArray *arr1 = [[_dataSource objectForKey:[_titleArr objectAtIndex:indexPath.row]]mutableCopy];
    
    UIView *myView = (UIView *)[myCell.contentView viewWithTag:21];
    if (!myView) {
        myView = [self.view createViewWithFrame:CGRectMake(0, 30, WIDTH_CONTROLLER_DEFAULT, (arr1.count/2+arr1.count%2)*40) andBackgroundColor:Color_Clear];
        myView.tag = 21;
        [myCell.contentView addSubview:myView];
    }
    for (UIView *tmpView in myView.subviews) {
        [tmpView removeFromSuperview];
    }
    
    for (int i=0; i<arr1.count; i++) {
        NSMutableArray *arr2 = [[arr1 objectAtIndex:i]mutableCopy];
        
        MyClickLb *lb1 = [[MyClickLb alloc]initWithFrame:CGRectMake(10+i%2*2+i%2*((WIDTH_CONTROLLER_DEFAULT-22)/2), 5+i/2*36+i/2*2, (WIDTH_CONTROLLER_DEFAULT-22)/2, 36)];
        lb1.font = [UIFont systemFontOfSize:16.0f];
        lb1.tag = i*100+1000;
        
        lb1.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0f];
        lb1.text = [NSString stringWithFormat:@"    %@",[arr2 objectAtIndex:2]];
        lb1.textColor = [UIColor colorWithRed:110.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0f];
        [lb1 callbackClickedLb:^(MyClickLb *clickLb) {
            if (clickLb.tag == i*100+1000) {
                NSLog(@"%ld",(long)clickLb.tag);
                weakSelf.block([arr2 objectAtIndex:1],[arr2 objectAtIndex:2]);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
        [myView addSubview:lb1];
    }
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myCell;
}


- (void)callBackProduct:(CallbackAllProductBlock)block
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

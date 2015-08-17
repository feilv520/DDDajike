//
//  IndentDetailViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/9.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
 **  类描述： 代金劵订单详情
 */

#import "IndentDetailViewController.h"
#import "defines.h"
#import "UIView+MyView.h"
#import "OrdersDetailModel.h"

//商品订单详情
#import "BeautifulFoodCellTableViewCell.h"
#import "ReceiveAddressCell.h"
#import "SwbCell5.h"
#import "SwbCell6.h"
#import "SwbCell7.h"
#import "SwbCell8.h"
static NSString *goodsCell0 = @"BeautifulFoodCellTableViewCell";
static NSString *goodsCell1 = @"ReceiveAddressCell";
static NSString *goodsCell2 = @"SwbCell5";
static NSString *goodsCell3 = @"SwbCell6";
static NSString *goodsCell4 = @"SwbCell7";
static NSString *goodsCell5 = @"SwbCell8";



//代金券订单详情
#import "IndentDetailCell1.h"
#import "IndentDetailCell2.h"
#import "IndentDetailCell3.h"

static NSString *cell1 = @"swbCell1";
static NSString *cell2 = @"swbCell2";
static NSString *cell3 = @"swbCell3";
//static NSString *cell4 = @"swbCell4";



@interface IndentDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableDictionary *_ordersDetailDict;
    OrdersDetailModel *_ordersDetailModel;
    
    UILabel *lb1;
    UILabel *lb2;
    UILabel *lb3;
}
@end

@implementation IndentDetailViewController
{
    UIView *_viewBg;
    UIView *_mView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"订单详情";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.delegate = self;
    
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self addTableView:UITableViewStyleGrouped];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    _ordersDetailDict = [[NSMutableDictionary alloc]init];
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"IndentDetailCell1" bundle:nil] forCellReuseIdentifier:cell1];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"IndentDetailCell2" bundle:nil] forCellReuseIdentifier:cell2];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"IndentDetailCell3" bundle:nil] forCellReuseIdentifier:cell3];
//    [self.mainTabview registerClass:[UITableViewCell class] forCellReuseIdentifier:cell4];
    
//    [self addHeaderAndFooter];
    
    [self setViewBg];
    //订单详情
    [self myOrdersDetail];
}


//------------------ 我是分割线 ，代码开始 ----------------------
#pragma mark  TableView  Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //代金券订单详情
    if ([self.myOrderListModel.type isEqualToString:@"coupon"]) {
        return 6;
    }else{
        //商品订单详情
        
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.myOrderListModel.type isEqualToString:@"coupon"]) {
        //代金券订单详情
        if (indexPath.row == 0) {
            return 90;
        }
        if (indexPath.row == 5) {
            return 120;
        }
        return 44;
    }else{
        //商品订单详情
        if (indexPath.row == 0|| indexPath.row == 2) {
            return 80;
        }else if (indexPath.row == 3||indexPath.row == 1){
            return 70;
        }else if (indexPath.row == 4){
            return 150;
        }else{
            return 60;
        }

    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *mView = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 80) andBackgroundColor:[UIColor clearColor]];
    NSString *mBtnTitle = [[NSString alloc]init];
//    if ([self.myOrderListModel.type isEqualToString:@"coupon"]) { //代金券订单详情
//        mBtnTitle = @"申请退款";
//    }else{
//        mBtnTitle = @"继续购物";//商品订单详情
//    }
    mBtnTitle = @"继续购物";
    UIButton *mBtn = [self.view createButtonWithFrame:CGRectMake(10, 30, WIDTH_CONTROLLER_DEFAULT-20, 44) andBackImageName:nil andTarget:self andAction:@selector(goOnShopping:) andTitle:mBtnTitle andTag:1];
    mBtn.backgroundColor = Color_mainColor;
    [mView addSubview:mBtn];
    return mView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.myOrderListModel.type isEqualToString:@"coupon"]) {//代金券订单详情
        return [self chitOrderDetailCell:tableView withRow:indexPath.row];
    }else{//商品订单详情
        
        return [self goodsOrderDetailCell:tableView withRow:indexPath.row];
    }
    return nil;
}

//商品订单详情cell
- (UITableViewCell *)goodsOrderDetailCell:(UITableView *)tableView withRow:(NSInteger)row{
    //商品订单详情
    if (row == 0) {
        BeautifulFoodCellTableViewCell * mCell = [tableView dequeueReusableCellWithIdentifier:goodsCell0];
        if (mCell == nil) {
            mCell = [[[NSBundle mainBundle] loadNibNamed:@"BeautifulFoodCellTableViewCell" owner:self options:nil] lastObject];
        }
        mCell.ordersDetailModel = _ordersDetailModel;
        return mCell;
    }else if (row == 1){
        SwbCell5* mCell = [tableView dequeueReusableCellWithIdentifier:goodsCell1];
        if (mCell == nil) {
            mCell = [[[NSBundle mainBundle] loadNibNamed:@"SwbCell5" owner:self options:nil] lastObject];
        }
        mCell.ordersDetailModel = _ordersDetailModel;
        return mCell;
    }else if (row == 2){
        SwbCell6* mCell = [tableView dequeueReusableCellWithIdentifier:goodsCell2];
        if (mCell == nil) {
            mCell = [[[NSBundle mainBundle] loadNibNamed:@"SwbCell6" owner:self options:nil] lastObject];
        }
        mCell.ordersDetailModel = _ordersDetailModel;
        return mCell;
    }else if (row == 3){
        ReceiveAddressCell* mCell = [tableView dequeueReusableCellWithIdentifier:goodsCell3];
        if (mCell == nil) {
            mCell = [[[NSBundle mainBundle] loadNibNamed:@"ReceiveAddressCell" owner:self options:nil] lastObject];
        }
        mCell.ordersDetailModel = _ordersDetailModel;
        return mCell;
    }else if (row == 5){
        SwbCell8* mCell = [tableView dequeueReusableCellWithIdentifier:goodsCell4];
        if (mCell == nil) {
            mCell = [[[NSBundle mainBundle] loadNibNamed:@"SwbCell8" owner:self options:nil] lastObject];
        }
        mCell.ordersDetailModel = _ordersDetailModel;
        return mCell;
    } else if (row == 4){
        SwbCell7* mCell = [tableView dequeueReusableCellWithIdentifier:goodsCell5];
        if (mCell == nil) {
            mCell = [[[NSBundle mainBundle] loadNibNamed:@"SwbCell7" owner:self options:nil] lastObject];
        }
        mCell.ordersDetailModel = _ordersDetailModel;
        return mCell;
    }else {
        return nil;
    }

    return nil;
}

//代金券订单详情
- (UITableViewCell *)chitOrderDetailCell:(UITableView *)tableView withRow:(NSInteger)row{
    //代金券订单详情
    if (row == 0) {
        IndentDetailCell1 *mCell = [tableView dequeueReusableCellWithIdentifier:cell1];
        mCell.ordersDetailModel = _ordersDetailModel;
        return mCell;
    }else if (row == 1) {
        IndentDetailCell2 *mCell = [tableView dequeueReusableCellWithIdentifier:cell2];
        mCell.orderDetailModel = _ordersDetailModel;
        return mCell;
    }else if (row == 5) {
        IndentDetailCell3 *mCell = [tableView dequeueReusableCellWithIdentifier:cell3];
        mCell.ordersDetailModel = _ordersDetailModel;
        return mCell;
    }else {
        static NSString *cell4 = @"cell44";
        UITableViewCell *mCell = [tableView dequeueReusableCellWithIdentifier:cell4];
        
//        if (!mCell) {
//            
//        }
        mCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell4];
        lb1 = [self.view creatLabelWithFrame:CGRectMake(10, 7, 100, 30) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
        [mCell.contentView addSubview:lb1];
        lb2 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(lb1.frame)+10, 7, WIDTH_CONTROLLER_DEFAULT-CGRectGetMaxX(lb1.frame)-20, 30) AndFont:14.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
        [mCell.contentView addSubview:lb2];
        lb3 = [self.view creatLabelWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-110, 7, 100, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentRight AndTextColor:[UIColor redColor] andCornerRadius:0.0f];
        [mCell.contentView addSubview:lb3];
        
        if (row == 2) {
            lb1.text = @"代金券";
            if (_ordersDetailModel.endTime == nil) {
                lb2.text = @"无";
            }else{
                lb2.text = [NSString stringWithFormat:@"有效期至: %@",_ordersDetailModel.endTime];
            }
            lb2.textAlignment = NSTextAlignmentRight;
            lb3.hidden = YES;
        }
        if (row == 3) {
            lb1.text = @"密码";
            lb2.frame = CGRectMake(CGRectGetMaxX(lb1.frame)+10, 7, WIDTH_CONTROLLER_DEFAULT-CGRectGetMaxX(lb1.frame)-120, 30);
            if (_ordersDetailModel.code == nil) {
                lb2.text = @"无";
            }else{
                lb2.text = _ordersDetailModel.code;
            }
            
            lb3.text = @"未消费";
        }
        if (row == 4) {
            lb1.text = @"订单信息";
            lb2.hidden = YES;
            lb3.hidden = YES;
        }
        return mCell;
    }
    return nil;

}

- (void)setViewBg
{
    _viewBg = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT) andBackgroundColor:[UIColor clearColor]];
    [_viewBg setHidden:YES];
    
    UIView *viewBG = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT) andBackgroundColor:[UIColor blackColor]];
    viewBG.alpha = 0.5f;
    [_viewBg addSubview:viewBG];
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
    [_viewBg addGestureRecognizer:mTap];
    
    _mView = [self.view createViewWithFrame:CGRectMake(30, 100, WIDTH_CONTROLLER_DEFAULT-60, 120) andBackgroundColor:[UIColor whiteColor]];
    
    UILabel *mLabel = [self.view creatLabelWithFrame:CGRectMake(10, 20, _mView.frame.size.width-20, 30) AndFont:15.0f AndBackgroundColor:[UIColor clearColor] AndText:@"申请退款后将享受不到优惠，继续？" AndTextAlignment:NSTextAlignmentCenter AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
    [_mView addSubview:mLabel];
    
    UIView *lineView1 = [self.view createViewWithFrame:CGRectMake(0, CGRectGetMaxY(mLabel.frame)+20, _mView.frame.size.width, 1) andBackgroundColor:[UIColor grayColor]];
    [_mView addSubview:lineView1];
    
    UIButton *cancleBtn = [self.view createButtonWithFrame:CGRectMake(0, CGRectGetMaxY(lineView1.frame), _mView.frame.size.width/2, 50) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:@"取消" andTag:33];
    [cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_mView addSubview:cancleBtn];
    
    UIView *lineView2 = [self.view createViewWithFrame:CGRectMake(CGRectGetMaxX(cancleBtn.frame), CGRectGetMaxY(lineView1.frame), 1, 50) andBackgroundColor:[UIColor grayColor]];
    [_mView addSubview:lineView2];
    
    UIButton *okBtn = [self.view createButtonWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame), CGRectGetMaxY(lineView1.frame), _mView.frame.size.width/2, 50) andBackImageName:nil andTarget:self andAction:@selector(btnClickedAction:) andTitle:@"确认" andTag:55];
    [okBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_mView addSubview:okBtn];
    
    [_viewBg addSubview:_mView];
    [self.view addSubview:_viewBg];
}
// 手势
- (void)tapClicked:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3f animations:^{
        _viewBg.alpha = 0.0;
        [_mView setHidden:YES];
        [_viewBg setHidden:YES];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)goOnShopping:(id)sender{
    [[JTabBarController sharedManager] selectAtIndex:0];
}

// 申请退款
- (void)refundBtnAction:(id)sender
{
//    [UIView animateWithDuration:0.3f animations:^{
        _viewBg.alpha = 1.0f;
        
        
//    } completion:^(BOOL finished) {
        [_viewBg setHidden:NO];
        [_mView setHidden:NO];
//    }];
    NSLog(@"申请退款");
}

// tag:  33.取消   55.确认
- (void)btnClickedAction:(id)sender
{
    UIButton *mBtn = (UIButton *)sender;
    if (mBtn.tag == 33) {
        NSLog(@"取消");
        [UIView animateWithDuration:0.3f animations:^{
            _viewBg.alpha = 0.0;
            [_mView setHidden:YES];
            [_viewBg setHidden:YES];
        } completion:^(BOOL finished) {
            
        }];
    }
    if (mBtn.tag == 55) {
        NSLog(@"确认");
    }
}


//订单详情
- (void)myOrdersDetail{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.userInfoModel.userId, @"userId", self.myOrderListModel.order_id,@"orderId",  @"buyer",@"type",nil];
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2", @"userId", @"507",@"orderId",  @"buyer",@"type",nil];
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.detail" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            _ordersDetailDict = responseObject.result;
            NSMutableDictionary *dict0 = [NSMutableDictionary dictionaryWithDictionary:_ordersDetailDict];
            NSDictionary *dict = [[_ordersDetailDict objectForKey:@"orderGoods"]objectAtIndex:0];
            NSArray *keyArr = [dict allKeys];
            for ( NSString *key in keyArr) {
                [dict0 setValue:[dict objectForKey:key] forKey:key];
            }
            [dict0 removeObjectForKey:@"orderGoods"];
            _ordersDetailModel = [[OrdersDetailModel alloc]init];
            _ordersDetailModel = [JsonStringTransfer dictionary:dict0 ToModel:_ordersDetailModel];
            [self.mainTabview reloadData];
        }else{
            
        }
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
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

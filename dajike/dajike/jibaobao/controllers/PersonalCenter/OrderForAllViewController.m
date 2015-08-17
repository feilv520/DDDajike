//
//  OrderForAllViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "OrderForAllViewController.h"

#import "PYTabbar.h"
#import "defines.h"

#import "OrderCommentViewController.h"
#import "FillInIndentViewController.h"

#import "IndentDetailViewController.h"

#import "MyOrdersAjaxListModel.h"
#import "orderGoodsModel.h"
#import "NewIndentViewController.h"
#import "OrdersDetailModel.h"
#import "PayPopView.h"
#import "FindPassword0ViewController.h"


@interface OrderForAllViewController ()<PYTabbarDelegate>
{
    NSMutableArray *dataArray;
    PYTabbar *headTabbar;
    //订单类型
//    不传值默认所有订单。可能的值为：
//    unPay, //未付款
//    payed, // 已付款
//    unConsume, //未消费
//    sent, //已发货
//    notSent, //未发货
//    unComment, //未评论
//    refunding, //退款中
//    cancel, //已取消
//    success //交易完成
    NSString *_orderType;
    NSInteger _fromPage;    //分页当前页数
    NSString *_type;        //不传值默认买家、买家buyer、卖家seller
    NSString *_userId;      //用户id
    NSDictionary *parameter;
    
    NSMutableArray *_orderGoodsArr;
    BOOL _cellEdit;
    UIButton *deleteBut;
    
    //当前页数
    NSInteger  page;
    
    OrdersDetailModel *_ordersDetailModel;
    NSInteger _row;
    
    NSMutableArray *_delectArr;
}
@end

@implementation OrderForAllViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       titleLabel.text = @"全部订单";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _orderGoodsArr = [[NSMutableArray alloc]init];
    
    [self addTableView:UITableViewStyleGrouped];
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    [self addHeadTabbar];
    [self layoutMainTableView];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    CGRect frame = self.mainTabview.frame;
    frame.size.height -= 49;
    self.mainTabview.frame = frame;
    self.mainTabview.allowsSelectionDuringEditing = YES;
    _delectArr = [[NSMutableArray alloc] init];
    
    deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBut.frame = CGRectMake(0, 0, 20, 20);
    [deleteBut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteBut setImage:[UIImage imageNamed:@"img_editor_h.png"] forState:UIControlStateNormal];
    [deleteBut addTarget:self action:@selector(setEditing:animated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:deleteBut];
    self.navigationItem.rightBarButtonItem = rightBut;
    
    _orderType = @"";
    _cellEdit = NO;
    [self addHeaderAndFooter];
    [self refreshData:^(BOOL finish) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [self refreshData:^(BOOL finish) {
        
    }];
}

- (void)addData:(void (^)(BOOL finish))success
{
    NSLog(@"asd");
   parameter = [NSDictionary dictionaryWithObjectsAndKeys:_orderType, @"status", self.userInfoModel.userId,@"userId", [NSString stringWithFormat:@"%d",page+1],@"fromPage",nil];
        // 耗时的操作
        [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.list" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            NSLog(@"operation6 = %@",operation);
            if (responseObject.succeed) {
                NSLog(@"result = %@",responseObject.result);
                
                NSString *totalCount = [responseObject.result objectForKey:@"totalCount"];
                page = [[responseObject.result objectForKey:@"page"] intValue];
                if ([totalCount intValue] > 0 && [totalCount intValue] < 100) {
                    if ([_orderType isEqualToString:@"unPay"]) {
                        [headTabbar setTitle:[NSString stringWithFormat:@"未付款%@",totalCount] atIndex:1];
                    }else if ([_orderType isEqualToString:@"unConsume"]){
                        [headTabbar setTitle:[NSString stringWithFormat:@"未消费%@",totalCount] atIndex:2];
                    }else if ([_orderType isEqualToString:@"unComment"]){
                        [headTabbar setTitle:[NSString stringWithFormat:@"待评价%@",totalCount] atIndex:3];
                    }else if ([_orderType isEqualToString:@"refunding"]){
                        [headTabbar setTitle:[NSString stringWithFormat:@"待退款%@",totalCount] atIndex:4];
                    }else{
                        [headTabbar setTitle:[NSString stringWithFormat:@"全部%@",totalCount] atIndex:0];
                    }
                }
                
                NSMutableArray *tmpArr = [[responseObject.result objectForKey:@"data"]mutableCopy];
                for (int i=0; i<tmpArr.count; i++) {
                    
                    NSMutableArray *arr = [[[tmpArr objectAtIndex:i]objectForKey:@"orderGoods"]mutableCopy];
                    orderGoodsModel *tmpModel = [[orderGoodsModel alloc]init];
                    tmpModel = [JsonStringTransfer dictionary:[arr objectAtIndex:0] ToModel:tmpModel];
                    [_orderGoodsArr addObject:tmpModel];
                    
                    MyOrdersAjaxListModel *myOrdersAjaxListModel = [[MyOrdersAjaxListModel
                                                                     alloc]init];
                    myOrdersAjaxListModel = [JsonStringTransfer dictionary:[tmpArr objectAtIndex:i] ToModel:myOrdersAjaxListModel];
                    myOrdersAjaxListModel.isChecked = NO;
                    [dataArray addObject:myOrdersAjaxListModel];
                    
                }
                if (page >= [[responseObject.result objectForKey:@"totalPage"] intValue]) {
                    isEnd = YES;
                }
            }
            
            [self.mainTabview reloadData];
            success(YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            NSLog(@"operation6 = %@",operation);
            dataArray = nil;
            [self.mainTabview reloadData];
            success(NO);
        }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) addHeadTabbar
{
    NSArray * arr = @[
                  @"全部",
                  @"未付款",
                  @"未消费",
                  @"待评价",
                  @"待退款",
                  @""
                  ];

    headTabbar = [[PYTabbar alloc]initWithStrings:arr andFrame:CGRectMake(0, 3, WIDTH_CONTROLLER_DEFAULT, 40) containerView:self.view];
    [headTabbar setBackgroundColor:[UIColor whiteColor]];
    [headTabbar setSelectedItemBackgroundColor:[UIColor whiteColor]];
    [headTabbar setDelegate:self];
    [self.view addSubview:headTabbar];
    
//    [self.view insertSubview:headTabbar belowSubview:self.mainTabview];
}
- (void) layoutMainTableView
{
    CGRect frame = self.mainTabview.frame;
    frame.origin.y = self.mainTabview.frame.origin.y+45;
    frame.size.height = self.mainTabview.frame.size.height-45;
    [self.mainTabview setFrame:frame];
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
    if (dataArray.count == 0) {
        [self.noDataView setHidden:NO];
    }else{
        [self.noDataView setHidden:YES];
    }
    return dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderCell *cell = [self loadMyOrderCell:self.mainTabview];
    if (indexPath.row < dataArray.count) {
        cell.orderGoodsModel =_orderGoodsArr[indexPath.row];
        MyOrdersAjaxListModel *listModel = dataArray[indexPath.row];
        cell.listModel = listModel;
        cell.row = indexPath.row;
        cell.cellDelegate = self;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setChecked:listModel.isChecked];
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cellEdit) {
        MyOrdersAjaxListModel *listModel = dataArray[indexPath.row];
        if ([listModel.status intValue] == 40||
            [listModel.status intValue] == 0) {
            MyOrderCell *cell = (MyOrderCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            listModel.isChecked = !listModel.isChecked;
            [dataArray replaceObjectAtIndex:indexPath.row withObject:listModel];
            [cell setChecked:listModel.isChecked];
            
            if ([_delectArr containsObject:indexPath]) {
                [_delectArr removeObject:indexPath];
            }else{
                [_delectArr addObject:indexPath];
            }
        }
        
    }else{
        //取消点击选中状态
        IndentDetailViewController *indentDetailVC = [[IndentDetailViewController alloc]initWithNibName:nil bundle:nil];
        indentDetailVC.userInfoModel = self.userInfoModel;
        indentDetailVC.myOrderListModel = dataArray[indexPath.row];
        [self.navigationController pushViewController:indentDetailVC animated:YES];
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

//删除未消费订单
- (void)setEditing:(BOOL)editting animated:(BOOL)animated{
    
    if (_cellEdit) {
        _cellEdit = !_cellEdit;//不可编辑
        if (_delectArr.count == 0){
            [deleteBut setImage:[UIImage imageNamed:@"img_editor_h.png"] forState:UIControlStateNormal];
            [self.mainTabview setEditing:_cellEdit animated:YES];
            [self.mainTabview performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您是否要删除所选项？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 2;
            [alert show];
        }
        
    }else{
        _cellEdit = !_cellEdit;
        [deleteBut setImage:[UIImage imageNamed:@"img_editor_c.png"] forState:UIControlStateNormal];
        [self.mainTabview setEditing:_cellEdit animated:YES];
        [self.mainTabview performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_cellEdit) {
//        MyOrdersAjaxListModel *myorderslistModel = dataArray[indexPath.row];
//        if ([myorderslistModel.status isEqualToString: @"0"]||
//            [myorderslistModel.status isEqualToString:@"40"]){
//            return YES;
//        }
//    }
//    return NO;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete &&
//        _cellEdit) {
//        [self deleteOrderWithRow:indexPath.row];
//    }
//    
//}


#pragma mark------
#pragma mark------loadTableView--------
- (MyOrderCell *)loadMyOrderCell:(UITableView *)tableView
{
    NSString * const nibName  = @"MyOrderCell";
    
    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

#pragma mark------
#pragma mark------PYTabbarDelegate--------
- (void)filterView:(PYTabbar *)filterView didSelectedAtIndex:(NSInteger)index
{
    _fromPage = 1;
    _delectArr = [[NSMutableArray alloc]init];
    [deleteBut setImage:[UIImage imageNamed:@"img_editor_h.png"] forState:UIControlStateNormal];
    [self.mainTabview setEditing:NO animated:YES];
    [self.mainTabview performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    switch (index) {
        case 0:
            _orderType = @"";//<null>
            break;
        case 1:
            _orderType = @"unPay";
            break;
        case 2:
            _orderType = @"unConsume";
            break;
        case 3:
            _orderType = @"unComment";
            break;
        case 4:
            _orderType = @"refunding";
            break;
        default:
            break;
    }
    [self refreshData:^(BOOL finish) {
        
    }];

}

//If the delegate implement this method it can return a custom animation speed for the hide/unhide
- (CGFloat)filterViewDisplayAnimatioSpeed:(PYTabbar *)filterView
{
    return 0.20;
    //     NSLog(@"ss2");
}
//If the delegate implement this methid it can return a custom animation speed for the selection
- (CGFloat)filterViewSelectionAnimationSpeed:(PYTabbar *)filterView
{
    return 0.20;
    //     NSLog(@"s3");
}
//Implement this method to know when the selection animation begin
- (void)filterViewSelectionAnimationDidBegin:(PYTabbar *)filterView
{
    //    NSLog(@"ss4");
    
}
//Implement this method to know when the selection animation end
- (void)filterViewSelectionAnimationDidEnd:(PYTabbar *)filterView
{
    //     NSLog(@"ss5");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-----
#pragma mark---------MJRefresh---------

//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        [ProgressHUD showMessage:@"加载完成" Width:280 High:10];
        success (YES);
    }else{
        [self addData:^(BOOL finish) {
            success(finish);
        }];
    }
    
}

//刷新数据
- (void) refreshData:(void (^)(BOOL finish))success
{
    //重新加载数据。一切都重新初始化
    [self.footer resetNoMoreData];
    [dataArray removeAllObjects];
    dataArray = nil;
    dataArray = [[NSMutableArray alloc]init];
    page = 0;
    isEnd = NO;
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}

//  付款
- (void)payForOrderGoods:(NSInteger)row{
    NewIndentViewController *vc = [[NewIndentViewController alloc]init];
    MyOrdersAjaxListModel *listModel = dataArray[row];
    
    vc.payJine = listModel.yueJine;
    
    if ([listModel.yueJine floatValue]>0) {
        vc.money = listModel.yueJine;
    }
    
    vc.isChongzhiSelect = false;
    vc.isShouyiSelect = false;
    vc.order_id = listModel.order_id;
    
    if ([listModel.type isEqualToString:@"coupon"]) {//代金券订单详情
        vc.buyType = @"1";
    }else{//商品订单详情
        vc.buyType = @"0";
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:listModel.authAppId,@"authAppId",listModel.authUserId,@"authUserId",listModel.order_sn,@"orderSns", nil];
    CreateDingDanModel *dingdaoModel = [[CreateDingDanModel alloc]init];
    dingdaoModel = [JsonStringTransfer dictionary:dict ToModel:dingdaoModel];
    vc.dingdaoModel = dingdaoModel;
    
   [self.navigationController pushViewController:vc animated:YES];
}

//确认订单需要支付密码
- (void)inputDaJiKePayPassword
{
    PayPopView *vv = [[PayPopView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT)];
    vv.tag = 8008;
    vv.jineLb.text = @"确认订单";
    vv.backgroundColor = [UIColor clearColor];
    
    __weak OrderForAllViewController *weakSelf = self;
    [vv.mimaLb callbackClickedLb:^(MyClickLb *clickLb) {
        NSLog(@"忘记密码");
        //找回密码
        FindPassword0ViewController *FindPassword0VC = [[FindPassword0ViewController alloc]initWithNibName:nil bundle:nil];
        [weakSelf.navigationController pushViewController:FindPassword0VC animated:YES];
    }];
    [vv callbackHidden:^(int flag,NSString *password){
        if (flag == 0) {
            [UIView animateWithDuration:0.25f animations:^{
                vv.alpha = 0.1f;
            } completion:^(BOOL finished) {
                [vv setHidden:YES];
            }];
        }
        if (flag == 1) {
            [weakSelf checkPayPassword:password];
            NSLog(@"支付吧--____%@",password);
        }
    }];
    [self.view addSubview:vv];
}

//校验支付密码
- (void)checkPayPassword:(NSString *)password
{
    NSDictionary *dic = @{@"userId":[FileOperation getUserId],@"password":[DES3Util encrypt:password]};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.validatePassword" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"____校验支付密码：%@",responseObject.result);
            
            PayPopView *vv = (PayPopView *)[self.view viewWithTag:8008];
            if (vv) {
                [UIView animateWithDuration:0.25f animations:^{
                    
                    vv.alpha = 0.1f;
                    [vv setHidden:YES];
                } completion:^(BOOL finished) {
                    
                }];
            }
            [self confirmReceiveWithPassword:password];
        }
        else
        {
            [ProgressHUD showMessage:@"密码错误" Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}

//删除订单 OK
- (void)deleteOrders{
    NSMutableString *orderIds = [[NSMutableString alloc]init];
    for (int i = 0; i < _delectArr.count; i++) {
        NSIndexPath *index = _delectArr[i];
        MyOrdersAjaxListModel *listmodel = dataArray[index.row];
        if (i == 0) {
            orderIds = [NSMutableString stringWithString:listmodel.order_id];
        }else{
            [orderIds appendFormat:@",%@",listmodel.order_id];
        }
    }
    parameter = [NSDictionary dictionaryWithObjectsAndKeys:self.userInfoModel.userId,@"userId",orderIds,@"orderIds", @"buyer",@"type", nil];
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.deleteOrder" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        NSLog(@"result = %@",responseObject.result);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
//            for (int i = 0; i < _delectArr.count; i++) {
//                NSIndexPath *index = _delectArr[i];
//                [dataArray removeObjectAtIndex:index.row];
//                [_orderGoodsArr removeObjectAtIndex:index.row];
//            }
            [self refreshData:^(BOOL finish) {
                
            }];
            
        }else{
            
        }
        [deleteBut setImage:[UIImage imageNamed:@"img_editor_h.png"] forState:UIControlStateNormal];
        [self.mainTabview setEditing:_cellEdit animated:YES];
        [self.mainTabview performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
        [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//评价订单  评价
- (void)evaluateOrderGoods:(NSInteger)row{
    //进入评价界面
    OrderCommentViewController *OrderCommentVC = [[OrderCommentViewController alloc]init];
    OrderCommentVC.goodsOrOrder = 2;
    OrderCommentVC.orderGoodsModel = _orderGoodsArr[row];
    OrderCommentVC.myOrderListModel = dataArray[row];
    OrderCommentVC.userInfoModel = self.userInfoModel;
    [self.navigationController pushViewController:OrderCommentVC animated:YES];
}

//确认收货 OK
- (void)confirmReceiveWithRow:(NSInteger)row{
    _row = row;
    [self inputDaJiKePayPassword];
    
}

- (void)confirmReceiveWithPassword:(NSString *)password{
    MyOrdersAjaxListModel *orderListModel = dataArray[_row];
    parameter = [NSDictionary dictionaryWithObjectsAndKeys:self.userInfoModel.userId,@"userId",[DES3Util encrypt:orderListModel.order_id],@"orderId", [DES3Util encrypt:password],@"payPassword", nil];
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.confirmReceive" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        NSLog(@"result = %@",responseObject.result);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
        }else{
            
        }
        [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

//取消订单 OK
- (void)cancelOrderWithRow:(NSInteger)row{
    _row = row;
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要取消订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertV.tag = 1;
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1 ) {
        if (buttonIndex == 1) {
            MyOrdersAjaxListModel *orderListModel = dataArray[_row];
            parameter = [NSDictionary dictionaryWithObjectsAndKeys:self.userInfoModel.userId,@"userId",orderListModel.order_id,@"orderId", @"buyer",@"type", nil];
            
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyOrders.cancleOrder" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                NSLog(@"operation6 = %@",operation);
                NSLog(@"result = %@",responseObject.result);
                if (responseObject.succeed) {
                    NSLog(@"result = %@",responseObject.result);
                    [self refreshData:^(BOOL finish) {
                        
                    }];
                    
                }else{
                    
                }
                [deleteBut setImage:[UIImage imageNamed:@"img_editor_h.png"] forState:UIControlStateNormal];
                [self.mainTabview setEditing:_cellEdit animated:YES];
                [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];

        }
    }else if (alertView.tag == 2){
        if (buttonIndex == 1){
            [self deleteOrders];
        }else{
            for (int i = 0; i < dataArray.count; i++) {
                MyOrdersAjaxListModel *listmodel = dataArray[i];
                listmodel.isChecked = NO;
                [dataArray replaceObjectAtIndex:i withObject:listmodel];
            }
            _delectArr = [[NSMutableArray alloc]init];
            [deleteBut setImage:[UIImage imageNamed:@"img_editor_h.png"] forState:UIControlStateNormal];
            [self.mainTabview setEditing:_cellEdit animated:YES];
            [self.mainTabview performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
        }
    }
}


@end

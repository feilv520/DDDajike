//
//  DMyAccountDetailViewController.m
//  dajike
//
//  Created by songjw on 15/7/20.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DMyAccountDetailViewController.h"
#import "UIView+MyView.h"
#import "dDefine.h"
#import "DTools.h"
#import "commonTools.h"
#import "DMyAfHTTPClient.h"
#import "AnalysisData.h"
#import "AccountDetail0Cell.h"
#import "AccountDetail1Cell.h"
#import "AccountDetail2Cell.h"
#import "AccountDetail3Cell.h"
#import "AccountDetailModel.h"

#import "DGetCashViewController.h"
#import "DTransferViewController.h"

//一次请求数据条数
static NSInteger pageSize = 10;
@interface DMyAccountDetailViewController (){
    NSArray *dataArray;
    NSMutableArray *accountList;
    //数据总条数
    //    NSString * totalCount;
    //当前页数
    NSInteger  page;
    //积分和奖励收益的类型
    NSString *type;
    
    NSString *userId;
    
}



@property (weak, nonatomic) IBOutlet UIView *headVIew;
@property (weak, nonatomic) IBOutlet UIView *typeVIew1;
@property (weak, nonatomic) IBOutlet UIView *typeView2;
@property (weak, nonatomic) IBOutlet UIView *typeView4;
@property (weak, nonatomic) IBOutlet UILabel *headLabel1;
@property (weak, nonatomic) IBOutlet UILabel *headLabel2;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIButton *type1Button1;
@property (weak, nonatomic) IBOutlet UIButton *type1Button2;
@property (weak, nonatomic) IBOutlet UIButton *type1Button3;

@property (weak, nonatomic) IBOutlet UILabel *lab_1;
@property (weak, nonatomic) IBOutlet UILabel *lab_2;
@property (weak, nonatomic) IBOutlet UILabel *lab_3;
@property (weak, nonatomic) IBOutlet UILabel *lab_4;
@property (weak, nonatomic) IBOutlet UILabel *lab_5;

- (IBAction)headButtonClip:(id)sender;
- (IBAction)typeButtonsClip:(id)sender;
@end

@implementation DMyAccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:DColor_f3f3f3];
    [DTools setLable:self.headLabel1 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setLable:self.headLabel2 Font:DFont_13 titleColor:DColor_c4291f backColor:DColor_ffffff];
    [DTools setButtton:self.headButton Font:DFont_12 titleColor:DColor_ffffff backColor:DColor_c4291f];
    
    [DTools setLable:self.lab_1 Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
    [DTools setLable:self.lab_2 Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
    
    [DTools setButtton:self.type1Button1 Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
    [DTools setButtton:self.type1Button2 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setButtton:self.type1Button3 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    
    [DTools setLable:self.lab_3 Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
    [DTools setLable:self.lab_4 Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
    [DTools setLable:self.lab_5 Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
    
    [self addTableView:YES];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    isEnd = NO;
    userId = [FileOperation getUserId];
    
    [self layoutSubviews];
    type = @"";
    
    [self refreshData:^(BOOL finish) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
//根据页面类型显示界面

-(void) layoutSubviews
{
    [self hiddenAllTypeVIew];
    self.headLabel2.text = self.totalAccount;
    if (self.AccountDetailType == CHONGZHI) {//充值金额
        [self.typeView4 setHidden:NO];
        [self.headButton setHidden:NO];
        [self.headButton setTitle:@"提现" forState:UIControlStateNormal];
        [self layoutHeadViewLabels:@"充值金额:"];
        [self setNaviBarTitle:@"充值金额"];
        
    }else if (self.AccountDetailType == CHOUJIANG){//抽奖收益
        [self.typeView2 setHidden:NO];
        [self layoutHeadViewLabels:@"抽奖收益金额:"];
        [self.headButton setHidden:YES];
        [self setNaviBarTitle:@"抽奖收益"];
        
    }else if (self.AccountDetailType == JIFEN){//积分收益
        self.headLabel2.text = self.totalAccount;
        [self.typeVIew1 setHidden:NO];
        [self layoutHeadViewLabels:@"当前可用积分:"];
        [self.headButton setHidden:YES];
        [self setNaviBarTitle:@"积分查询"];
        
    }else if (self.AccountDetailType == JIANGLI){//奖励收益
        [self.typeView2 setHidden:NO];
        [self layoutHeadViewLabels:@"奖励收益:"];
        [self.headButton setHidden:NO];
        [self.headButton setTitle:@"转账" forState:UIControlStateNormal];
        [self setNaviBarTitle:@"奖励收益"];
        
    }else if (self.AccountDetailType == ZHANGHU){//收益账户
        [self.typeVIew1 setHidden:NO];
        [self.headButton setHidden:YES];
        [self layoutHeadViewLabels:@"收益账户:"];
        [self setNaviBarTitle:@"收益账户"];
        
    }else if (self.AccountDetailType == YINGYEE){//营业额
        [self.typeView2 setHidden:NO];
        [self.headButton setHidden:YES];
        [self layoutHeadViewLabels:@"营业额账户金额:"];
        [self setNaviBarTitle:@"营业额"];
    }
    
    CGRect frame = self.dMainTableView.frame;
    frame.origin.y = self.dMainTableView.frame.origin.y + 100;
    frame.size.height = self.dMainTableView.frame.size.height - 144;
    [self.dMainTableView setFrame:frame];
    [self.dMainTableView setHidden:NO];
    
}
//调整headVIew上元素的位置和大小
- (void) layoutHeadViewLabels:(NSString *)headLabel1textStr
{
    self.headLabel1.text = headLabel1textStr;
    CGRect frame1 = self.headLabel1.frame;
    CGRect f = [self.headLabel1 contentAdaptionLabel:headLabel1textStr withSize:CGSizeMake(1000, 21) withTextFont:13.0f];
    frame1.size.width = f.size.width;
    [self.headLabel1 setFrame:frame1];
    
    CGRect frame2 = self.headLabel2.frame;
    frame2.origin.x = self.headLabel1.frame.origin.x+frame1.size.width;
    [self.headLabel2 setFrame:frame2];
}

- (void) hiddenAllTypeVIew
{
    [self.typeVIew1 setHidden:YES];
    [self.typeView2 setHidden:YES];
    [self.typeView4 setHidden:YES];
}
//积分和奖励收益 收益类型转换
- (IBAction)typeButtonsClip:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0) {
        type = @"";
        [DTools setButtton:self.type1Button1 Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
        [DTools setButtton:self.type1Button2 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setButtton:self.type1Button3 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    }else if (btn.tag == 1){
        type = @"income";
        [DTools setButtton:self.type1Button2 Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
        [DTools setButtton:self.type1Button1 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setButtton:self.type1Button3 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    }else if (btn.tag == 2){
        type = @"pay";
        [DTools setButtton:self.type1Button3 Font:DFont_13 titleColor:DColor_ffffff backColor:DColor_c4291f];
        [DTools setButtton:self.type1Button2 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setButtton:self.type1Button1 Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    }
    [self refreshData:^(BOOL finish) {
        
    }];
}
- (IBAction)headButtonClip:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"提现"]) {
        
        DGetCashViewController *vc = [[DGetCashViewController alloc]init];
        vc.userId = userId;
        vc.type = @"2";
        vc.totalAccount = self.totalAccount;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([btn.titleLabel.text isEqualToString:@"转账"]) {
        
        DTransferViewController *vc = [[DTransferViewController alloc]init];
        vc.userId = userId;
        vc.type = @"4";
        vc.totalAccount = self.totalAccount;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


- (void)addData:(void (^)(BOOL finish))success
{
    switch (self.AccountDetailType) {
        case CHONGZHI://充值账户
        {
            NSDictionary *parameter = @{@"userId":userId,@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10"};
            [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.chongZhi" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"responseObject.result = %@",responseObject.result);
                    NSDictionary *resultDic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
                    NSArray *resultDateArr = [resultDic objectForKey:@"data"];
                    page = [[resultDic objectForKey:@"page"] integerValue];
                    for (NSDictionary *dic in resultDateArr) {
                        AccountDetailModel *accountDetailItem = [[AccountDetailModel alloc]init];
                        accountDetailItem = [JsonStringTransfer dictionary:dic ToModel:accountDetailItem];
                        [accountList addObject:accountDetailItem];
                    }
                    if (page >= [[resultDic objectForKey:@"totalPage"] integerValue]) {
                        isEnd = YES;
                    }
                    
                }
                [self.dMainTableView reloadData];
                success(YES);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
                success(NO);
            }];
            
        }
            break;
        case CHOUJIANG://抽奖收益
        {
            //            NSDictionary *parameter = @{@"userId":userId,@"getPage":[NSString stringWithFormat:@"%d",page+1],@"getPageSize":@"10"};
            //            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.shouYi" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            //                if (responseObject.succeed) {
            //                    NSLog(@"responseObject.result = %@",responseObject.result);
            //                    NSArray *resultDateArr = [responseObject.result objectForKey:@"data"];
            //                    for (NSDictionary *dic in resultDateArr) {
            //                        AccountDetailModel *accountDetailItem = [[AccountDetailModel alloc]init];
            //                        accountDetailItem = [JsonStringTransfer dictionary:dic ToModel:accountDetailItem];
            //                        [accountList addObject:accountDetailItem];
            //                    }
            //                    if (resultDateArr.count < 10) {
            //                        isEnd = YES;
            //                    }
            //
            //                }
            //                [self.mainTabview reloadData];
            //                success(YES);
            //            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //                NSLog(@"error = %@",error);
            //                success(NO);
            //            }];
            
        }
            break;
        case JIFEN://积分明细
        {
            NSDictionary *parameter = @{@"userId":userId,@"type":type,@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10"};
            [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.jiFen" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"responseObject.result = %@",responseObject.result);
                    NSDictionary *resultDic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
                    page = [[resultDic objectForKey:@"page"] integerValue];
                    NSArray *resultDateArr = [resultDic objectForKey:@"data"];
                    for (NSDictionary *dic in resultDateArr) {
                        AccountDetailModel *accountDetailItem = [[AccountDetailModel alloc]init];
                        accountDetailItem = [JsonStringTransfer dictionary:dic ToModel:accountDetailItem];
                        [accountList addObject:accountDetailItem];
                    }
                    if (page >= [[resultDic objectForKey:@"totalPage"] integerValue]) {
                        isEnd = YES;
                    }
                    
                }
                [self.dMainTableView reloadData];
                success(YES);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
                success(NO);
            }];
            
        }
            break;
        case JIANGLI://奖励收益
        {
            //             NSDictionary *parameter = @{@"userId":userId,@"type":@"income",@"getPage":[NSString stringWithFormat:@"%d",page+1],@"getPageSize":@"10"};
            NSDictionary *parameter = @{@"userId":userId,@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10"};
            [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.jiangLiShouYi" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"responseObject.result = %@",responseObject.result);
                    NSDictionary *resultDic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
                    page = [[resultDic objectForKey:@"page"] integerValue];
                    NSArray *resultDateArr = [resultDic objectForKey:@"data"];
                    for (NSDictionary *dic in resultDateArr) {
                        AccountDetailModel *accountDetailItem = [[AccountDetailModel alloc]init];
                        accountDetailItem = [JsonStringTransfer dictionary:dic ToModel:accountDetailItem];
                        [accountList addObject:accountDetailItem];
                    }
                    if (page >= [[resultDic objectForKey:@"totalPage"] integerValue]) {
                        isEnd = YES;
                    }
                    
                }
                [self.dMainTableView reloadData];
                success(YES);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
                success(NO);
            }];
            
        }
            break;
        case ZHANGHU://收益账户  dddddddd
        {
            NSDictionary *parameter = @{@"userId":userId,@"type":type,@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10"};
            [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.shouYi" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"responseObject.result = %@",responseObject.result);
                    NSDictionary *resultDIc = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
                    page = [[resultDIc objectForKey:@"page"] integerValue];
                    NSArray *resultDateArr = [resultDIc objectForKey:@"data"];
                    for (NSDictionary *dic in resultDateArr) {
                        AccountDetailModel *accountDetailItem = [[AccountDetailModel alloc]init];
                        accountDetailItem = [JsonStringTransfer dictionary:dic ToModel:accountDetailItem];
                        NSLog(@"type = %@",accountDetailItem.type);
                        [accountList addObject:accountDetailItem];
                    }
                    if (page >= [[resultDIc objectForKey:@"totalPage"] integerValue]) {
                        isEnd = YES;
                    }
                    
                }
                [self.dMainTableView reloadData];
                success(YES);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
                success(NO);
            }];
            
        }
            break;
        case YINGYEE://营业额
        {
            NSDictionary *parameter = @{@"userId":userId,@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10"};
            [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.yingYeE" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"responseObject.result = %@",responseObject.result);
                    NSDictionary *resultDic = [AnalysisData decodeAndDecriptWittDESstring:responseObject.result];
                    
                    NSArray *resultDateArr = [resultDic objectForKey:@"data"];
                    for (NSDictionary *dic in resultDateArr) {
                        AccountDetailModel *accountDetailItem = [[AccountDetailModel alloc]init];
                        accountDetailItem = [JsonStringTransfer dictionary:dic ToModel:accountDetailItem];
                        [accountList addObject:accountDetailItem];
                    }
                    page = [[resultDic objectForKey:@"page"] integerValue];
                    if (page >= [[resultDic objectForKey:@"totalPage"] integerValue]) {
                        isEnd = YES;
                    }
                    
                }
                [self.dMainTableView reloadData];
                success(YES);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
                success(NO);
            }];
            
        }
            break;
            
        default:
            break;
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
//- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 0;
//}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return accountList.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.AccountDetailType == CHONGZHI) {//充值金额
        return 50;
    }else if (self.AccountDetailType == CHOUJIANG){//抽奖收益
        return 51;
    }else if (self.AccountDetailType == JIFEN){//积分收益
        return 71;
    }else if (self.AccountDetailType == JIANGLI){//奖励收益
        return 50;
    }else if (self.AccountDetailType == ZHANGHU){//收益账户
        return 70;
    }else if (self.AccountDetailType == YINGYEE){//营业额
        return 50;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (self.AccountDetailType == CHONGZHI) {//充值金额 *
        AccountDetail2Cell *cell = [DTools loadTableViewCell:self.dMainTableView cellClass:[AccountDetail2Cell class]];
        [DTools setLable:cell.mainLabel Font:DFont_11 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell.priceLabel Font:DFont_10 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell.dayLabel Font:DFont_10 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell.lab_1 Font:DFont_10 titleColor:DColor_808080 backColor:DColor_ffffff];

        
        if (accountList.count > 0) {
            cell.accountDetailModel = [accountList objectAtIndex:row];
        }
        return cell;
        
    }else if (self.AccountDetailType == CHOUJIANG){//抽奖收益
        //        AccountDetail1Cell *cell1 = [self loadAccountDetail1Cell:self.mainTabview];
        //        if (accountList.count > 0) {
        //            cell1.choujiangModel = [accountList objectAtIndex:row];
        //        }
        //        return cell1;
        
    }else if (self.AccountDetailType == JIFEN){//积分收益
        AccountDetail0Cell *cell0 = [DTools loadTableViewCell:self.dMainTableView cellClass:[AccountDetail0Cell class]];
        
        cell0.backgroundColor = DColor_ffffff;
        [DTools setLable:cell0.label0 Font:DFont_11 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell0.label1 Font:DFont_12 titleColor:DColor_c4291f backColor:DColor_ffffff];
        [DTools setLable:cell0.label3 Font:DFont_11 titleColor:DColor_b2b2b2 backColor:DColor_ffffff];
        [DTools setLable:cell0.label4 Font:DFont_11 titleColor:DColor_808080 backColor:DColor_ffffff];

        if (accountList.count > 0) {
            cell0.accountDetailModel = [accountList objectAtIndex:row];
        }
        
        return cell0;
    }else if (self.AccountDetailType == ZHANGHU){//收益账户 *
        AccountDetail3Cell *cell3 = [DTools loadTableViewCell:self.dMainTableView cellClass:[AccountDetail3Cell class]];
        [DTools setLable:cell3.typeLabel Font:DFont_11 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell3.codeLabel Font:DFont_11 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell3.timeLabel Font:DFont_11 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell3.label0 Font:DFont_11 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell3.label1 Font:DFont_11 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell3.money1Label Font:DFont_11 titleColor:DColor_c4291f backColor:DColor_ffffff];

        if (accountList.count > 0) {
            cell3.accountDetailModel = [accountList objectAtIndex:row];
        }
        return cell3;
    }else if (self.AccountDetailType == JIANGLI){//奖励收益
        AccountDetail1Cell *cell = [DTools loadTableViewCell:self.dMainTableView cellClass:[AccountDetail1Cell class]];
        [DTools setLable:cell.mingxiLabel Font:DFont_10 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell.typeLabel Font:DFont_11 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell.lab_1 Font:DFont_10 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell.moneyLabel Font:DFont_10 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell.dayLabel Font:DFont_10 titleColor:DColor_808080 backColor:DColor_ffffff];
        if (accountList.count > 0) {
            cell.accountDetailModel = [accountList objectAtIndex:row];
        }
        
        return cell;
    }else if (self.AccountDetailType == YINGYEE){//营业额 *
        AccountDetail1Cell *cell = [DTools loadTableViewCell:self.dMainTableView cellClass:[AccountDetail1Cell class]];
        [DTools setLable:cell.mingxiLabel Font:DFont_10 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell.typeLabel Font:DFont_11 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell.lab_1 Font:DFont_10 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell.moneyLabel Font:DFont_10 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:cell.dayLabel Font:DFont_10 titleColor:DColor_808080 backColor:DColor_ffffff];
        if (accountList.count > 0) {
            cell.yingyeeModel = [accountList objectAtIndex:row];
        }
        
        return cell;
    }
    return nil;
    
    
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark-----
#pragma mark---------MJRefresh---------

//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    if (isEnd) {
        showMessage(@"加载完成");
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
    [accountList removeAllObjects];
    accountList = nil;
    accountList = [[NSMutableArray alloc]init];
    page = 0;
    isEnd = NO;
    [self.footer resetNoMoreData];
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
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

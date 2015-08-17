//
//  AccountDetailViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/14.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "UIView+MyView.h"
#import "defines.h"
#import "AccountDetail0Cell.h"
#import "AccountDetail1Cell.h"
#import "AccountDetail2Cell.h"
#import "AccountDetail3Cell.h"
#import "AccountDetailModel.h"
#import "GetCashViewController.h"
#import "TransferViewController.h"

//一次请求数据条数
static NSInteger pageSize = 10;
@interface AccountDetailViewController ()
{
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
//@property (weak, nonatomic) IBOutlet UIView *typeView3;
@property (weak, nonatomic) IBOutlet UIView *typeView4;
@property (weak, nonatomic) IBOutlet UILabel *headLabel1;
@property (weak, nonatomic) IBOutlet UILabel *headLabel2;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIButton *type1Button1;
@property (weak, nonatomic) IBOutlet UIButton *type1Button2;
@property (weak, nonatomic) IBOutlet UIButton *type1Button3;
//@property (weak, nonatomic) IBOutlet UILabel *pageNumberLAbel;
//@property (weak, nonatomic) IBOutlet UIButton *lastPageBbutton;
//@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;
//@property (weak, nonatomic) IBOutlet UILabel *totalPageNumberLabel;
- (IBAction)headButtonClip:(id)sender;
- (IBAction)typeButtonsClip:(id)sender;
@end

@implementation AccountDetailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
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
    
    userId = [FileOperation getUserId];
    
    isEnd = NO;
    [self layoutSubviews];
    type = @"";
    self.type1Button1.backgroundColor = Color_mainColor;
    self.type1Button2.backgroundColor = Color_gray1;
    self.type1Button3.backgroundColor = Color_gray1;
    [self.type1Button1 setTitleColor:Color_White forState:UIControlStateNormal];
    [self.type1Button2 setTitleColor:Color_word_bg forState:UIControlStateNormal];
    [self.type1Button3 setTitleColor:Color_word_bg forState:UIControlStateNormal];
    [self addHeaderAndFooter];
    [self refreshData:^(BOOL finish) {
        
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    float a = [self.totalAccount floatValue];
    a = a*100;
    a = round(a);
    a = a/100;
    
    self.headLabel2.text = [NSString stringWithFormat:@"%.2f",a];
}


- (void)addData:(void (^)(BOOL finish))success
{
    switch (self.AccountDetailType) {
        case CHONGZHI://充值账户
        {
            NSDictionary *parameter = @{@"userId":userId,@"page":[NSString stringWithFormat:@"%d",page+1],@"pageSize":@"10"};
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.chongZhi" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
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
                [self.mainTabview reloadData];
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
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.jiFen" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
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
                [self.mainTabview reloadData];
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
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.jiangLiShouYi" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
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
                [self.mainTabview reloadData];
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
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.shouYi" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
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
                [self.mainTabview reloadData];
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
            [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyFinances.yingYeE" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
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
                [self.mainTabview reloadData];
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

//根据页面类型显示界面

-(void) layoutSubviews
{
    [self hiddenAllTypeVIew];
    
    if (self.AccountDetailType == CHONGZHI) {//充值金额
        [self.typeView4 setHidden:NO];
        [self.headButton setHidden:NO];
        [self.headButton setTitle:@"提现" forState:UIControlStateNormal];
        [self layoutHeadViewLabels:@"充值金额:"];
        titleLabel.text = @"充值金额";
        
    }else if (self.AccountDetailType == CHOUJIANG){//抽奖收益
        [self.typeView2 setHidden:NO];
        [self layoutHeadViewLabels:@"抽奖收益金额:"];
        [self.headButton setHidden:YES];
        titleLabel.text = @"抽奖收益";
    }else if (self.AccountDetailType == JIFEN){//积分收益
        [self.typeVIew1 setHidden:NO];
        [self layoutHeadViewLabels:@"当前可用积分:"];
        [self.headButton setHidden:YES];
        titleLabel.text = @"积分查询";
    }else if (self.AccountDetailType == JIANGLI){//奖励收益
        [self.typeView2 setHidden:NO];
        [self layoutHeadViewLabels:@"奖励收益:"];
        [self.headButton setHidden:NO];
        [self.headButton setTitle:@"转账" forState:UIControlStateNormal];
        titleLabel.text = @"奖励收益";
    }else if (self.AccountDetailType == ZHANGHU){//收益账户
        [self.typeVIew1 setHidden:NO];
        [self.headButton setHidden:YES];
//        [self.headButton setTitle:@"转账" forState:UIControlStateNormal];
        [self layoutHeadViewLabels:@"收益账户:"];
        titleLabel.text = @"收益账户";

    }else if (self.AccountDetailType == YINGYEE){//营业额
        [self.typeView2 setHidden:NO];
        [self.headButton setHidden:YES];
        [self layoutHeadViewLabels:@"营业额账户金额:"];
        titleLabel.text = @"营业额";
    }
    
    CGRect frame = self.mainTabview.frame;
    frame.origin.y = self.mainTabview.frame.origin.y + 76;
//    frame.size.height = self.mainTabview.frame.size.height - 76-68-5;
    frame.size.height = self.mainTabview.frame.size.height - 76;
    [self.mainTabview setFrame:frame];
    [self.mainTabview setHidden:NO];
    
}
//调整headVIew上元素的位置和大小
- (void) layoutHeadViewLabels:(NSString *)headLabel1textStr
{
    self.headLabel1.text = headLabel1textStr;
    CGRect frame1 = self.headLabel1.frame;
//    CGRect f = [self.headLabel1 contentAdaptionLabel:headLabel1textStr withTextFont:13];
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
//- (IBAction)nextAndLastPage:(id)sender
//{
//    
//    UIButton *btn = (UIButton *)sender;
//    if (btn.tag == 100) {
//        if (page > 1) {
//            page--;
//            self.nextPageButton.backgroundColor = Color_mainColor;
//            [self.nextPageButton setEnabled:YES];
//        }else{
//            page--;
//            self.lastPageBbutton.backgroundColor = Color_gray1;
//            [self.lastPageBbutton setEnabled:NO];
//        }
//    }else if(btn.tag == 200){
//        if (page < (([totalCount integerValue]/pageSize)+(([totalCount integerValue]%pageSize)>0?1:0)-2)) {
//            page ++;
//            self.lastPageBbutton.backgroundColor = Color_mainColor;
//            [self.lastPageBbutton setEnabled:YES];
//        }else{
//            page++;
//            self.nextPageButton.backgroundColor = Color_gray1;
//            [self.nextPageButton setEnabled:NO];
//        }
//    }
//    self.pageNumberLAbel.text = [NSString stringWithFormat:@"%d",page+1];
//    self.totalPageNumberLabel.text = [NSString stringWithFormat:@"%@",totalCount];
//    [self addData:^(BOOL finish) {
//        
//    }];
//}

//积分和奖励收益 收益类型转换
- (IBAction)typeButtonsClip:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0) {
        type = @"";
        self.type1Button1.backgroundColor = Color_mainColor;
        self.type1Button2.backgroundColor = Color_gray1;
        self.type1Button3.backgroundColor = Color_gray1;
        [self.type1Button1 setTitleColor:Color_White forState:UIControlStateNormal];
        [self.type1Button2 setTitleColor:Color_word_bg forState:UIControlStateNormal];
        [self.type1Button3 setTitleColor:Color_word_bg forState:UIControlStateNormal];
    }else if (btn.tag == 1){
        type = @"income";
        self.type1Button1.backgroundColor = Color_gray1;
        self.type1Button2.backgroundColor = Color_mainColor;
        self.type1Button3.backgroundColor = Color_gray1;
        [self.type1Button1 setTitleColor:Color_word_bg forState:UIControlStateNormal];
        [self.type1Button2 setTitleColor:Color_White forState:UIControlStateNormal];
        [self.type1Button3 setTitleColor:Color_word_bg forState:UIControlStateNormal];
    }else if (btn.tag == 2){
        type = @"pay";
        self.type1Button1.backgroundColor = Color_gray1;
        self.type1Button2.backgroundColor = Color_gray1;
        self.type1Button3.backgroundColor = Color_mainColor;
        [self.type1Button1 setTitleColor:Color_word_bg forState:UIControlStateNormal];
        [self.type1Button2 setTitleColor:Color_word_bg forState:UIControlStateNormal];
        [self.type1Button3 setTitleColor:Color_White forState:UIControlStateNormal];
    }
    [self refreshData:^(BOOL finish) {
        
    }];
}
- (IBAction)headButtonClip:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"提现"]) {
        
        GetCashViewController *vc = [[GetCashViewController alloc]init];
        vc.userId = userId;
        vc.type = @"2";
        float a = [self.totalAccount floatValue];
        a = a*100;
        a = round(a);
        a = a/100;
        vc.totalAccount = [NSString stringWithFormat:@"%.2f",a];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([btn.titleLabel.text isEqualToString:@"转账"]) {
        
        TransferViewController *vc = [[TransferViewController alloc]init];
        vc.userId = userId;
        vc.type = @"4";
        float a = [self.totalAccount floatValue];
        a = a*100;
        a = round(a);
        a = a/100;
        vc.totalAccount = [NSString stringWithFormat:@"%.2f",a];
        [self.navigationController pushViewController:vc animated:YES];
        
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
        AccountDetail2Cell *cell = [self loadAccountDetail2Cell:self.mainTabview];
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
        AccountDetail0Cell *cell0 = [self loadAccountDetail0Cell:self.mainTabview];
        if (accountList.count > 0) {
             cell0.accountDetailModel = [accountList objectAtIndex:row];
        }
       
        return cell0;
    }else if (self.AccountDetailType == ZHANGHU){//收益账户 *
        AccountDetail3Cell *cell3 = [self loadAccountDetail3Cell:self.mainTabview];
        if (accountList.count > 0) {
            cell3.accountDetailModel = [accountList objectAtIndex:row];
        }
        return cell3;
    }else if (self.AccountDetailType == JIANGLI){//奖励收益
        AccountDetail1Cell *cell = [self loadAccountDetail1Cell:self.mainTabview];
        if (accountList.count > 0) {
            cell.accountDetailModel = [accountList objectAtIndex:row];
        }
        
        return cell;
    }else if (self.AccountDetailType == YINGYEE){//营业额 *
        AccountDetail1Cell *cell = [self loadAccountDetail1Cell:self.mainTabview];
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
    switch (indexPath.row) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5://积分
        {
//            if (self.AccountDetailType == JIFEN){
//                AccountDetailViewController * integralVC = [[AccountDetailViewController alloc]initWithNibName:nil bundle:nil];
//                [self.navigationController pushViewController:integralVC animated:YES];
//            }
        }
            break;
            
        default:
            break;
    }
}
#pragma mark------
#pragma mark------loadTableView--------
- (AccountDetail0Cell *)loadAccountDetail0Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"AccountDetail0Cell";
    
    AccountDetail0Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (AccountDetail1Cell *)loadAccountDetail1Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"AccountDetail1Cell";
    
    AccountDetail1Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (AccountDetail2Cell *)loadAccountDetail2Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"AccountDetail2Cell";
    
    AccountDetail2Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (AccountDetail3Cell *)loadAccountDetail3Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"AccountDetail3Cell";
    
    AccountDetail3Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

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
    
    [accountList removeAllObjects];
    accountList = nil;
    accountList = [[NSMutableArray alloc]init];
    page = 0;
    isEnd = NO;
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}



@end

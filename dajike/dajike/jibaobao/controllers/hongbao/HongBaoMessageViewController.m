//
//  HongBaoMessageViewController.m
//  jibaobao
//
//  Created by swb on 15/6/2.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 ****  红包消息
 */

#import "HongBaoMessageViewController.h"
#import "HongbaoMessageCell.h"
#import "SendHongBaoModel.h"
#import "ReceiveHongBao.h"
#import "defines.h"
#import "GetHongBaoDetailViewController.h"
#import "SendOutHongBaoViewController.h"
#import "UserInfoModel.h"

static NSString *HBCell = @"HongBaoDetailCell";
static NSString *HBMCell = @"HongbaoMessageCell";

@interface HongBaoMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_sendBtn;
    UIButton *_getBtn;
    
    NSInteger page;
    
    UserInfoModel *_userModel;
}

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *rArray;
@property (nonatomic, strong) UILabel *numLb;
@property (nonatomic, strong) UILabel *moneyLb;
@property (nonatomic, strong) UILabel *lb;

@end

@implementation HongBaoMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleLabel.text = @"红包消息";
    self.delegate = self;
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc]init];
    userInfoDic = [[FileOperation readFileToDictionary:jibaobaoUser]mutableCopy];
    _userModel = [[UserInfoModel alloc]init];
    _userModel = [JsonStringTransfer dictionary:userInfoDic ToModel:_userModel];
    
    [self addTableView:UITableViewStylePlain];
    [self.mainTabview setFrame:CGRectMake(0, 40, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64-40)];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    self.mainTabview.tableFooterView = [UIView new];
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"HongbaoMessageCell" bundle:nil] forCellReuseIdentifier:HBMCell];
    
    [self setSegmentBtn];
    
    [self getRecevieHongBao];
    
    [self setTabviewHeaderView];
    
    [self setScrollBtnHidden:YES];
    
    [self addHeaderAndFooter];
}
//----------------------------------- 万恶的分割线 --------------------------------------

//分段选择按钮  1.收到的红包     2.发出的红包
- (void)setSegmentBtn
{
    _getBtn = [self.view createButtonWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT/2, 40) andBackImageName:nil andTarget:self andAction:@selector(btnGetHB:) andTitle:@"收到的红包" andTag:12];
    _getBtn.selected = YES;
    [_getBtn setTitleColor:Color_word_bg forState:UIControlStateNormal];
    [_getBtn setTitleColor:Color_White forState:UIControlStateSelected];
    _getBtn.backgroundColor = Color_mainColor;
    _getBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.view addSubview:_getBtn];
    
    _sendBtn = [self.view createButtonWithFrame:CGRectMake(CGRectGetMaxX(_getBtn.frame), 0, WIDTH_CONTROLLER_DEFAULT/2, 40) andBackImageName:nil andTarget:self andAction:@selector(btnSendHB:) andTitle:@"发出的红包" andTag:13];
    _sendBtn.selected = NO;
    [_sendBtn setTitleColor:Color_word_bg forState:UIControlStateNormal];
    [_sendBtn setTitleColor:Color_White forState:UIControlStateSelected];
    _sendBtn.backgroundColor = Color_White;
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.view addSubview:_sendBtn];
}

- (void)btnGetHB:(id)sender{
    self.lb.text = @"共收到";
    NSDictionary *parameter = @{@"userId":self.userId};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyHongBaos.receiveHongbaoList" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            self.rArray = [NSMutableArray array];
            for (NSDictionary *dic in [responseObject.result objectForKey:@"data"]) {
                ReceiveHongBao *receiveHB = [[ReceiveHongBao alloc] init];
                [receiveHB setValuesForKeysWithDictionary:dic];
                [self.rArray addObject:receiveHB];
            }
            _moneyLb.text = [NSString stringWithFormat:@"%.2lf",[[responseObject.result objectForKey:@"sumJine"] floatValue]];
            _numLb.text = [NSString stringWithFormat:@"元       %@个红包",[responseObject.result objectForKey:@"totalCount"]];
            [self.mainTabview reloadData];
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
    if (!_getBtn.selected) {
        _getBtn.selected = !_getBtn.selected;
        _sendBtn.selected = !_sendBtn.selected;
    }
    _getBtn.backgroundColor = Color_mainColor;
    _sendBtn.backgroundColor = Color_White;

    [self.mainTabview reloadData];
}

- (void)btnSendHB:(id)sender{
    self.lb.text = @"共发送";
    NSDictionary *parameter = @{@"userId":self.userId};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyHongBaos.sendHongbaoList" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            self.array = [NSMutableArray array];
            NSArray *sendHBArray = [responseObject.result objectForKey:@"data"];
            for (NSDictionary *dic in sendHBArray) {
                SendHongBaoModel *sendHBM = [[SendHongBaoModel alloc] init];
                [sendHBM setValuesForKeysWithDictionary:dic];
                [self.array addObject:sendHBM];
            }
            _moneyLb.text = [NSString stringWithFormat:@"%@",[responseObject.result objectForKey:@"sumJine"]];
            _numLb.text = [NSString stringWithFormat:@"元       %@个红包",[responseObject.result objectForKey:@"totalCount"]];
            [self.mainTabview reloadData];
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
    if (!_sendBtn.selected) {
        _getBtn.selected = !_getBtn.selected;
        _sendBtn.selected = !_sendBtn.selected;
    }
    _sendBtn.backgroundColor = Color_mainColor;
    _getBtn.backgroundColor = Color_White;
    
    [self.mainTabview reloadData];
}

//设置tableView的透视图
- (void)setTabviewHeaderView
{
    UIView *viewBG = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 200) andBackgroundColor:Color_bg];
    UIView *headViewBg = [self.view createViewWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/2-55, 20, 110, 110) andBackgroundColor:Color_gray2];
    headViewBg.layer.cornerRadius = 55.0f;
    headViewBg.layer.masksToBounds = YES;
    [viewBG addSubview:headViewBg];
    EGOImageView *headImg = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"ico"]];
    [headImg setImageWithURL:[NSURL URLWithString:_userModel.portrait] placeholderImage:[UIImage imageNamed:@"nan.png"]];
    headImg.frame = CGRectMake(5, 5, 100, 100);
    headImg.layer.cornerRadius = 50.0f;
    headImg.layer.masksToBounds = YES;
    [headViewBg addSubview:headImg];
    _lb = [self.view creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(headViewBg.frame)+5, WIDTH_CONTROLLER_DEFAULT-20, 25) AndFont:15.0f AndBackgroundColor:Color_Clear AndText:@"共收到" AndTextAlignment:NSTextAlignmentCenter AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [viewBG addSubview:_lb];
    _moneyLb = [self.view creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(_lb.frame)+5, WIDTH_CONTROLLER_DEFAULT/2-30, 25) AndFont:20.0f AndBackgroundColor:Color_Clear AndText:@"0.00" AndTextAlignment:NSTextAlignmentRight AndTextColor:Color_mainColor andCornerRadius:0.0f];
    [viewBG addSubview:_moneyLb];
    
    _numLb = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(_moneyLb.frame)+3, CGRectGetMaxY(_lb.frame)+6, WIDTH_CONTROLLER_DEFAULT/2-30, 25) AndFont:15.0f AndBackgroundColor:Color_Clear AndText:@"元       0个红包" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [viewBG addSubview:_numLb];
    
    self.mainTabview.tableHeaderView = viewBG;
}

- (void)getRecevieHongBao{
    
    NSDictionary *parameter = @{@"userId":self.userId};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyHongBaos.receiveHongbaoList" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            self.rArray = [NSMutableArray array];
            for (NSDictionary *dic in [responseObject.result objectForKey:@"data"]) {
                ReceiveHongBao *receiveHB = [[ReceiveHongBao alloc] init];
                [receiveHB setValuesForKeysWithDictionary:dic];
                [self.rArray addObject:receiveHB];
            }
            _moneyLb.text = [NSString stringWithFormat:@"%.2lf",[[responseObject.result objectForKey:@"sumJine"] floatValue]];
            _numLb.text = [NSString stringWithFormat:@"元       %@个红包",[responseObject.result objectForKey:@"totalCount"]];
            [self.mainTabview reloadData];
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
    if (!_getBtn.selected) {
        _getBtn.selected = !_getBtn.selected;
        _sendBtn.selected = !_sendBtn.selected;
    }
    _getBtn.backgroundColor = Color_mainColor;
    _sendBtn.backgroundColor = Color_White;
    
    [self.mainTabview reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_getBtn.selected){
        return self.rArray.count;
    } else {
        return self.array.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_getBtn.selected) {
        HongbaoMessageCell *myCell = [tableView dequeueReusableCellWithIdentifier:HBMCell];
        if (indexPath.row < self.array.count) {
            [myCell.hbImageView setImage:[UIImage imageNamed:@"img_hb_02.png"]];
            myCell.typeHongBao.text = [[self.array objectAtIndex:indexPath.row] type_text];
            myCell.moneyLabel.text = [NSString stringWithFormat:@"%@元",[[self.array objectAtIndex:indexPath.row] jine]];
            myCell.typeNumber.text = [NSString stringWithFormat:@"包%@个",[[self.array objectAtIndex:indexPath.row] num]];
            myCell.workLabel.text = [[self.array objectAtIndex:indexPath.row] status_text];
            myCell.dateLabel.text = [self timeStringFromTimeInterval:[[[self.array objectAtIndex:indexPath.row] create_time] doubleValue] / 1000];
        }
        return myCell;
    } else {
        HongbaoMessageCell *myCell = [tableView dequeueReusableCellWithIdentifier:HBMCell];
        if (indexPath.row < self.rArray.count) {
            myCell.moneyLabel.text = [NSString stringWithFormat:@"+%@",[[self.rArray objectAtIndex:indexPath.row] jine]];
            [myCell.hbImageView setImageWithURL:[NSURL URLWithString:[[self.rArray objectAtIndex:indexPath.row] portrait]] placeholderImage:[UIImage imageNamed:@"img_hb_02.png"]];
            myCell.typeNumber.text = @"";
            myCell.workLabel.text = @"";
            myCell.typeHongBao.text = [NSString stringWithFormat:@"来自%@",[[self.rArray objectAtIndex:indexPath.row ] send_nick_name]];
            myCell.dateLabel.text = [self timeStringFromTimeInterval:[[[self.rArray objectAtIndex:indexPath.row] create_time] doubleValue] / 1000];
        }
        return myCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_getBtn.selected) {
        GetHongBaoDetailViewController *vc = [[GetHongBaoDetailViewController alloc]init];
        vc.hongbao_id = [[self.rArray objectAtIndex:indexPath.row] hongbao_id];
        vc.portrait = [[self.rArray objectAtIndex:indexPath.row] portrait];
        vc.send_nick_name = [[self.rArray objectAtIndex:indexPath.row] send_nick_name];
        vc.jinEString = [[self.rArray objectAtIndex:indexPath.row] jine];
        vc.dataDouble = [[[self.rArray objectAtIndex:indexPath.row] create_time] doubleValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (_sendBtn.selected) {
        SendOutHongBaoViewController *vc = [[SendOutHongBaoViewController alloc]init];
        vc.hongbao_id = [NSString stringWithFormat:@"%@",[[self.array objectAtIndex:indexPath.row] hongbao_id]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 时间戳转换时间
- (NSString *)timeStringFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *timeString = [formatter stringFromDate:date];
    
    return timeString;
}

//----------------------------------- 万恶的分割线 --------------------------------------

- (void)addData:(void (^)(BOOL finish))success
{
    NSDictionary *parameter = @{@"userId":self.userId,@"page":[NSString stringWithFormat:@"%ld",page+1]};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyHongBaos.sendHongbaoList" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"---------------%ld",page);
            NSLog(@"result = %@",responseObject.result);
            page = [[responseObject.result objectForKey:@"page"] intValue];
            NSArray *sendHBArray = [[responseObject.result objectForKey:@"data"] mutableCopy];
            for (NSDictionary *dic in sendHBArray) {
                SendHongBaoModel *sendHBM = [[SendHongBaoModel alloc] init];
                [sendHBM setValuesForKeysWithDictionary:dic];
                [self.array addObject:sendHBM];
            }
            
            if (page >= [[responseObject.result objectForKey:@"totalPage"] intValue]) {
                isEnd = YES;
            }
            [self.mainTabview reloadData];
            success(YES);
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
        _array = nil;
        [self.mainTabview reloadData];
        success(NO);
    }];
}

#pragma mark-----
#pragma mark---------MJRefresh---------

//加载数据
- (void) loadData:(void (^)(BOOL finish))success
{
    page = 1;
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
    [self.array removeAllObjects];
    self.array = nil;
    self.array = [[NSMutableArray alloc]init];
    page = 0;
    isEnd = NO;
    [self loadData:^(BOOL finish) {
        success(finish);
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

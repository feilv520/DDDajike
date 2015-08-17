//
//  DrawMainViewController.m
//  jibaobao
//
//  Created by dajike on 15/6/10.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "DrawMainViewController.h"
#import "DrawHeaderView.h"
#import "defines.h"
#import "Choujiang01Cell.h"
#import "Choujiang02Cell.h"
#import "DrawSearchViewController.h"
#import "DrawResultView.h"
#import "ZhongJiangTopModel.h"
#import "HelpCenterViewController.h"

@interface DrawMainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    DrawHeaderView *headerView;
    UIButton *_backView;
    DrawResultView *_resultV;
    
    //用户抽奖信息
    NSMutableDictionary *_choujiangInfo;
    //中奖排行榜列表
    NSMutableArray *_zhongjiangTopArr;
    //中奖播报
    NSMutableArray *_zhongjiangBobaopArr;
    
    NSTimer *_timer;
    //播报index
    NSInteger _bobaoIndex;
    NSString *_userId;
}
@end

@implementation DrawMainViewController
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
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self setNavType:CHOUJIANG_NAV action:nil];
    self.navigationItem.title = @"抽奖";
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    self.mainTabview.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1.0f];
    [self.mainTabview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    headerView = [[DrawHeaderView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, WIDTH_CONTROLLER_DEFAULT/416.0*250.0)];
    [headerView.xianjinBtn addTarget:self action:@selector(xianjinBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView.jifenBtn addTarget:self action:@selector(jifenBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.mainTabview.tableHeaderView = headerView;
    
//    [headerView.nameBtn addTarget:self action:@selector(jifenBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _backView = [[UIButton alloc]initWithFrame:self.view.frame];
    [_backView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
//    [_backView addTarget:self action:@selector(toResultButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backView];
    [_backView setHidden:YES];
    
    _resultV = [[DrawResultView alloc]initWithFrame:CGRectMake(5, 50, 300, 200)];
    [_resultV setUserInteractionEnabled:YES];
    [_resultV.closeButton addTarget:self action:@selector(toResultButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resultV];
    [_resultV setHidden:YES];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self.mainTabview setFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, HEIGHT_CONTROLLER_DEFAULT-64-12)];
    //判断当前是否在登录状态
    if ([FileOperation isLogin]) {
        _userId = [NSString stringWithFormat:@"%@",[FileOperation getUserId]];
        
        NSDictionary *userInfoDic = [NSDictionary dictionaryWithContentsOfFile:[FileOperation creatPlistIfNotExist:jibaobaoUser]];
        //会员头像
        NSString *portrait = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"portrait"]];
        //会员性别
        NSString *gender = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"gender"]];
        //用户名
        NSString *userName = [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"nickName"]];

        if ([commonTools isEmpty:portrait]||[portrait isEqualToString:@""]) {
            if ([gender isEqualToString:@"2"]) {
                [headerView.headImageBtn setBackgroundImage:[UIImage imageNamed:@"nv.png"] forState:UIControlStateNormal];
            }else{
                [headerView.headImageBtn setBackgroundImage:[UIImage imageNamed:@"nan.png"] forState:UIControlStateNormal];
            }
        }else{
            NSURL *imgUrl = [commonTools getImgURL:portrait];
            NSData *data = [NSData dataWithContentsOfURL:imgUrl];
            if (data == nil) {
                [headerView.headImageBtn setBackgroundImage:[UIImage imageNamed:@"nan.png"] forState:UIControlStateNormal];
            }else{
                [headerView.headImageBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            }
            
        }
        
        headerView.nameBtn.text = userName;

    }else{
        _userId = @"";
    }
    //重新请求并加载数据
    [self getData];
    //开场动画
    headerView.angle0 = 120;
    headerView.angle2 = -120;
    headerView.myAlpha = 0.0;
    
    [headerView startAnimation0];
    [headerView startAnimation1];
    //定时器，设定时间过1.5秒，
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(BobaoAnimation) userInfo:nil repeats:YES];
    _bobaoIndex = 0;
    [_timer fire];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [headerView.dengguang0 setHidden:YES];
    [headerView.dengguang1 setHidden:YES];
    [headerView.dengguang2 setHidden:YES];
    [_timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark------
#pragma mark------get data--------
- (void) getData
{
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"ChouJiangs.index" parameters:@{@"userId":_userId} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"responseObject.result = %@",responseObject.result);
            
            //中奖排行榜
            if (_zhongjiangTopArr) {
                [_zhongjiangTopArr removeAllObjects];
                _zhongjiangTopArr = nil;
            }
            _zhongjiangTopArr = [[NSMutableArray alloc]init];
            if (!([[responseObject.result objectForKey:@"zhongJiangTop"] isEqual:[NSNull null]]||([responseObject.result objectForKey:@"zhongJiangTop"] == nil))) {
                for (NSDictionary *dic in [responseObject.result objectForKey:@"zhongJiangTop"]) {
                    ZhongJiangTopModel *zhongjiangModel = [[ZhongJiangTopModel alloc]init];
                    zhongjiangModel = [JsonStringTransfer dictionary:dic ToModel:zhongjiangModel];
                    [_zhongjiangTopArr addObject:zhongjiangModel];
                }
            }
            
            
            //中奖播报
            if (_zhongjiangBobaopArr) {
                [_zhongjiangBobaopArr removeAllObjects];
                _zhongjiangBobaopArr = nil;
            }
            _zhongjiangBobaopArr = [[NSMutableArray alloc]init];
            if (!([[responseObject.result objectForKey:@"zhongJiangBoBao"] isEqual:[NSNull null]]||([responseObject.result objectForKey:@"zhongJiangBoBao"] == nil))) {
                for (NSDictionary *dic in [responseObject.result objectForKey:@"zhongJiangBoBao"]) {
                    ZhongJiangTopModel *zhongjiangModel = [[ZhongJiangTopModel alloc]init];
                    zhongjiangModel = [JsonStringTransfer dictionary:dic ToModel:zhongjiangModel];
                    [_zhongjiangBobaopArr addObject:zhongjiangModel];
                }
            }
           
            //用户抽奖相关信息
            _choujiangInfo = [[NSMutableDictionary alloc]init];
            for (NSString * key in [responseObject.result allKeys]) {
                id objc = [responseObject.result objectForKey:key];
                if (![objc isKindOfClass:[NSArray class]]) {
                    [_choujiangInfo setObject:objc forKey:key];
                }
            }
//            [headerView.nameBtn setTitle:[responseObject.result objectForKey:@"nickName"] forState:UIControlStateNormal];
            [self.mainTabview reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

#pragma mark------
#pragma mark------uitableViewDelegate uitableViewDatasource--------


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_zhongjiangTopArr.count > 3) {
        if (_zhongjiangTopArr.count > 10) {
            return 8;
        }
        return _zhongjiangTopArr.count-2;
    }else{
        return 1;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        return 206;
    }else {
        return 29;
        
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        Choujiang01Cell *cell1 = [self loadChoujiang01Cell:self.mainTabview];
        cell1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"choujiang_bg"]];
        if (_zhongjiangBobaopArr.count > 0) {
            cell1.boBaoModel = [_zhongjiangBobaopArr objectAtIndex:0];
            [cell1 bobaoAnimation];
        }
        if (_choujiangInfo != nil) {
            cell1.label01.text = [NSString stringWithFormat:@"%@",[_choujiangInfo objectForKey:@"keYongChouJiangQuan"]];
            cell1.label02.text = [NSString stringWithFormat:@"%@",[_choujiangInfo objectForKey:@"jiFen"]];
            cell1.label03.text = [NSString stringWithFormat:@"%@",[_choujiangInfo objectForKey:@"shouYi"]];
        }
        if (_zhongjiangTopArr.count > 0) {
            cell1.topModel0 = [_zhongjiangTopArr objectAtIndex:0];
        }
        if (_zhongjiangTopArr.count > 1) {
            cell1.topModel1 = [_zhongjiangTopArr objectAtIndex:1];
        }
        if (_zhongjiangTopArr.count > 2) {
            cell1.topModel2 = [_zhongjiangTopArr objectAtIndex:2];
        }
        return cell1;
    }else{
        Choujiang02Cell *cell1 = [self loadChoujiang02Cell:self.mainTabview];
        cell1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"choujiang_bg"]];
        if (_zhongjiangTopArr.count > 0) {
            cell1.topModel = [_zhongjiangTopArr objectAtIndex:row+2];
            cell1.indexLabel.text = [NSString stringWithFormat:@"%d",row+3];
        }
        return cell1;
    }
    return nil;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = [indexPath row];
   }


#pragma mark------
#pragma mark------loadTableView--------
- (Choujiang01Cell *)loadChoujiang01Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"Choujiang01Cell";
    
    Choujiang01Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (Choujiang02Cell *)loadChoujiang02Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"Choujiang02Cell";
    
    Choujiang02Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

#pragma mark------
#pragma mark--------CHOUJIANG -----------------
//现金抽奖
- (void)xianjinBtn:(id)sender
{
    //判断当前是否在登录状态
    if ([FileOperation isLogin] == NO) {
        [ProgressHUD showMessage:@"请先登录！" Width:280 High:10];
        return;
    }
    if (_choujiangInfo == nil) {
        [ProgressHUD showMessage:@"获取信息失败！" Width:280 High:10];
        return;
    }
    if ([[_choujiangInfo objectForKey:@"keYongChouJiangQuan"] integerValue] == 0) {
        [ProgressHUD showMessage:@"您当前无可用抽奖权！" Width:280 High:10];
        return;
    }
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"ChouJiangs.start" parameters:@{@"userId":@"2",@"type":@"0"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {//arr
            [_resultV setResultWithArr:responseObject.result];
            [_backView setHidden:NO];
            [self.view bringSubviewToFront:_backView];
            [self.view bringSubviewToFront:_resultV];
            //    [self.view insertSubview:_backView belowSubview:_resultV];
            
            [self DrawResultShow];
        }else{
            [ProgressHUD showMessage:[NSString stringWithFormat:@"%@",responseObject.msg] Width:280 High:10];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//积分抽奖
- (void)jifenBtn:(id)sender
{
    //判断当前是否在登录状态
    if ([FileOperation isLogin] == NO) {
        [ProgressHUD showMessage:@"请先登录！" Width:280 High:10];
        return;
    }
    if (_choujiangInfo == nil) {
        [ProgressHUD showMessage:@"获取信息失败！" Width:280 High:10];
        return;
    }
    if ([[_choujiangInfo objectForKey:@"keYongChouJiangQuan"] integerValue] == 0) {
        [ProgressHUD showMessage:@"您没有可用的抽奖权！" Width:280 High:10];
        return;
    }
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"ChouJiangs.start" parameters:@{@"userId":@"2",@"type":@"1"} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {//arr
            [_resultV setResultWithArr:responseObject.result];
            [_backView setHidden:NO];
            [self.view bringSubviewToFront:_backView];
            [self.view bringSubviewToFront:_resultV];
            //    [self.view insertSubview:_backView belowSubview:_resultV];
            
            [self DrawResultShow];
        }else{
            [ProgressHUD showMessage:[NSString stringWithFormat:@"%@",responseObject.msg] Width:280 High:10];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}
//播报动画
- (void)BobaoAnimation
{
    if (!(_zhongjiangBobaopArr.count > 0)) {
        return;
    }
    if (_bobaoIndex >= (_zhongjiangBobaopArr.count -1)) {
        _bobaoIndex = 0;
    }else{
        _bobaoIndex ++;
    }
    if (_zhongjiangBobaopArr.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        Choujiang01Cell *cell = (Choujiang01Cell *)[self.mainTabview cellForRowAtIndexPath:indexPath];
        cell.boBaoModel = [_zhongjiangBobaopArr objectAtIndex:_bobaoIndex];
        [cell bobaoAnimation];
    }
   
    NSLog(@"fjsdgfjd");
}
////设置抽奖账户信息
//- (void) setChoujiangAccount
//{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    Choujiang01Cell *cell = (Choujiang01Cell *)[self.mainTabview cellForRowAtIndexPath:indexPath];
//    cell.label01.text = [NSString stringWithFormat:@"%@",[_choujiangInfo objectForKey:@"keYongChouJiangQuan"]];
//    cell.label02.text = [NSString stringWithFormat:@"%@",[_choujiangInfo objectForKey:@"jiFen"]];
//    cell.label03.text = [NSString stringWithFormat:@"%@",[_choujiangInfo objectForKey:@"shouYi"]];
//    [self.mainTabview reloadData];
//}

- (void)toResultButton:(id) sender
{
    if ([_backView isHidden] == NO) {
       
        [_backView setHidden:YES];
        [_resultV setHidden:YES];
    }
    //重新请求数据，刷新tableView
    [self getData];
    
}

- (void) DrawResultShow
{
    [UIView animateWithDuration:0.2 animations:^{
        _resultV.alpha = 1.0f;
        [_resultV setHidden:NO];
        
        _resultV.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);}
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.12 animations:^{
                             _resultV.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);} completion:^(BOOL finished) {
                                 
                                 [UIView animateWithDuration:0.12 animations:^{
                                     _resultV.transform = CGAffineTransformIdentity;
                                 } completion:^(BOOL finished) {
                                     NSLog(@"hello");
                                     
                                 }];
                             }];
                     }];
}
#pragma mark------
#pragma mark--------my delegate -----------------
//左一 抽奖规则
- (void)left1ButtonClicked:(id)sender
{
    HelpCenterViewController *helpCenterVC = [[HelpCenterViewController alloc]initWithNibName:nil bundle:nil];
    helpCenterVC.isHelp = 5;
    [self.navigationController pushViewController:helpCenterVC animated:YES];
}
//右一  奖金查询
- (void) rightButtonClicked:(id)sender
{
    //判断当前是否在登录状态
    if ([FileOperation isLogin] == NO) {
        [ProgressHUD showMessage:@"请先登录！" Width:280 High:10];
        return;
    }
    DrawSearchViewController *searchVC = [[DrawSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
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

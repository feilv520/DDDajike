//
//  MyAccountsFriends.m
//  jibaobao
//
//  Created by songjw on 15/6/8.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "MyAccountsFriends.h"
#import "defines.h"
#import "MyFriendsModel.h"
#import "MyFriendsDetailViewController.h"
#import "JsonStringTransfer.h"
static NSString *cell0 = @"cell0";
static NSString *cell1 = @"cell1";

@interface MyAccountsFriends (){
    NSInteger _page;
    UILabel *_nameLab;
    UILabel *_shopNoLab;
    MyFriendsModel *_myFriendsModel;
    NSMutableArray *_friendsListArray;
    
    UIImageView *centerImgView;
    UIImageView *topImgView;
    UIImageView *buttomImgView;
    UIImageView *buttomImgView2;
}

@end

@implementation MyAccountsFriends
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"我的好友";
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
    
    _page = 0;
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    self.mainTabview.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self addHeaderAndFooter];
    [self refreshData:^(BOOL finish) {
        
    }];
}

- (void)addData:(void (^)(BOOL finish))success{
    NSString *pageStr = [NSString stringWithFormat:@"%ld",_page+1];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys: self.userInfoModel.userId,@"userId", pageStr,@"page", @"15",@"pageSize", nil];
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.Friends" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result:%@",responseObject.result);
            NSString *totalCount = [responseObject.result objectForKey:@"totalCount"];
            _page = [[responseObject.result objectForKey:@"page"] intValue];
            
            NSArray *tempArr = [[responseObject.result objectForKey:@"data"]mutableCopy];
            for (int i = 0; i < tempArr.count;i++) {
                MyFriendsModel *myFriendsModel = [[MyFriendsModel alloc]init];
                myFriendsModel = [JsonStringTransfer dictionary:tempArr[i] ToModel:myFriendsModel];
                [_friendsListArray addObject:myFriendsModel];
            }
            if (_page >= [[responseObject.result objectForKey:@"totalPage"] intValue]) {
                isEnd = YES;
            }
        }
        [self.mainTabview reloadData];
        success(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
        _friendsListArray = nil;
        [self.mainTabview reloadData];
        success(NO);
    }];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _friendsListArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell0];
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/4 -60, 0, 120, 33.0)];
    _shopNoLab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT*3/4-60, 0, 120, 33.0)];
    
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.textColor = Color_word_bg;
    
    _shopNoLab.textAlignment = NSTextAlignmentCenter;
    _shopNoLab.textColor = Color_word_bg;
    centerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/2-0.5, 0, 0.7, 33.0)];
    centerImgView.backgroundColor = Color_line_bg;
    
    topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 0.7)];
    topImgView.backgroundColor = Color_line_bg;
    
    buttomImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 32, WIDTH_CONTROLLER_DEFAULT, 0.7)];
    buttomImgView.backgroundColor = Color_line_bg;
    
    buttomImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 32, WIDTH_CONTROLLER_DEFAULT-20, 0.7)];
    buttomImgView2.backgroundColor = Color_line_bg;
    
    _nameLab.font = [UIFont systemFontOfSize:15.0];
    _shopNoLab.font = [UIFont systemFontOfSize:16.0];
    
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:centerImgView];
        [cell addSubview:topImgView];
        [cell addSubview:buttomImgView];
        _nameLab.text = @"用户名";
        _shopNoLab.text = @"集客小店号";
        
    }else{
        if (indexPath.row -1 < _friendsListArray.count) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell addSubview:buttomImgView2];
            if (indexPath.row != 0) {
                MyFriendsModel *myFriendsModel = _friendsListArray[indexPath.row-1];
                
                _nameLab.text = myFriendsModel.user_name;
                if ([myFriendsModel.user_id isEqualToString:@"<null>"]) {
                    _shopNoLab.text = @"无";
                }else{
                    _shopNoLab.text = myFriendsModel.user_id;
                }
            }
            
        }
        
    }
    [cell addSubview:_nameLab];
    [cell addSubview:_shopNoLab];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row != 0) {
        MyFriendsDetailViewController *friendDetailVC = [[MyFriendsDetailViewController alloc]init];
        friendDetailVC.myFriendsModel = _friendsListArray[indexPath.row];
        [self.navigationController pushViewController:friendDetailVC animated:YES];
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
    [_friendsListArray removeAllObjects];
    _friendsListArray = nil;
    _friendsListArray = [[NSMutableArray alloc]init];
    _page = 0;
    isEnd = NO;
    [self loadData:^(BOOL finish) {
        success(finish);
    }];
}


@end
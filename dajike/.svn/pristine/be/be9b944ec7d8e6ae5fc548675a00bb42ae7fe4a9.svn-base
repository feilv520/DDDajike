//
//  SeetingViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "SeetingViewController.h"
#import "defines.h"
#import "SettintOneCell.h"
#import "MineNextCell.h"
#import "HelpCenterViewController.h"

 //待app上线后将appID改为本app的apid
//static NSString *appID = @"594467299";
static NSString *appID = @"996401785";

@interface SeetingViewController ()<UIAlertViewDelegate>
{
    NSArray *dataArray;
}

@end

@implementation SeetingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"设置";
        
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableView:UITableViewStyleGrouped];
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    [self addData];
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutMainTableView
{
    CGRect frame = self.mainTabview.frame;
    frame.origin.y = self.mainTabview.frame.origin.y+45;
    frame.size.height = self.mainTabview.frame.size.height-45;
    [self.mainTabview setFrame:frame];
}

- (void)addData
{
    dataArray = @[
//                  @{
//                      @"title" : @"展示高清图片",
//                      },
                  @{
                      @"title" : @"系统消息",
                      },
                  @{
                      @"title" : @"我的消息",
                      },
                  @{
                      @"title" : @"清除缓存",
                      },
                  @{
                      @"title" : @"联系客服",
                      },
                  @{
                      @"title" : @"去评价",
                      },
                  @{
                      @"title" : @"帮助中心",
                      },
                  @{
                      @"title" : @"关于我们",
                      },
                  @{
                      @"title" : @"特别声明",
                      },
                  ];

}

#pragma mark------
#pragma mark------uitableViewDelegate uitableViewDatasource--------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 80) andBackgroundColor:Color_Clear];
    if ([FileOperation isLogin]) {
        UIButton *quitBtn = [self.view createButtonWithFrame:CGRectMake(40, 20, WIDTH_CONTROLLER_DEFAULT-80, 40) andBackImageName:nil andTarget:self andAction:@selector(quitBtnAction:) andTitle:@"退出登录" andTag:22];
        quitBtn.backgroundColor = Color_mainColor;
        quitBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        quitBtn.layer.cornerRadius = 5.0f;
        quitBtn.layer.masksToBounds = YES;
        [footV addSubview:quitBtn];
    }
    
    return footV;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //    return cell.frame.size.height;
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row <= 1) {
        SettintOneCell *cell0 = [self loadSettintOneCell:self.mainTabview];
        [cell0.label1 setHidden:YES];
        [cell0.switch1 setHidden:NO];
        cell0.titlelabel.text = [[dataArray objectAtIndex:row]objectForKey:@"title"];
        return cell0;
    }else if(row == 2){
        SettintOneCell *cell1 = [self loadSettintOneCell:self.mainTabview];
        [cell1.label1 setHidden:NO];
        [cell1.switch1 setHidden:YES];
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        cell1.titlelabel.text = [[dataArray objectAtIndex:row]objectForKey:@"title"];
        cell1.label1.text = [NSString stringWithFormat:@"%.1fM",[FileOperation folderSizeAtPath:cachPath]];
        return cell1;
    }else if(row > 2){
        MineNextCell *cell2 = [self loadMineNextCell:self.mainTabview];
        cell2.titleLabel.text = [[dataArray objectAtIndex:row]objectForKey:@"title"];
        [cell2.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [cell2.titleTwoLabel setHidden:YES];
        return cell2;
    }
    return nil;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 2) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要清除缓存数据吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    if (indexPath.row == 3) {
        [commonTools dialPhone:@"4007281117"];
    }
    if (indexPath.row == 4) {
        NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appID];
        
        if([[[UIDevice currentDevice] systemVersion]floatValue] >= 7){
            
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appID];
            
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    if (indexPath.row == 5) {//帮助中心
        HelpCenterViewController *helpCenterVC = [[HelpCenterViewController alloc]initWithNibName:nil bundle:nil];
        helpCenterVC.isHelp = 1;
        [self.navigationController pushViewController:helpCenterVC animated:YES];
    }
    if (indexPath.row == 6) {//关于我们
        HelpCenterViewController *aboutUs = [[HelpCenterViewController alloc]initWithNibName:nil bundle:nil];
        aboutUs.isHelp = 2;
        [self.navigationController pushViewController:aboutUs animated:YES];
    }
    if (indexPath.row == 7) {//特别声明
        HelpCenterViewController *aboutUs = [[HelpCenterViewController alloc]initWithNibName:nil bundle:nil];
        aboutUs.isHelp = 4;
        [self.navigationController pushViewController:aboutUs animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else {
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        [FileOperation clearCacheAtPath:cachPath];
        [self.mainTabview reloadData];
    }
}
- (void)quitBtnAction:(UIButton *)btn
{
    NSDictionary *parameter = @{@"userId":[FileOperation getUserId]};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyAccounts.logout" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            [FileOperation logOffOrlogOut];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else
            [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}
#pragma mark------
#pragma mark------loadTableView--------
- (SettintOneCell *)loadSettintOneCell:(UITableView *)tableView
{
    NSString * const nibName  = @"SettintOneCell";
    
    SettintOneCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (MineNextCell *)loadMineNextCell:(UITableView *)tableView
{
    NSString * const nibName  = @"MineNextCell";
    
    MineNextCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
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

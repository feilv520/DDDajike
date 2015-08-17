//
//  DrawSearchViewController.m
//  jibaobao
//
//  Created by dajike on 15/6/10.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "DDrawSearchViewController.h"
#import "DrawResult01Cell.h"
#import "DrawResult02Cell.h"
#import "defines.h"
#import "JIangjinModel.h"
#import "dDefine.h"

@interface DDrawSearchViewController ()
{
    //奖金查询数组
    NSMutableArray *_jiangjinChaxunArr;
}

@end

@implementation DDrawSearchViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"奖金查询"];
    [self addTableView:NO];
    //    [self.dMainTableView setFrame:CGRectMake(0, 64, DWIDTH_CONTROLLER_DEFAULT, DHEIGHT_CONTROLLER_DEFAULT-64-49)];
    [self.dMainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;

    [self.dMainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _jiangjinChaxunArr = [[NSMutableArray alloc]init];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //奖金查询
    [[DMyAfHTTPClient sharedClient] postPathWithMethod:@"ChouJiangs.query" parameters:@{@"userId":[NSString stringWithFormat:@"%@",[FileOperation getUserId]]} ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {//arr
            if (_jiangjinChaxunArr != nil) {
                [_jiangjinChaxunArr removeAllObjects];
                _jiangjinChaxunArr = nil;
            }
            _jiangjinChaxunArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject.result) {
                JIangjinModel *jiangjinModel = [[JIangjinModel alloc]init];
                jiangjinModel = [JsonStringTransfer dictionary:dic ToModel:jiangjinModel];
                [_jiangjinChaxunArr addObject:jiangjinModel];
            }
            
            [self.dMainTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    [self addTableView:UITableViewStyleGrouped];
    
    
//    self.mainTabview.delegate = self;
//    self.mainTabview.dataSource = self;
    

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
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _jiangjinChaxunArr.count+1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
//    if (row == 0) {
//        static NSString *identifer = @"pcell0";
//        UITableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:identifer];
//        if (nil == cell0) {
//            cell0 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
//            UILabel *label = [[UILabel alloc]initWithFrame:cell0.frame];
//            [label setTextAlignment:NSTextAlignmentCenter];
//            [label setFont:[UIFont systemFontOfSize:19 weight:18]];
//            [label setTextColor:[UIColor blackColor]];
//            label.text = @"奖金查询";
//            [cell0 addSubview:label];
//        }
//        return cell0;
//    } else
    if(row == 0){
        DrawResult01Cell *cell1 = [self loadDrawResult01Cell:self.dMainTableView];
        return cell1;
    } else {
        DrawResult02Cell *cell2 = [self loadDrawResult02Cell:self.dMainTableView];
        if (_jiangjinChaxunArr.count > 0) {
            cell2.jiangjinModel = (JIangjinModel *)[_jiangjinChaxunArr objectAtIndex:row-1];
        }
        return cell2;
    }

    
    
    return nil;
    
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
}
#pragma mark------
#pragma mark------loadTableView--------
- (DrawResult01Cell *)loadDrawResult01Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"DrawResult01Cell";
    
    DrawResult01Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (DrawResult02Cell *)loadDrawResult02Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"DrawResult02Cell";
    
    DrawResult02Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
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

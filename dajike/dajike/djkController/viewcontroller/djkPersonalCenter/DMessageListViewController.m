//
//  DMessageListViewController.m
//  dajike
//
//  Created by songjw on 15/7/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DMessageListViewController.h"
#import "DBaseNavView.h"
#import "MyMessage0Cell.h"
#import "MyMessage1Cell.h"
#import "dDefine.h"

@interface DMessageListViewController (){
    DImgButton *_rightBut;
    NSMutableArray *_dataArray;
}

@end

@implementation DMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarTitle:@"消息"];
    [self.view setBackgroundColor:DBackColor_mine];
    _rightBut = [DBaseNavView createNavBtnWithTitle:@"清空" target:self action:@selector(rightButAction)];
    [self setNaviBarRightBtn:_rightBut];
    
    _dataArray = [[NSMutableArray alloc]init];
//    [self addData];
    
    [self addTableView:NO];
    
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
    self.dMainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
}
- (void)addData
{
           _dataArray = @[
                      @{
                          @"title1" : @"退款通知",
                          @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
                          @"date" : @"2015-04-20",
                          @"time" : @"18:00",
                          },
                      @{
                          @"title1" : @"退款通知",
                          @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
                          @"date" : @"2015-04-20",
                          @"time" : @"18:00",
                          },
                      @{
                          @"title1" : @"退款通知",
                          @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
                          @"date" : @"2015-04-20",
                          @"time" : @"18:00",
                          },
                      @{
                          @"title1" : @"退款通知",
                          @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
                          @"date" : @"2015-04-20",
                          @"time" : @"18:00",
                          },
                      @{
                          @"title1" : @"退款通知",
                          @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
                          @"date" : @"2015-04-20",
                          @"time" : @"18:00",
                          },
                      @{
                          @"title1" : @"退款通知",
                          @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
                          @"date" : @"2015-04-20",
                          @"time" : @"18:00",
                          },
                      @{
                          @"title1" : @"退款通知",
                          @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
                          @"date" : @"2015-04-20",
                          @"time" : @"18:00",
                          }
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
    return 0.5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count != 0) {
        return _dataArray.count;
    }
    [self.noDataView setHidden:NO];
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row%2 == 0) {
        return 68;
    }else{
        return 90;
    }
    
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    MyMessage0Cell *cell = [self loadMyMessage0Cell:self.dMainTableView];
            if (row%2 == 0) {
            MyMessage0Cell *cell = [self loadMyMessage0Cell:self.dMainTableView];
            cell.label1.text = [[_dataArray objectAtIndex:row]objectForKey:@"title2"];
            cell.dateLabel.text = [[_dataArray objectAtIndex:row]objectForKey:@"date"];
            cell.timeLabel.text = [[_dataArray objectAtIndex:row]objectForKey:@"time"];
            return cell;
        }else{
            MyMessage1Cell *cell = [self loadMyMessage1Cell:self.dMainTableView];
            cell.lane.text = [[_dataArray objectAtIndex:row]objectForKey:@"title1"];
            cell.label1.text = [[_dataArray objectAtIndex:row]objectForKey:@"title2"];
            cell.dateLabel.text = [[_dataArray objectAtIndex:row]objectForKey:@"date"];
            cell.timeLabel.text = [[_dataArray objectAtIndex:row]objectForKey:@"time"];
            return cell;
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
- (MyMessage0Cell *)loadMyMessage0Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"MyMessage0Cell";
    
    MyMessage0Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}
- (MyMessage1Cell *)loadMyMessage1Cell:(UITableView *)tableView
{
    NSString * const nibName  = @"MyMessage1Cell";
    
    MyMessage1Cell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

- (void)rightButAction{
    //消息列表清空
    [FileOperation clearMessageList];
    [self.dMainTableView reloadData];
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

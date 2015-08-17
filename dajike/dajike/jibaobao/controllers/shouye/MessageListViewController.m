//
//  MessageListViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "MessageListViewController.h"
#import "MyMessage0Cell.h"
#import "MyMessage1Cell.h"
#import "defines.h"

@interface MessageListViewController ()
{
    NSMutableArray *dataArray;
}
@end

@implementation MessageListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"消息";
        
        
        
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //未读消息个数清零
    [FileOperation writeMessageNum:0];
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
    
    [self addnavItems];
    
    [self addTableViewFootView];
}
- (void) addnavItems
{
    
    UIButton *rightNavButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
    [rightNavButton setTitleColor:Color_mainColor forState:UIControlStateNormal];
    [rightNavButton setTitle:@"清空" forState:UIControlStateNormal];
    rightNavButton.backgroundColor = [UIColor clearColor];
    [rightNavButton.titleLabel setFont:Font_Default];
    [rightNavButton addTarget:self action:@selector(clearBUttonClip:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightNavButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加footView 新增收获地址按钮
- (void) addTableViewFootView
{
   
}

- (void)addData
{
    dataArray = [NSMutableArray arrayWithArray:[FileOperation getMessageList]];
//    dataArray = @[
//                  @{
//                      @"title1" : @"退款通知",
//                      @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
//                      @"date" : @"2015-04-20",
//                      @"time" : @"18:00",
//                      },
//                  @{
//                      @"title1" : @"退款通知",
//                      @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
//                      @"date" : @"2015-04-20",
//                      @"time" : @"18:00",
//                      },
//                  @{
//                      @"title1" : @"退款通知",
//                      @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
//                      @"date" : @"2015-04-20",
//                      @"time" : @"18:00",
//                      },
//                  @{
//                      @"title1" : @"退款通知",
//                      @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
//                      @"date" : @"2015-04-20",
//                      @"time" : @"18:00",
//                      },
//                  @{
//                      @"title1" : @"退款通知",
//                      @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
//                      @"date" : @"2015-04-20",
//                      @"time" : @"18:00",
//                      },
//                  @{
//                      @"title1" : @"退款通知",
//                      @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
//                      @"date" : @"2015-04-20",
//                      @"time" : @"18:00",
//                      },
//                  @{
//                      @"title1" : @"退款通知",
//                      @"title2" : @"5727265 6e742e53 63686564 756c6564 54687265 6164506f 6f6c4578 65637574 6f722453 63686564 756c6564 46757475 ",
//                      @"date" : @"2015-04-20",
//                      @"time" : @"18:00",
//                      }
//                  ];
    
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
//    return dataArray.count;
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
    MyMessage0Cell *cell = [self loadMyMessage0Cell:self.mainTabview];
    cell.label1.text = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:row]objectForKey:@"alert"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:row]objectForKey:@"badge"]];
//    cell.timeLabel.text = [[dataArray objectAtIndex:row]objectForKey:@"category"];
    return cell;
//    if (row%2 == 0) {
//        MyMessage0Cell *cell = [self loadMyMessage0Cell:self.mainTabview];
//        cell.label1.text = [[dataArray objectAtIndex:row]objectForKey:@"title2"];
//        cell.dateLabel.text = [[dataArray objectAtIndex:row]objectForKey:@"date"];
//        cell.timeLabel.text = [[dataArray objectAtIndex:row]objectForKey:@"time"];
//        return cell;
//    }else{
//        MyMessage1Cell *cell = [self loadMyMessage1Cell:self.mainTabview];
//        cell.lane.text = [[dataArray objectAtIndex:row]objectForKey:@"title1"];
//        cell.label1.text = [[dataArray objectAtIndex:row]objectForKey:@"title2"];
//        cell.dateLabel.text = [[dataArray objectAtIndex:row]objectForKey:@"date"];
//        cell.timeLabel.text = [[dataArray objectAtIndex:row]objectForKey:@"time"];
//        return cell;
//    }
    return nil;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
//    selectIndex = row;
    [tableView reloadData];
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

- (void) clearBUttonClip:(id) sender
{
    //消息列表清空
    [FileOperation clearMessageList];
    [self addData];
    [self.mainTabview reloadData];
}

@end

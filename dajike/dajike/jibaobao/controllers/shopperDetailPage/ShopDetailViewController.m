//
//  ShopDetailViewController.m
//  jibaobao
//
//  Created by dajike_yc on 15/5/8.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

/*
 **   类描述 ：商家详情   列表
 */

#import "ShopDetailViewController.h"
#import "defines.h"
#import "SwbCell1.h"
#import "SwbCell2.h"
#import "SwbCell3.h"
#import "BeautifulFoodCellTableViewCell.h"
#import "MyHeaderView.h"
#import "UIView+MyView.h"

static NSString *cell1 = @"Cell11";
static NSString *cell2 = @"Cell22";
static NSString *cell3 = @"Cell33";
static NSString *cell4 = @"Cell44";

@interface ShopDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ShopDetailViewController
{
    UITableView *_myTableView;
    
    //最近打开的index
    int currentClickIndex;
    int currentClickSection;
    
    //是否打开cell
    BOOL isOpenCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    currentClickIndex   = -1;
    currentClickSection = -1;
    isOpenCell          = NO;
    
    
    [self addTableView:UITableViewStyleGrouped];
    
    [self setNavType:SHAREANGSHOUCANG_BUTTON];
    
    self.delegate = self;
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    UIView *viewBg = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 170) andBackgroundColor:[UIColor clearColor]];
    
    MyHeaderView *mView = [[MyHeaderView alloc]init];
    mView.frame = CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 170);
    mView.backgroundColor = [UIColor whiteColor];
    
    [mView addShopPhotosBtn];
    
    [viewBg addSubview:mView];
    self.mainTabview.tableHeaderView = viewBg;
    
    [mView btnClickedCallBackAction:^(long btnTag) {
        if (btnTag == 2) {
            NSLog(@"地址");
        }
        if (btnTag == 3) {
            NSLog(@"电话");
        }
        if (btnTag == 4) {
            NSLog(@"收藏");
        }
        if (btnTag == 5) {
            NSLog(@"相册");
        }
    }];
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"SwbCell1" bundle:nil] forCellReuseIdentifier:cell1];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"SwbCell2" bundle:nil] forCellReuseIdentifier:cell2];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"SwbCell3" bundle:nil] forCellReuseIdentifier:cell3];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"BeautifulFoodCellTableViewCell" bundle:nil] forCellReuseIdentifier:cell4];
    
    [self setScrollBtnHidden:NO];
    [self setStoreBtnHidden:YES];
}

//右一
- (void)right1Cliped:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 55) {
        [self.mainTabview setContentOffset:CGPointMake(0, 0) animated:YES];
        NSLog(@"列表滚回顶部");
    }
}

#pragma mark ------- tableView   Delegate -----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == currentClickSection) {
        if (indexPath.row == currentClickIndex) {
            if (isOpenCell == YES) {
                currentClickSection = (int)indexPath.section;
                currentClickIndex = (int)indexPath.row;
                return 120;
            }
            return 80;
        }else
            return 80;
    }
    return 80;
//    if (indexPath.section == currentClickSection && indexPath.row == currentClickIndex) {
//        if (isOpenCell == YES) {
//            currentClickSection = (int)indexPath.section;
//            currentClickIndex = (int)indexPath.row;
//            return 120;
//        }
//        return 80;
//    }else{
//        return 80;
//    }
//    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3 || section == 4) {
        return 30;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    if (section == 3) {
        return 40;
    }
    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *mView = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 30) andBackgroundColor:[UIColor whiteColor]];
    UILabel *mLb = [self.view creatLabelWithFrame:CGRectMake(10, 0, WIDTH_CONTROLLER_DEFAULT, 30) AndFont:13.0f AndBackgroundColor:[UIColor whiteColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor lightGrayColor] andCornerRadius:0.0f];
    [mView addSubview:mLb];
    if (section == 2) {
        mLb.text = @"商家概述";
        return mView;
    }else if (section == 3) {
        mLb.text = @"网友点评（241人评价）";
        return mView;
    }else if (section == 4) {
        mLb.text = @"小伙伴还看了";
        return mView;
    }else
        return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *mView = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 30) andBackgroundColor:[UIColor whiteColor]];
    UILabel *mLb = [self.view creatLabelWithFrame:CGRectMake(10, 0, WIDTH_CONTROLLER_DEFAULT, 30) AndFont:13.0f AndBackgroundColor:[UIColor clearColor] AndText:nil AndTextAlignment:NSTextAlignmentLeft AndTextColor:[UIColor redColor] andCornerRadius:0.0f];
    UIView *lineView = [self.view createViewWithFrame:CGRectMake(0, 30, WIDTH_CONTROLLER_DEFAULT, 10) andBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    [mView addSubview:lineView];
    [mView addSubview:mLb];
    if (section == 3) {
        mLb.text = @"查看241条评论";
        return mView;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SwbCell1 *mCell = [tableView dequeueReusableCellWithIdentifier:cell1];
        return mCell;
    }
    if (indexPath.section == 1) {
        SwbCell2 *mCell = [tableView dequeueReusableCellWithIdentifier:cell2];
        return mCell;
    }
    if (indexPath.section == 2 || indexPath.section == 3) {
        SwbCell3 *mCell = [tableView dequeueReusableCellWithIdentifier:cell3];
        return mCell;
    }
    else {
        BeautifulFoodCellTableViewCell *mCell = [tableView dequeueReusableCellWithIdentifier:cell4];
        return mCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == currentClickSection && indexPath.row == currentClickIndex) {
        isOpenCell = !isOpenCell;
    }else{
        isOpenCell = YES;
    }
    NSLog(@"--%d,--%d",currentClickSection,currentClickIndex);
    currentClickSection = (int)indexPath.section;
    currentClickIndex = (int)indexPath.row;
//    [tableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:currentClickIndex inSection:currentClickSection], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
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

//
//  BuySucceedViewController.m
//  jibaobao
//
//  Created by swb on 15/5/18.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 **   购物---》购买成功
 */

#import "BuySucceedViewController.h"
#import "defines.h"
#import "UIView+MyView.h"
//各种cell
#import "BuySucceedCell.h"
#import "MyLastCell.h"
//#import "SwbCell6.h"
#import "ReceiveAddressCell.h"
#import "BeautifulFoodCellTableViewCell.h"
#import "SwbCell7.h"
#import "SwbCell8.h"
#import "AllProductSortCell.h"

static NSString *swbCell1 = @"swbCell111";
static NSString *swbCell2 = @"swbCell222";
//static NSString *swbCell3 = @"swbCell333";
static NSString *swbCell4 = @"swbCell444";
static NSString *swbCell5 = @"swbCell555";
static NSString *swbCell6 = @"swbCell666";
static NSString *swbCell7 = @"swbCell777";
static NSString *swbCell8 = @"AllProductSortCell";

@interface BuySucceedViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BuySucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f];
    if ([self.flagstr intValue] == 1) {
        titleLabel.text = @"购买成功";
    }
    if ([self.flagstr intValue] == 2) {
        titleLabel.text = @"订单详情";
    }
    
    self.delegate = self;
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    [self addTableView:UITableViewStyleGrouped];
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"BuySucceedCell" bundle:nil] forCellReuseIdentifier:swbCell1];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"MyLastCell" bundle:nil] forCellReuseIdentifier:swbCell2];
//    [self.mainTabview registerNib:[UINib nibWithNibName:@"SwbCell6" bundle:nil] forCellReuseIdentifier:swbCell3];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"ReceiveAddressCell" bundle:nil] forCellReuseIdentifier:swbCell4];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"BeautifulFoodCellTableViewCell" bundle:nil] forCellReuseIdentifier:swbCell5];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"SwbCell7" bundle:nil] forCellReuseIdentifier:swbCell6];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"SwbCell8" bundle:nil] forCellReuseIdentifier:swbCell7];
    [self.mainTabview registerNib:[UINib nibWithNibName:@"AllProductSortCell" bundle:nil] forCellReuseIdentifier:swbCell8];
    
}

// --------------------- 分割线 --------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.flagstr intValue] == 1) {
        return 5;
    }
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([self.flagstr intValue] == 1) {
            return 60;
        }
        return 80;
    }
    if (indexPath.row == 2) {
        return 55*self.arr.count;
    }
    if (indexPath.row == 3) {
        return 35;
    }
    if (indexPath.row == 4) {
        return 70;
    }
    if (indexPath.row == 5) {
        return 60;
    }
    if (indexPath.row == 6) {
        return 150;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *iv = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 80) andBackgroundColor:[UIColor clearColor]];
    UIButton *btn = [self.view createButtonWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT/2-75, 25, 150, 36) andBackImageName:nil andTarget:self andAction:@selector(goOnShopping:) andTitle:@"继续购物" andTag:21];
    btn.layer.cornerRadius = 3.0f;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = Color_mainColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [btn setTitleColor:Color_White forState:UIControlStateNormal];
    [iv addSubview:btn];
    return iv;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([self.flagstr intValue] == 1) {
            BuySucceedCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell1];
            return myCell;
        }
        if ([self.flagstr intValue] == 2) {
            BeautifulFoodCellTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell5];
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return myCell;
        }
        
    }
    if (indexPath.row == 1) {
        MyLastCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell2];
        myCell.namelb.text = self.goodsName;
        myCell.moneyLb.text = [NSString stringWithFormat:@"%.2f",[self.money floatValue]];
        CGRect rect = [self.view contentAdaptionLabel:myCell.moneyLb.text withSize:CGSizeMake(500, 21) withTextFont:17.0f];
        myCell.moneyLbCon.constant = rect.size.width;
        return myCell;
    }
    if (indexPath.row == 2) {
        static NSString *cell111 = @"cell111";
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell111];
        if (!myCell) {
            myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell111];
        }
        for (UIView *tmpView in myCell.contentView.subviews) {
            [tmpView removeFromSuperview];
        }
        
        for (int i=0; i<self.arr.count; i++) {
            UILabel *lb = [self.view creatLabelWithFrame:CGRectMake(10, 60*i+5, 100, 20) AndFont:13.0f AndBackgroundColor:Color_Clear AndText:[NSString stringWithFormat:@"类型%d：",i] AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
            if (self.arr.count == 1) {
                lb.text = @"类型：";
            }
            [myCell.contentView addSubview:lb];
            UILabel *valueLb = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(lb.frame)+10, 60*i+5, WIDTH_CONTROLLER_DEFAULT-CGRectGetMaxX(lb.frame)-20, 20) AndFont:13.0f AndBackgroundColor:Color_Clear AndText:[NSString stringWithFormat:@"%@%@",[[self.arr objectAtIndex:i]objectForKey:@"spec_1"],[[self.arr objectAtIndex:i]objectForKey:@"spec_2"]] AndTextAlignment:NSTextAlignmentRight AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
            [myCell.contentView addSubview:valueLb];
            UILabel *lb1 = [self.view creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(lb.frame)+5, 100, 20) AndFont:13.0f AndBackgroundColor:Color_Clear AndText:@"数量：" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
            [myCell.contentView addSubview:lb1];
            UILabel *valueLb1 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(lb1.frame)+10, CGRectGetMaxY(valueLb.frame)+5, WIDTH_CONTROLLER_DEFAULT-CGRectGetMaxX(lb1.frame)-20, 20) AndFont:13.0f AndBackgroundColor:Color_Clear AndText:[NSString stringWithFormat:@"共%@件",[[self.arr objectAtIndex:i]objectForKey:@"goodsNumber"]] AndTextAlignment:NSTextAlignmentRight AndTextColor:[UIColor darkGrayColor] andCornerRadius:0.0f];
            [myCell.contentView addSubview:valueLb1];
            
            if (self.arr.count > 1) {
                if (i != self.arr.count) {
                    UIView *lineView = [self.view createViewWithFrame:CGRectMake(10, 55*i+55, WIDTH_CONTROLLER_DEFAULT-20, 0.5) andBackgroundColor:Color_line_bg];
                    [myCell.contentView addSubview:lineView];
                }
                
            }
            
            
        }
        return myCell;
//        SwbCell6 *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell3];
//        return myCell;
    }
    if (indexPath.row == 3) {
        AllProductSortCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell8];
        myCell.titleLb.text = @"运费：";
        myCell.titleLb.font = [UIFont systemFontOfSize:16.0f];
        [myCell.allBtn setTitle:[NSString stringWithFormat:@"%@ 元",self.yunfei] forState:UIControlStateNormal];
        myCell.allBtn.userInteractionEnabled = NO;
        return myCell;
    }
    if (indexPath.row == 4) {
        ReceiveAddressCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell4];
        myCell.model = self.model;
        return myCell;
    }
    if (indexPath.row == 5) {
        SwbCell8 *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell7];
        myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return myCell;
    }
    if (indexPath.row == 6) {
        SwbCell7 *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell6];
        return myCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)goOnShopping:(id)sender
{
    NSLog(@"继续购物");
    [self.navigationController popToRootViewControllerAnimated:YES];
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

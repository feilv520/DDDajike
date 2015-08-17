//
//  SendOutHongBaoViewController.m
//  jibaobao
//
//  Created by swb on 15/6/1.
//  Copyright (c) 2015年 dajike. All rights reserved.
//




/*
 ****   发出红包详情---- 领完   未领完
 */

#import "SendOutHongBaoViewController.h"
#import "HongBaoDetailCell.h"
#import "HongBaoModel.h"
#import "defines.h"
#import "UserInfoModel.h"

static NSString *swbCell = @"HongBaoDetailCell";

@interface SendOutHongBaoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UserInfoModel *userInfoModel;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSMutableArray *hongBaoArray;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) double sum;
@property (nonatomic, strong) UILabel *lb1;

@end

@implementation SendOutHongBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleLabel.text = @"红包详情";
    
    self.count = 0;
    self.sum = 0.0;
    
    self.delegate = self;
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self addTableView:UITableViewStylePlain];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    
    [self.mainTabview registerNib:[UINib nibWithNibName:@"HongBaoDetailCell" bundle:nil] forCellReuseIdentifier:swbCell];
    
    
    [self setScrollBtnHidden:YES];
    
    [self setTabviewHeaderAndFooterView];
    
    [self getData];
}
// -------------------------------------------------- 万恶的分割线 -----------------------------------------

- (void)setTabviewHeaderAndFooterView
{
    //设置头视图
    NSDictionary *userInfoDic = [[NSMutableDictionary alloc]init];
    userInfoDic = [[FileOperation readFileToDictionary:jibaobaoUser]mutableCopy];
    self.userInfoModel = [[UserInfoModel alloc]init];
    self.userInfoModel = [JsonStringTransfer dictionary:userInfoDic ToModel:self.userInfoModel];
    UIView *headerViewBG = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 80) andBackgroundColor:Color_Clear];
    UIImageView *headImg = [[UIImageView alloc]init];
    headImg.frame = CGRectMake(60, 8, 64, 64);
    headImg.layer.cornerRadius = 6.0f;
    headImg.layer.masksToBounds = YES;
    [headImg setImageWithURL:[NSURL URLWithString:self.userInfoModel.portrait] placeholderImage:[UIImage imageNamed:@"img_touxiang"]];
    [headerViewBG addSubview:headImg];
    _lb1 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame)+5, 8, 150, 30) AndFont:15.0f AndBackgroundColor:Color_Clear AndText:[NSString stringWithFormat:@"%@的红包",self.userInfoModel.nickName] AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [headerViewBG addSubview:_lb1];
    NSLog(@"%@",self.userInfoModel.userName);
    UILabel *lb2 = [self.view creatLabelWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame)+5, CGRectGetMaxY(_lb1.frame)+4, 150, 30) AndFont:15.0f AndBackgroundColor:Color_Clear AndText:@"恭喜发财，心想事成" AndTextAlignment:NSTextAlignmentLeft AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [headerViewBG addSubview:lb2];
    
    UIView *lineV = [self.view createViewWithFrame:CGRectMake(0, headerViewBG.frame.size.height-1, WIDTH_CONTROLLER_DEFAULT, 1) andBackgroundColor:Color_line_bg];
    [headerViewBG addSubview:lineV];
    
    self.mainTabview.tableHeaderView = headerViewBG;
    //设置尾视图
    UIView *footerVierBG = [self.view createViewWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 100) andBackgroundColor:Color_Clear];
    UILabel *lb3 = [self.view creatLabelWithFrame:CGRectMake(10, 50, WIDTH_CONTROLLER_DEFAULT-20, 30) AndFont:13.0f AndBackgroundColor:Color_Clear AndText:@"红包编号：38726872334238768" AndTextAlignment:NSTextAlignmentCenter AndTextColor:Color_word_bg andCornerRadius:0.0f];
    [footerVierBG addSubview:lb3];
    
    self.mainTabview.tableFooterView = footerVierBG;
}

- (void)getData
{
    NSDictionary *parameter = @{@"hongbaoId":self.hongbao_id};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyHongBaos.detail" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            self.hongBaoArray = [NSMutableArray array];
            NSArray *array = [responseObject.result objectForKey:@"details"];
            for (NSDictionary *dic in array) {
                if ([[dic objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                    HongBaoModel *hongBM = [[HongBaoModel alloc] init];
                    [hongBM setValuesForKeysWithDictionary:dic];
                    [self.hongBaoArray addObject:hongBM];
                }
                if ([[dic objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:0]] || [[dic objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:2]]) {
                    ++self.count;
                    self.sum += [[dic objectForKey:@"jine"] doubleValue];
                }
            }
            self.lb1.text = [NSString stringWithFormat:@"%@的%@",self.userInfoModel.nickName,[responseObject.result objectForKey:@"type_text"]];
            
            NSLog(@"----------------%ld,%lf",self.count,self.sum);
            
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hongBaoArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell11 = @"cell1111";
    if (indexPath.row == 0) {
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cell11];
        if (!myCell) {
            myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell11];
        }
        UILabel *lb = (UILabel *)[myCell.contentView viewWithTag:11];
        if (!lb) {
            lb = [[UILabel alloc]init];
            [myCell.contentView addSubview:lb];
        }
        lb.frame = CGRectMake(10, 5, WIDTH_CONTROLLER_DEFAULT-20, 50);
        lb.numberOfLines = 0;
        lb.tag = 11;
        lb.font = [UIFont systemFontOfSize:15.0f];
        lb.textAlignment = NSTextAlignmentCenter;
        if (self.count == 0) {
            lb.text = [NSString stringWithFormat:@"%ld人已领取",self.hongBaoArray.count];
        } else {
            lb.text = [NSString stringWithFormat:@"%ld个红包未领取退回金额(%.2lf元)\n24小时之内金额自动退回账户",self.count,self.sum];
        }
        lb.textColor = Color_word_bg;
        
        myCell.userInteractionEnabled = NO;
        
        return myCell;
    }else {
        HongBaoDetailCell *myCell = [tableView dequeueReusableCellWithIdentifier:swbCell];
        
//        [myCell.headImgView setImageWithURL:[NSURL URLWithString:[[self.hongBaoArray objectAtIndex:indexPath.row] portrait]] placeholderImage:[UIImage imageNamed:@"img_hb_02.png"]];
        [myCell.headImgView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"img_hb_02.png"]];
        myCell.nameLb.text = [[self.hongBaoArray objectAtIndex:indexPath.row - 1] receive_nick_name];
        myCell.jineLb.text = [NSString stringWithFormat:@"%.2lf元",[[[self.hongBaoArray objectAtIndex:indexPath.row - 1] jin_e] floatValue]];
        myCell.timeLb.text = [self timeStringFromTimeInterval:[[[self.hongBaoArray objectAtIndex:indexPath.row - 1] create_time] doubleValue] / 1000];
        myCell.userInteractionEnabled = NO;
        
        return myCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

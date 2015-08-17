//
//  DGetHongBaoDetailViewController.m
//  dajike
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DGetHongBaoDetailViewController.h"
#import "FileOperation.h"
#import "UserInfoModel.h"
#import "JsonStringTransfer.h"
#import "DMyAfHTTPClient.h"
#import "ProgressHUD.h"

@interface DGetHongBaoDetailViewController ()

@property (nonatomic, strong) UserInfoModel *userInfoModel;

@end

@implementation DGetHongBaoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary *userInfoDic = [[NSMutableDictionary alloc]init];
    userInfoDic = [[FileOperation readFileToDictionary:@"userInfo"]mutableCopy];
    self.userInfoModel = [[UserInfoModel alloc]init];
    self.userInfoModel = [JsonStringTransfer dictionary:userInfoDic ToModel:self.userInfoModel];
    
    [self setNaviBarTitle:@"红包详情"];
    
    self.headImgView.layer.cornerRadius = 6.0f;
    self.headImgView.layer.masksToBounds = YES;
    
    self.sendBtn.layer.cornerRadius = 6.0f;
    self.sendBtn.layer.masksToBounds = YES;
    
    self.jineLb.text = [NSString stringWithFormat:@"¥%@",self.jinEString];
    
//    [self.headImgView setImageWithURL:[NSURL URLWithString:self.portrait] placeholderImage:[UIImage imageNamed:@"img_touxiang"]];
    
    self.lb1.text = [NSString stringWithFormat:@"%@的拼人气红包",self.send_nick_name];
    
    self.dataLabel.text = [NSString stringWithFormat:@"%@\n红包编号：20150520151211123898349",[self timeStringFromTimeInterval: (self.dataDouble / 1000)]];
    
    [self getData];
}

- (void)getData
{
    NSDictionary *parameter = @{@"hongbaoId":[NSString stringWithFormat:@"%@",self.hongbao_id]};
    
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyHongBaos.detail" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            self.lb1.text = [NSString stringWithFormat:@"%@的%@",self.send_nick_name,[responseObject.result objectForKey:@"type_text"]];
            NSLog(@"%@",self.lb1.text);
            [self.dMainTableView reloadData];
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

// 时间戳转换时间
- (NSString *)timeStringFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *timeString = [formatter stringFromDate:date];
    
    return timeString;
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

- (IBAction)sendHongBaoBtnAction:(id)sender {
    NSInteger count = [self.navigationController.viewControllers count];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count - 3] animated:YES];
}

@end

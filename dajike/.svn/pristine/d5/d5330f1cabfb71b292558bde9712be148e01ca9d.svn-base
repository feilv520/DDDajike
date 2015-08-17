//
//  MySexViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "MySexViewController.h"
#import "defines.h"

@interface MySexViewController ()
{
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    NSInteger selectINdex;
}
@end

@implementation MySexViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"性别";
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    [self addViews];
}
- (void) addViews
{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH_CONTROLLER_DEFAULT, 30)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 14, 14)];
    [view1 addSubview:imageView1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 200, 30)];
    label1.text = @"男";
    [label1 setTintColor:Color_gray1];
    [label1 setFont:Font_Default];
    [view1 addSubview:label1];
    
    button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 30)];
    button1.backgroundColor = [UIColor clearColor];
    button1.tag = 1;
    [button1 addTarget:self action:@selector(toButtons:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:button1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 41, WIDTH_CONTROLLER_DEFAULT, 30)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    
    imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 14, 14)];
    [view2 addSubview:imageView2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 200, 30)];
    label2.text = @"女";
    [label2 setTintColor:Color_gray1];
    [label2 setFont:Font_Default];
    [view2 addSubview:label2];
    
    button2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 30)];
    button2.backgroundColor = [UIColor clearColor];
    button2.tag = 2;
    [button2 addTarget:self action:@selector(toButtons:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:button2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 72, WIDTH_CONTROLLER_DEFAULT, 30)];
    view3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view3];
    
    imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 14, 14)];
    [view3 addSubview:imageView3];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 200, 30)];
    label3.text = @"保密";
    [label3 setTintColor:Color_gray1];
    [label3 setFont:Font_Default];
    [view3 addSubview:label3];
    
    button3 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH_CONTROLLER_DEFAULT, 30)];
    button3.backgroundColor = [UIColor clearColor];
    button3.tag = 0;
    [button3 addTarget:self action:@selector(toButtons:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:button3];
    selectINdex = [self.userInfoModel.gender intValue];
    [self genderSwitch];
    
    UIButton *saveBut = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBut.frame = CGRectMake(0, 0, 45, 45);
    [saveBut setTitle:@"保存" forState:UIControlStateNormal];
    [saveBut setTitleColor:Color_mainColor forState:UIControlStateNormal];
    [saveBut addTarget:self action:@selector(updateGender) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:saveBut];
    
    self.navigationItem.rightBarButtonItem = rightBut;
}

- (void)genderSwitch{
    switch (selectINdex) {
        case 0:
            [imageView1 setImage:[UIImage imageNamed:@"img_no_selected"]];
            [imageView2 setImage:[UIImage imageNamed:@"img_no_selected"]];
            [imageView3 setImage:[UIImage imageNamed:@"img_selected"]];
            break;
        case 1:
            [imageView1 setImage:[UIImage imageNamed:@"img_selected"]];
            [imageView2 setImage:[UIImage imageNamed:@"img_no_selected"]];
            [imageView3 setImage:[UIImage imageNamed:@"img_no_selected"]];
            break;
        case 2:
            [imageView1 setImage:[UIImage imageNamed:@"img_no_selected"]];
            [imageView2 setImage:[UIImage imageNamed:@"img_selected"]];
            [imageView3 setImage:[UIImage imageNamed:@"img_no_selected"]];
            break;
            
        default:
            break;
    }

}
// 修改性别 完成
- (void)updateGender{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:self.userInfoModel.userId,@"userId",[NSString stringWithFormat:@"%ld",selectINdex],@"gender", nil];
    [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyUserInfos.updateGender" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        NSLog(@"operation = %@",operation);
        NSLog(@"--%@--",responseObject.result);
        [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        if (responseObject.succeed) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //获取用户会员信息
                [self getUerInfo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
            
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
    
}

- (void)getUerInfo
{
    NSDictionary *parameter = @{@"userId":self.userInfoModel.userId};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyUserInfos.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSString *jsonStr = [AnalysisData decodeToString:responseObject.result];
            NSMutableDictionary *userInfoDic = [[JsonStringTransfer jsonStringToDictionary:jsonStr]mutableCopy];
            NSString *filePath = [FileOperation creatPlistIfNotExist:jibaobaoUser];
            [FileOperation writeToPlistFile:filePath withDic:userInfoDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) toButtons:(id) sender
{
    UIButton *btn = (UIButton *)sender;
    selectINdex = btn.tag;
    [self genderSwitch];
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

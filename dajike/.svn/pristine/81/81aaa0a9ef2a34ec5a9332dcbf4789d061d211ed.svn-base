//
//  MyNameViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "MyNameViewController.h"
#import "defines.h"

@interface MyNameViewController ()
{
    UITextField *nameTextField;
}
@end

@implementation MyNameViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"姓名";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additionazl setup after loading the view.
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    [self addViews];
}

- (void) addViews
{
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, WIDTH_CONTROLLER_DEFAULT-30, 30)];
    nameTextField.layer.borderWidth = 0.5;
    nameTextField.layer.borderColor = [Color_gray4 CGColor];
    nameTextField.backgroundColor = [UIColor whiteColor];
    [nameTextField setTintColor:[UIColor whiteColor]];
    [nameTextField setEnabled:YES];
    nameTextField.placeholder = self.userInfoModel.nickName;
    [self.view addSubview:nameTextField];
    
    UIButton *saveBut = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBut.frame = CGRectMake(0, 0, 45, 45);
    [saveBut setTitle:@"保存" forState:UIControlStateNormal];
    [saveBut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [saveBut addTarget:self action:@selector(updateNickName) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:saveBut];
    
    self.navigationItem.rightBarButtonItem = rightBut;
}

// 修改昵称 完成
- (void)updateNickName{
    if ([nameTextField.text isEqualToString:@""]) {
        [MBProgressHUD show:@"修改名称不能为空！" icon:nil view:self.view afterDelay:0.7];
        
    }else{
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:self.userInfoModel.userId,@"userId",nameTextField.text,@"nickName", nil];
        [[MyAfHTTPClient sharedClient] postPathWithMethod:@"MyUserInfos.updateNickName" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
            
            NSLog(@"operation = %@",operation);
            NSLog(@"--%@--",responseObject.result);
            if (responseObject.succeed) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    //获取用户会员信息
                    [self getUerInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                });
//                [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            }else{
                
                [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            NSLog(@"operation6 = %@",operation);
        }];

    }
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
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [nameTextField endEditing:YES];
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

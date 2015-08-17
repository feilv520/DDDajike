//
//  DMyNameAndSexViewController.m
//  dajike
//
//  Created by songjw on 15/7/13.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DMyNameAndSexViewController.h"
#import "DBaseNavView.h"
#import "dDefine.h"
#import "DMyAfHTTPClient.h"
#import "MBProgressHUD+Add.h"
#import "FileOperation.h"
#import "AnalysisData.h"
#import "DTools.h"
@interface DMyNameAndSexViewController (){
    DImgButton * _rightBut;
    UITextField *_nameTextField;
    UIButton *_selectBut_1;
    UIButton *_selectBut_2;
    UIButton *_selectBut_3;
    NSString *_gender;
}

@end

@implementation DMyNameAndSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:DColor_f3f3f3];
    [self initView];
}
- (void)initView{
    
    _rightBut = [DBaseNavView createNavBtnWithTitle:@"保存" target:self action:@selector(rightButAction)];
    [self setNaviBarRightBtn:_rightBut];
    self.view.backgroundColor = DColor_f3f3f3;
    if (self.name_sex == NAME) {
        [self setNaviBarTitle:@"昵称"];
        _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 84, DWIDTH_CONTROLLER_DEFAULT-30, 30)];
        [DTools setTextfield:_nameTextField Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
        _nameTextField.layer.cornerRadius = 3.0;
        _nameTextField.layer.masksToBounds = YES;
        _nameTextField.layer.borderWidth = 1.0f;
        _nameTextField.layer.borderColor = DColor_line_bg.CGColor;
        
        [_nameTextField setTintColor:[UIColor whiteColor]];
        [_nameTextField setEnabled:YES];
        _nameTextField.userInteractionEnabled = YES;
        _nameTextField.placeholder = self.userModel.nickName;
        
        [self.view addSubview:_nameTextField];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 124, DWIDTH_CONTROLLER_DEFAULT-30, 60)];
        [DTools setLable:lab Font:DFont_12 titleColor:DColor_808080 backColor:[UIColor clearColor]];
        lab.numberOfLines = 0;
        lab.text = @"4-20个字符,可由中英文、数字、“_”、“－”组成";
        lab.textColor = [UIColor grayColor];
        [self.view addSubview:lab];
    }else if (self.name_sex == SEX){
        [self setNaviBarTitle:@"性别"];
        float startY  = 70;
        float labHight = 35;
        
        
        UIImageView *line_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, startY, DWIDTH_CONTROLLER_DEFAULT, 1)];
        line_1.backgroundColor = DColor_dadada;
        
        UIImageView *backImg_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, line_1.frame.origin.y +line_1.frame.size.height +1, DWIDTH_CONTROLLER_DEFAULT, labHight + 2)];
        backImg_1.backgroundColor = DColor_ffffff;
        UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(15, line_1.frame.origin.y +line_1.frame.size.height +2, labHight, labHight)];
        label_1.text = @"男";
        _selectBut_1 = [[UIButton alloc]initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT - 50, line_1.frame.origin.y +line_1.frame.size.height + 4,labHight -5, labHight-5)];
        [_selectBut_1 addTarget:self action:@selector(selectButAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *line_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, backImg_1.frame.origin.y + backImg_1.frame.size.height +1, DWIDTH_CONTROLLER_DEFAULT, 1)];
        line_2.backgroundColor = DColor_dadada;
        
        UIImageView *backImg_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, backImg_1.frame.origin.y + backImg_1.frame.size.height +2, DWIDTH_CONTROLLER_DEFAULT, labHight +2)];
        backImg_2.backgroundColor = DColor_ffffff;
        UILabel *label_2 = [[UILabel alloc]initWithFrame:CGRectMake(15, backImg_1.frame.origin.y + backImg_1.frame.size.height +2, labHight, labHight)];
        label_2.text = @"女";
        _selectBut_2 = [[UIButton alloc]initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT - 50, backImg_1.frame.origin.y + backImg_1.frame.size.height +4, labHight -5, labHight -5)];;
        [_selectBut_2 addTarget:self action:@selector(selectButAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *line_3 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  backImg_2.frame.origin.y + backImg_2.frame.size.height +1, DWIDTH_CONTROLLER_DEFAULT, 1)];
        line_3.backgroundColor = DColor_dadada;
        
        UIImageView *backImg_3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, backImg_2.frame.origin.y + backImg_2.frame.size.height +2, DWIDTH_CONTROLLER_DEFAULT, labHight +2)];
        backImg_3.backgroundColor = DColor_ffffff;
        UILabel *label_3 = [[UILabel alloc]initWithFrame:CGRectMake(15, backImg_2.frame.origin.y + backImg_2.frame.size.height +2, labHight, labHight)];
        label_3.text = @"保密";
        _selectBut_3 = [[UIButton alloc]initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT - 50, backImg_2.frame.origin.y + backImg_2.frame.size.height +4, labHight -5, labHight -5)];;
        [_selectBut_3 addTarget:self action:@selector(selectButAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *line_4 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  backImg_3.frame.origin.y + backImg_3.frame.size.height +1, DWIDTH_CONTROLLER_DEFAULT, 1)];
        line_4.backgroundColor = DColor_dadada;
        
        [DTools setLable:label_1 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:label_2 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];
        [DTools setLable:label_3 Font:DFont_15 titleColor:DColor_808080 backColor:DColor_ffffff];

        [self.view addSubview:line_1];
        [self.view addSubview:line_2];
        [self.view addSubview:line_3];
        [self.view addSubview:line_4];
        [self.view addSubview:backImg_1];
        [self.view addSubview:backImg_2];
        [self.view addSubview:backImg_3];
        [self.view addSubview:label_1];
        [self.view addSubview:label_2];
        [self.view addSubview:label_3];
        [self.view addSubview:_selectBut_1];
        [self.view addSubview:_selectBut_2];
        [self.view addSubview:_selectBut_3];
        int a = [self.userModel.gender intValue];
        if (a == 1) {
            [_selectBut_1 setImage:[UIImage imageNamed:@"mine_selected"] forState:UIControlStateNormal];
            [_selectBut_2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_selectBut_3 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }else if (a == 2){
            [_selectBut_1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_selectBut_2 setImage:[UIImage imageNamed:@"mine_selected"] forState:UIControlStateNormal];
            [_selectBut_3 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }else{
            [_selectBut_1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_selectBut_2 setImage:[UIImage imageNamed:@"mine_selected"] forState:UIControlStateNormal];
            [_selectBut_3 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        
        
        
    }
    
}
- (void)rightButAction{
    if (self.name_sex == NAME) {
        [self updateNickName];
    }
    if (self.name_sex == SEX) {
        [self updateGender];
    }
    
}
- (void)selectButAction:(UIButton *)but{
    if (but == _selectBut_1) {
        [_selectBut_1 setImage:[UIImage imageNamed:@"mine_selected"] forState:UIControlStateNormal];
        [_selectBut_2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_selectBut_3 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _gender = @"1";
    }else if (but == _selectBut_2){
        [_selectBut_2 setImage:[UIImage imageNamed:@"mine_selected"] forState:UIControlStateNormal];
        [_selectBut_1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_selectBut_3 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        _gender = @"2";
    }else if (but == _selectBut_3){
        [_selectBut_3 setImage:[UIImage imageNamed:@"mine_selected"] forState:UIControlStateNormal];
        [_selectBut_1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_selectBut_2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        _gender = @"0";
    }
    
}

- (void)updateNickName{
    if ([_nameTextField.text isEqualToString:@""]) {
        [MBProgressHUD show:@"修改名称不能为空！" icon:nil view:self.view afterDelay:0.7];
    }else{
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:self.userModel.userId,@"userId",_nameTextField.text,@"nickName", nil];
        [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyUserInfos.updateNickName" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
            if (responseObject.succeed) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    //获取用户会员信息
                    [self getUerInfo];

                });
            }else{
                
                [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
        }];
        
    }
    
}
- (void)updateGender{
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:self.userModel.userId,@"userId",_gender,@"gender", nil];
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyUserInfos.updateGender" parameters:paramsDic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation = %@",operation);
        NSLog(@"result:%@",responseObject.result);
        if (responseObject.succeed) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                //获取用户会员信息
                [self getUerInfo];
                
            });
        }else{
            
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}
- (void)getUerInfo{
    NSLog(@"%@",[FileOperation getUserId]);
    NSDictionary *parameter = @{@"userId":[NSString stringWithString:[FileOperation getUserId]]};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyUserInfos.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation = %@",operation);
        NSLog(@"result:%@",responseObject.result);
        if (responseObject.succeed) {
            
            NSString *jsonStr = [AnalysisData decodeToString:responseObject.result];
            NSMutableDictionary *userInfoDic = [[JsonStringTransfer jsonStringToDictionary:jsonStr]mutableCopy];
            NSString *filePath = [FileOperation creatPlistIfNotExist:dajikeUser];
            [FileOperation writeToPlistFile:filePath withDic:userInfoDic];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

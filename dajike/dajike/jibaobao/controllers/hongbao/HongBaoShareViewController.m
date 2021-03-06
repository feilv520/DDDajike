//
//  HongBaoShareViewController.m
//  jibaobao
//
//  Created by swb on 15/6/1.
//  Copyright (c) 2015年 dajike. All rights reserved.
//






/*
 ***  红包分享
 */

#import "HongBaoShareViewController.h"
#import "defines.h"
//测试
#import "HongBaoMessageViewController.h"
#import "GeneralHongBaoViewController.h"

#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsData.h"

//static NSString *hongbaoUrl = @"http://192.168.1.134:9003/HongBaos/share/hongbaoId";
static NSString *hongbaoUrl = @"http://weixin1.dajike.com/HongBaos/lingQu?hongbaoId=hongbaobao&t_id=userId";
@interface HongBaoShareViewController () <UIAlertViewDelegate>

@end

@implementation HongBaoShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleLabel.text = @"给小伙伴发红包";
    
    self.delegate = self;
    [self setNavType:WORD_TYPE action:@"取消"];
//    [self setBackBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    
    self.wxView.layer.cornerRadius      = 22.0f;
    self.wxView.layer.masksToBounds     = YES;
    self.wxBtn.layer.cornerRadius       = 22.0f;
    self.wxBtn.layer.masksToBounds      = YES;
    
    self.pyView.layer.cornerRadius      = 22.0f;
    self.pyView.layer.masksToBounds     = YES;
    self.pyBtn.layer.cornerRadius       = 22.0f;
    self.pyBtn.layer.masksToBounds      = YES;
    
    self.cancelBtn.layer.cornerRadius   = 3.0f;
    self.cancelBtn.layer.masksToBounds  = YES;
    self.cancelBtn.layer.borderColor    = [Color_White CGColor];
    self.cancelBtn.layer.borderWidth    = 1.0f;
    
    self.okBtn.layer.cornerRadius       = 3.0f;
    self.okBtn.layer.masksToBounds      = YES;
    self.okBtn.layer.borderWidth        = 1.0f;
    self.okBtn.layer.borderColor        = [Color_White CGColor];
    
    self.littleViewBg.layer.cornerRadius = 3.0f;
    self.littleViewBg.layer.masksToBounds = YES;
    
    self.viewBg.hidden                  = YES;
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)wordBtnCliped:(id)sender
{
    [UIView animateWithDuration:1.0 animations:^{
        
        self.viewBg.hidden = !self.viewBg.hidden;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)cancelBtnAction:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.viewBg.hidden = !self.viewBg.hidden;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (IBAction)okBtnAction:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    NSDictionary *parameter = @{@"userId":[FileOperation getUserId],@"hongbaoId":[NSString stringWithFormat:@"%@", self.hongBaoId]};
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyHongBaos.cancel" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            [self.navigationController popToRootViewControllerAnimated:YES];
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

- (IBAction)wxBtnAction:(id)sender {
    NSLog(@"微信分享");
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [[hongbaoUrl stringByReplacingOccurrencesOfString:@"hongbaobao" withString:[NSString stringWithFormat:@"%@",self.hongBaoId]]stringByReplacingOccurrencesOfString:@"userId" withString:[FileOperation getUserId]];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"给你发一个红包，赶快打开看一看！";
    //分享的资源
    //            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareUrl];
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:self.hongbaoZhufu image:[UIImage imageNamed:@"fahongbao.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"红包分享成功｀" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            alertView.delegate = self;
            [alertView show];
        } else if(response.responseCode != UMSResponseCodeCancel) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"红包分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }];

//    [ProgressHUD showMessage:@"微信分享" Width:100 High:80];
}

- (IBAction)pyBtnAction:(id)sender {
    NSLog(@"朋友圈");
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [[hongbaoUrl stringByReplacingOccurrencesOfString:@"hongbaobao" withString:[NSString stringWithFormat:@"%@",self.hongBaoId]]stringByReplacingOccurrencesOfString:@"userId" withString:[FileOperation getUserId]];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"给你发一个红包，赶快打开看一看！";;
    //分享的资源
    //            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareUrl];
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:self.hongbaoZhufu image:[UIImage imageNamed:@"fahongbao.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity * response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"红包分享成功｀" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            alertView.delegate = self;
            [alertView show];
        } else if(response.responseCode != UMSResponseCodeCancel) {
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"红包分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }];
//    [self.navigationController popViewControllerAnimated:YES];

//    [ProgressHUD showMessage:@"微信分享" Width:100 High:80];
}

- (IBAction)tapClicked:(id)sender {
    NSLog(@"手势");
    [UIView animateWithDuration:1.0 animations:^{
        self.viewBg.hidden = !self.viewBg.hidden;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

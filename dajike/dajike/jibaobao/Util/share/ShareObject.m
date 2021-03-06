//
//  ShareObject.m
//  jibaobao
//
//  Created by dajike on 15/5/20.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "ShareObject.h"
#import "defines.h"
#import "UIView+MyView.h"

#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsData.h"

//static NSString *shareUrl = @"https://itunes.apple.com/cn/app/ji-bao-bao/id996401785?l=en&mt=8";
static NSString *shareUrl = @"https://itunes.apple.com/us/app/ji-bao-bao/id996401785?l=zh&ls=1&mt=8";


@interface ShareObject()
{
    UIView *backView;
    UIView *actionView;
    UIImage *_image;
    NSString *_title;
    NSString *_urlStr;
}
@end

@implementation ShareObject
//单例
static ShareObject  *shareobjc = nil;
+ (ShareObject *) shared
{
    if (shareobjc == nil)
    {
        shareobjc = [[self alloc]init];
    }
    return shareobjc;
}
- (id)init
{
    if (self = [super init]) {
        _image = [[UIImage alloc]init];
        _title = [[NSString alloc]init];
        _urlStr = [[NSString alloc]init];
    }
    return self;
}
- (void) setShareImage:(UIImage *)image andShareTitle:(NSString *)title andShareUrl:(NSString *)urlStr
{
    _image = image;
    _title = title;
    _urlStr = urlStr;
}

- (void) shareUM:(NSString *)content presentSnsIconSheetView:(UIViewController *)controller delegate:(id <UMSocialUIDelegate>)delegate
{
    //presentedController
    self.presentedController = controller;
    
    
    //自定义友盟分享面板
    backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:0.5];
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    UIView *rootView = topController.view;
    backView.frame = rootView.bounds;
    [rootView addSubview:backView];
    [rootView bringSubviewToFront:backView];
    
    actionView = [[UIView alloc]initWithFrame:CGRectMake(0, rootView.bounds.size.height, rootView.bounds.size.width, 210)];
    actionView.backgroundColor = Color_White;
    
   
     //分享面板名字 arr
    NSArray *titleArr = [NSArray arrayWithObjects:@"朋友圈",@"微信好友",@"QQ好友",@"新浪微博",@"QQ空间",@"复制链接", nil];
    //分享面板icon arr
    NSArray *iconArr = [NSArray arrayWithObjects:@"img_fx_01",@"img_fx_02",@"img_fx_03",@"img_fx_05",@"img_fx_04",@"img_fx_08", nil];
    
    for (int i = 0; i < 6; i++) {
        //        UIImageView *imageV = [[UIImageView alloc]createImageViewWithFrame:CGRectMake(20+(i%3)*100, (i/3)*100, 60, 60) andImageName:[UIImage imageNamed:@"1"]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(18+(i%3)*115, 12+(i/3)*75, 53, 45)];
        [imageView setImage:[UIImage imageNamed:[iconArr objectAtIndex:i]]];
        
        [actionView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]creatLabelWithFrame:CGRectMake(10+(i%3)*115, 57+(i/3)*75, 69, 30) AndFont:14 AndBackgroundColor:Color_Clear AndText:[NSString stringWithString:[titleArr objectAtIndex:i]] AndTextAlignment:NSTextAlignmentCenter AndTextColor:Color_Black andCornerRadius:0];
        [actionView addSubview:label];
        
        UIButton *btn = [[UIButton alloc]createButtonWithFrame:CGRectMake(18+(i%3)*115, 12+(i/3)*75, 53, 83) andBackImageName:nil andTarget:self andAction:@selector(toShareBtn:) andTitle:nil andTag:i+100];
        [actionView addSubview:btn];
    }
    
    [backView addSubview:actionView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 160, topController.view.bounds.size.width, 1)];
    line.backgroundColor = Color_mainColor;
    [actionView addSubview:line];
    
    UIButton *cancleBtn = [[UIButton alloc]createButtonWithFrame:CGRectMake(0, 161, topController.view.bounds.size.width, 47) andBackImageName:nil andTarget:self andAction:@selector(toCancleBtn:) andTitle:nil andTag:300];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:Color_mainColor forState:UIControlStateNormal];
    [actionView addSubview:cancleBtn];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = actionView.frame;
        frame.origin.y = actionView.frame.origin.y-210;
        [actionView setFrame:frame];
    }];
    
    //    [UIView animateWithDuration:0.2 animations:^{
    //        backView.alpha = 1.0f;
    //        backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);}
    //                     completion:^(BOOL finished) {
    //
    //                         [UIView animateWithDuration:0.12 animations:^{
    //                             backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);} completion:^(BOOL finished) {
    //
    //                                 [UIView animateWithDuration:0.12 animations:^{
    //                                     backView.transform = CGAffineTransformIdentity;
    //                                 } completion:^(BOOL finished) {
    //                                     NSLog(@"hello");
    //
    //                                 }];
    //                             }];
    //                     }];
    
    
    
    
    //    UMSocialSnsPlatform *sinaPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:@"UMCOPYLink"];
    //    sinaPlatform.bigImageName = @"1";
    //    sinaPlatform.displayName = @"微博";
    //    sinaPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
    //        NSLog(@"点击新浪微博的响应");
    //    };
    //
    
    
    
    /*
     NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";             //分享内嵌文字
     UIImage *shareImage = [UIImage imageNamed:@"1"];          //分享内嵌图片
     
     //调用快速分享接口
     NSArray *arr = [NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToEmail,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,@"UMCOPYLink", nil];
     //     NSArray *arr = [NSArray arrayWithObjects:@"UMCOPYLink",@"UMCOPYLink1",@"UMCOPYLink2",@"UMCOPYLink3", nil];
     
     //调用快速分享接口
     [UMSocialSnsService presentSnsIconSheetView:controller
     appKey:UmengAppkey
     shareText:shareText
     shareImage:shareImage
     shareToSnsNames:arr
     delegate:delegate];
     */
    
}
- (void)toShareBtn:(id)sender
{
    [self toCancleBtn:nil];
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100://微信朋友圈
        {
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = _urlStr;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = _title;
            //分享的资源
//            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareUrl];
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:_title image:_image location:nil urlResource:nil presentedController:self.presentedController completion:^(UMSocialResponseEntity * response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                } else if(response.responseCode != UMSResponseCodeCancel) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                }
            }];

        }
            break;
        case 101://微信好友
        {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = _urlStr;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = _title;
            //分享的资源
//            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareUrl];
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:_title image:_image location:nil urlResource:nil presentedController:self.presentedController completion:^(UMSocialResponseEntity * response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                } else if(response.responseCode != UMSResponseCodeCancel) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                }
            }];

        }
            break;
        case 102://qq好友
        {
             [UMSocialData defaultData].extConfig.qqData.url = _urlStr;
            [UMSocialData defaultData].extConfig.qqData.title = _title;
            //分享的资源
//            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareUrl];
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:_title image:_image location:nil urlResource:nil presentedController:self.presentedController completion:^(UMSocialResponseEntity * response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                } else if(response.responseCode != UMSResponseCodeCancel) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                }
            }];

        }
            break;
        case 103://新浪微博
        {
            //分享的资源
//            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_urlStr];
            NSString *title = [NSString stringWithFormat:@"%@ %@",_title,_urlStr];
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:title image:_image location:nil urlResource:nil presentedController:self.presentedController completion:^(UMSocialResponseEntity * response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                } else if(response.responseCode != UMSResponseCodeCancel) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                }
            }];

        }
            break;
        case 104://qq空间
        {
            [UMSocialData defaultData].extConfig.qzoneData.url = _urlStr;
            [UMSocialData defaultData].extConfig.qzoneData.title = _title;
            //分享的资源
//            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareUrl];
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:_title image:_image location:nil urlResource:nil presentedController:self.presentedController completion:^(UMSocialResponseEntity * response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                } else if(response.responseCode != UMSResponseCodeCancel) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                }
            }];

        }
            break;
        case 105://复制链接
        {
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.URL = [NSURL URLWithString:_urlStr];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经将链接复制到剪切版" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
            break;
            
        default:
            break;
    }
}
- (void)toCancleBtn:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = actionView.frame;
        frame.origin.y = actionView.frame.origin.y+210;
        [actionView setFrame:frame];
    } completion:^(BOOL finished) {
        CGRect frame = actionView.frame;
        frame.origin.y = actionView.frame.origin.y-210;
        [actionView setFrame:frame];
        [backView removeFromSuperview];
    }];
        
    
    
}
@end

//
//  ShareObject.h
//  jibaobao
//
//  Created by dajike on 15/5/20.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialSnsPlatformManager.h"

@interface ShareObject : NSObject
@property (retain, nonatomic) UIViewController *presentedController;
+ (instancetype)shared;
//先
- (void) setShareImage:(UIImage *)image andShareTitle:(NSString *)title andShareUrl:(NSString *)urlStr;
//后
- (void) shareUM:(NSString *)content presentSnsIconSheetView:(UIViewController *)controller delegate:(id <UMSocialUIDelegate>)delegate;
@end

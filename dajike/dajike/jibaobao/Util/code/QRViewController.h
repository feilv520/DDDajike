//
//  QRViewController.h
//  Test
//
//  Created by 李江明 on 15/5/30.
//  Copyright (c) 2015年 lijiangming. All rights reserved.
//

/*
 
 二维码编译顺序
 Zbar编译
 需要添加AVFoundation  CoreMedia  CoreVideo QuartzCore libiconv
 
 
 
 生成二维码
 拖拽libqrencode包进入工程，注意点copy
 添加头文件#import "QRCodeGenerator.h"
 imageView.image=[QRCodeGenerator qrImageForString:@"这个是什么" imageSize:imageView.bounds.size.width];
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7

@interface QRViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UIImageView*_line;
}


@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, assign) BOOL isScanning;

@property (nonatomic,copy)void(^ScanResult)(NSString*result,BOOL isSucceed);
//初始化函数
-(id)initWithBlock:(void(^)(NSString*,BOOL))a;

//正则表达式对扫描结果筛选
+(NSString*)zhengze:(NSString*)str;


@end

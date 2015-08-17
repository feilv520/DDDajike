//
//  ImageCompress.m
//  RuYi
//
//  Created by DLin on 14-11-6.
//  Copyright (c) 2014-2015 DLin. All rights reserved.
//

#import "ImageCompress.h"

@implementation ImageCompress

+ (UIImage *)scaleImage:(UIImage *)img WithScale:(float)scale{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    CGSize sz = img.size;
    CGSize newSize = CGSizeMake(sz.width*scale, sz.height*scale);
    UIGraphicsBeginImageContext(newSize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, newSize.width, newSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
    
    //将图片保存在本地
    /*
     NSString *path = [[documentPath stringByAppendingPathComponent:@"tmp"]stringByAppendingPathComponent:[NSString stringWithFormat:@"abc%d.png",10087]];
     NSFileManager *manager = [NSFileManager defaultManager];
     NSData *data = UIImageJPEGRepresentation(new, 1);
     [manager createFileAtPath:path contents:data attributes:nil];

     */
}
@end

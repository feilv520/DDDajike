//
//  PhotoAlbumModel.h
//  jibaobao
//
//  Created by swb on 15/6/17.
//  Copyright (c) 2015年 dajike. All rights reserved.
//


/*
 *    商家相册
 
 */

#import <Foundation/Foundation.h>

@interface PhotoAlbumModel : NSObject


@property (strong, nonatomic) NSString *image_name; //照片名

@property (strong, nonatomic) NSString *file_path;  //路径

@property (strong, nonatomic) NSString *file_id;    //照片ID

@end

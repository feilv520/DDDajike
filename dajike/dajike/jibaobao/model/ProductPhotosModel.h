//
//  ProductPhotosModel.h
//  jibaobao
//
//  Created by swb on 15/6/19.
//  Copyright (c) 2015年 dajike. All rights reserved.
//



/*
 **   商品相册
 
 */

#import <Foundation/Foundation.h>

@interface ProductPhotosModel : NSObject

@property (strong, nonatomic) NSString *imageId;     //商品图片ID
@property (strong, nonatomic) NSString *goodsId;     //商品ID
@property (strong, nonatomic) NSString *imageUrl;     //商品图片
@property (strong, nonatomic) NSString *thumbnail;     //商品缩略图地址
@property (strong, nonatomic) NSString *sortOrder;     //排序
@property (strong, nonatomic) NSString *fileId;     //关联上传图片路径ecm_upload_file表ID
@property (strong, nonatomic) NSString *spec1;     //商品规格1
@property (strong, nonatomic) NSString *spec2;     //
@property (strong, nonatomic) NSString *persistent;     //
@property (strong, nonatomic) NSString *entityId;       //

@end

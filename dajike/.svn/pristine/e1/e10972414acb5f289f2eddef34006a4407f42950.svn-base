//
//  MyHeaderView.h
//  jibaobao
//
//  Created by dajike_yc on 15/5/8.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import <UIKit/UIKit.h>

// button点击事件 : 传参 点击的Button的tag值
typedef void (^ClickBtnBlock)(long btnTag);

@interface MyHeaderView : UIView

@property (nonatomic, strong) UIButton  *shopPhotosBtn;     //商家相册按钮
@property (nonatomic, strong) UILabel   *shopNameLb;        //商家名称
@property (nonatomic, strong) UILabel   *commentNumLb;      //评论数
@property (nonatomic, strong) UILabel   *photoNumLb;        //相册张数
@property (nonatomic, strong) UILabel   *xingjiLb;          //评分
@property (nonatomic, strong) UIImageView *storeImg;        //收藏小图标
@property (nonatomic, strong) UIImageView *iv;              //商家图

@property (nonatomic, strong) UIImageView *shopPhotoImg;    //商家相册图片

@property (nonatomic, strong) UILabel   *adressLb;          //地址

@property (nonatomic, strong) ClickBtnBlock btnCallBackBlock;

- (void)addShopPhotosBtn;

//点击button响应事件
- (void)btnClickedCallBackAction:(ClickBtnBlock)block;

@end

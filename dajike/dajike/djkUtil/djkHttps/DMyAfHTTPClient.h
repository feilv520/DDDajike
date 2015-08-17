//
//  DMyAfHTTPClient.h
//  dajike
//
//  Created by dajike on 15/7/10.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "PostData.h"
#import "ActivityIndicator.h"
#import "ImageCompress.h"



//网络请求成功，回掉的块
typedef void (^success)(AFHTTPRequestOperation *operation, id responseObject);

//网络请求成功，其他错误比如登陆信息错误，回掉的块
typedef void (^failure)(AFHTTPRequestOperation *operation, NSError *error);
//网络请求错误
typedef BOOL (^httpError)();

@interface DMyAfHTTPClient : AFHTTPRequestOperationManager
+ (instancetype)sharedClient;

/**
 *  判断网络链接
 */
-(BOOL) isConnectionAvailable;

//网络失败请求的次数
@property (nonatomic,assign)int retryCount;

//timeout时间
@property (nonatomic,assign)int timeOutTime;

@property (nonatomic, retain) ActivityIndicator *indicator;


@property (nonatomic, strong)success suc;
@property (nonatomic, strong)failure fail;
@property (nonatomic, strong)httpError err;

//get
- (void) getPathWithMethod:(NSString *)method parameters:(NSDictionary *)parameters ifAddActivityIndicator:(BOOL)hasActivityIndicator
                   success:(void (^)(AFHTTPRequestOperation *operation, PostData * responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//post
- (void) postPathWithMethod:(NSString *)method parameters:(NSDictionary *)parameters ifAddActivityIndicator:(BOOL)hasActivityIndicator
                    success:(void (^)(AFHTTPRequestOperation *operation, PostData * responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)chatAsiHttpRequestWithUrl:(NSString *)method andImagePaths:(NSDictionary *)paths andDic:(NSDictionary *)params ifAddActivityIndicator:(BOOL)hasActivityIndicator success:(void (^)(AFHTTPRequestOperation *operation, PostData *responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//修改图片大小
+ (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize;

//保存图片
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;


//调整加载视图的frame
- (void) setIndicatorFrameWithFrame:(CGRect) loadingFrame;
//恢复加载视图的frame
- (void) reSetIndicatorFrame;
//当正在加载的过程中，突然返回，隐藏加载界面
- (void) hiddenLoadingView;
@end


@interface UIImageView(adimageView)
//广告页面图片路径拼接处理、图片异步加载、本地缓存
- (void)setADImageWithURLStr:(NSString *)oldUrlStr
            placeholderImage:(UIImage *)placeholderImage;
@end


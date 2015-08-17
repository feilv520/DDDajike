//
//  OrderCommentViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "OrderCommentViewController.h"
#import "MyAfHTTPClient.h"
#import "MBProgressHUD+Add.h"
#import "defines.h"

@interface OrderCommentViewController ()
{
    NSString  *_xingji;
    NSString  *_anonymous;
    NSMutableArray *_imagePathArr;
    NSMutableArray *_imageDataArr;
    NSMutableDictionary *_userInfoDic;
}

@end

@implementation OrderCommentViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.goodsOrOrder == 1) {
        titleLabel.text = @"评价商家";
    }else
        titleLabel.text = @"评价订单";
    
    _nimingBtn.frame = CGRectMake(9, 166, 302, 30);
    _niMingLabel.frame = CGRectMake(9, 166, 302, 30);
    _statusImageVIew.frame = CGRectMake(287, 169, 16, 17);
    _photoButton.frame = CGRectMake(62, 213, 70, 71);
    _moreButton.frame = CGRectMake(180, 213, 70, 71);
    _publikButton.frame = CGRectMake(35, 292, 251, 32);
    
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    self.textView.delegate = self;
    _imagePathArr = [[NSMutableArray alloc]init];
    _imageDataArr = [[NSMutableArray alloc]init];
    
//    _userInfoDic = [[NSMutableDictionary alloc]init];
//    _userInfoDic = [[FileOperation readFileToDictionary:jibaobaoUser]mutableCopy];
//    self.userInfoModel = [[UserInfoModel alloc]init];
//    self.userInfoModel = [JsonStringTransfer dictionary:_userInfoDic ToModel:self.userInfoModel];
    
    _xingji = @"0";
    _anonymous = @"1";
    
}

//评论订单
- (void)ordersEvaluate{
    
    NSDictionary *param = @{@"userId":self.userInfoModel.userId,
                                       @"orderId":self.myOrderListModel.order_id,
                                       @"recId":self.orderGoodsModel.rec_id,
                                       @"xingji":_xingji,
                                       @"anonymous":_anonymous,
                                       @"content":self.textView.text};
    
    NSMutableDictionary *parameter = [param mutableCopy];
    NSMutableDictionary *imagePaths = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < _imagePathArr.count; i++) {
        NSString *imageFilePath = [_imagePathArr objectAtIndex:i];
        NSString *imageName = [[imageFilePath componentsSeparatedByString:@"/"]lastObject];
        [imagePaths setObject:imageName forKey:[NSString stringWithFormat:@"files[%d]",i]];
        NSString *str1 = [NSString stringWithFormat:@"files[%d]",i];
        [parameter setObject:imageName forKey:str1];
    }
    NSLog(@"imagepath:%@\n parameter:%@",imagePaths,parameter);
    [[MyAfHTTPClient sharedClient]chatAsiHttpRequestWithUrl:@"MyOrders.evaluate" andImagePaths:imagePaths andDic:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {

        if (responseObject.succeed) {
            NSLog(@"result:%@",responseObject.msg);
            
            [self.navigationController popViewControllerAnimated:YES];
            [ProgressHUD showMessage:@"评论成功" Width:100 High:80];
        }else{
             NSLog(@"result:%@",responseObject.msg);
        }
        [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@\n operation:%@",error,operation);
        
        
    }];
}

//评论商家
- (void)goodsEvaluate{
    
    NSDictionary *param = @{@"userId":[FileOperation getUserId],
                            @"storeId":self.storeId,
                            @"xingji":_xingji,
                            @"anonymous":_anonymous,
                            @"content":self.textView.text};
    NSMutableDictionary *parameter = [param mutableCopy];
    NSMutableDictionary *imagePaths = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < _imagePathArr.count; i++) {
        NSString *imageFilePath = [_imagePathArr objectAtIndex:i];
        NSString *imageName = [[imageFilePath componentsSeparatedByString:@"/"]lastObject];
        [imagePaths setObject:imageName forKey:[NSString stringWithFormat:@"files[%d]",i]];
        NSString *str1 = [NSString stringWithFormat:@"files[%d]",i];
        [parameter setObject:imageName forKey:str1];
    }
    
    [[MyAfHTTPClient sharedClient]chatAsiHttpRequestWithUrl:@"Stores.addComments" andImagePaths:imagePaths andDic:parameter ifAddActivityIndicator:YES success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        if (responseObject.succeed) {
            NSLog(@"result:%@",responseObject.msg);
            self.block();
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            NSLog(@"result:%@",responseObject.msg);
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@\n operation:%@",error,operation);
        
        
    }];
}
//检查数据
- (BOOL)checkData
{
    if ([_xingji intValue] == 0) {
        [ProgressHUD showMessage:@"请选择评分" Width:100 High:80];
        return NO;
    }
    if ([self.numLabel.text intValue] == 0) {
        [ProgressHUD showMessage:@"亲~ 写点什么吧" Width:100 High:80];
        return NO;
    }
    return YES;
}
- (void)callBackShopComment:(CallBackCommentShopBlock)block
{
    self.block = block;
}


- (void)submitEvalute{
    

    
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
//五星
- (IBAction) xingButtonClip:(id)sender
{
    UIButton *starBtn = (UIButton *)sender;
    UIImage *img01 = [UIImage imageNamed:@"img_xx_01.png"];
    UIImage *img02 = [UIImage imageNamed:@"img_xx_02.png"];
    if (starBtn.tag == 0) {
        if ([starBtn.currentImage isEqual:img02]) {
            [self.xing1 setImage:img01 forState:UIControlStateNormal];
            _xingji = @"0";
        }else{
            [self.xing1 setImage:img02 forState:UIControlStateNormal];
            _xingji = @"1";
        }
        [self.xing2 setImage:img01 forState:UIControlStateNormal];
        [self.xing3 setImage:img01 forState:UIControlStateNormal];
        [self.xing4 setImage:img01 forState:UIControlStateNormal];
        [self.xing5 setImage:img01 forState:UIControlStateNormal];
    }else if (starBtn.tag == 1){
        if ([starBtn.currentImage isEqual:img02]) {
            [self.xing2 setImage:img01 forState:UIControlStateNormal];
            _xingji = @"1";
        }else{
            [self.xing2 setImage:img02 forState:UIControlStateNormal];
            _xingji = @"2";
        }
        [self.xing1 setImage:img02 forState:UIControlStateNormal];
        [self.xing3 setImage:img01 forState:UIControlStateNormal];
        [self.xing4 setImage:img01 forState:UIControlStateNormal];
        [self.xing5 setImage:img01 forState:UIControlStateNormal];
    }else if (starBtn.tag == 2){
        if ([starBtn.currentImage isEqual:img02]) {
            [self.xing3 setImage:img01 forState:UIControlStateNormal];
            _xingji = @"2";
        }else{
            [self.xing3 setImage:img02 forState:UIControlStateNormal];
            _xingji = @"3";
        }
        [self.xing1 setImage:img02 forState:UIControlStateNormal];
        [self.xing2 setImage:img02 forState:UIControlStateNormal];
        [self.xing4 setImage:img01 forState:UIControlStateNormal];
        [self.xing5 setImage:img01 forState:UIControlStateNormal];
        
    }else if (starBtn.tag == 3){
        if ([starBtn.currentImage isEqual:img02]) {
            [self.xing4 setImage:img01 forState:UIControlStateNormal];
            _xingji = @"3";
        }else{
            [self.xing4 setImage:img02 forState:UIControlStateNormal];
            _xingji = @"4";
        }
        [self.xing1 setImage:img02 forState:UIControlStateNormal];
        [self.xing2 setImage:img02 forState:UIControlStateNormal];
        [self.xing3 setImage:img02 forState:UIControlStateNormal];
        [self.xing5 setImage:img01 forState:UIControlStateNormal];
        
    }else if (starBtn.tag == 4){
        if ([starBtn.currentImage isEqual:img02]) {
            [self.xing5 setImage:img01 forState:UIControlStateNormal];
            _xingji = @"4";
        }else{
            [self.xing5 setImage:img02 forState:UIControlStateNormal];
            _xingji = @"5";
        }
        [self.xing1 setImage:img02 forState:UIControlStateNormal];
        [self.xing2 setImage:img02 forState:UIControlStateNormal];
        [self.xing3 setImage:img02 forState:UIControlStateNormal];
        [self.xing4 setImage:img02 forState:UIControlStateNormal];
    }


}
//匿名评价
- (IBAction)nimingButtobClip:(id)sender {
    UIImage *img01 = [UIImage imageNamed:@"img_no_selected.png"];
    UIImage *img02 = [UIImage imageNamed:@"img_selected.png"];
    if ([self.statusImageVIew.image isEqual:img01]) {
        [self.statusImageVIew setImage:img02];
        _anonymous = @"1";
    }else{
        [self.statusImageVIew setImage:img01];
        _anonymous = @"0";
    }
    
}

//拍照 相机
- (IBAction)photoButtonClip:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    
    [self highLight];
    
    if (_imagePathArr.count < 4){
        _nimingBtn.frame = CGRectMake(9, 213, 302, 30);
        _niMingLabel.frame = CGRectMake(9, 213, 302, 30);
        _statusImageVIew.frame = CGRectMake(287, 216, 16, 17);
        _photoButton.frame = CGRectMake(62, 260, 70, 71);
        _moreButton.frame = CGRectMake(180, 260, 70, 71);
        _publikButton.frame = CGRectMake(35, 339, 251, 32);
    } else {
        _nimingBtn.frame = CGRectMake(9, 260, 302, 30);
        _niMingLabel.frame = CGRectMake(9, 260, 302, 30);
        _statusImageVIew.frame = CGRectMake(287, 263, 16, 17);
        _photoButton.frame = CGRectMake(62, 299, 70, 71);
        _moreButton.frame = CGRectMake(180, 299, 70, 71);
        _publikButton.frame = CGRectMake(35, 378, 251, 32);
    }
    
    [self presentViewController:ipc animated:YES completion:nil];
}

//更多 相册
- (IBAction)moreButtonClip:(id)sender {
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate=self;
    ipc.allowsEditing=NO;
    
    [self highLight];
    
    if (_imagePathArr.count < 4){
        _nimingBtn.frame = CGRectMake(9, 213, 302, 30);
        _niMingLabel.frame = CGRectMake(9, 213, 302, 30);
        _statusImageVIew.frame = CGRectMake(287, 216, 16, 17);
        _photoButton.frame = CGRectMake(62, 260, 70, 71);
        _moreButton.frame = CGRectMake(180, 260, 70, 71);
        _publikButton.frame = CGRectMake(35, 339, 251, 32);
    } else {
        _nimingBtn.frame = CGRectMake(9, 260, 302, 30);
        _niMingLabel.frame = CGRectMake(9, 260, 302, 30);
        _statusImageVIew.frame = CGRectMake(287, 263, 16, 17);
        _photoButton.frame = CGRectMake(62, 299, 70, 71);
        _moreButton.frame = CGRectMake(180, 299, 70, 71);
        _publikButton.frame = CGRectMake(35, 378, 251, 32);
    }

    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    [self loadingImage:img];
    UIImage *newImg=[MyAfHTTPClient imageWithImageSimple:img scaledToSize:CGSizeMake(300, 300)];
    NSString *imagePaths = [MyAfHTTPClient saveImage:newImg WithName:[NSString stringWithFormat:@"%lu",(unsigned long)_imagePathArr.count] ];
    [_imagePathArr addObject:imagePaths];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePaths];
    [_imageDataArr addObject:imageData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self hiddenLight];
    
    if (_imagePathArr.count == 0) {
        _nimingBtn.frame = CGRectMake(9, 166, 302, 30);
        _niMingLabel.frame = CGRectMake(9, 166, 302, 30);
        _statusImageVIew.frame = CGRectMake(287, 169, 16, 17);
        _photoButton.frame = CGRectMake(62, 213, 70, 71);
        _moreButton.frame = CGRectMake(180, 213, 70, 71);
        _publikButton.frame = CGRectMake(35, 292, 251, 32);
    } else if (_imagePathArr.count > 0 && _imagePathArr.count <= 4){
        _nimingBtn.frame = CGRectMake(9, 213, 302, 30);
        _niMingLabel.frame = CGRectMake(9, 213, 302, 30);
        _statusImageVIew.frame = CGRectMake(287, 216, 16, 17);
        _photoButton.frame = CGRectMake(62, 260, 70, 71);
        _moreButton.frame = CGRectMake(180, 260, 70, 71);
        _publikButton.frame = CGRectMake(35, 339, 251, 32);
    } else {
        _nimingBtn.frame = CGRectMake(9, 260, 302, 30);
        _niMingLabel.frame = CGRectMake(9, 260, 302, 30);
        _statusImageVIew.frame = CGRectMake(287, 263, 16, 17);
        _photoButton.frame = CGRectMake(62, 299, 70, 71);
        _moreButton.frame = CGRectMake(180, 299, 70, 71);
        _publikButton.frame = CGRectMake(35, 378, 251, 32);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发布
- (IBAction)publikButtonClip:(id)sender {
    if ([self checkData]) {
        if (self.goodsOrOrder == 1) {
            [self goodsEvaluate];
        } else if(self.goodsOrOrder == 2){
            [self ordersEvaluate];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    self.numLabel.text = [NSString stringWithFormat:@"%lu字",(unsigned long)textView.text.length];
}

//加载图片
- (void)loadingImage:(UIImage *)img{
    if (_imagePathArr.count == 0) {
        [_photoView setImage:img];
    } else if(_imagePathArr.count == 1){
        [_photoView1 setImage:img];
    } else if(_imagePathArr.count == 2){
        [_photoView2 setImage:img];
    } else if(_imagePathArr.count == 3){
        [_photoView3 setImage:img];
    } else if(_imagePathArr.count == 4){
        [_photoView4 setImage:img];
    } else if(_imagePathArr.count == 5){
        [_photoView5 setImage:img];
    } else if(_imagePathArr.count == 6){
        [_photoView6 setImage:img];
    } else if(_imagePathArr.count == 7){
        [_photoView7 setImage:img];
    }
}

- (void)highLight{
    if (_imagePathArr.count == 0) {
        _photoView.hidden = NO;
    } else if(_imagePathArr.count == 1){
        _photoView1.hidden = NO;
    } else if(_imagePathArr.count == 2){
        _photoView2.hidden = NO;
    } else if(_imagePathArr.count == 3){
        _photoView3.hidden = NO;
    } else if(_imagePathArr.count == 4){
        _photoView4.hidden = NO;
    } else if(_imagePathArr.count == 5){
        _photoView5.hidden = NO;
    } else if(_imagePathArr.count == 6){
        _photoView6.hidden = NO;
    } else if(_imagePathArr.count == 7){
        _photoView7.hidden = NO;
    }
}

- (void)hiddenLight{
    if (_imagePathArr.count == 0) {
        _photoView.hidden = YES;
    } else if(_imagePathArr.count == 1){
        _photoView1.hidden = YES;
    } else if(_imagePathArr.count == 2){
        _photoView2.hidden = YES;
    } else if(_imagePathArr.count == 3){
        _photoView3.hidden = YES;
    } else if(_imagePathArr.count == 4){
        _photoView4.hidden = YES;
    } else if(_imagePathArr.count == 5){
        _photoView5.hidden = YES;
    } else if(_imagePathArr.count == 6){
        _photoView6.hidden = YES;
    } else if(_imagePathArr.count == 7){
        _photoView7.hidden = YES;
    }
}

@end

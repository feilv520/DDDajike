//
//  DGoodCommetViewController.m
//  dajike
//
//  Created by swb on 15/7/17.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DGoodCommetViewController.h"
#import "dDefine.h"
#import "SwbClickImageView.h"
//model
#import "orderGoodsModel.h"
//cell
#import "DProduceCommentCell.h"

#define img_interval 10
#define img_width ((DWIDTH_CONTROLLER_DEFAULT-6*img_interval)/5)
#define img_height img_width

#define deleteBtn_interval (img_interval+img_width)


@interface DGoodCommetViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *imgArr;
    int _starNum;
}

@end

@implementation DGoodCommetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviBarTitle:@"评价商品"];
    _starNum = 0;
    imgArr = [[NSMutableArray alloc]init];
    [self resetUI];
    [self setData];
}
//
- (void)setData
{
    orderGoodsModel *model = [self.productAarry objectAtIndex:0];
    [self.goodImgView setImageWithURL:[commonTools getImgURL:model.goods_image] placeholderImage:DPlaceholderImage];
    self.goodNameLb.text = model.goods_name;
    self.goodSpecLb.text = model.specification;
    self.goodNumLb.text = [NSString stringWithFormat:@"x%d",[model.quantity intValue]];
    self.goodPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[model.price floatValue]];
}
//调整界面UI
- (void)resetUI
{
    [self.oneBtn setImage:[UIImage imageNamed:@"img_pub_star_0.png"] forState:UIControlStateSelected];
    [self.twoBtn setImage:[UIImage imageNamed:@"img_pub_star_0.png"] forState:UIControlStateSelected];
    [self.threeBtn setImage:[UIImage imageNamed:@"img_pub_star_0.png"] forState:UIControlStateSelected];
    [self.fourBtn setImage:[UIImage imageNamed:@"img_pub_star_0.png"] forState:UIControlStateSelected];
    [self.fiveBtn setImage:[UIImage imageNamed:@"img_pub_star_0.png"] forState:UIControlStateSelected];
    [self.shaidanBtn setImage:[UIImage imageNamed:@"img_pingjia_02.png"] forState:UIControlStateSelected];
    [self.oneBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.twoBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.threeBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.fourBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.fiveBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.shaidanBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 6, 30, 7)];
    self.tijiaoBtn.layer.cornerRadius = 3.0f;
    self.tijiaoBtn.layer.masksToBounds = YES;
    if (self.productAarry.count == 1) {
        self.tableViewCon.constant = 5;
        [self.goodListTableView setHidden:YES];
    }else {
        self.goodListTableView.scrollEnabled = NO;
        self.tableViewCon.constant = (self.productAarry.count-1)*40;
    }
    self.scrollViewBG.showsVerticalScrollIndicator = NO;
}

#pragma mark tableView  datasource  &&  delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productAarry.count-1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DProduceCommentCell *myCell = [DTools loadTableViewCell:self.goodListTableView cellClass:[DProduceCommentCell class]];
    myCell.model = [self.productAarry objectAtIndex:indexPath.row+1];
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    orderGoodsModel *model = [self.productAarry objectAtIndex:0];
    [self.productAarry replaceObjectAtIndex:0 withObject:[self.productAarry objectAtIndex:indexPath.row+1]];
    [self.productAarry replaceObjectAtIndex:indexPath.row+1 withObject:model];
    [self setData];
    
    [self.goodListTableView reloadData];
}
#pragma mark textView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //    NSLog(@"%d",_textView.text.length);
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (self.pingyuTV.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            self.placeholderLb.hidden=NO;//隐藏文字
        }else{
            self.placeholderLb.hidden=YES;
        }
    }else{//textview长度不为0
        if (self.pingyuTV.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                self.placeholderLb.hidden=NO;
            }else{//不是删除
                self.placeholderLb.hidden=YES;
            }
        }else{//长度不为1时候
            self.placeholderLb.hidden=YES;
        }
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if(textView == self.pingyuTV) {
        self.placeholderLb.hidden = self.pingyuTV.text.length > 0;
        self.wordsNumLb.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)self.pingyuTV.text.length];
    }
    if(textView.text.length>=100){
        NSString *text=[textView.text substringToIndex:100];
        self.pingyuTV.text=text;
    }
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


//tag=1-5评分按钮 tag=6.晒单  tag=7.提交
- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:{
            self.oneBtn.selected = !self.oneBtn.selected;
            if (self.oneBtn.selected) {
                self.placeholderLb.text = @"对商品不满意";
                self.pingfenLb.text = @"商品满意度：1分   不满意";
                _starNum = 1;
            }else {
                self.placeholderLb.text = @"对商品评价（5~100字）";
                self.pingfenLb.text = @"商品满意度：选择评分";
                _starNum = 0;
            }
            
            self.twoBtn.selected = NO;
            self.threeBtn.selected = NO;
            self.fourBtn.selected = NO;
            self.fiveBtn.selected = NO;
        }
            break;
            
        case 2:{
            self.oneBtn.selected = YES;
            self.twoBtn.selected = !self.twoBtn.selected;
            if (self.twoBtn.selected) {
                self.placeholderLb.text = @"对商品感觉一般";
                self.pingfenLb.text = @"商品满意度：2分   一般";
                _starNum = 2;
            }else {
                self.placeholderLb.text = @"对商品不满意";
                self.pingfenLb.text = @"商品满意度：1分   不满意";
                _starNum = 1;
            }
            
            self.threeBtn.selected = NO;
            self.fourBtn.selected = NO;
            self.fiveBtn.selected = NO;
        }
            break;
            
        case 3:{
            self.oneBtn.selected = YES;
            self.twoBtn.selected = YES;
            self.threeBtn.selected = !self.threeBtn.selected;
            if (self.threeBtn.selected) {
                self.placeholderLb.text = @"商品还可以";
                self.pingfenLb.text = @"商品满意度：3分   还可以";
                _starNum = 3;
            }else {
                self.placeholderLb.text = @"对商品感觉一般";
                self.pingfenLb.text = @"商品满意度：2分   一般";
                _starNum = 2;
            }
            
            self.fourBtn.selected = NO;
            self.fiveBtn.selected = NO;
        }
            break;
        case 4:{
            self.oneBtn.selected = YES;
            self.twoBtn.selected = YES;
            self.threeBtn.selected = YES;
            self.fourBtn.selected = !self.fourBtn.selected;
            if (self.fourBtn.selected) {
                self.placeholderLb.text = @"对商品满意";
                self.pingfenLb.text = @"商品满意度：4分   满意";
                _starNum = 4;
            }else {
                self.placeholderLb.text = @"商品还可以";
                self.pingfenLb.text = @"商品满意度：3分   还可以";
                _starNum = 3;
            }
            
            self.fiveBtn.selected = NO;
        }
            break;
            
        case 5:{
            self.oneBtn.selected = YES;
            self.twoBtn.selected = YES;
            self.threeBtn.selected = YES;
            self.fourBtn.selected = YES;
            self.fiveBtn.selected = !self.fiveBtn.selected;
            if (self.fiveBtn.selected) {
                self.placeholderLb.text = @"对商品非常满意";
                self.pingfenLb.text = @"商品满意度：5分   非常满意";
                _starNum = 5;
            }else {
                self.placeholderLb.text = @"对商品满意";
                self.pingfenLb.text = @"商品满意度：4分   满意";
                _starNum = 4;
            }
            
        }
            break;
        case 6:{
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选取", nil];
            [sheet showInView:self.scrollViewBG];
        }
            
            break;
        case 7:{
            if ([self checkDataIsRight]) {
                [self productEvaluate];
            }
        }
            
            break;
            
        default:
            break;
    }
}
//判空
- (BOOL)checkDataIsRight
{
    if (_starNum == 0) {
        showMessage(@"请选择评分");
        return NO;
    }
    if (self.pingyuTV.text.length<5) {
        showMessage(@"请输入5~100字");
        return NO;
    }
    return YES;
}

//提交评论
- (void)productEvaluate
{
    orderGoodsModel *mmodel = [self.productAarry objectAtIndex:0];
    NSDictionary *param = @{@"userId":get_userId,
                            @"orderId":self.orderId,
                            @"recId":mmodel.rec_id,
                            @"xingji":[NSString stringWithFormat:@"%d",_starNum],
                            @"anonymous":@"1",
                            @"content":self.pingyuTV.text};
    
    NSMutableDictionary *parameter = [param mutableCopy];
    NSMutableDictionary *imagePaths = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < imgArr.count; i++) {
        NSString *imageFilePath = [imgArr objectAtIndex:i];
        [imagePaths setObject:imageFilePath forKey:[NSString stringWithFormat:@"files[%d]",i]];
        NSString *str1 = [NSString stringWithFormat:@"files[%d]",i];
        [parameter setObject:imageFilePath forKey:str1];
    }
    NSLog(@"imagepath:%@\n parameter:%@",imagePaths,parameter);
    [[DMyAfHTTPClient sharedClient]chatAsiHttpRequestWithUrl:@"MyOrders.evaluate" andImagePaths:imagePaths andDic:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData * responseObject) {
        
        if (responseObject.succeed) {
            NSLog(@"result:%@",responseObject.msg);
            [self.productAarry removeObjectAtIndex:0];
            if (self.productAarry.count>0) {
                [self setData];
                [self.goodListTableView reloadData];
            }else {
                self.block();
                pop();
                [ProgressHUD showMessage:@"评论成功" Width:100 High:80];
            }
        }else{
            NSLog(@"result:%@",responseObject.msg);
            showMessage(responseObject.msg);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@\n operation:%@",error,operation);
        
        
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    if(buttonIndex == 0)//拍照
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            [ProgressHUD showMessage:@"不支持相机" Width:100 High:80];
            return;
        }
    }
    else if (buttonIndex == 1)//从相册中选择
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else
    {
        return;
    }
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 拍照或者浏览相册得到图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //压缩图片，图片长宽，不能超过1000
    CGSize imgSize = image.size;
    float maxF = imgSize.height>imgSize.width?imgSize.height:imgSize.width;
    //如果最大大于1000，则需要压缩
    if(maxF>1000)
    {
        image = [ImageCompress scaleImage:image WithScale:1000.0/maxF];
    }
    //保存图片在本地
    NSString *imageName = [NSString stringWithFormat:@"%@.png", [self timeString]];
    NSString *imgPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    if([self saveImage:image withPath:imgPath])
    {
        [imgArr addObject:[[imgPath componentsSeparatedByString:@"/"]lastObject]];
        [self layoutImg];
    }
    else
    {
        showMessage(@"未知错误，请重新选择图片");
    }
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
}
//布局图片
- (void)layoutImg
{
    if (imgArr.count >= 5) {
        [self.shaidanBtn setUserInteractionEnabled:NO];
        self.shaidanBtn.selected = YES;
    }else {
        [self.shaidanBtn setUserInteractionEnabled:YES];
        self.shaidanBtn.selected = NO;
    }
    for (int i=0; i<imgArr.count; i++) {
        SwbClickImageView *imgV = (SwbClickImageView *)[self.scrollViewBG viewWithTag:666+i];
        if (!imgV) {
            imgV = [[SwbClickImageView alloc]initWithFrame:DRect(img_interval*(i+1)+img_width*i, CGRectGetMaxY(self.pingyuTV.frame)+15, img_width, img_height)];
            imgV.tag = 666+i;
            [self.scrollViewBG addSubview:imgV];
        }
        NSString *filePath = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/"] stringByAppendingPathComponent:[imgArr objectAtIndex:i]];
        imgV.image = [UIImage imageWithContentsOfFile:filePath];
        [imgV callBackImgViewClicked:^(SwbClickImageView *clickImgView) {
            
        }];
        UIButton *deleteBtn = (UIButton *)[self.scrollViewBG viewWithTag:1006+i];
        if (!deleteBtn) {
            deleteBtn = [self.view createButtonWithFrame:DRect(deleteBtn_interval*(i+1)-10, CGRectGetMaxY(self.pingyuTV.frame), 20, 20) andBackImageName:nil andTarget:self andAction:@selector(deleteImg:) andTitle:nil andTag:1006+i];
            [self.scrollViewBG addSubview:deleteBtn];
        }
        [deleteBtn setImage:[UIImage imageNamed:@"img_pingjia_03"] forState:UIControlStateNormal];
        [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 2, 0, 3)];
    }
    if (imgArr.count>0) {
        self.tijiaoBtnCon.constant = img_height+35;
    }else
        self.tijiaoBtnCon.constant = 20;
}
//删除图片，重新布局
- (void)deleteImg:(UIButton *)btn
{
    SwbClickImageView *imgV = (SwbClickImageView *)[self.scrollViewBG viewWithTag:666+imgArr.count-1];
    [imgV removeFromSuperview];
    UIButton *deletBtn = (UIButton *)[self.scrollViewBG viewWithTag:1006+imgArr.count-1];
    [deletBtn removeFromSuperview];
    [imgArr removeObjectAtIndex:btn.tag-1006];
    [self layoutImg];
}
// 得到当前时间
- (NSString *) timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyyMMddHHmmssSSSS"];
    return [formatter stringFromDate:[NSDate date]];
}
//保存图片在本地
- (BOOL)saveImage:(UIImage *)img withPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSData *data = UIImageJPEGRepresentation(img, 1);
    if([manager createFileAtPath:filePath contents:data attributes:nil])
        return YES;
    else
        return NO;
    
}
- (void)callBack:(CallbackToDOrderDetailVCandDMyOrderListVC)block
{
    self.block = block;
}
@end

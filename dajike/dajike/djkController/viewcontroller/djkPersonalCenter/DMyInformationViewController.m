//
//  DMyInformationViewController.m
//  dajike
//
//  Created by songjw on 15/7/13.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DMyInformationViewController.h"
#import "dDefine.h"
#import "DMyAfHTTPClient.h"
#import "MineNextCell.h"
#import "DMyNameAndSexViewController.h"
#import "DMyAddressListAndSafeViewController.h"
#import "FileOperation.h"
#import "AnalysisData.h"
#import "MBProgressHUD+Add.h"
#import "UserInfoModel.h"
#import "DTools.h"

@interface DMyInformationViewController (){
    NSArray *_viewArr;
    UIImage *_headImg;
    NSString *_imagePaths;
    UserInfoModel *_userModel;
    
}

@end

@implementation DMyInformationViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    if ([FileOperation isLogin]) {
        NSDictionary *userInfoDic = [[FileOperation readFileToDictionary:dajikeUser]mutableCopy];
        _userModel = [[UserInfoModel alloc]init];
        _userModel = [JsonStringTransfer dictionary:userInfoDic ToModel:_userModel];
    }
    [self.dMainTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:DColor_f3f3f3];
    [self initView];
    self.dMainTableView.delegate = self;
    self.dMainTableView.dataSource = self;
}

- (void)initView{
    
    [self setNaviBarTitle:@"个人中心"];
    [self addTableView:NO];
    _viewArr = @[
                 @{
                     @"title1" : @"头像",
                     @"title2" : @"",
                     @"headIMage" : @"me.png",
                     },
                 @{
                     @"title1" : @"昵称",
                     @"title2" : @"jason",
                     @"headIMage" : @"",
                     },
                 @{
                     @"title1" : @"性别",
                     @"title2" : @"男",
                     @"headIMage" : @"",
                     },
                 @{
                     @"title1" : @"收货地址",
                     @"title2" : @"",
                     @"headIMage" : @"",
                     },
                 @{
                     @"title1" : @"安全设置（可修改密码）",
                     @"title2" : @"",
                     @"headIMage" : @"",
                     }
                 ];
    [self.dMainTableView reloadData];

}

#pragma mark------
#pragma mark------uitableViewDelegate uitableViewDatasource--------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 75.0;
    }else{
        return 45.0;
    }
    return 0.0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const cellID = @"gongyong";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [DTools setLable:cell.textLabel Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    [DTools setLable:cell.detailTextLabel Font:DFont_13 titleColor:DColor_808080 backColor:DColor_ffffff];
    cell.textLabel.text = [_viewArr[indexPath.row] objectForKey:@"title1"];
    
    switch (indexPath.row) {
        case 0:{
            UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(DWIDTH_CONTROLLER_DEFAULT - 95 , 7.5, 60, 60)];
            headImg.layer.masksToBounds = YES;
            headImg.backgroundColor = [UIColor whiteColor];
            headImg.layer.cornerRadius = 30.0;
            headImg.layer.borderColor = [[UIColor colorWithRed:212 green:192 blue:161 alpha:1]CGColor];
            headImg.layer.borderWidth = 2.0;
            if ([FileOperation isLogin]) {
                NSURL *imgUrl = [commonTools getImgURL:_userModel.portrait];
                [headImg setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"nan.png"]];
            }else{
                headImg.image = [UIImage imageNamed:@"img_pub_06"];
            }
            [cell addSubview:headImg];
        }
            break;
        case 1:{
            if ([FileOperation isLogin]) {
                cell.detailTextLabel.text = _userModel.nickName;
            }else{
                cell.detailTextLabel.text = @"大集客";
            }
        }
            
            break;
        case 2:
            if ([FileOperation isLogin]) {
                int a = [_userModel.gender intValue];
                if (a == 0) {
                    cell.detailTextLabel.text = @"保密";
                }else if (a == 1){
                    cell.detailTextLabel.text = @"男";
                }else{
                    cell.detailTextLabel.text = @"女";
                }
            }else{
                cell.detailTextLabel.text = @"男";
            }
            
            break;
            
        default:
            cell.textLabel.text = [[_viewArr objectAtIndex:indexPath.row] objectForKey:@"title1"];
            cell.detailTextLabel.text = [[_viewArr objectAtIndex:indexPath.row] objectForKey:@"title2"];
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0://头像
        {
            UIActionSheet *headImgAS = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册中选择", nil];
            headImgAS.delegate = self;
            [headImgAS showInView:self.view];
            
        }
            break;
        case 1://姓名
        {
            DMyNameAndSexViewController *vc = [[DMyNameAndSexViewController alloc]init];
            vc.name_sex = NAME;
            vc.userModel = _userModel;
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 2://性别
        {
            DMyNameAndSexViewController *vc = [[DMyNameAndSexViewController alloc]init];
            vc.name_sex = SEX;
            vc.userModel = _userModel;
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 3://收货地址
        {
            DMyAddressListAndSafeViewController *vc = [[DMyAddressListAndSafeViewController alloc]init];
            vc.address_safe = ADDRESS;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4://安全设置
        {
            DMyAddressListAndSafeViewController *vc = [[DMyAddressListAndSafeViewController alloc]init];
            vc.address_safe = SAFE;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}





- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"拍照");
        UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
        ipc.allowsEditing = NO;
        [self presentViewController:ipc animated:YES completion:nil];
    }else if (buttonIndex == 1){
        NSLog(@"手机相册");
        UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
        ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        ipc.allowsEditing=NO;
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    _headImg=[DMyAfHTTPClient imageWithImageSimple:img scaledToSize:CGSizeMake(300, 300)];
    _imagePaths = [DMyAfHTTPClient saveImage:_headImg WithName:@"0"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updatePortrait];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)updatePortrait{
    NSDictionary *param = @{@"userId":[FileOperation getUserId]};
    NSMutableDictionary *parameter = [param mutableCopy];
    NSString *imageName = [[_imagePaths componentsSeparatedByString:@"/"]lastObject];
    
    NSDictionary *imagePathDict = [[NSDictionary alloc]initWithObjectsAndKeys:imageName,@"files[0]", nil ];
    [parameter setObject:imageName forKey:@"files[0]"];
    [[DMyAfHTTPClient sharedClient]chatAsiHttpRequestWithUrl:@"MyUserInfos.updatePortrait" andImagePaths:imagePathDict andDic:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result:%@",responseObject);
            [self getUerInfo];
            
        }else{
            NSLog(@"result:%@",responseObject);
        }
        [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}
- (void)getUerInfo{
    NSLog(@"%@",[FileOperation getUserId]);
    NSDictionary *parameter = @{@"userId":[NSString stringWithString:[FileOperation getUserId]]};
    [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyUserInfos.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation = %@",operation);
        NSLog(@"result:%@",responseObject.result);
        if (responseObject.succeed) {
            
            NSString *jsonStr = [AnalysisData decodeToString:responseObject.result];
            NSMutableDictionary *userInfoDic = [[JsonStringTransfer jsonStringToDictionary:jsonStr]mutableCopy];
            NSString *filePath = [FileOperation creatPlistIfNotExist:dajikeUser];
            [FileOperation writeToPlistFile:filePath withDic:userInfoDic];
        }else{
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
    
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

@end
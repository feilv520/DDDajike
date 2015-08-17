//
//  MyInformationViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "MyInformationViewController.h"
#import "MineNextCell.h"

#import "MyNameViewController.h"
#import "MySexViewController.h"
#import "MyAddressListViewController.h"
#import "SafetySettingViewController.h"
#import "FileOperation.h"
#import "defines.h"

@interface MyInformationViewController ()
{
    NSArray *dataArray;
    NSData *_imgData;
    UIImage *_headImg;
    NSString *_imagePaths;
}
@end

@implementation MyInformationViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"个人资料";
        
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableView:UITableViewStyleGrouped];
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    [self addData];
    
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self initUserInfoModel];
    [self.mainTabview reloadData];
}

- (void)initUserInfoModel{
    NSString *filePAth = [FileOperation creatPlistIfNotExist:SET_PLIST];
    if ([[FileOperation getobjectForKey:kIsLogin ofFilePath:filePAth] boolValue] == 1) {
        NSDictionary *userInfoDic = [[NSMutableDictionary alloc]init];
        userInfoDic = [[FileOperation readFileToDictionary:jibaobaoUser]mutableCopy];
        NSLog(@"name:%@",userInfoDic);
        self.userInfoModel = [[UserInfoModel alloc]init];
        self.userInfoModel = [JsonStringTransfer dictionary:userInfoDic ToModel:self.userInfoModel];
    }else{
        
    }
}

- (void)addData
{
    dataArray = @[
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
    NSInteger row = [indexPath row];
    MineNextCell *cell = [self loadMineNextCell:self.mainTabview];
    if (row == 0) {
        cell.titleTwoLabel.hidden = YES;
        cell.arrowImageV.hidden = YES;
        cell.headImageView.hidden = NO;
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH_CONTROLLER_DEFAULT-18, 30, 10, 15)];
        [imageV setImage:[UIImage imageNamed:@"img_arrow_01_right.png"]];
        [cell addSubview:imageV];
        
        if ([commonTools isEmpty:_userInfoModel.portrait]||[_userInfoModel.portrait isEqualToString:@""]) {
            if ([_userInfoModel.gender isEqualToString:@"2"]) {
                [cell.headImageView setImage:[UIImage imageNamed:@"nv.png"]];
            }else{
                [cell.headImageView setImage:[UIImage imageNamed:@"nan.png"]];
            }
        }else{
            NSURL *imgUrl = [commonTools getImgURL:_userInfoModel.portrait];
            [cell.headImageView setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"nan.png"]];
        }
    }
    
    switch (indexPath.row) {
        case 1:
            cell.titleLabel.text = @"昵称";
            if ([self.userInfoModel.nickName isEqualToString:@""]||
                [self.userInfoModel.nickName isEqualToString:@"(null)"]) {
                cell.titleTwoLabel.text = @"无";
            }else{
                cell.titleTwoLabel.text = self.userInfoModel.nickName;
            }
            
            break;
        case 2:
            cell.titleLabel.text = @"性别";
            switch ([self.userInfoModel.gender intValue]) {
                case 0:
                    cell.titleTwoLabel.text = @"保密";
                    break;
                case 1:
                    cell.titleTwoLabel.text = @"男";
                    break;
                case 2:
                    cell.titleTwoLabel.text = @"女";
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            cell.titleLabel.text = [[dataArray objectAtIndex:row] objectForKey:@"title1"];
            cell.titleTwoLabel.text = [[dataArray objectAtIndex:row] objectForKey:@"title2"];
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
            MyNameViewController *MyNameVC = [[MyNameViewController alloc]initWithNibName:nil bundle:nil];
            MyNameVC.userInfoModel = self.userInfoModel;
            [self.navigationController pushViewController:MyNameVC animated:YES];
        }
            break;
        case 2://性别
        {
            MySexViewController *mysexVC = [[MySexViewController alloc]initWithNibName:nil bundle:nil];
            mysexVC.userInfoModel = self.userInfoModel;
            [self.navigationController pushViewController:mysexVC animated:YES];
        }
            break;
        case 3://收货地址
        {
            MyAddressListViewController *MyAddressListVC = [[MyAddressListViewController alloc]initWithNibName:nil bundle:nil];
            MyAddressListVC.userId = self.userInfoModel.userId;
            [self.navigationController pushViewController:MyAddressListVC animated:YES];
        }
            break;
        case 4://安全设置
        {
            SafetySettingViewController *SafetySettingVC = [[SafetySettingViewController alloc]initWithNibName:nil bundle:nil];
            SafetySettingVC.userInfoModel = self.userInfoModel;
            [self.navigationController pushViewController:SafetySettingVC animated:YES];
        }
            break;
            
        default:
            break;
    }
//    CouponDetailsListViewController *CouponDetailsListVC = [[CouponDetailsListViewController alloc]initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:CouponDetailsListVC animated:YES];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    
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
        ipc.delegate=self;
        ipc.allowsEditing=NO;
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    }
    _headImg=[MyAfHTTPClient imageWithImageSimple:img scaledToSize:CGSizeMake(300, 300)];
    _imagePaths = [MyAfHTTPClient saveImage:_headImg WithName:@"0"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updatePortrait];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updatePortrait{
//    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//
//    self.img.image = selfPhoto;
//    [self.img.layer setCornerRadius:CGRectGetHeight([self.img bounds]) / 2];  //修改半径，实现头像的圆形化
//    self.img.layer.masksToBounds = YES;
    
    NSDictionary *param = @{@"userId":self.userInfoModel.userId};
    NSMutableDictionary *parameter = [param mutableCopy];

    NSString *imageName = [[_imagePaths componentsSeparatedByString:@"/"]lastObject];

    NSDictionary *imagePathDict = [[NSDictionary alloc]initWithObjectsAndKeys:imageName,@"files[0]", nil ];
    [parameter setObject:imageName forKey:@"files[0]"];
    
    [[MyAfHTTPClient sharedClient]chatAsiHttpRequestWithUrl:@"MyUserInfos.updatePortrait" andImagePaths:imagePathDict andDic:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation:%@",operation);
        NSLog(@"result:%@",responseObject.msg);
        [self getUerInfo];
        [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.7];
        
                if (responseObject.succeed) {
                    NSLog(@"result:%@",responseObject);
                    
                }else{
                    NSLog(@"result:%@",responseObject);
                }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@\n operation:%@",error,operation);
        
        
    }];

}
#pragma mark------
#pragma mark------loadTableView--------
- (MineNextCell *)loadMineNextCell:(UITableView *)tableView
{
    NSString * const nibName  = @"MineNextCell";
    
    MineNextCell *cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
        cell = [tableView dequeueReusableCellWithIdentifier:nibName];
    }
    
    return cell;
}

//获取用户会员信息，存入本地
- (void)getUerInfo
{
    NSDictionary *parameter = @{@"userId":_userInfoModel.userId};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyUserInfos.index" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"operation6 = %@",operation);
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSString *jsonStr = [AnalysisData decodeToString:responseObject.result];
            NSMutableDictionary *userInfoDic = [[JsonStringTransfer jsonStringToDictionary:jsonStr]mutableCopy];
            NSString *filePath = [FileOperation creatPlistIfNotExist:jibaobaoUser];
            [FileOperation writeToPlistFile:filePath withDic:userInfoDic];
            NSLog(@"%@",userInfoDic);
            [self initUserInfoModel];
            [self.mainTabview reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];
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

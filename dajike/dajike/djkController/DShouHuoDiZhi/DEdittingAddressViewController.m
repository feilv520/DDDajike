//
//  DEdittingAddressViewController.m
//  dajike
//
//  Created by swb on 15/7/13.
//  Copyright (c) 2015年 haixia. All rights reserved.
//

#import "DEdittingAddressViewController.h"
#import "defines.h"
#import "dDefine.h"
#import "DConfirmOrderViewController.h"

@interface DEdittingAddressViewController ()<UITextFieldDelegate>
{
    //一级地区列表
    NSMutableArray *list0;
    //二级地区列表
    NSMutableArray *list1;
    //三级地区列表
    NSMutableArray *list2;
    
    //一级地区选中
    NSString *title0;
    //二级地区选中
    NSString *title1;
    //三级地区选中
    NSString *title2;
}

@end

@implementation DEdittingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = DColor_f3f3f3;
    
    [self.phoneTF addTarget:self action:@selector(inputValue:) forControlEvents:UIControlEventEditingChanged];
    
    [self.codeTF addTarget:self action:@selector(inputVValue:) forControlEvents:UIControlEventEditingChanged];
    
    if ([self.flagStr intValue] == 1) {
        [self setNaviBarTitle:@"新增收货地址"];
        self.model = [[MyAddressModel alloc]init];
    }
    if ([self.flagStr intValue] == 2) {
        [self setNaviBarTitle:@"编辑收货地址"];
        if (![commonTools isNull:self.model.consignee]) {
            self.nameTF.text     = self.model.consignee;
        }
        if (![commonTools isNull:self.model.phoneMob]) {
            self.phoneTF.text    = self.model.phoneMob;
        }
        if (![commonTools isNull:self.model.phoneTel]) {
            self.mobileTF.text = self.model.phoneTel;
        }
        if (![commonTools isNull:self.model.address]) {
            self.detailAddress.text = self.model.address;
        }
        if (![commonTools isNull:self.model.regionName]) {
            self.areaTF.text = self.model.regionName;
        }
        if (![commonTools isNull:self.model.zipcode]) {
            self.codeTF.text            = self.model.zipcode;
        }
        
    }
    
    self.nameTF.delegate = self;
    self.phoneTF.delegate = self;
    self.codeTF.delegate = self;
    self.mobileTF.delegate = self;
    self.detailAddress.delegate = self;
    list0 = [[NSMutableArray alloc]init];
    list1 = [[NSMutableArray alloc]init];
    list2 = [[NSMutableArray alloc]init];
    
    [self.placePickerView setHidden:YES];
    [FileOperation getAllPlaces:^(BOOL finish) {
        
        list0 = [NSMutableArray arrayWithArray:[FileOperation getAllYijiPlaces]];
        if (list0.count != 0) {
            list1 = [NSMutableArray arrayWithArray:[FileOperation getNextPlacesWithRegionId:[[[list0 objectAtIndex:0]objectForKey:@"regionId"]integerValue]]];
            //第二行美数据的话
            if (list1.count >= 1) {
                list2 = [NSMutableArray arrayWithArray:[FileOperation getNextPlacesWithRegionId:[[[list1 objectAtIndex:0]objectForKey:@"regionId"]integerValue]]];
            }else{
                [list1 setArray:[NSArray arrayWithObject:[list0 objectAtIndex:0]]];
                [list2 setArray:[NSArray arrayWithObject:[list0 objectAtIndex:0]]];
            }
            //第三行没数据的话
            if (list2.count <= 0) {
                [list2 setArray:[NSArray arrayWithObject:[list1 objectAtIndex:0]]];
            }
            
            title0 = [[list0 objectAtIndex:0]objectForKey:@"regionName"];
            title1 = [[list1 objectAtIndex:0]objectForKey:@"regionName"];
            title2 = [[list2 objectAtIndex:0]objectForKey:@"regionName"];
            [self.placePickerView reloadAllComponents];
        }
        
    }];
}

//手机号限制
- (void)inputValue:(UITextField *)tf
{
    if (tf.text.length>11) {
        tf.text = [tf.text substringToIndex:11];
    }
}

- (void)inputVValue:(UITextField *)tf{
    if (tf.text.length>6) {
        tf.text = [tf.text substringToIndex:6];
    }
}

//判断数据输入的正确性
- (BOOL)checkDataIsRight
{
    if ([commonTools isEmpty:self.nameTF.text]) {
        [ProgressHUD showMessage:@"请填写收件人姓名" Width:100 High:80];
        return NO;
    }else if ([commonTools isEmpty:self.phoneTF.text]) {
        [ProgressHUD showMessage:@"请填写您的手机号" Width:100 High:80];
        return NO;
    }else if (![commonTools isMobileNumber:self.phoneTF.text]) {
        [ProgressHUD showMessage:@"请输入一个正确的手机号码" Width:100 High:80];
        return NO;
    }else if (![commonTools isNull:self.mobileTF.text]) {
        if (![commonTools isPhoneNum:self.mobileTF.text]) {
            showMessage(@"请输入一个正确的电话号码");
            return NO;
        }
    }else if ([commonTools isEmpty:self.codeTF.text]) {
        [ProgressHUD showMessage:@"请填写您所在地的邮编" Width:100 High:80];
        return NO;
    }else if (![commonTools isValidZipcode:self.codeTF.text]) {
        [ProgressHUD showMessage:@"请填写正确的邮编" Width:100 High:80];
        return NO;
    }else if ([commonTools isEmpty:self.areaTF.text]) {
        [ProgressHUD showMessage:@"请填写您所在的地区" Width:100 High:80];
        return NO;
    }else if ([commonTools isEmpty:self.detailAddress.text]) {
        [ProgressHUD showMessage:@"请填写您的详细地址" Width:100 High:80];
        return NO;
    }else if (self.detailAddress.text.length < 5 || self.detailAddress.text.length > 120){
        [ProgressHUD showMessage:@"详细地址长度控制在5-120个字符内" Width:100 High:80];
        return NO;
    }
    return YES;
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

- (IBAction)saveBtnActino:(id)sender {
    [self.view endEditing:YES];
    if ([self checkDataIsRight]) {
        
        if ([commonTools isEmpty:self.mobileTF.text]) {
            self.mobileTF.text = @"";
        }
        //新增
        if ([self.flagStr intValue] == 1) {
            NSLog(@"新增收货地址");
            
            NSDictionary *parameter = @{@"userId":[FileOperation getUserId],
                                        @"regionId":[NSString stringWithFormat:@"%@",self.model.regionId],
                                        @"zipcode":self.codeTF.text,
                                        @"address":self.detailAddress.text,
                                        @"consignee":self.nameTF.text,
                                        @"phoneMob":self.phoneTF.text,
                                        @"phoneTel":self.mobileTF.text
                                        };
            
            [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyAddress.create" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                NSLog(@"%ld",(long)responseObject.code);
                NSLog(@"%@",responseObject.msg);
                if (responseObject.succeed) {
                    NSLog(@"result = %@",responseObject.result);
                    self.model = [JsonStringTransfer dictionary:responseObject.result ToModel:self.model];
                    //                    self.model.regionName = self.address2TextField.text;
                    //                    self.model.consignee = self.nameTextField.text;
                    //                    self.model.address = self.address3TextField.text;
                    //                    self.model.zipcode = self.codeTf.text;
                    //                    self.model.phoneMob = self.phoneTextField.text;
                    //                    self.model.phoneTel = self.address1TextField.text;
                    if ([self.comefrom isEqualToString:@"DConfirmOrderViewController"]) {
                        self.block(1,self.model);
                        int vcNum = 0;
                        for (int i=0;i<self.navigationController.viewControllers.count;i++) {
                            if ([self.navigationController.viewControllers[i] isKindOfClass:[DConfirmOrderViewController class]]) {
                                vcNum = i;
                                break;
                            }
                        }
                        [self.navigationController popToViewController:self.navigationController.viewControllers[vcNum] animated:YES];
                    }else {
                        self.block(1,self.model);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                else
                {
                    if ([responseObject.msg isEqualToString:@"街道地址长度控制在5-120个字符内"])
                        [ProgressHUD showMessage:@"详细地址长度控制在5-120个字符内" Width:100 High:80];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
                NSLog(@"operation6 = %@",operation);
            }];
        }
        //编辑
        if ([self.flagStr intValue] == 2) {
            NSLog(@"编辑收货地址");
            
            NSDictionary *parameter = @{@"userId":[FileOperation getUserId],@"regionId":[NSString stringWithFormat:@"%@",self.model.regionId],@"addrId":self.model.addrId,@"zipcode":self.codeTF.text,@"address1":self.detailAddress.text,@"consignee":self.nameTF.text,@"phoneMob":self.phoneTF.text,@"phoneTel":self.mobileTF.text};
            
            [[DMyAfHTTPClient sharedClient]postPathWithMethod:@"MyAddress.update" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
                if (responseObject.succeed) {
                    NSLog(@"result = %@",responseObject.result);
                    self.model = [JsonStringTransfer dictionary:responseObject.result ToModel:self.model];
                    //                    self.model.regionName = self.address2TextField.text;
                    //                    self.model.consignee = self.nameTextField.text;
                    //                    self.model.address = self.address3TextField.text;
                    //                    self.model.zipcode = self.codeTf.text;
                    //                    self.model.phoneMob = self.phoneTextField.text;
                    //                    self.model.phoneTel = self.address1TextField.text;
                    if ([self.comefrom isEqualToString:@"DConfirmOrderViewController"]) {
                        self.block(2,self.model);
                        NSLog(@"%@",self.navigationController.viewControllers);
                        int vcNum = 0;
                        for (int i=0;i<self.navigationController.viewControllers.count;i++) {
                            if ([self.navigationController.viewControllers[i] isKindOfClass:[DConfirmOrderViewController class]]) {
                                vcNum = i;
                                break;
                            }
                        }
                        [self.navigationController popToViewController:self.navigationController.viewControllers[vcNum] animated:YES];
                    }else {
                        self.block(2,self.model);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                } else {
                    [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
//                    if ([responseObject.msg isEqualToString:@"街道地址长度控制在5-120个字符内"])
//                        [ProgressHUD showMessage:@"详细地址长度控制在5-120个字符内" Width:100 High:80];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
                NSLog(@"operation6 = %@",operation);
            }];
        }
    }
}
- (void)callBackAddressEdit:(AddressManageBlock)block
{
    self.block = block;
}
#pragma mark dataSouce
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //    if (component == 0) return  self.citys.count;
    //    else return [[[self.citys objectAtIndex:self.rowInProvince] objectForKey:@"Cities"] count];
    if (component == 0) {
        return list0.count;
    }else if(component == 1){
        return list1.count;
    }else if(component == 2){
        return list2.count;
    }
    return 0;
    
}
#pragma mark delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    //    if (component == 0) {return [[self.citys objectAtIndex:row] objectForKey:@"State"];
    //    }
    //    else return [[[[self.citys objectAtIndex:self.rowInProvince] objectForKey:@"Cities"] objectAtIndex:row] objectForKey:@"city"];
    if (list0.count != 0) {
        if (component == 0) {
            return [[list0 objectAtIndex:row] objectForKey:@"regionName"];
        }else if(component == 1){
            return [[list1 objectAtIndex:row] objectForKey:@"regionName"];
        }else if(component == 2){
            return [[list2 objectAtIndex:row] objectForKey:@"regionName"];
        }
    }
    
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        list1 = [[FileOperation getNextPlacesWithRegionId:[[[list0 objectAtIndex:row]objectForKey:@"regionId"]integerValue]] mutableCopy];
        if (list1.count <= 0) {
            [list1 setArray:[NSArray arrayWithObject:[list0 objectAtIndex:row]]];
            [list2 setArray:[NSArray arrayWithObject:[list0 objectAtIndex:row]]];
        }else{
            list2 = [[FileOperation getNextPlacesWithRegionId:[[[list1 objectAtIndex:0]objectForKey:@"regionId"]integerValue]] mutableCopy];
        }
        if (list2.count <= 0) {
            [list2 setArray:[NSArray arrayWithObject:[list1 objectAtIndex:0]]];
        }
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        title0 = [[list0 objectAtIndex:row]objectForKey:@"regionName"];
        title1 = [[list1 objectAtIndex:0]objectForKey:@"regionName"];
        title2 = [[list2 objectAtIndex:0]objectForKey:@"regionName"];
    }else if(component == 1){
        list2 = [[FileOperation getNextPlacesWithRegionId:[[[list1 objectAtIndex:row]objectForKey:@"regionId"]integerValue]] mutableCopy];
        if (list2.count <= 0) {
            [list2 setArray:[NSArray arrayWithObject:[list1 objectAtIndex:row]]];
        }
        [pickerView selectRow:0 inComponent:2 animated:YES];
        title1 = [[list1 objectAtIndex:row]objectForKey:@"regionName"];
        title2 = [[list2 objectAtIndex:0]objectForKey:@"regionName"];
    }else if(component == 2){
        //地区选择完成
        title2 = [[list2 objectAtIndex:row]objectForKey:@"regionName"];
        self.model.regionId =[[list2 objectAtIndex:row]objectForKey:@"regionId"];
        
        if ([title2 isEqualToString:title1]) {
            title2 = @"";
        }
        if ([title1 isEqualToString:title0]) {
            title1 = @"";
        }
        self.areaTF.text = [NSString stringWithFormat:@"%@   %@  %@",title0,title1,title2];
        [self.placePickerView setHidden:YES];
    }
    [self.placePickerView reloadAllComponents];
    
}
#pragma mark textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.placePickerView setHidden:YES];
}
- (IBAction)selectPlaceAction:(id)sender {
    [self.view endEditing:YES];
    if (list0.count != 0) {
        [self.placePickerView setHidden:NO];
    }
}
@end

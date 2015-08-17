//
//  BoundBankCardViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "BoundBankCardViewController.h"
#import "defines.h"
#import "BankCardTypeModel.h"
#import "DES3Util.h"
#import "BoundPhoneViewController.h"


@interface BoundBankCardViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *bankTypeList;//银行卡类型列表
    BOOL isShow;//是否显示银行卡列表（标志位）
    BOOL isPlaceShow;//是否显示地区列表（标志位）
    BankCardTypeModel *selectBank;//选中的银行（信息）
    
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
    
    //地区id
    NSString *_regionId;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *upDownImageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *selectPlaceImage;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idcardTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *selectBankTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *PlacePicker;
@property (weak, nonatomic) IBOutlet UILabel *selectPlaceField;

- (IBAction)upDownButtonClip:(id)sender;
- (IBAction)remmberPaymentPassword:(id)sender;
- (IBAction)nextButtonClip:(id)sender;
@end

@implementation BoundBankCardViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"绑定银行卡";
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavType:SEARCH_BUTTON];
    [self setSearchBtnHidden:YES];
    [self setScrollBtnHidden:YES];
    
    [self addTableView:UITableViewStyleGrouped];
    self.mainTabview.delegate = self;
    self.mainTabview.dataSource = self;
    [self.mainTabview setHidden:YES];


    //获取银行卡类型列表
    [self getBankList];
    
    list0 = [[NSMutableArray alloc]init];
    list1 = [[NSMutableArray alloc]init];
    list2 = [[NSMutableArray alloc]init];
    
    [self.PlacePicker setHidden:YES];
    
    [FileOperation getAllPlaces:^(BOOL finish) {
        list0 = [NSMutableArray arrayWithArray:[FileOperation getAllYijiPlaces]];
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
        [self.PlacePicker reloadAllComponents];
        
        for (int i = 0; i < list0.count; i++) {
            NSLog(@"regionName %d = %@",i,[[list0 objectAtIndex:i]objectForKey:@"regionName"]);
            NSLog(@"parentId %d = %@",i,[[list0 objectAtIndex:i]objectForKey:@"parentId"]);
            NSLog(@"regionId %d = %@",i,[[list0 objectAtIndex:i]objectForKey:@"regionId"]);
        }
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

- (void) getBankList
{
    //获取银行卡类型列表
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyBanks.ChannelList" parameters:nil ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            bankTypeList = [[NSMutableArray alloc]init];
            NSLog(@"result = %@",responseObject.result);
            for (NSDictionary *dic in responseObject.result) {
                BankCardTypeModel *BankCardTypeItem = [[BankCardTypeModel alloc]init];
                BankCardTypeItem = [JsonStringTransfer dictionary:dic ToModel:BankCardTypeItem];
                [bankTypeList addObject:BankCardTypeItem];
            }
            [self layoutTableView];
//            [self.mainTabview setHidden:NO];
            [self.mainTabview reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
    
 
}

- (IBAction)upDownButtonClip:(id)sender {
    [self.PlacePicker setHidden:YES];
    if (isShow == NO) {
        [self.upDownImageVIew setImage:[UIImage imageNamed:@"img_arrow_03_up.png"]];
        [self.mainTabview setHidden:NO];
        isShow = YES;
    }else if (isShow == YES){
        [self.upDownImageVIew setImage:[UIImage imageNamed:@"img_arrow_03_down.png"]];
        [self.mainTabview setHidden:YES];
        isShow = NO;
    }
}
- (IBAction)selectPlaceButtonClip:(id)sender {
    [self.mainTabview setHidden:YES];
    if (isPlaceShow == NO) {
        [self.selectPlaceImage setImage:[UIImage imageNamed:@"img_arrow_03_up.png"]];
        [self.PlacePicker setHidden:NO];
        isPlaceShow = YES;
    }else if (isPlaceShow == YES){
        [self.selectPlaceImage setImage:[UIImage imageNamed:@"img_arrow_03_down.png"]];
        [self.PlacePicker setHidden:YES];
        isPlaceShow = NO;
    }
}

//忘记支付密码
- (IBAction)remmberPaymentPassword:(id)sender {
    BoundPhoneViewController *vc = [[BoundPhoneViewController alloc]init];
    vc.phoneType = ZFMIMA_VERIFY;
    [vc callBackRegisterSuccess:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

//下一步  验证提交信息的合法性
- (IBAction)nextButtonClip:(id)sender {
//    [self boundBankCard];
    //银行卡类型
    if ([self.selectBankTextField.text isEqualToString:@"请选择银行"]) {
        [MBProgressHUD show:@"请选择银行" icon:nil view:self.view afterDelay:0.5];
        return;
    }
    
    //银行卡
    if ([commonTools isEmpty:self.cardNumberTextField.text]) {
        [MBProgressHUD show:@"请输入银行卡卡号" icon:nil view:self.view afterDelay:0.5];
        return;
    }
    if (![commonTools checkCardNo:self.cardNumberTextField.text]) {
        [MBProgressHUD show:@"请输入正确的银行卡卡号" icon:nil view:self.view afterDelay:0.5];
        
        return;
    }
    //姓名
    if ([commonTools isEmpty:self.nameTextField.text]) {
        [MBProgressHUD show:@"请输入姓名" icon:nil view:self.view afterDelay:0.5];
        return;
    }
    if (![commonTools isValidChanseName:self.nameTextField.text]) {
        [MBProgressHUD show:@"请输入2-20个汉字的真实姓名！" icon:nil view:self.view afterDelay:0.5];
        return;
    }

    //身份证号
    if ([commonTools isEmpty:self.idcardTextField.text]) {
        [MBProgressHUD show:@"请输入身份证号" icon:nil view:self.view afterDelay:0.5];
        return;
    }
    if (![commonTools isValidIDCard:self.idcardTextField.text]) {
        [MBProgressHUD show:@"请输入正确的身份证号" icon:nil view:self.view afterDelay:0.5];
        return;
    }

    //手机号
    if ([commonTools isEmpty:self.phoneNumberTextField.text]) {
        [MBProgressHUD show:@"请输入手机号" icon:nil view:self.view afterDelay:0.5];
        return;
    }
    if (![commonTools isMobileNumber:self.phoneNumberTextField.text]) {
        [MBProgressHUD show:@"请输入正确的手机号" icon:nil view:self.view afterDelay:0.5];
        return;
    }
    //银行开户地区
    if ([self.selectPlaceField.text isEqualToString:@"  请选择银行卡开户地区"]) {
        [MBProgressHUD show:@"请选择银行卡开户地！" icon:nil view:self.view afterDelay:0.5];
        return;
    }

    //密码
    if ([commonTools isEmpty:self.passwordTextField.text]) {
        [MBProgressHUD show:@"请输入大集客支付密码" icon:nil view:self.view afterDelay:0.5];
        return;
    }
    if (![commonTools isValidPassword:self.passwordTextField.text]) {
        [MBProgressHUD show:@"请输入正确的支付密码" icon:nil view:self.view afterDelay:0.5];
        return;
    }
    [self boundBankCard];
}



//下一步  绑定银行卡
- (void)boundBankCard
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[FileOperation getUserId],@"userId",self.nameTextField.text,@"userName",[NSString stringWithFormat:@"%@",_regionId],@"regionId",selectBank.channelCode,@"bankCode",self.cardNumberTextField.text,@"kahao",[DES3Util encrypt:self.passwordTextField.text],@"password",self.idcardTextField.text,@"shenfenzheng",self.phoneNumberTextField.text,@"tel", nil];
    NSLog(@"qq:%@\nnn:%@",_regionId,selectBank.channelCode);
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyBanks.create" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        NSLog(@"alkfja:%@",responseObject.result);
        if (responseObject.succeed) {//绑定成功
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.5];
            [self.navigationController popViewControllerAnimated:YES];
        }else{//支付密码错误或银行卡已经绑定
            [MBProgressHUD show:responseObject.msg icon:nil view:self.view afterDelay:0.5];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];

}


#pragma mark------
#pragma mark------uitableViewDelegate uitableViewDatasource--------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (bankTypeList == nil) {
        return 0;
    }
    return bankTypeList.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //    return cell.frame.size.height;
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *identifer = @"bankTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    if (bankTypeList.count > 0) {
        [cell.textLabel setFont:Font_Default];
        cell.textLabel.text = ((BankCardTypeModel *)[bankTypeList objectAtIndex:row]).channelName;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    selectBank = [bankTypeList objectAtIndex:indexPath.row];
    [self upDownButtonClip:nil];
    self.selectBankTextField.text = selectBank.channelName;
    
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
    if (component == 0) {
        return [[list0 objectAtIndex:row] objectForKey:@"regionName"];
    }else if(component == 1){
        return [[list1 objectAtIndex:row] objectForKey:@"regionName"];
    }else if(component == 2){
        return [[list2 objectAtIndex:row] objectForKey:@"regionName"];
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
        [self selectPlaceButtonClip:nil];
        title2 = [[list2 objectAtIndex:row]objectForKey:@"regionName"];
        _regionId = [[list2 objectAtIndex:row]objectForKey:@"regionId"];
        if ([title2 isEqualToString:title1]) {
            title2 = @"";
        }
        if ([title1 isEqualToString:title0]) {
            title1 = @"";
        }
        self.selectPlaceField.text = [NSString stringWithFormat:@"%@   %@  %@",title0,title1,title2];
    }
    [self.PlacePicker reloadAllComponents];
}



#pragma mark------
#pragma mark------layout tableView--------
//调整tableview大小
-(void)layoutTableView
{
    CGRect frame = self.mainTabview.frame;
    //tableView高度很长
    if ((bankTypeList.count *30) > (self.view.frame.size.height-60) ) {
        frame.size.height = self.view.frame.size.height-60;
    }else{
        frame.size.height = bankTypeList.count *30;
    }
    frame.origin.y = 60;
    [self.mainTabview setFrame:frame];
}


@end

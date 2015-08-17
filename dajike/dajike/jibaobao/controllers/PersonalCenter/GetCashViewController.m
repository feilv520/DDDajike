//
//  GetCashViewController.m
//  jibaobao
//
//  Created by dajike on 15/5/15.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

#import "GetCashViewController.h"
#import "defines.h"
#import "BankBoundListModel.h"
#import "BoundPhoneViewController.h"
@interface GetCashViewController (){
    NSMutableArray *_bankDataArr;
    BankBoundListModel *_selectedCardModel;
}
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UIImageView *upDownImageVIew;
- (IBAction)rememberPasswordButtonClip:(id)sender;
- (IBAction)submitSuplyButtobClip:(id)sender;
- (IBAction)selectButtonCLip:(id)sender;

@end

@implementation GetCashViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleLabel.text = @"我要提现";
        
        
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
    
    CGRect frame = self.mainTabview.frame;
    frame.origin.x = self.cardLabel.frame.origin.x;
    frame.origin.y = self.cardLabel.frame.origin.y + self.cardLabel.frame.size.height;
    frame.size.width = self.cardLabel.frame.size.width;
    [self.mainTabview setFrame:frame];
    self.mainTabview.hidden = YES;
    self.label2.text = self.totalAccount;
    [self configsProperty];
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

- (IBAction)rememberPasswordButtonClip:(id)sender {
    BoundPhoneViewController *vc = [[BoundPhoneViewController alloc]init];
    vc.phoneType = ZFMIMA_VERIFY;
    [vc callBackRegisterSuccess:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)submitSuplyButtobClip:(id)sender {
    
    [self myBanksTiXian];
}

- (IBAction)selectButtonCLip:(id)sender {
    [self getMyBanksListData];
}
- (BOOL)judgeFunction{
    if (_selectedCardModel != nil&&
        self.textField1.text != nil&&
        self.textField2.text != nil&&
        self.textField3.text != nil&&
        self.textField4.text != nil) {
        return YES;
    }
    [MBProgressHUD show:@"请检查信息是否填写正确！" icon:nil view:self.view afterDelay:0.7];
    return NO;
}

- (void)getMyBanksListData{

    NSString *userId = [FileOperation getUserId];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId", nil];
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyBanks.list" parameters:dic ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        
        if (responseObject.succeed == YES) {
            NSArray *resultArr= [AnalysisData decodeAndDecriptWittDESArray:responseObject.result];
            NSLog(@"%@",resultArr);
            _bankDataArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in resultArr) {
                BankBoundListModel *bankListItem = [[BankBoundListModel alloc]init];
                bankListItem = [JsonStringTransfer dictionary:dic ToModel:bankListItem];
                [_bankDataArr addObject:bankListItem];
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                self.mainTabview.hidden = NO;
                CGRect frame = self.mainTabview.frame;
                frame.size.height = 30 * _bankDataArr.count;
                self.mainTabview.frame = frame;
            }];
            
            [self.mainTabview reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation = %@",operation);
        NSLog(@"error = %@",error);
    }];
}
- (void)myBanksTiXian{
    NSDictionary *parameter = @{@"userId":[FileOperation getUserId],@"type":self.type,@"jine":self.textField1.text,@"bankId":_selectedCardModel.id,@"password":[DES3Util encrypt:self.textField2.text],@"shenfenzheng":self.textField3.text,@"tel":_selectedCardModel.tel};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"MyBanks.tixian" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            [ProgressHUD showMessage:@"请求成功，等待处理！" Width:100 High:80];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if ([responseObject.msg length] == 0) {
                [ProgressHUD showMessage:@"请求失败" Width:100 High:80];
            }else
                [ProgressHUD showMessage:responseObject.msg Width:100 High:80];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
    }];

}
- (void)configsProperty{
    NSDictionary *parameter = @{@"field":@"tixian"};
    
    [[MyAfHTTPClient sharedClient]postPathWithMethod:@"Configs.property" parameters:parameter ifAddActivityIndicator:NO success:^(AFHTTPRequestOperation *operation, PostData *responseObject) {
        if (responseObject.succeed) {
            NSLog(@"result = %@",responseObject.result);
            NSDictionary *dict = [[NSDictionary alloc]init];
            dict = responseObject.result;
            self.textField1.placeholder = [NSString stringWithFormat:@"每日提现限额 ¥%@",[dict objectForKey:@"tixian" ]];
                    }
        else
        {
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        NSLog(@"operation6 = %@",operation);
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
    
    return _bankDataArr.count;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bankCell"];
        BankBoundListModel *model = [_bankDataArr objectAtIndex:indexPath.row];
        UILabel *bankName = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 280, 20)];
        bankName.text = [NSString stringWithFormat:@"%@  尾号:%@",model.bankName,[model.kahao substringFromIndex:model.kahao.length-4]];
        bankName.font = [UIFont fontWithName:@"Arial" size:14.0];
        [cell addSubview:bankName];
        
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消点击选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    _selectedCardModel = [_bankDataArr objectAtIndex:indexPath.row];
    self.mainTabview.hidden = YES;
    self.cardLabel.text = [NSString stringWithFormat:@"%@  尾号:%@",_selectedCardModel.bankName,[_selectedCardModel.kahao substringFromIndex:_selectedCardModel.kahao.length-4]];
    self.textField3.text = _selectedCardModel.shenfenzheng;
    self.textField4.text = _selectedCardModel.tel;
}

@end

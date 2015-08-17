//
//  MyAddressEditingViewController.h
//  jibaobao
//
//  Created by dajike on 15/5/11.
//  Copyright (c) 2015年 dajike. All rights reserved.
//

/*
 编辑地址
 */
#import "BackNavigationViewController.h"
#import "MyAddressModel.h"

typedef void (^AddressManageBlock)(int flag,MyAddressModel *addressModel);

@interface MyAddressEditingViewController : BackNavigationViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *address1TextField;
@property (weak, nonatomic) IBOutlet UITextField *address2TextField;
@property (weak, nonatomic) IBOutlet UITextField *address3TextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UIPickerView *PlacePicker;

@property (strong, nonatomic) NSString *flagStr;
@property (strong, nonatomic) NSString *comeFrom;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) MyAddressModel *model;

@property (strong, nonatomic) AddressManageBlock block;

- (IBAction)saveButtonClip:(id)sender;

- (void)callBackAddressEdit:(AddressManageBlock)block;

@end

//
//  AddAddressViewController.h
//  haitao
//
//  Created by pwy on 15/7/19.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaPickerView.h"

@interface AddAddressStep1 : UIViewController<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,HTTPControllerProtocol>

@property (weak, nonatomic) IBOutlet UITextField *consignee;//收货人

@property (weak, nonatomic) IBOutlet UITextField *mobile;

@property (weak, nonatomic) IBOutlet UITextField *idcard;

@property (weak, nonatomic) IBOutlet UITextField *province;

@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet UITextField *zipcode;

@property(assign,nonatomic) BOOL isFirstAddress;

@property(strong,nonatomic) AreaPickerView *picker;

@property(strong,nonatomic) UIView *pickerView;

- (IBAction)textFieldBeginEdit:(id)sender;

- (IBAction)textFieldEndEdit:(id)sender;


- (IBAction)gotoStep2:(id)sender;

- (IBAction)areaPick:(id)sender;

- (IBAction)didEndOnExit:(id)sender;
@end

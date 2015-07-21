//
//  AddAddressViewController.h
//  haitao
//
//  Created by pwy on 15/7/19.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface AddAddressStep1 : UIViewController<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *consignee;//收货人

@property (weak, nonatomic) IBOutlet UITextField *mobile;

@property (weak, nonatomic) IBOutlet UITextField *idcard;

@property (weak, nonatomic) IBOutlet UITextField *province;

@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet UITextField *zipcode;

@property(strong,nonatomic) UIPickerView *picker;


@property (strong, nonatomic)  NSDictionary *areaDic;
@property (strong, nonatomic)  NSArray *provinces;
@property (strong, nonatomic)  NSArray *city;
@property (strong, nonatomic)  NSArray *district;

@property (strong, nonatomic)  NSString *selectedProvince;

- (IBAction)gotoStep2:(id)sender;

- (IBAction)areaPick:(id)sender;
@end

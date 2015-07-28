//
//  UpdateAddressForEdit.h
//  haitao
//
//  Created by pwy on 15/7/27.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
#import "AreaPickerView.h"
#import "UpdateAddress.h"

@interface UpdateAddressForEdit : UIViewController<HTTPControllerProtocol,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property(strong,nonatomic) AddressModel *addressModel;

@property(strong,nonatomic) UpdateAddress *updateAddress;

@property(strong,nonatomic) NSString *id;//地址ID

@property (weak, nonatomic) IBOutlet UITextField *consignee;//收货人

@property (weak, nonatomic) IBOutlet UITextField *mobile;

@property (weak, nonatomic) IBOutlet UITextField *idcard;

@property (weak, nonatomic) IBOutlet UITextField *province;

@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet UITextField *zipcode;

@property (weak, nonatomic) IBOutlet UIImageView *idcard_zhengmian;

@property(strong,nonatomic) AreaPickerView *picker;//省市区选择器

@property (weak, nonatomic) IBOutlet UIImageView *idcard_fanmian;

@property(assign,nonatomic) int targetIdex;//纪录哪个UIImageView被触发

@property(assign,nonatomic) int uploadStatus_zhengmian;//0、用户并未上传，1、上传正面

@property(assign,nonatomic) int uploadStatus_fanmian;//0、用户并未上场 1、上传反面



- (IBAction)areaPick:(id)sender;
- (IBAction)DidEndOnExit:(id)sender;

@end

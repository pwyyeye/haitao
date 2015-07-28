//
//  UpdateAddress.h
//  haitao
//
//  Created by pwy on 15/7/21.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface UpdateAddress : UIViewController<HTTPControllerProtocol>

@property(strong,nonatomic) AddressModel *addressModel;

@property(strong,nonatomic) NSString *id;//地址ID

@property (weak, nonatomic) IBOutlet UITextField *consignee;//收货人

@property (weak, nonatomic) IBOutlet UITextField *mobile;

@property (weak, nonatomic) IBOutlet UITextField *idcard;

@property (weak, nonatomic) IBOutlet UITextField *province;

@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet UITextField *zipcode;

- (IBAction)setToDefault:(id)sender;


- (IBAction)deleteAddress:(id)sender;

- (IBAction)DidEndOnExit:(id)sender;

@end

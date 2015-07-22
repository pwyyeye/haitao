//
//  RegisterViewController.h
//  haitao
//
//  Created by pwy on 15/7/22.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *username;

@property (weak, nonatomic) IBOutlet UITextField *captcha;

@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)register:(id)sender;
@end

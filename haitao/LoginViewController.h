//
//  LoginViewController.h
//  haitao
//
//  Created by pwy on 15-7-14.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTKViewController.h"
@interface LoginViewController : UIViewController<HTTPControllerProtocol>

@property (weak, nonatomic) IBOutlet UITextField *user_name;

@property (weak, nonatomic) IBOutlet UITextField *user_pass;

@property(strong,nonatomic) NSString *loginRequestURL;

@property(strong,nonatomic) NSString *username;

@property(strong,nonatomic) NSString *password;

- (IBAction)login:(id)sender;

- (IBAction)didEndOnExit:(id)sender;

@end

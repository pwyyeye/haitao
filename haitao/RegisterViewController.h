//
//  RegisterViewController.h
//  haitao
//
//  Created by pwy on 15/7/22.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<HTTPControllerProtocol>

@property (weak, nonatomic) IBOutlet UITextField *mobile;

@property (weak, nonatomic) IBOutlet UITextField *captcha;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *btn_captcha;

@property(strong,nonatomic) NSTimer *timer;

@property(assign,nonatomic) int step;

- (IBAction)getCaptcha:(id)sender;

- (IBAction)registerAccount:(id)sender;

- (IBAction)didEndOnExit:(id)sender;

@end

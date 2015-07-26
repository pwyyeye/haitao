//
//  ForgetPwdStep3.h
//  haitao
//
//  Created by pwy on 15/7/24.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdStep3 : UIViewController<HTTPControllerProtocol>


@property(strong,nonatomic) NSString *username;
@property(strong,nonatomic) NSString *captcha;

@property (weak, nonatomic) IBOutlet UITextField *password_TextField;

@property (weak, nonatomic) IBOutlet UITextField *comfirm_TextField;

- (IBAction)EditingDidEnd:(id)sender;

- (IBAction)resetPwd:(id)sender;
@end

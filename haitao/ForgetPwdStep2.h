//
//  ForgetPwdStep1.h
//  haitao
//
//  Created by pwy on 15/7/23.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdStep2 : UIViewController

@property(strong,nonatomic) NSString *username;

@property (weak, nonatomic) IBOutlet UITextField *captcha;

- (IBAction)gotoStep3:(id)sender;


@end

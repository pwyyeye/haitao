//
//  ForgtetPwdStep1.h
//  haitao
//
//  Created by pwy on 15/7/23.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdStep1 : UIViewController<HTTPControllerProtocol>

@property (weak, nonatomic) IBOutlet UITextField *userame;

@property(strong,nonatomic) NSTimer *timer;
@property(assign,nonatomic) int step;
@property (weak, nonatomic) IBOutlet UIButton *btn_stepNext;

- (IBAction)gotoStep2:(id)sender;

@end

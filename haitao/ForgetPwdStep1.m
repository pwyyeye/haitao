//
//  ForgtetPwdStep1.m
//  haitao
//
//  Created by pwy on 15/7/23.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "ForgetPwdStep1.h"
#import "ForgetPwdStep2.h"
#import "ForgetForEmail.h"
@interface ForgetPwdStep1 ()

@end

@implementation ForgetPwdStep1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"找回密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)gotoStep2:(id)sender {
    if ([MyUtil isEmptyString:_userame.text]) {
        ShowMessage(@"请输入手机号或者登录邮箱！");
        return;
    }
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil  action:nil]];
    if ([MyUtil isValidateTelephone:_userame.text]) {
        ForgetPwdStep2 * vc=[[ForgetPwdStep2 alloc] initWithNibName:@"ForgetPwdStep2" bundle:nil];
        vc.username=_userame.text;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([MyUtil isValidateEmail:_userame.text]){
        ForgetForEmail * vc=[[ForgetForEmail alloc] initWithNibName:@"ForgetForEmail" bundle:nil];
        vc.username=_userame.text;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ShowMessage(@"请输入正确的手机号码或者邮箱！");
        return;
    }
    
    
}
@end
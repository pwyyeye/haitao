//
//  ForgetPwdStep1.m
//  haitao
//
//  Created by pwy on 15/7/23.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "ForgetPwdStep2.h"
#import "ForgetPwdStep3.h"

@interface ForgetPwdStep2 ()

@end

@implementation ForgetPwdStep2

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

- (IBAction)gotoStep3:(id)sender {
    if ([MyUtil isEmptyString:_captcha.text]) {
        ShowMessage(@"请输入验证码！");
        return;
    }
    ForgetPwdStep3 * vc=[[ForgetPwdStep3 alloc] initWithNibName:@"ForgetPwdStep3" bundle:nil];
    vc.username=_username;
    vc.captcha=_captcha.text;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil  action:nil]];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end

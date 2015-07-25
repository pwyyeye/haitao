//
//  ForgetPwdStep3.m
//  haitao
//
//  Created by pwy on 15/7/24.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "ForgetPwdStep3.h"

@interface ForgetPwdStep3 ()

@end

@implementation ForgetPwdStep3

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

- (IBAction)resetPwd:(id)sender {
    
    if ([MyUtil isEmptyString:_password_TextField.text]) {
        ShowMessage(@"请输入密码！");
        return;
    }
    if ([MyUtil isEmptyString:_comfirm_TextField.text]) {
        ShowMessage(@"请输入重复密码！");
        return;
    }
    
    if(![_comfirm_TextField.text isEqualToString:_password_TextField.text]){
        ShowMessage(@"两次输入密码不一样！");
        return;
    }
    NSDictionary *parameters = @{@"user_name":_username,@"user_pass":_password_TextField.text,@"mobile_code":_captcha};
    
//    HTTPController *httpController =  [[HTTPController alloc]initWith:req withType:POSTURL withPam:parameters withUrlName:@"login"];
//    httpController.delegate = self;
//    [httpController onSearchForPostJson];
    

}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{

}
@end

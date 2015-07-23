//
//  RegisterViewController.m
//  haitao
//
//  Created by pwy on 15/7/22.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.title=@"注册";
    
    _step=0;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(captchaWait) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];//暂停


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

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    if ([urlname isEqualToString:@"getCaptcha"]) {
        NSLog(@"----pass-getCaptcha%@---",dictemp);
    }else if ([urlname isEqualToString:@"registerAccount"]) {
        NSLog(@"----pass-registerAccount%@---",dictemp);
        if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
            //[USER_DEFAULT setObject:[dictemp objectForKey:@"s_app_id"] forKey:@"s_app_id"];
            NSDictionary *dic=[dictemp objectForKey:@"data"];
            [USER_DEFAULT setObject:[dic objectForKey:@"user_name"] forKey:@"user_name"];
            [USER_DEFAULT setObject:[dic objectForKey:@"user_nick"]  forKey:@"user_nick"];
            //返回原来界面
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            app.s_app_id=[dictemp objectForKey:@"s_app_id"];
            [app stopLoading];
            
            //判断是否有注册通知
            [USER_DEFAULT setObject:_password forKey:@"user_pass"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }else{
            NSArray *array=[dictemp objectForKey:@"msg"];
            ShowMessage([array objectAtIndex:0]);
        }
        
    }

}
//获取验证码
- (IBAction)getCaptcha:(id)sender {
    
    if (![MyUtil checkTelephone:_mobile.text]) {
        ShowMessage(@"请输入正确的手机号码！");
        return;
    }
   
    [_timer setFireDate:[NSDate distantPast]];//开启


    NSLog(@"----pass-captcha%@---",requestUrl_captcha);
    
    NSDictionary *dic=@{@"mobile":_mobile.text};
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_captcha withType:GETURL withPam:dic withUrlName:@"getCaptcha"];
    
    
    httpController.delegate = self;
    [httpController onSearch];
}

//定时器更新验证码按钮

-(void)captchaWait{

    if (_step==60) {
        _btn_captcha.enabled=YES;
        _step=0;
        
        [_timer setFireDate:[NSDate distantFuture]];//暂停
        [_btn_captcha setTitle:@"获取验证码" forState:UIControlStateNormal];

        
    }else{
        _btn_captcha.enabled=NO;
        _step++;
        _btn_captcha.titleLabel.text=[NSString stringWithFormat:@"重新发送(%d)秒",_step];
        [_btn_captcha setTitle:[NSString stringWithFormat:@"重新发送(%d)秒",_step] forState:UIControlStateDisabled];
        [_btn_captcha setTitle:[NSString stringWithFormat:@"重新发送(%d)秒",_step] forState:UIControlStateNormal];

    }
    

}

- (IBAction)registerAccount:(id)sender {
    if (![MyUtil checkTelephone:_mobile.text]) {
        ShowMessage(@"请输入正确的手机号码！");
        return;
    }
    if ([MyUtil isEmptyString:_captcha.text]) {
        ShowMessage(@"请输入验证码！");
        return;
    }
    if ([MyUtil isEmptyString:_password.text]) {
        ShowMessage(@"密码不能为空！");
        return;
    }
    NSDictionary *dic=@{@"mobile":_mobile.text,@"mobile_code":_captcha.text,@"user_pass":_password.text,@"gotologin":@"1"};
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_doMobileRegist withType:POSTURL withPam:dic withUrlName:@"registerAccount"];
    
    
    httpController.delegate = self;
    [httpController onSearchForPostJson];

}

- (IBAction)didEndOnExit:(id)sender {
    [sender resignFirstResponder];
}
@end

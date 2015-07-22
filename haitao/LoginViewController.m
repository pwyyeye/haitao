//
//  LoginViewController.m
//  haitao
//
//  Created by pwy on 15-7-14.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    NSString *username=[userdefault objectForKey:@"user_name"];
    NSString *password=[userdefault objectForKey:@"user_pass"];
    if (![MyUtil isEmptyString:username]) {
        _user_name.text=username;
    }
    
    
    if (![MyUtil isEmptyString:password]) {
        _user_pass.text=password;
    }
    
    
    
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
#pragma mark - login
- (IBAction)login:(id)sender {
    
    _loginRequestURL=[NSString stringWithFormat:@"%@&f=doLogin&m=user",requestUrl];

    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
   
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    _username=_user_name.text;
    _password=_user_pass.text;
    
    if (sender==nil) {
        _username=[userdefault objectForKey:@"user_name"];
        _password=[userdefault objectForKey:@"user_pass"];
    }
    
    

     NSDictionary *parameters = @{@"user_name":_username,@"user_pass":_password};
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:_loginRequestURL withType:POSTURL withPam:parameters withUrlName:@"login"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}

- (IBAction)didEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    
    NSLog(@"----pass-login%@---",dictemp);
    
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
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeToReload" object:nil];
        

        
        
    }
    
    
    
    

}
@end

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
    _loginRequestURL=[NSString stringWithFormat:@"%@&f=doLogin&m=user",requestUrl];
    NSLog(@"----pass-pass%@---",_loginRequestURL);
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
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
     NSDictionary *parameters = @{@"user_name":_user_name.text,@"user_pass":_user_pass.text};
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:_loginRequestURL withType:POSTURL withPam:parameters withUrlName:@"login"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}

- (IBAction)didEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    
    NSLog(@"----pass-login%@---",dictemp);
    
    
    

}
@end

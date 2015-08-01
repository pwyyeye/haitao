//
//  LoginViewController.m
//  haitao
//
//  Created by pwy on 15-7-14.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPwdStep1.h"

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
    //是否显示navigationBar
    [self.navigationController setNavigationBarHidden:NO];
    //navigationBar 背景色
    self.navigationController.navigationBar.barTintColor=RGB(255, 13, 94);
    //若为yesnavigationBar背景 会有50％的透明
    self.navigationController.navigationBar.translucent = NO;
    
    //返回值

//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)]];
//    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    self.title=@"登录";
  
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    
    
    
    _loginBtn.layer.shadowColor=[UIColor blackColor].CGColor;
    

    [_loginBtn.layer setShadowOffset: CGSizeMake(0.1, 2.1)];
    [_loginBtn.layer setShadowRadius: 4];
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

-(void)gotoBack{
  
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark - login
- (IBAction)login:(id)sender {
    
    _loginRequestURL=[NSString stringWithFormat:@"%@&f=doLogin&m=user",requestUrl];

    
   
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    _username=_user_name.text;
    _password=_user_pass.text;
    
    if (sender==nil) {
        _username=[userdefault objectForKey:@"user_name"];
        _password=[userdefault objectForKey:@"user_pass"];
    }else{
        if (![MyUtil isValidateTelephone:_user_name.text]&&![MyUtil isValidateEmail:_user_name.text]) {
            ShowMessage(@"请输入正确的登录账户！");
            return;
        }
        if ([MyUtil isEmptyString:_user_pass.text]) {
            ShowMessage(@"密码不能为空！");
            return;
        }
    }
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];

     NSDictionary *parameters = @{@"user_name":_username,@"user_pass":_password};
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:_loginRequestURL withType:POSTURL withPam:parameters withUrlName:@"login"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}

- (IBAction)didEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)gotoRegister:(id)sender {
    RegisterViewController * vc=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
   // AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil  action:nil]];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)gotoForgetPwd:(id)sender {
    ForgetPwdStep1 * vc=[[ForgetPwdStep1 alloc] initWithNibName:@"ForgetPwdStep1" bundle:nil];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil  action:nil]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    
    NSLog(@"----pass-login%@---",dictemp);
    
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        //[USER_DEFAULT setObject:[dictemp objectForKey:@"s_app_id"] forKey:@"s_app_id"];
        NSDictionary *dic=[dictemp objectForKey:@"data"];
        [USER_DEFAULT setObject:[dic objectForKey:@"user_name"] forKey:@"user_name"];
        [USER_DEFAULT setObject:[dic objectForKey:@"user_nick"]  forKey:@"user_nick"];
        [USER_DEFAULT setObject:_password forKey:@"user_pass"];
        [USER_DEFAULT setObject:[dic objectForKey:@"avatar_img"] forKey:@"avatar_img"];
        //返回原来界面
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.s_app_id=[dictemp objectForKey:@"s_app_id"];
        [app stopLoading];
        
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
        if (_customTabBar!=nil) {
            _customTabBar.currentSelectedIndex=_currentSelectedIndex;
        }
        //判断是否有注册通知

        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeToReload" object:nil];
        

        
        
    }
    
    
    
    

}
@end

//
//  ForgetForEmaol.m
//  haitao
//
//  Created by pwy on 15/7/24.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "ForgetForEmail.h"
#import "LoginViewController.h"
@interface ForgetForEmail ()

@end

@implementation ForgetForEmail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"忘记密码";
    [self sendEmail];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
}
-(void)gotoBack{

    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LoginViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
-(void)sendEmail{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    NSDictionary *parameters = @{@"user_name":_username};
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_sendForgetMail withType:POSTURL withPam:parameters withUrlName:@"mail"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1)
    {
        ShowMessage(@"邮件已发送！");
        _message.text=@"发送成功";
    }else{
        _message.text=@"发送失败";
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

- (IBAction)reSend:(id)sender {
    [self sendEmail];
}
@end

//
//  HelpContentController.m
//  haitao
//
//  Created by pwy on 15/8/25.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "HelpContentController.h"

@interface HelpContentController ()

@end

@implementation HelpContentController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //是否显示navigationBar
    [self.navigationController setNavigationBarHidden:NO];
    //navigationBar 背景色
    self.navigationController.navigationBar.barTintColor=RGB(255, 13, 94);
    //若为yesnavigationBar背景 会有50％的透明
    self.navigationController.navigationBar.translucent = NO;
    
    //返回值
    
    //    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)]];
    //
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    self.title=@"联系客服";
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
}
-(void)getUrl{
    NSString* url =[NSString stringWithFormat:@"%@&m=home&f=helpApi",requestUrl]
    ;
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:GETURL withUrlName:@"getUrl"];
    httpController.delegate = self;
    [httpController onSearch];
}
-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    if ([dictemp objectForKey:@"data"]) {
        
        _webView.delegate=self;
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[dictemp objectForKey:@"data"]]]];
        [self.view addSubview:_webView];    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [_webView reload];
}
-(void)gotoBack
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController popViewControllerAnimated:YES];
    
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

@end

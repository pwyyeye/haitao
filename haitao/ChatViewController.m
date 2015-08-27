//
//  ChatViewController.m
//  haitao
//
//  Created by pwy on 15/8/14.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
{
    BOOL isSended;
}

+(ChatViewController *)shareChat
{
    static dispatch_once_t onceToken;
    static ChatViewController *singleton;
    dispatch_once(&onceToken, ^{
        singleton=[[ChatViewController alloc] init];
    });
    NSLog(@"-------singletonChat---------%@",singleton);
    return singleton;    
}
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
//    _chatUrl=@"http://chat16.live800.com/live800/chatClient/chatbox.jsp?companyID=544660&configID=81070&jid=1011818181";
//    _chatView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//    _chatView.delegate=self;
//    [_chatView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_chatUrl]]];
//    [self.view addSubview:_chatView];
    
    _isHome=NO;
    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [_chatView reload];
//    [self mechat];
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    ShowMessage(@"客服加载出现问题，请确保您的网络畅通！");
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)mechat
{
    //创建用户信息
    // @"realName"     : @"张三",
    //@"avatar"       : @"http://meiqia.com/avatar.jpg",
    //@"appUserName"  : @"loginName",
    //@"appUserId"    : @"10000",
    //可以只添加部分信息
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSDictionary* userInfoTemp =  @{
                                    @"realName"     : ![USER_DEFAULT objectForKey:@"user_name"]?@"游客":[USER_DEFAULT objectForKey:@"user_name"],
                                    @"avatar"       : ![USER_DEFAULT objectForKey:@"avatar_img"]?@"http://meiqia.com/avatar.jpg":[USER_DEFAULT objectForKey:@"avatar_img"],
                                    @"comment"      : @"来自IOS客户端",
                                    @"appUserName"  : ![USER_DEFAULT objectForKey:@"user_name"]?@"游客":[USER_DEFAULT objectForKey:@"user_name"],
                                    @"appNickName"  : ![USER_DEFAULT objectForKey:@"user_nick"]?@"游客":[USER_DEFAULT objectForKey:@"user_nick"],
                                    @"appUserId"    : !app.s_app_id?[NSString stringWithFormat:@"%i",(arc4random() % 9999999) + 1000000]:app.s_app_id
                                    };
    
    //设置用户id，实现该用户的消息漫游
    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] initWithDictionary:userInfoTemp];
    
    //创建自定义信息
    NSDictionary* otherInfo = nil;
    
    //添加用户信息
    [MCCore addUserInfo:userInfo addOtherInfo:otherInfo];
    
    //指定分配到客服分组
    //    [MCCore specifyAllocGroup:@"客服组的ID"];
    //指定分配到客服
    //    [MCCore specifyAllocServer:@"1000" isForce:NO];
    
    _viewController = [MCCore createChatViewController];
    //    MCChatViewController* viewController = [[MCChatViewController alloc] init];  //这种方法也可以
    
    //修改footerBar的backgroundColor
    _viewController.footerBar.backgroundColor = RGB(255, 13, 94);
    _viewController.navigationBarTintColor=[UIColor whiteColor];
    
    //设置deviceToken
    _viewController.deviceToken = [USER_DEFAULT objectForKey:@"deviceToken"];
    
    //设置代理
    _viewController.delegate = (id)self;
    //禁用语音
    //    viewController.sendAudioEnable = NO;
    
    //隐藏提示
    //    viewController.hideTipView = YES;
    
    //是否消息同步
    //    viewController.syncNetworkMessage = YES;
   
    [_viewController.navigationController setNavigationBarHidden:YES];

    
    //给chatViewController添加一个自定义navigationBar
    if (_isHome==YES) {
        UIView* bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        bar.backgroundColor = RGB(255, 13, 94);
        _viewController.putFrame = CGRectMake(0, 64, 0, -64);
        
        self.navigationController.navigationBar.hidden = YES;
        
        UIButton *backItem=[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 44)];
        [backItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [backItem addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchDragInside];
        [bar addSubview:backItem];
        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 20, 100, 44)];
        title.text=@"联系客服";
        title.textAlignment=1;
        title.font=[UIFont boldSystemFontOfSize:17];
        title.textColor=[UIColor whiteColor];
        [bar addSubview:title];
        //     viewController.navigationController.navigationBar.hidden = YES;
        [_viewController.view addSubview:bar];
    }else{
        
    }
    

//    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    //    delegate.navigationController.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
   
//    if (_isHome==NO) {
//        
//        [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil  action:nil]];
//        [self.navigationController pushViewController:viewController animated:YES];
//    }else{
//        
//    }
//    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
//    delegate.navigationController.navigationItem.backBarButtonItem=item;
//    
//    [delegate.navigationController pushViewController:_viewController animated:YES];
}

-(void)serviceChange:(MCService*)service expcetion:(kMCExceptionStatus)expcetion
{
    if(!isSended) {
//        [viewController sendMessageWithString:@"你好！"];
        isSended = YES;
    }
}

//注意：该代理函数为MCChatViewDelegate中的函数，并非MCMessageDelegate的函数。
//这两者的参数类型不同，注意不要混淆
-(void)receiveMessage:(MCMessage*)message
{
    //收到消息时，震动手机
    SystemSoundID soundID = kSystemSoundID_Vibrate;
    AudioServicesPlaySystemSound(soundID);
}

@end
